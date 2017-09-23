# frozen_string_literal: true

require 'ripper'

module Iro
  module RipperWrapper
    refine Array do
      def type
        self.first
      end

      def children
        [].tap do |res|
          self[1..-1].each do |child|
            if child.is_a?(Array)
              if child.node?
                res << child
              else
                res.concat(child)
              end
            else
              res << child
            end
          end
        end
      end

      def content
        self[1]
      end

      def position
        self[2]
      end

      def node?
        self.first.is_a?(Symbol)
      end

      def parser_event?
        type =~ /\A@/
      end

      def scanner_event?
        type !~ /\A@/
      end

      Ripper::SCANNER_EVENTS.each do |e|
        eval <<~RUBY
          def #{e}_type?
            type == #{:"@#{e}".inspect}
          end
        RUBY
      end

      Ripper::PARSER_EVENTS.each do |e|
        eval <<~RUBY
          def #{e}_type?
            type == #{e.inspect}
          end
        RUBY
      end
    end
  end
  using RipperWrapper

  class Parser < Ripper::SexpBuilderPP
    def initialize(*)
      super
      @tokens = {}
    end

    def register_token(group, token)
      @tokens[group] ||= []
      @tokens[group] << token
    end

    def highlight
      @tokens.each do |group, tokens|
        tokens.each_slice(8) do |ts|
          # TODO: match ID
          ::Vim.evaluate("matchaddpos(#{group.inspect}, #{ts.inspect}, -1)")
        end
      end
    end

    rules = ::Vim.evaluate('g:iro_ruby')
    scanner_events = Ripper::SCANNER_EVENTS.map(&:to_s)
    rules.select{|r| scanner_events.include?(r[0])}.each do |tok_type, group|
      eval <<~RUBY
        def on_#{tok_type}(str)
          str.split("\\n").each.with_index do |s, idx|
            register_token #{group.inspect}, [
              lineno + idx,
              idx == 0 ? column+1 : 1,
              s.size]
          end
          super
        end
      RUBY
    end

    # For lvar
    if rule = rules.find{|r| r.first == 'var_ref'}
      define_method :traverse do |node|
        return if node.parser_event?

        if node.var_ref_type?
          ident = node.children.first
          if ident.ident_type?
            pos = ident.position
            register_token rule[1], [pos[0], pos[1]+1, ident.content.size]
          end
        end
        node.children.each do |child|
          traverse(child) if child.is_a?(Array)
        end
      end
    else
      def traverse(node)
      end
    end
  end


  def self.highlight(bufnr)
    source = ::Vim.evaluate("getbufline(#{bufnr}, 1, '$')").join("\n")
    parser = Parser.new(source)
    sexp = parser.parse
    parser.traverse(sexp)
    parser.highlight
  end
end

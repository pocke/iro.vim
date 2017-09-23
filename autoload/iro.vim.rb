# frozen_string_literal: true

require 'ripper'

module Iro
  class Parser < Ripper
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
          ::Vim.evaluate("matchaddpos(#{group.inspect}, #{ts.inspect})")
        end
      end
    end

    rules = ::Vim.evaluate('g:iro_ruby')
    rules.each do |tok_type, group|
      eval <<~END
        def on_#{tok_type}(str)
          str.split("\\n").each.with_index do |s, idx|
            register_token #{group.inspect}, [
              lineno + idx,
              idx == 0 ? column+1 : 1,
              s.size]
          end
        end
      END
    end
  end

  def self.highlight(bufnr)
    source = ::Vim.evaluate("getbufline(#{bufnr}, 1, '$')").join("\n")
    parser = Parser.new(source)
    parser.parse
    parser.highlight
  end
end

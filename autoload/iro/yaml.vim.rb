gem 'psych', '= 3.0.0.beta3'
require 'psych'
require 'json'

module Iro
  module YAML
    class Parser < ::Psych::Parser
      def initialize(source)
        @source = source
        super(MarkHandler.new(self, source))
      end

      def parse
        super(@source)
      end
    end

    class MarkHandler < ::Psych::TreeBuilder
      attr_reader :tokens

      def initialize(parser, source)
        @parser = parser
        @source = source.force_encoding(Encoding::UTF_8).split("\n")
        @tokens = {}
        @scanner = Psych::ScalarScanner.new(Psych::ClassLoader.new)
        super()
      end

      def scalar(value, anchor, tag, plain, quoted, style)
        super.tap do |node|
          case @scanner.tokenize(value)
          when String
            register_token 'String', node
          when TrueClass, FalseClass
            register_token 'Boolean', node
          when Integer
            register_token 'Number', node
          end
        end
      end

      private

      def register_token(group, node)
        @tokens[group] ||=[]

        if node.start_line == node.end_line
          size = @source[node.start_line][node.start_column..node.end_column].bytesize
          @tokens[group] << [node.start_line+1, node.start_column+1, size]
        else
          @tokens[group] << [
            node.start_line+1,
            node.start_column+1,
            @source[node.start_line].bytesize - node.start_column]
          @source[(node.start_line+1)...node.end_line].each.with_index(1) do |line, idx|
            @tokens[group] << [node.start_line+1+idx, 0, line.size]
          end
          @tokens[group] << [node.end_line+1, 0, node.end_column]
        end
      end
    end

    def self.tokens(bufnr)
      source = ::Vim.evaluate("getbufline(#{bufnr}, 1, '$')").join("\n")
      tokens = Parser.new(source).parse.handler.tokens
      ::Vim.command "let s:result = #{tokens.to_json}"
    end
  end
end

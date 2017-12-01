gem 'psych', '= 3.0.0'
require 'psych'
require 'json'

module Iro
  module YAML
    def self.traverse(node)
      case node
      when Psych::Nodes::Mapping
        node.children.each_slice(2) do |key, value|
          register_token 'Identifier', key
          traverse(value)
        end
      when Psych::Nodes::Scalar
        case node.to_ruby
        when String, Symbol
          register_token 'String', node
        when TrueClass, FalseClass
          register_token 'Boolean', node
        when Integer
          register_token 'Number', node
        when Float
          register_token 'Float', node
        end
      when Psych::Nodes::Alias
        register_token 'Identifier', node
      else
        node.children&.each do |c|
          traverse(c)
        end
      end
    end

    def self.register_token(group, node)
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

    def self.tokens(bufnr)
      source = ::Vim.evaluate("getbufline(#{bufnr}, 1, '$')").join("\n")
      node = Psych.parse(source)
      if node == false # Psych.parse returns false when parsing empty file.
        ::Vim.command "let s:result = {}"
        return
      end

      @tokens = {}
      @source = source.force_encoding(Encoding::UTF_8).split("\n")
      traverse(node)
      ::Vim.command "let s:result = #{@tokens.to_json}"
    rescue Psych::SyntaxError
      ::Vim.command "let s:result = {}"
    end
  end
end

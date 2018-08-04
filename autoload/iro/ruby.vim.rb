# frozen_string_literal: true

require 'json'
require 'iro'

module IroVim
  module Ruby
    extend self

    def parse(bufnr)
      source = Vim.evaluate("getbufline(#{bufnr}, 1, '$')").join("\n")
      source = Encoding.encode(source)
      result = Iro::Ruby::Parser.tokens(source)
      Vim.command 'let s:result = ' + JSON.generate(result)
    end

    module Encoding
      extend self

      def encode(source)
        vim_internal_encoding = vim_to_ruby(Vim.evaluate("&encoding"))
        vim_file_encoding = vim_to_ruby(Vim.evaluate("&fileencoding"))
        source.encode(vim_file_encoding, vim_internal_encoding)
      end

      def vim_to_ruby(vim_enc)
        case vim_enc
        when ''
          vim_to_ruby(Vim.evaluate("&encoding"))
        when 'utf-8'
          ::Encoding::UTF_8
        when 'latin1'
          ::Encoding::ISO_8859_1
        when /\Acp\d+\z/
          ::Encoding.const_get(vim_enc.upcase)
        else
          warn "`#{vim_enc}` is unknwon encoding. So it is parsed as ASCII 8BIT. Pull request is welcome! https://github.com/pocke/iro.vim"
          ::Encoding::ASCII_8BIT
        end
      rescue NameError => ex
        warn ex
        warn "`#{vim_enc}` is unknwon encoding. So it is parsed as ASCII 8BIT. Pull request is welcome! https://github.com/pocke/iro.vim"
        ::Encoding::ASCII_8BIT
      end
    end
  end
end

# frozen_string_literal: true

require 'json'
require 'iro'

module IroVim
  module Ruby
    extend self

    def parse(bufnr)
      source = Vim.evaluate("getbufline(#{bufnr}, 1, '$')").join("\n")
      result = Iro::Ruby::Parser.tokens(source)
      Vim.command 'let s:result = ' + JSON.generate(result)
    end
  end
end

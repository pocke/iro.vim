module Iro
  class << self
    def clean(winnr)
      ids = Vim.evaluate('get(w:, "iro_match_ids", [])')
      ids.each do |id|
        ::Vim.evaluate("matchdelete(#{id})")
      end
      Vim.command('let w:iro_match_ids = []')
    end

    def draw(winnr, ft)
      ids = []
      tokens = ::Vim.evaluate("iro##{ft}#tokens()")
      tokens.each do |group, toks|
        toks.each_slice(8) do |ts|
          id = ::Vim.evaluate("matchaddpos(#{group.inspect}, #{ts.inspect}, -1)")
          ids << id
        end
      end
      Vim.command("let w:iro_match_ids = #{ids.inspect}")
    end
  end
end

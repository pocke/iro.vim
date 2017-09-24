import io
import tokenize
import vim
import json


definitions = vim.eval('g:iro#python#definitions')


def tokens(bufnr):
    source = "\n".join(vim.eval(f"getbufline({bufnr}, 1, '$')"))
    readline = io.BytesIO(source.encode('utf-8')).readline
    res = {}
    for token in tokenize.tokenize(readline):
        group = None
        for d in definitions:
            if token.type == eval(f"tokenize.{d[0]}"):
                group = d[1]
                break
        if not group:
            continue

        line = token.start[0]
        col = token.start[1] + 1
        size = len(token.string)
        if group not in res:
            res[group] = []
        res[group].append([line, col, size])
    s = json.dumps(res)
    vim.command(f"let s:result = {s}")

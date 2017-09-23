if !has('ruby')
  echoerr "iro.vim: This plugin does not work without has('ruby')"
  finish
endif

let s:prev_rubyopt = $RUBYOPT
let $RUBYOPT = ''
ruby nil
let $RUBYOPT = s:prev_rubyopt
unlet s:prev_rubyopt

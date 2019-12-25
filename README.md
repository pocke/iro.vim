Iro.vim
=====

Iro.vim is a Vim plugin that is a next generation syntax highlighter.




Installation
-------

Use some plugin manager.

Example to use [vim-plug](https://github.com/junegunn/vim-plug)

```viml
Plug 'pocke/iro.vim', { 'do': 'bundle install'}
```


What's different from standard syntax highlighter?
--------

TODO...



Requirements
-----


- Vim 8 or newer
- `+if_ruby` 
- `+if_python` (For Python highlight)
- psych gem version 3.0.0 or higher (for YAML highlight)
- iro gem (for Ruby highlight)
  - You can execute `bundle install` in this directory each updates.

Supported Languages
----------

- Ruby
- YAML
- Python (experimental)

License
-------

Copyright 2017-2018 Masataka Pocke Kuwabara

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

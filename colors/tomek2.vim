" Vim color file
" Maintainer:	Jan Tomek <rpi3.tomek@protonmail.com>
" Last Change:	2020 03 22
"

set background=dark
hi clear
if exists("syntax_on")
  syntax reset
endif
colorscheme default
let g:colors_name = "tomek2"

highlight Normal        ctermfg=LightGrey  ctermbg=234
highlight Folded        ctermfg=Grey       ctermbg=234
highlight Comment       ctermfg=Blue
highlight Underline                                        cterm=underline
highlight Cursor                                           cterm=reverse
hi def link Reversed Normal
highlight Reversed                                         cterm=reverse
highlight LineNr        ctermfg=LightGrey  ctermbg=236
highlight Todo                             ctermbg=Yellow
highlight Error         ctermfg=White      ctermbg=Red

highlight Constant      ctermfg=Magenta
highlight String        ctermfg=Red
highlight Special       ctermfg=LightGreen
highlight Identifier    ctermfg=Cyan                       cterm=Bold
highlight Type          ctermfg=Green
highlight Function      ctermfg=Cyan
highlight Statement     ctermfg=Brown
highlight Keyword       ctermfg=202
highlight Label         ctermfg=Yellow
highlight PreProc       ctermfg=Grey

" VimDiff colors
highlight DiffAdd       ctermfg=250        ctermbg=60      cterm=Bold     " line was added
highlight DiffDelete    ctermfg=250        ctermbg=60      cterm=Bold     " line was deleted
highlight DiffChange    ctermfg=250        ctermbg=60      cterm=Bold     " line was changed - whole line
highlight DiffText      ctermfg=255        ctermbg=196     cterm=Bold     " line was changed - the changed text


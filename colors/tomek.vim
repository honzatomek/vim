" Vim color file
" Maintainer:	Jan Tomek <rpi3.tomek@protonmail.com>
" Last Change:	2020 03 22
"

set background=dark
hi clear
if exists("syntax_on")
  syntax reset
endif
"colorscheme default
let g:colors_name = "tomek"

" hardcoded colors :
" GUI Comment : #80a0ff = Light blue

" GUI
" highlight Normal     guifg=Grey80	guibg=Black
" highlight Search     guifg=Black	guibg=Red	gui=bold
" highlight Visual     guifg=#404040			gui=bold
" highlight Cursor     guifg=Black	guibg=Green	gui=bold
" highlight Special    guifg=Orange
" highlight Comment    guifg=#80a0ff
" highlight StatusLine guifg=blue		guibg=white
" highlight Statement  guifg=Yellow			gui=NONE
" highlight Type						gui=NONE

" Console
highlight Normal       ctermfg=LightGrey  ctermbg=236
highlight LineNr       ctermfg=LightGrey  ctermbg=238
highlight Search       ctermfg=236        ctermbg=Red     cterm=NONE
highlight Visual                                          cterm=reverse
highlight Cursor       ctermfg=236        ctermbg=Green   cterm=bold
highlight Special      ctermfg=Brown
highlight Comment      ctermfg=Blue
highlight StatusLine   ctermfg=blue       ctermbg=white
highlight Statement    ctermfg=Yellow                     cterm=NONE
highlight Type                                            cterm=NONE

highlight DiffAdd      ctermfg=236        ctermbg=Blue
highlight DiffDelete   ctermfg=236        ctermbg=Blue
highlight DiffChange   ctermfg=236        ctermbg=Blue 
highlight DiffText     ctermfg=Blue       ctermbg=LightGrey

" only for vim 5
" if has("unix")
"   if v:version<600
"     highlight Normal  ctermfg=Grey	ctermbg=Black	cterm=NONE	guifg=Grey80      guibg=Black	gui=NONE
"     highlight Search  ctermfg=Black	ctermbg=Red	cterm=bold	guifg=Black       guibg=Red	gui=bold
"     highlight Visual  ctermfg=Black	ctermbg=yellow	cterm=bold	guifg=#404040			gui=bold
"     highlight Special ctermfg=LightBlue			cterm=NONE	guifg=LightBlue			gui=NONE
"     highlight Comment ctermfg=Cyan			cterm=NONE	guifg=LightBlue			gui=NONE
"   endif
" endif


if exists("b:permas_dat_diff")
  finish
endif

" ignore case
" set diffopt+=icase
" ignore whitespace
set diffopt+=iwhite
" from ../plugin/permas_diff.vim
if !exists("g:permas_diffopt")
  let g:permas_diffopt = []
endif
" ignore comments
" let g:permas_diffopt += ["icomment"]
" ignore commented lines
let g:permas_diffopt += ["icline"]
" ignore blank lines
let g:permas_diffopt += ["iblank"]
set diffexpr=PermasDiff()

let b:permas_dat_diff = 1

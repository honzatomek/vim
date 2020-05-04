" if exists("g:git_custom_syntax_loaded")
"   finish
" endif

syn match gitadd "\v^\s{4}\+.*$"
syn match gitdel "\v^\s{4}\-.*$"

hi def link gitadd DiffAdd
hi def link gitdel DiffDelete

let g:git_custom_syntax_loaded = 1

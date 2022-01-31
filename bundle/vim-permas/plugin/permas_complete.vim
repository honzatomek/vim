" Vim plugin file for Permas *.dat1 Code Completion
"
"     Plugin:  vim-permas/permas_complete.vim
"     Author:  AKKA Czech republic - Jan Tomek <jan.tomek@mbeng.cz>
"     Date:    27.04.2020
"     Varsion: 0.1.0
"
"#############################################################################

" load plugin only once ================================================= {{{1
if exists("g:permas_complete_plugin_loaded")
  finish
endif

" set plugin location =================================================== {{{1
if !exists("g:permas_complete_plugin_location")
  let g:permas_complete_plugin_location = fnamemodify(resolve(expand("<sfile>:p")), ":h:h")
else
  let g:permas_complete_plugin_location = substitute(g:permas_complete_plugin_location, "/$", "", "")
endif

" set snippets location ================================================= {{{1
if !exists("g:permas_complete_snippets_location")
  let g:permas_complete_snippets_location = g:permas_complete_plugin_location . "/permas_complete"
else
  let g:permas_complete_snippets_location = substitute(g:permas_complete_snippets_location, "/$", "", "")
endif

" set filetype specific snippet location ================================ {{{1
function! s:PermasComplete_SetFiletypeSpecifics(filetype)
  if !exists("g:permas_complete_snippets_" . a:filetype)
    silent! execute "let g:permas_complete_snippets_" . a:filetype . " =  g:permas_complete_snippets_location . \"/" . a:filetype . "\""
  else
    silent! execute "let g:permas_complete_snippets_" . a:filetype . " = substitute(g:permas_complete_snippets_" . a:filetype . ", \"/$\", \"\", \"\")"
  endif
  silent! execute "echom '[i] PermasComplete: filetype snippets stored at ' .  g:permas_complete_snippets_" . a:filetype
endfunction

augroup PermasComplete
  autocmd!
  autocmd FileType permas_uci,permas_dat :call <SID>PermasComplete_SetFiletypeSpecifics(&filetype)
augroup END

" set plugin keymaps ==================================================== {{{1
function! s:PermasComplete_SetMapping(mode, name, function, keys)
  silent! execute a:mode . 'noremap <silent> <plug>' . a:name . ' :call ' . a:function . '<cr>'
"   if !hasmapto('<plug>' . a:name, a:mode) && (mapcheck(a:keys, a:mode) == "")
"     execute a:mode . 'map <silent> ' . a:keys . ' <plug>' . a:name
"   endif
endfunction

call <SID>PermasComplete_SetMapping('n', 'PermasComplete_InsertSnippetN', 'permas_complete#Insert("n")', '<leader>pi')
call <SID>PermasComplete_SetMapping('v', 'PermasComplete_InsertSnippetV', 'permas_complete#Insert("v")', '<leader>pi')
call <SID>PermasComplete_SetMapping('n', 'PermasComplete_InsertSnippetI', 'permas_complete#Insert("i")', '$$')
call <SID>PermasComplete_SetMapping('n', 'PermasComplete_StoreSnippetN', 'permas_complete#Store("n")', '<leader>ps')
call <SID>PermasComplete_SetMapping('v', 'PermasComplete_StoreSnippetV', 'permas_complete#Store("v")', '<leader>ps')

" }}}

let g:permas_complete_plugin_loaded = 1
" vim: set fdm=marker ft=vim

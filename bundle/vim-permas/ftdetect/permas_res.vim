au BufRead *.res setlocal filetype=permas_res nofoldenable readonly nomodifiable
" au BufRead *.res if (search('P E R M A S', 'n', 50) > 0) | setlocal filetype=permas_res nofoldenable readonly nomodifiable | endif
" au BufRead *.res if (expand("%:p:h")=~'\v\S*/permas/\S*') | setlocal filetype=permas_res nofoldenable readonly nomodifiable | endif


au BufRead *.pro setlocal filetype=permas_pro nofoldenable readonly nomodifiable
au BufRead *.pro if (search('P E R M A S', 'n', 50) > 0) | setlocal filetype=permas_pro nofoldenable readonly nomodifiable | endif
au BufRead *.pro if (expand("%:p:h")=~'\v\S*/permas/\S*') | setlocal filetype=permas_pro nofoldenable readonly nomodifiable | endif
au BufRead *.o\d\+ if (expand("%:p:h")=~'\v\S*/permas/\S*') | setlocal filetype=permas_pro nofoldenable readonly nomodifiable | endif


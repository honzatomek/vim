" au BufRead,BufNewFile *.dato set filetype=permas_dat
" au BufRead,BufNewFile *.dat1 set filetype=permas_dat
" au BufRead,BufNewFile *.dat set filetype=permas_dat

" autocmd BufRead,BufNewFile *.dato,*.dat,*.dat\d*,*.post setlocal filetype=permas_dat nofoldenable
" autocmd BufRead,BufNewFile *.dato,*.dat,*.dat\d*,*.post let &foldenable=(line2byte('$') < 1*32*1024*1024)

autocmd BufRead,BufNewFile *.dato,*.dat,*.dat\d*,*.post if (line2byte('$') < 1*32*1024*1024) | setlocal filetype=permas_dat | setlocal nofoldenable | else | setlocal filetype=txt | endif

" autocmd BufRead,BufEnter,BufLeave,InsertLeave,CursorMoved *.dato,*.dat,*.dat\d*,*.post call PermasDatPlaceSigns()
autocmd BufRead,BufEnter,BufLeave,InsertLeave,CursorMoved *.dato,*.dat,*.dat\d*,*.post if (&filetype == 'permas_dat') | call PermasDatPlaceSigns() | endif

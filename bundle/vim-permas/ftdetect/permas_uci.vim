au BufRead,BufNewFile *.uci setlocal filetype=permas_uci nofoldenable
au BufRead,BufNewFile *.uci setlocal shortmess+=c
au BufRead,BufEnter,BufLeave,InsertLeave,CursorMoved *.uci call PermasUCIPlaceSigns()
" au TextChangedI *.uci if !pumvisible() | silent call feedkeys("\<c-x>\<c-k>\<c-p>", "n") | endif

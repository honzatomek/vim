" GREP Operator, based on Learn Vim Script the Hard Way
"
" Author: Jan Tomek <rpi3.tomek@protonmail.com>
" Date:   21.4.2020

nnoremap          <leader>g     :set operatorfunc=<SID>GrepOperator<cr>g@
vnoremap          <leader>g     :<c-u>call <SID>GrepOperator(visualmode())<cr>

function! s:GrepOperator(type)
    let l:saved_unnamed_register = @@

    if a:type ==# 'v'
        normal! `<v`>y
    elseif a:type ==# 'char'
        normal! `[y`]
    else
        return
    endif

    silent execute "grep! -R " . shellescape(@@) . " ."
    copen

    let @@ = l:saved_unnamed_register
endfunction


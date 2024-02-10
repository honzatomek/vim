if exists("b:permas_pro_search")
    finish
endif

nnoremap <buffer> <F5> :call <SID>ProSearch(0)<CR>
nnoremap <buffer> <S-F5> :call <SID>ProSearch(1)<CR>

nnoremap <buffer> q :quit!<CR>
nnoremap <buffer> Q :quit!<CR>

nnoremap <buffer> r :edit!<CR>:normal G<CR>

nnoremap <buffer> m :normal $<CR>:call <SID>ProSearchTag(['Msg\\>'],0)<CR>
nnoremap <buffer> M :normal 0<CR>:call <SID>ProSearchTag(['Msg\\>'],1)<CR>

nnoremap <buffer> c :normal $<CR>:call <SID>ProSearchTag(['^\\s*\\*C\\*'],0)<CR>
nnoremap <buffer> C :normal 0<CR>:call <SID>ProSearchTag(['^\\s*\\*C\\*'],1)<CR>

nnoremap <buffer> w :normal $<CR>:call <SID>ProSearchTag(['^\\s*\\*W\\*'],0)<CR>
nnoremap <buffer> W :normal 0<CR>:call <SID>ProSearchTag(['^\\s*\\*W\\*'],1)<CR>

" nnoremap <buffer> e :normal $<CR>:call <SID>ProSearchTag(['^\\s*\\*E\\*', '^\\s*\\*F\\*'],0)<CR>
" nnoremap <buffer> E :normal 0<CR>:call <SID>ProSearchTag(['^\\s*\\*E\\*', '^\\s*\\*F\\*'],1)<CR>
nnoremap <buffer> e :normal $<CR>:call <SID>ProSearchTag(['^\\s*\\*E\\*'],0)<CR>
nnoremap <buffer> E :normal 0<CR>:call <SID>ProSearchTag(['^\\s*\\*E\\*'],1)<CR>

nnoremap <buffer> f :normal $<CR>:call <SID>ProSearchTag(['^\\s*\\*F\\*'],0)<CR>
nnoremap <buffer> F :normal 0<CR>:call <SID>ProSearchTag(['^\\s*\\*F\\*'],1)<CR>

function! s:ProSearchTag(tags, backward)
    if a:backward
        let l:flag = 'bw'
    else
        let l:flag = 'w'
    endif

    let l:line = search('\v' . join(a:tags, '|'), 'n' . l:flag)
    if l:line != 0
        call cursor(l:line, 1)
        normal! zz
    else
        echom 'No [' . join(a:tags, ', ') . '] tag found!'
    endif

    " if search('\v' . join(a:tags, '|'), 'n') != 0
        " call search('\v' . join(a:tags, '|'), l:flag)
        " normal! zz
    " else
        " echom 'No [' . join(a:tags, ', ') . '] tag found!'
    " endif
endfunction

" Search *F*, *E*, *W*, *C* tags in this order respectively
function! s:ProSearch(backward)
    if a:backward
        let l:flag = 'bw'
    else
        let l:flag = 'w'
    endif

    if search("^\\*\\(F\\|E\\)\\*", 'n') != 0
       call search("^\\*\\(F\\|E\\)\\*", l:flag)
       normal! zz
"     elseif search("^\\*E\\*", 'n') != 0
"        call search("^\\*E\\*", l:flag)
    elseif search("^\\*W\\*", 'n') != 0
       call search("^\\*W\\*", l:flag)
       normal! zz
    elseif search("^\\*C\\*", 'n') != 0
       call search("^\\*C\\*", l:flag)
       normal! zz
    endif
endfunction

let b:permas_pro_search = 1

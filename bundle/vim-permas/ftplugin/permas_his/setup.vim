if exists("b:permas_his_setup")
    finish
endif

" nnoremap <buffer> q :quit!<CR>
nnoremap <buffer> Q :quit!<CR>

nnoremap <buffer> r :edit!<CR>:normal G<CR>

let b:permas_his_setup = 1

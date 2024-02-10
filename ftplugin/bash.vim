if exists('g:loaded_tomek_bash_mappings')
    finish
endif

" <--------------------------------------------------------------------------------------- BASH --->
" set directory for bash#ExecuteAndShow temporary files
let g:bash_tmp_dir = $HOME . "/tmp/vim/"

" execute current line in BASH and insert output below
noremap  <silent>      !I           :exec '.r !'.getline('.')<CR>
" execute current line as a separate BASH script and show the output in a new buffer
" nnoremap <silent>      !!           :call bash#ExecuteLine()<CR>
noremap  <silent>      !!           :call bash#ExecuteAndShow('n')<CR>
" execute selected lines as a separate BASH script and show the output in a new buffer
vnoremap <silent>      !!           :call bash#ExecuteAndShow('v')<CR>
" execute whole file as a separate BASH script and show the output in a new buffer
noremap  <silent>      !A           :normal ggjVG<CR>:call bash#ExecuteAndShow('v')<CR>
" execute file up to cursor as a separate BASH script and show the output in a new buffer
noremap  <silent>      !C           :normal Vggj<CR>:call bash#ExecuteAndShow('v')<CR>

let g:loaded_tomek_bash_mappings = 1

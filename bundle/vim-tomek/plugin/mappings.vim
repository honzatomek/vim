if exists('g:loaded_tomek_mappings')
    finish
endif
let g:loaded_tomek_mappings = 1

" <------------------------------------------------------------------------------------ TAGLIST --->
let Tlist_Ctags_Cmd='/usr/bin/ctags'
let Tlist_Use_Right_Window = 1
nnoremap <silent>     <F8>          :TlistToggle<CR>

" <----------------------------------------------------------------------------------- FOLDLIST --->
nnoremap <silent>     <F9>          :Flist<CR>

" <----------------------------------------------------------------------------- CUSTOM FOLDING --->
nnoremap <buffer>      f            za
nnoremap <silent> <buffer> F        :call folding_controls#ToggleFold()<CR>
setlocal foldtext=folding_controls#CustomFoldText()
set fillchars=fold:\ 

" <---------------------------------------------------------------------------------- GITBACKUP --->
" vim-gitbackup plugin: backup directory for all files
let g:custom_backup_dir='~/.vim_gitbackup'

" <--------------------------------------------------------------------------------------- BASH --->
" set directory for bash#ExecuteAndShow temporary files
let g:bash_tmp_dir = $HOME . "/tmp/vim/"

" execute current line in BASH and insert output below
nmap     <silent>      !I           :exec '.r !'.getline('.')<CR>
" execute current line as a separate BASH script and show the output in a new buffer
" nnoremap <silent>      !!           :call bash#ExecuteLine()<CR>
nmap     <silent>      !!           :call bash#ExecuteAndShow('n')<CR>
" execute selected lines as a separate BASH script and show the output in a new buffer
vmap     <silent>      !!           :call bash#ExecuteAndShow('v')<CR>
" execute whole file as a separate BASH script and show the output in a new buffer
nmap     <silent>      !A           :normal ggjVG<CR>:call bash#ExecuteAndShow('v')<CR>
" execute file up to cursor as a separate BASH script and show the output in a new buffer
nmap     <silent>      !C           :normal Vggj<CR>:call bash#ExecuteAndShow('v')<CR>

" <------------------------------------------------------------------------------------- PYTHON --->
" Bind F5 to save file if modified and execute python script in a buffer.
nnoremap <silent> <F5> :call python#SaveAndExecute()<CR>
vnoremap <silent> <F5> :<C-u>call python#SaveAndExecute()<CR>

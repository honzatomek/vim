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
" nnoremap <buffer>      f            za
" nnoremap <silent> <buffer> F        :call folding_controls#ToggleFold()<CR>
" setlocal foldtext=folding_controls#CustomFoldText()
" setlocal fillchars=fold:\ 
nnoremap              <leader>f     za
nnoremap <silent>     <leader>F     :call folding_controls#ToggleFold()<CR>
set foldtext=folding_controls#CustomFoldText()
set fillchars=fold:\ 

" <---------------------------------------------------------------------------------- GITBACKUP --->
" vim-gitbackup plugin: backup directory for all files
let g:custom_backup_dir='~/.vim_gitbackup'

" <--------------------------------------------------------------------------------------- JSON --->
" reformat json file into pretty pring
" command! Json execute "normal ggVG!jq '.'"
command! JsonPretty %!python -m json.tool
" reformat json file into one line
command! JsonOneline %s/^\s*//g | %s/\s*$\n//g


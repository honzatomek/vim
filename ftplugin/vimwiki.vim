if exists("b:custom_vimwiki_override")
  finish
endif

" the following in vimwiki/plugin/vimwiki.vim throw an error
" as they cannot be found in vimwiki#u#map_key
" omap <buffer> a\ <plug>VimwikiTextObjTableCell
" vmap <buffer> a\ <plug>VimwikiTextObjTableCellV
" omap <buffer> i\ <plug>VimwikiTextObjTableCellInner
" vmap <buffer> i\ <plug>VimwikiTextObjTableCellInnerV

" FIX:
" disabled text objects mappings in $MYVIMRC
" let g:vimwiki_key_mappings = {'text_objs': 0,}
"
" hard linked the following keymaps without the <plug>

onoremap <silent><buffer> ah
    \ :<C-U>call vimwiki#base#TO_header(0, 0, v:count1)<CR>
vnoremap <silent><buffer> ah
    \ :<C-U>call vimwiki#base#TO_header(0, 0, v:count1)<CR>
onoremap <silent><buffer> ih
    \ :<C-U>call vimwiki#base#TO_header(1, 0, v:count1)<CR>
vnoremap <silent><buffer> ih
    \ :<C-U>call vimwiki#base#TO_header(1, 0, v:count1)<CR>
onoremap <silent><buffer> aH
    \ :<C-U>call vimwiki#base#TO_header(0, 1, v:count1)<CR>
vnoremap <silent><buffer> aH
    \ :<C-U>call vimwiki#base#TO_header(0, 1, v:count1)<CR>
onoremap <silent><buffer> iH
    \ :<C-U>call vimwiki#base#TO_header(1, 1, v:count1)<CR>
vnoremap <silent><buffer> iH
    \ :<C-U>call vimwiki#base#TO_header(1, 1, v:count1)<CR>
onoremap <silent><buffer> a\
    \ :<C-U>call vimwiki#base#TO_table_cell(0, 0)<CR>
vnoremap <silent><buffer> a\
    \ :<C-U>call vimwiki#base#TO_table_cell(0, 1)<CR>
onoremap <silent><buffer> i\
    \ :<C-U>call vimwiki#base#TO_table_cell(1, 0)<CR>
vnoremap <silent><buffer> i\
    \ :<C-U>call vimwiki#base#TO_table_cell(1, 1)<CR>
onoremap <silent><buffer> ac
    \ :<C-U>call vimwiki#base#TO_table_col(0, 0)<CR>
vnoremap <silent><buffer> ac
    \ :<C-U>call vimwiki#base#TO_table_col(0, 1)<CR>
onoremap <silent><buffer> ic
    \ :<C-U>call vimwiki#base#TO_table_col(1, 0)<CR>
vnoremap <silent><buffer> ic
    \ :<C-U>call vimwiki#base#TO_table_col(1, 1)<CR>
onoremap <silent><buffer> al
    \ :<C-U>call vimwiki#lst#TO_list_item(0, 0)<CR>
vnoremap <silent><buffer> al
    \ :<C-U>call vimwiki#lst#TO_list_item(0, 1)<CR>
onoremap <silent><buffer> il
    \ :<C-U>call vimwiki#lst#TO_list_item(1, 0)<CR>
vnoremap <silent><buffer> il
    \ :<C-U>call vimwiki#lst#TO_list_item(1, 1)<CR>

let b:custom_vimwiki_override = 1

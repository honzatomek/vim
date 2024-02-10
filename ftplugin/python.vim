if exists('g:loaded_tomek_python_mappings')
    finish
endif

command! Pytest :! python -m pytest -v %

function! IsPytest()
  return split(expand("%"), "_")[0] == "test"
endfunction


" <------------------------------------------------------------------------------------- PYTHON --->
" Bind F5 to save file if modified and execute python script in a buffer.
nnoremap <silent> <F5> :call python#SaveAndExecute()<CR>
vnoremap <silent> <F5> :<C-u>call python#SaveAndExecute()<CR>

let g:loaded_tomek_python_mappings = 1

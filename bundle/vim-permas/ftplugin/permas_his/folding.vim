if exists("b:permas_his_ftplugin")
    finish
endif
let b:permas_his_ftplugin = 1

setlocal foldmethod=expr
setlocal foldexpr=PermasHisFoldExpr(v:lnum)
setlocal foldtext=PermasHisText()
" setlocal foldnestmax=2
" setlocal foldlevelstart=2

nnoremap <buffer> <leader>f za
nnoremap <buffer> <leader>F :call ToggleFold()<CR>

"map <buffer> F zA
let b:folded = 1
setlocal fillchars=fold:\ 

function! ToggleFold()
    if b:folded == 0
        exec "normal! zM"
        let b:folded = 1
    else
        exec "normal! zR"
        let b:folded = 0
    endif
endfunction

let g:line_length = 100

function! PermasHisText()
    let size = 1 + v:foldend - v:foldstart
    if size < 10
        let size = " " . size
    endif
    if size < 100
        let size = " " . size
    endif
    if size < 1000
        let size = " " . size
    endif

    if match(getline(v:foldstart), '"""') >= 0
        let text = substitute(getline(v:foldstart), '"""', '', 'g' ) . ' '
    elseif match(getline(v:foldstart), "'''") >= 0
        let text = substitute(getline(v:foldstart), "'''", '', 'g' ) . ' '
    else
        let text = getline(v:foldstart)
    endif

    " return size . ' lines:'. text . ' '
    if len(text) < g:line_length
        let padding = repeat(' ', max([g:line_length - len(text), 0]))
        return text . padding . '  (lines: ' . size . ')'
    else
        return text . '  (lines: ' . size . ')'
    endif
endfunction

function! PermasHisFoldExpr(lnum) abort
    let l:cur_line = tolower(getline(a:lnum))
"     echom l:cur_line
    if l:cur_line =~? "/\s\+line"
"       echom 'header'
      return 0
    endif

    let l:prev_line = tolower(getline(a:lnum - 1))
    if l:prev_line =~ '\v/\s+line'
      return 1
    else
      let l:next_line = tolower(getline(a:lnum + 1))
      if l:next_line =~ '\v/\s+\-+'
"         echom 'footer'
        return 0
      else
"         echom 'else'
        return '='
      endif
    endif

    return '='
endfunction

" In case folding breaks down
function! ReFold()
    setlocal foldmethod=expr
    setlocal foldexpr=0
"    set foldnestmax=1
    setlocal foldmethod=expr
    setlocal foldexpr=PermasHisFoldExpr(v:lnum)
    setlocal foldtext=PermasHisText()
    echo
endfunction

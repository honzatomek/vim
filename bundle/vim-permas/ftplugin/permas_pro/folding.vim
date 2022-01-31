if exists("b:permas_pro_folding")
    finish
endif

setlocal foldmethod=expr
setlocal foldexpr=<SID>PermasProFoldExpr(v:lnum)
setlocal foldtext=<SID>PermasProFoldText()
let b:folding_line_length = 82

nnoremap <buffer> f za
nnoremap <buffer> F :call <SID>ToggleFold()<CR>

let b:folded = 0
setlocal fillchars=fold:\ 

function! Unfold()
    if b:folded == 1
        exec "normal! zR"
        let b:folded = 0
    endif
endfunction

function! s:ToggleFold()
    if b:folded == 0
        exec "normal! zM"
        let b:folded = 1
    else
        exec "normal! zR"
        let b:folded = 0
    endif
endfunction

function! s:PermasProFoldText()
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
        let l:text = substitute(getline(v:foldstart), '"""', '', 'g' ) . ' '
    elseif match(getline(v:foldstart), "'''") >= 0
        let l:text = substitute(getline(v:foldstart), "'''", '', 'g' ) . ' '
    else
        let l:text = getline(v:foldstart)
    endif

    " return size . ' lines:'. l:text . ' '
    if len(text) < b:folding_line_length
        let padding = repeat(' ', max([b:folding_line_length - len(text), 0]))
        return l:text . padding . '  (lines: ' . size . ')'
    else
        return l:text . '  (lines: ' . size . ')'
    endif
endfunction

function! s:PermasProFoldExpr(lnum) abort
    if getline(a:lnum) =~ "^\\s*\\(\\*F\\*\\|\\*E\\*\\|\\*W\\*\\|\\*C\\*\\|\\d\\{6}\\s\\+Msg>\\)\\s.*"
        return 0
    else
        return 1
    endif
endfunction

" In case folding breaks down
function! ReFold()
    setlocal foldmethod=expr
    setlocal foldexpr=0
    setlocal foldmethod=expr
    setlocal foldexpr=<SID>PermasProFoldExpr(v:lnum)
    setlocal foldtext=<SID>PermasProFoldText()
    echo
endfunction

let b:permas_pro_folding = 1

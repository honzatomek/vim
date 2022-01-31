if exists("b:permas_res_folding")
    finish
endif

setlocal foldmethod=expr
setlocal foldexpr=<SID>PermasResFoldExpr(v:lnum)
setlocal foldtext=<SID>PermasResFoldText()
let b:folding_line_length = 132

nnoremap <buffer> f za
nnoremap <buffer> F :call <SID>ToggleFold()<CR>
nnoremap <silent> <buffer> r :edit!<CR>:call <SID>Unfold()<CR>G

let b:folded = 0
setlocal fillchars=fold:\ 

function! s:Unfold()
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

function! s:PermasResFoldText()
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

function! s:PermasResFoldExpr(lnum)
    if getline(a:lnum) =~ "^\\s*\\(\\*F\\*\\|\\*E\\*\\|\\*W\\*\\|\\*C\\*\\|\\d\\{6}\\s\\+Msg>\\)\\s.*"
        return 0
    elseif getline(a:lnum) =~ "^\\s*Databus\\sINTRO.*"
        return 0
    elseif getline(a:lnum) =~ "^\\s*>.*"
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
    setlocal foldexpr=<SID>PermasResFoldExpr(v:lnum)
    setlocal foldtext=<SID>PermasResFoldText()
    echo
endfunction

let b:permas_res_folding = 1

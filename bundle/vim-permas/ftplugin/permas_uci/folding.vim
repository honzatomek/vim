if exists("b:permas_uci_ftplugin")
    finish
endif
let b:permas_uci_ftplugin = 1

setlocal foldmethod=expr
setlocal foldexpr=PermasUciFoldExpr(v:lnum)
setlocal foldtext=PermasUciText()

nnoremap <buffer> <leader>f za
nnoremap <buffer> <leader>F :call ToggleFold()<CR>
nnoremap <buffer> <F5> :call UciSearch(0)<CR>
nnoremap <buffer> <S-F5> :call UciSearch(1)<CR>
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

function! PermasUciText()
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

let g:zero = ['NEW', 'MODIFY', 'DEFAULT', 'STOP']
let g:sections = ['INPUT', 'EXEC', 'SELECT', 'PRINT', 'EXPORT', 'USER', 'LICENSE']
let g:sec_end = 'RETURN'
let g:cloop = 'CLOOP'
let g:cloop_end = 'END'
let g:task = 'TASK'
let g:task_end = ['END', 'STORE', 'RUN']
let g:port = 'PORT'
let g:port_end = 'RESET'

function! PermasUciFoldExpr(lnum)
    let l:prev_line = toupper(get(split(getline(a:lnum - 1)), 0, ''))
    let l:cur_line = toupper(get(split(getline(a:lnum)), 0, ''))

    if index(g:sections, l:cur_line) >= 0
        return 0
    elseif index(g:zero, l:cur_line) >= 0
        return 0
    elseif l:cur_line == g:cloop || l:cur_line == g:task || l:cur_line == g:port
        return 0
    elseif l:cur_line == g:sec_end
        return 0
    endif

    if index(g:sections, l:prev_line) >= 0
        return 1
    elseif l:prev_line == g:port && toupper(get(split(getline(a:lnum - 1)), 2, '')) != g:port_end
        return 1
    endif

    return '='
endfunction


function! PermasUciFoldExpr2(lnum) abort
    let l:prev_line = toupper(get(split(getline(a:lnum - 1)), 0, ''))
    let l:cur_line = toupper(get(split(getline(a:lnum)), 0, ''))

    if index(g:zero, l:cur_line, 0, 1) >= 0
        return 0
    endif

    if l:prev_line == g:cloop
        if toupper(get(split(getline(a:lnum - 1)), 1, '')) != g:cloop_end
            return foldlevel(a:lnum - 1) + 1
        endif
    elseif l:prev_line == g:task
        if index(g:task_end, toupper(get(split(getline(a:lnum)), 1, ''))) < 0
            return foldlevel(a:lnum - 1) + 1
        endif
    elseif l:prev_line == g:port
        if toupper(get(split(getline(a:lnum)), 2, '')) != g:port_end
            return foldlevel(a:lnum - 1) + 1
        endif
    endif

    if l:cur_line == g:cloop
        if toupper(get(split(getline(a:lnum)), 1, '')) == g:cloop_end
            let l:last_level = foldlevel(search(g:cloop, 'bn'))
            return l:last_level
        else
            return '='
        endif
    elseif l:cur_line == g:task
        if index(g:task_end, toupper(get(split(getline(a:lnum)), 1, ''))) >= 0
            let l:last_level = foldlevel(search(g:task, 'bn'))
            return l:last_level
        else
            return '='
        endif
    elseif l:cur_line == g:port
        if toupper(get(split(getline(a:lnum)), 2, '')) == g:port_end
            let l:last_level = foldlevel(search(g:port, 'bn'))
            return l:last_level
        else
            return '='
        endif
    endif

    if index(g:sections, l:prev_line, 0, 1) >= 0
        return foldlevel(a:lnum - 1) + 1
    endif

    if l:cur_line == g:sec_end
        return foldlevel(a:lnum - 1) - 1
    endif

    return '='
endfunction

" In case folding breaks down
function! ReFold()
    setlocal foldmethod=expr
    setlocal foldexpr=0
"    set foldnestmax=1
    setlocal foldmethod=expr
    setlocal foldexpr=PermasUciFoldExpr(v:lnum)
    setlocal foldtext=PermasUciText()
    echo
endfunction

" let g:sections = ['INPUT', 'EXEC', 'SELECT', 'PRINT', 'EXPORT', 'USER', 'LICENSE']
" Search *F*, *E*, *W*, *C* tags in this order respectively
function! UciSearch(backward)
    if a:backward
        let l:flag = 'bw'
    else
        let l:flag = 'w'
    endif

    if search("\\c^\\s*\\(INPUT\\|EXEC\\|SELECT\\|PRINT\\|EXPORT\\|USER\\|LICENSE\\)", 'n') != 0
        call search("^\\s*\\(INPUT\\|EXEC\\|SELECT\\|PRINT\\|EXPORT\\|USER\\|LICENSE\\)", l:flag)
        normal! zz
    elseif search("\\c^\\s*\\READ\\s", 'n') != 0
        call search("\\c^\\s*\\READ\\s", l:flag)
        normal! $
        normal! zz
    endif
    " if search("^\\*\\(F\\|E\\)\\*", 'n') != 0
    "    call search("^\\*\\(F\\|E\\)\\*", l:flag)
    " endif
endfunction


if exists('g:folding_controls_loaded')
    finish
endif
let g:folding_controls_loaded = 1

function! s:are_folds_closed()
    let l:index = 0
    while l:index < line('$')
        let l:index += 1
        if foldclosed(l:index) > 0
            return 1
        endif
    endwhile
    return 0
endfunction

if !exists('b:file_folded')
    let b:file_folded = s:are_folds_closed()
endif
function! folding_controls#ToggleFold()
    if b:file_folded == 0
        exec 'normal! zM'
        let b:file_folded = 1
    else
        exec 'normal! zR'
        let b:file_folded = 0
    endif
endfunction

if !exists('b:folded_line_length')
    let b:folded_line_length = 100
endif
function! folding_controls#CustomFoldText()
    let size = 1 + v:foldend - v:foldstart
    if size < 10
        let size = "   " . size
    elseif size < 100
        let size = "  " . size
    elseif size < 1000
        let size = " " . size
    endif

    if match(getline(v:foldstart), '"""') >= 0
        let text = substitute(getline(v:foldstart), '"""', '', 'g') . ' '
    elseif match(getline(v:foldstart), "'''") >= 0
        let text = substitute(getline(v:foldstart), "'''", '', 'g') . ' '
    else
        let text = getline(v:foldstart)
    endif

    if len(text) < b:folded_line_length
        let padding = repeat(' ', max([b:folded_line_length - len(text), 0]))
        return text . padding . '  (lines: ' . size . ')'
    else
        return text . '  (lines: ' . size . ')'
    endif
endfunction


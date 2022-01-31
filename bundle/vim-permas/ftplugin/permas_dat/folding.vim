if exists("b:permas_dat_ftplugin")
    finish
endif
let b:permas_dat_ftplugin = 1

setlocal foldmethod=expr
setlocal foldexpr=PermasDatFoldExpr(v:lnum)
setlocal foldtext=PermasDatText()
" setlocal foldnestmax=2
" setlocal foldlevelstart=2

nnoremap <buffer> <leader>f za
nnoremap <buffer> <leader>F :call ToggleFold()<CR>
nnoremap <buffer> <F5> :call DatSearch(0,1)<CR>
nnoremap <buffer> <S-F5> :call DatSearch(1,1)<CR>

nnoremap <buffer> <C-F5> :call DatSearch(0,0)<CR>
nnoremap <buffer> <C-S-F5> :call DatSearch(1,0)<CR>

"map <buffer> F zA
let b:folded = 1
setlocal fillchars=fold:\ 
let b:fold_compo = 0

let g:permasdat_compo_level = 0
let g:permasdat_compo_tags = {
            \ '$enter': g:permasdat_compo_level}
let g:permasdat_cend_tags = {
            \ '$exit': g:permasdat_compo_level - 1 > -1 ? g:permasdat_compo_level - 1 : 0,
            \ '$fin': g:permasdat_compo_level - 1 > -1 ? g:permasdat_compo_level - 1 : 0}

let g:permasdat_variant_level = g:permasdat_compo_level + 1
let g:permasdat_variant_tags = {
            \ '$structure': g:permasdat_variant_level,
            \ '$situation': g:permasdat_variant_level,
            \ '$loading': g:permasdat_variant_level,
            \ '$constraints': g:permasdat_variant_level,
            \ '$system': g:permasdat_variant_level,
            \ '$modification': g:permasdat_variant_level,
            \ '$results': g:permasdat_variant_level,
            \ '$material': g:permasdat_variant_level}
let g:permasdat_varend_tags = {
            \ '$end': g:permasdat_variant_level - 1 > -1 ? g:permasdat_variant_level - 1 : 0}

let g:permasdat_dont_fold_tags = {
            \ '$defvar': 0,
            \ '$loop': 0,
            \ '$endloop': 0,
            \ '$echo': 0,
            \ '$include': 0}

let g:permasdat_command_level = g:permasdat_variant_level + 1

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

function! PermasDatText()
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

function! PermasDatFoldExpr(lnum) abort
    let l:cur_line = tolower(get(split(getline(a:lnum)), 0, ''))
    if has_key(g:permasdat_cend_tags, l:cur_line)
        " echo 'Compo level end'
        return get(g:permasdat_cend_tags, l:cur_line)
    elseif has_key(g:permasdat_varend_tags, l:cur_line)
        " echo 'Variant level end'
        return get(g:permasdat_varend_tags, l:cur_line)
    endif

    let l:prev_line = tolower(get(split(getline(a:lnum - 1)), 0, ''))
    " echo g:permasdat_compo_tags
    if has_key(g:permasdat_compo_tags, l:prev_line)
        " echo 'Compo level'
        return get(g:permasdat_compo_tags, l:prev_line)
    elseif has_key(g:permasdat_variant_tags, l:prev_line)
        " echo 'Variant level'
        return get(g:permasdat_variant_tags, l:prev_line)
    endif

    if l:cur_line =~ "^\s*\$\w*"
        if !has_key(g:permasdat_compo_tags, l:cur_line)
                    \ && !has_key(g:permasdat_variant_tags, l:cur_line)
                    \ && !has_key(g:permasdat_cend_tags, l:cur_line)
                    \ && !has_key(g:permasdat_varend_tags, l:cur_line)
                    \ && !has_key(g:permasdat_dont_fold_tags, l:cur_line)
            " echo 'Command level end'
            return g:permasdat_variant_level
        endif
    endif

    if l:prev_line =~ "^\s*\$\w*"
        if !has_key(g:permasdat_compo_tags, l:prev_line)
                    \ && !has_key(g:permasdat_variant_tags, l:prev_line)
                    \ && !has_key(g:permasdat_cend_tags, l:prev_line)
                    \ && !has_key(g:permasdat_varend_tags, l:prev_line)
                    \ && !has_key(g:permasdat_dont_fold_tags, l:prev_line)
            " echo 'Command level'
            return g:permasdat_command_level
        endif
    endif

    return '='
endfunction

" In case one wants to fold Components also
function! FoldCompo()
    if !b:fold_compo
        let g:permasdat_compo_level = 1
        let b:fold_compo = 1
    else
        let g:permasdat_compo_level = 0
        let b:fold_compo = 0
    endif

    " echo g:permasdat_compo_tags
    for key in keys(g:permasdat_compo_tags)
        let g:permasdat_compo_tags[key] = g:permasdat_compo_level
    endfor
    " echo g:permasdat_compo_tags

    for key in keys(g:permasdat_cend_tags)
        let g:permasdat_cend_tags[key] = g:permasdat_compo_level - 1 > -1 ? g:permasdat_compo_level - 1 : 0
    endfor

    let g:permasdat_variant_level = g:permasdat_compo_level + 1
    for key in keys(g:permasdat_variant_tags)
        let g:permasdat_variant_tags[key] = g:permasdat_variant_level
    endfor

    for key in keys(g:permasdat_varend_tags)
        let g:permasdat_varend_tags[key] = g:permasdat_variant_level - 1 > -1 ? g:permasdat_variant_level - 1 : 0
    endfor

    let g:permasdat_command_level = g:permasdat_variant_level + 1
    call ReFold()
endfunction

" In case folding breaks down
function! ReFold()
    setlocal foldmethod=expr
    setlocal foldexpr=0
"    set foldnestmax=1
    setlocal foldmethod=expr
    setlocal foldexpr=PermasDatFoldExpr(v:lnum)
    setlocal foldtext=PermasDatText()
    echo
endfunction

" Search $ tags
let b:fold_was_closed = 0
let s:pattern = "^\\s*\\$"
let s:pattern_top = "\\c^\\s*\\$\\(structure\\|situation\\|loading\\|constraints\\|system\\|modification\\|results\\|material\\)"
function! DatSearch(backward, top_only)
    if a:backward
        let l:flag = 'b'
    else
        let l:flag = ''
    endif

    if b:fold_was_closed
        foldclose
        let b:fold_was_closed = 0
    endif

    if a:top_only
        if search(s:pattern_top, 'n') != 0
            call search(s:pattern_top, l:flag)
            if foldclosed(get(getpos('.'), 1, '')) != -1
                let b:fold_was_closed = 1
                foldopen
            endif
            normal! zz
        endif
    else
        if search(s:pattern, 'n') != 0
            call search(s:pattern, l:flag)
            if foldclosed(get(getpos('.'), 1, '')) != -1
                let b:fold_was_closed = 1
                foldopen
            endif
            normal! zz
        endif
    endif
endfunction


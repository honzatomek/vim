if exists("b:permas_uci_complete")
    finish
endif
let b:permas_uci_complete = 1

setlocal completefunc=ListIncludeFiles2
inoremap <buffer> <F7> normal! $<C-X><C-U>
" inoremap <F7> <C-R>=ListIncludeFiles()<CR>

func! ListIncludeFiles()
    let l:pos = stridx(getline('.'), expand('<cfile>:t')) + 1
    let l:files = globpath('<cfile>:h', "*" . get(split(expand('<cfile>:t'), "_"), 1, "") . "*." . expand('<cfile>:e'), 0, 1)
    call map(l:files, "get(split(v:val, '/'), -1, '')")

    call complete(stridx(getline('.'), expand('<cfile>:t')) + 1, l:files))
    return ''
endfunc

func! ListIncludeFiles2(findstart, base)
    if a:findstart == 1
        call cursor(line('.'), 999)
        if stridx(getline('.'), '=') != -1
            return stridx(getline('.'), '=') + 2
        else
            return -3
        endif
    else
        if getline('.') =~ "\\c\\s*READ\\s\\+MEDINA\\s\\+FILE\\s*=.*"
            let l:filepath = "../../../einzelteile/"
            let l:filext = "*.bif"
            let l:prev_line = tolower(get(filter(split(substitute(getline(line('.')-1), '-', ' ', 'g'), ' '), 'v:val != ""'), -1, "*"))
            let l:filext = "*" . l:prev_line . l:filext
        elseif getline('.') =~ "\\c\\s*READ\\s\\+PERMAS\\s\\+FILE\\s*=.*"
            if getline(line('.')-1) =~ "\\c.*\\(KPL\\|KOPPLUNG\\).*"
                let l:filepath = "../../../kopplung/"
            elseif getline(line('.')-1) =~ "\\c.*\\(LAS\\|STA\\).*"
                let l:filepath = "../../../lasten/"
            elseif getline(line('.')-1) =~ "\\c.*\\(AVS\\|AV-SYSTEM\\).*"
                let l:filepath = "../../../av-systeme/"
            elseif getline(line('.')-1) =~ "\\c.*\\(HAM\\|HANDSARM\\).*"
                let l:filepath = "../../../handarm-system/"
            elseif getline(line('.')-1) =~ "\\c.*MAT.*"
                let l:filepath = "../../../material/"
            elseif getline(line('.')-1) =~ "\\c.*\\[SST\\|ANREGUNG\\).*"
                let l:filepath = "../../../anregungen/"
            else
                " return []
                let l:filepath = "./"
            endif
            let l:filext = "*.dat*"
        else
            return []
        endif
        " echo l:filepath . "  - " . l:filext
        return globpath(l:filepath, l:filext, 0, 1)
    endif
endfunc


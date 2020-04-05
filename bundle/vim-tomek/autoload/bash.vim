if exists('g:loaded_tomek_bash')
    finish
endif
let g:loaded_tomek_bash = 1

function! bash#ExecuteLine()
    let l:cur_line = getline('.')

    vertical rightbelow new
    execute 'r!'.l:cur_line
endfunction

if !exists('g:bash_tmp_dir')
    let g:bash_tmp_dir = $HOME . "/tmp/vim/"
endif
let s:output_buffer_name = "cmd_output"
let s:output_buffer_type = "output"
let s:output_buffer_nr = -1
function! bash#ExecuteAndShow(mode) range
    if getline(1)[:2] == '#!'
        let l:interpreter = getline(1)
    else
        let l:interpreter = '#!/bin/bash'
    endif

    let l:curbuffwin = bufwinnr("%")
    
    if a:mode == 'v'
        let l:lines = getline(line("'<"), line("'>"))
    else
        let l:lines = [getline('.')]
    endif
    
    " let l:cmds = []
    " for l:line in l:lines
    "     let l:cmds += ["echo", "echo -e '[ ' " . shellescape(l:line) . " ']'", l:line]
    " endfor

    if !isdirectory(g:bash_tmp_dir)
       call mkdir(g:bash_tmp_dir, "p")
    endif

    let l:tmpbuffname = g:bash_tmp_dir . ".tmp" . strftime("%y%m%d%H%M%S")

    silent execute 'vert rightbelow new ' . l:tmpbuffname
    " call appendbufline(l:tmpbuffname, 0, l:interpreter)
    call append(0, l:interpreter)
    " call appendbufline(l:tmpbuffname, "$", l:lines)
    call append("$", l:lines)
    " call append("$", l:cmds)
    silent execute 'write | quit'

    if !bufexists(s:output_buffer_name)
        silent execute 'vertical botright new ' . s:output_buffer_name
        let s:output_buffer_nr = bufnr('%')
        echo 'creating buffer'

    elseif bufwinnr(s:output_buffer_name) == -1
        echo 'opening buffer'
        silent execute 'vertical botright sb ' . s:output_buffer_name
        
    elseif bufwinnr(s:output_buffer_name) != bufwinnr('%')
        echo 'focusing buffer'
        execute bufwinnr(s:output_buffer_name) . 'wincmd w'
        
    endif

    silent execute "setlocal filetype=" . s:output_buffer_type
    setlocal bufhidden=delete
    setlocal buftype=nofile
    setlocal noswapfile
    setlocal nobuflisted
    setlocal winfixheight
    setlocal cursorline
    setlocal nonumber
    setlocal norelativenumber
    setlocal showbreak=""

    " call appendbufline(s:output_buffer_name, "$", "")
    call append("$", "")
    silent execute "$" . l:interpreter[1:] . ' ' . shellescape(l:tmpbuffname, 1)

    silent call delete(l:tmpbuffname)
    silent execute l:curbuffwin . 'wincmd w'
    " echom 'Autoload bash plugin'
endfunction


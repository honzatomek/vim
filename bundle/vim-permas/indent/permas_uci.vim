if exists("b:permas_uci_indent")
  finish
endif

setlocal indentexpr=PermasUciIndent(v:lnum)

" line start - magic, case ignore, leading whitespaces
let g:permas_uci_ls = '\m\c^\s*'
" line end - trailing whitespace with possible comment
let g:permas_uci_le = '\(\s*\|\s\+!.*\)\=$'

let g:permas_uci_block_start = g:permas_uci_ls . '\(new\|modify\(\s\+dms\s*=\s*\S\+\)\=\)' . g:permas_uci_le
let g:permas_uci_block_end = g:permas_uci_ls . 'stop' . g:permas_uci_le

let g:permas_uci_section_start = g:permas_uci_ls . '\(input\|exec\|select\|print\|export\|user\|license\)' . g:permas_uci_le
let g:permas_uci_section_end = g:permas_uci_ls . 'return' . g:permas_uci_le

let g:permas_uci_task_start = g:permas_uci_ls . 'task\(\s\+begin\|\s\+loops\s*=\s*\d\+\)\=' . g:permas_uci_le
let g:permas_uci_task_end = g:permas_uci_ls . 'task\(\s\+end\|\s\+store\|\s\+run\)' . g:permas_uci_le

let g:permas_uci_comment_line = g:permas_uci_ls . '!.*$'

let g:permas_uci_dat_input = g:permas_uci_ls . 'read\s\+permas' . g:permas_uci_le

let g:permas_uci_cloop = g:permas_uci_ls . 'cloop\s\+\(loops\s*=\s*\d\+\(\s*,\s*\d\+\)\{,2}\|end\|label\s*=\s*\S\+\)' . g:permas_uci_le
let g:permas_uci_port = g:permas_uci_ls . 'port\s\+\(res\|pro\)\s\+\(reset\|\(replace\|switch\(\s\+to\)\=\)\s\+file\s*=\s*\S*\)' . g:permas_uci_le

let g:permas_uci_block = g:permas_uci_ls . '\(new\|modify\(\s\+dms\s*=\s*\S\+\)\=\|stop\)' . g:permas_uci_le

let g:permas_uci_error_indent_mult = 10

function! PermasUciIndent(lnum) abort
  if a:lnum <= 1
    return 0
  endif

  let l:curline = getline(a:lnum)
  " echom l:curline
  let l:sw = &shiftwidth

  if l:curline =~? g:permas_uci_cloop || l:curline =~? g:permas_uci_port
    " echom 'cloop or port'
    return 0
  endif

  let l:section = PermasUciPrevHeader(a:lnum)
  " echom join(l:section, ',')

  if l:curline =~? g:permas_uci_block_start
    " echom 'block start'
    if l:section[0] !=? 'none'
      return l:section[2] + g:permas_uci_error_indent_mult * l:sw
    else
      return 0
    endif
  endif

  if l:curline =~? g:permas_uci_block_end
    " echom 'block end'
    return 0
  endif

  if l:curline =~? g:permas_uci_section_start
    " echom 'section start'
    if l:section[0] ==? 'task'
      if l:section[1] ==? 's'
        return l:section[2] + l:sw
      else
        return l:section[2] - l:sw
      endif
    elseif l:section[0] ==? 'section'
      return l:section[2]
    elseif l:section[0] ==? 'block'
      if l:section[1] ==? 's'
        return l:section[2] + l:sw
      else
        return l:section[2] + g:permas_uci_error_indent_mult * l:sw
      endif
    else
      return 0
    endif
  endif

  if l:curline =~? g:permas_uci_section_end
    " echom 'section end'
    if l:section[0] ==? 'section'
      return l:section[2]
    elseif l:section[0] ==? 'task' && l:section[1] ==? 'e'
      return l:section[2] - l:sw
    else
      return l:section[2] + g:permas_uci_error_indent_mult * l:sw
    endif
  endif

  if l:curline =~? g:permas_uci_task_start
    " echom 'task start'
    if l:section[0] ==? 'task'
      if l:section[1] ==? 's'
        return l:section[2] + g:permas_uci_error_indent_mult * l:sw
      else
        return l:section[2]
      endif
    elseif l:section[0] ==? 'section'
      if l:section[1] ==? 's'
        return l:section[2] + l:sw
      else
        return l:section[2]
      endif
    else
      return l:section[2] + g:permas_uci_error_indent_mult * l:sw
    endif
  endif

  if l:curline =~? g:permas_uci_task_end
    " echom 'task end'
    if l:section[0] ==? 'task'
      if l:section[1] ==? 's'
        return l:section[2]
      else
        return l:section[2] + g:permas_uci_error_indent_mult * l:sw
      endif
    elseif l:section[0] ==? 'section'
      return l:section[2] - l:sw
    else
      return l:section[2] + g:permas_uci_error_indent_mult * l:sw
    endif
  endif

  if l:curline =~? g:permas_uci_comment_line
    " echom 'comment'
    let l:prev_uncommented = PermasUciNextUncommented(a:lnum, -1)
    " echom getline(l:prev_uncommented)
    if l:prev_uncommented == -1
      " echom 'file start'
      return 0
    elseif getline(l:prev_uncommented) =~? '\m\c^\s*$'
      " echom 'previous space'
      let l:next_uncommented = PermasUciNextUncommented(a:lnum, 1)
      if l:next_uncommented !~? '\m\c^\s*$'
        " echom 'next uncommented'
        return PermasUciIndent(a:lnum + 1)
      else
        " echom 'next space'
        return l:section[2] + l:sw
      endif
    else
"       return indent(l:prev_uncommented)
      return l:section[2] + l:sw
    endif
  endif

  if l:section[0] ==? 'none'
    " echom 'none'
    return l:section[2]
  else
    " echom 'else'
    if l:section[1] ==? 'e'
      return l:section[2]
    else
      return l:section[2] + l:sw
    endif
  endif

endfunction

" return [header name, start/end, indent, lnum]
function! PermasUciPrevHeader(lnum)
  let l:lnum = a:lnum - 1
  while l:lnum >= 1
    let l:curline = getline(l:lnum)

    if l:curline =~? g:permas_uci_section_start
      return ['section', 's', indent(l:lnum), l:lnum]

    elseif l:curline =~? g:permas_uci_section_end
      return ['section', 'e', indent(l:lnum), l:lnum]

    elseif l:curline =~? g:permas_uci_task_start
      return ['task', 's', indent(l:lnum), l:lnum]

    elseif l:curline =~? g:permas_uci_task_end
      return ['task', 'e', indent(l:lnum), l:lnum]

    elseif l:curline =~? g:permas_uci_block_start
      return ['block', 's', indent(l:lnum), l:lnum]

    elseif l:curline =~? g:permas_uci_block_end
      return ['block', 'e', indent(l:lnum), l:lnum]

    endif
    let l:lnum -= 1
  endwhile
  return ['none', 'none', 0, 1]
endfunction

" return line number of a specified previous header
function! PermasUciPrevHeaderLnum(lnum, header_regex)
  let l:lnum = a:lnum - 1
  while l:lnum >= 1
    if getline(l:lnum) =~? a:header_regex
      return l:lnum
    endif
    let l:lnum -= 1
  endwhile
  return 1
endfunction

" return next/previous uncommented line, direction: +next, -previous
" if no such line found return -1
function! PermasUciNextUncommented(lnum, dir)
  if a:dir >= 0
    let l:dir = 1
  else
    let l:dir = -1
  endif
  let l:lnum = a:lnum + l:dir
  while (l:lnum <= line("$") && l:lnum >= 1)
    let l:curline = getline(l:lnum)
    " echom l:curline
    if l:curline !~? g:permas_uci_comment_line
      return l:lnum
    endif
    let l:lnum += l:dir
  endwhile
  return -1
endfunction

let b:permas_uci_indent = 1

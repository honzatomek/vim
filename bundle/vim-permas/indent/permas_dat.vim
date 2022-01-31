if exists("b:permas_dat_indent")
  finish
endif

setlocal indentexpr=PermasDatIndent(v:lnum)

let g:permas_dat_int_chars = 8  " number of characters for aligning integer numbers to the right
let g:permas_dat_real_chars = 6 " number of characters for aligning the decimal point right

" TODO: completeley rewrite the logic

function! PermasDatIndent(lnum)
  let l:curline = getline(a:lnum)
  " echom l:curline
  if l:curline =~ '\v\c^\s*\$.*'
    if l:curline =~ '\v\c^\s*\$(enter|exit|fin)\s+(component|material).*'
      return 0
    elseif l:curline =~ '\v\c^\s*\$(fin)(\s.*)='
      return 0
    elseif l:curline =~ '\v\c^\s*\$(defvar|loop|endloop)(\s.*)='
      return 0
    elseif l:curline =~ '\v\c^\s*\$(material|structure|loading|constraints|system|modification|results|situation).*'
      return &shiftwidth
    elseif l:curline =~ '\v\c^\s*\$end\s+(material|structure|loading|constraints|system|modification|results|situation).*'
      return &shiftwidth
    elseif l:curline =~ '\v\c^\s*\$include.*'
      return 3 * &shiftwidth
    else
      return 2 * &shiftwidth
    endif

  " comments
  elseif l:curline =~ '\v\c^\s*!.*'
    let l:header = 0
    " echom 'comment'
    for l:lnum in range(1, a:lnum - 1)
      let l:prevline = getline(a:lnum - l:lnum)
      if l:prevline =~ '\v^\s*$'
        let l:header = 1
      elseif l:prevline =~ '\v\c^\s*\$.*'
        if l:header
          if l:prevline =~ '\v\c^\s*\$(enter|exit|fin)\s+(component|material).*'
            return 0
          elseif l:prevline =~ '\v\c^\s*\$(fin)(\s.*)='
            return 0
          elseif l:prevline =~ '\v\c^\s*\$(defvar|loop|endloop)(\s.*)='
            return 0
          elseif l:prevline =~ '\v\c^\s*\$(material|structure|loading|constraints|system|modification|results|situation).*'
            return &shiftwidth
          elseif l:prevline =~ '\v\c^\s*\$end\s+(material|structure|loading|constraints|system|modification|results|situation).*'
            return &shiftwidth
          elseif l:prevline =~ '\v\c^\s*\$include.*'
            return 3 * &shiftwidth
          else
            return 2 * &shiftwidth
          endif
        else
          " echom 'not header'
          return indent(a:lnum - l:lnum) + &shiftwidth
        endif
      endif
    endfor
    " echom 'unhandled'

  else
    for l:lnum in range(1, a:lnum - 1)
      let l:prevline = getline(a:lnum - l:lnum)

      if l:prevline =~ '\v\c^\s*\$.*'
        if l:prevline =~? '\v\c^\s*\$(material|structure|loading|constraints|system|modification|results|situation).*'
          return 2 * &shiftwidth
        elseif l:prevline =~ '\v\c^\s*\$end\s+(material|structure|loading|constraints|system|modification|results|situation).*'
          return &shiftwidth
        elseif l:prevline =~ '\v\c^\s*\$enter\s+(component|material).*'
          return &shiftwidth
        elseif l:prevline =~ '\v\c^\s*\$exit\s+(component|material).*'
          return 0
        elseif l:prevline =~ '\v\c^\s*\$(fin)(\s.*)='
          return 0
        elseif l:prevline =~ '\v\c^\s*\$(nlload table)(\s.*)='
          if l:curline =~ '\v^\s*\d+\..*'
            return 3 * &shiftwidth + 14
          else
            return 3 * &shiftwidth
          endif
        else
          " echom 'else ' . l:curline
          if l:curline =~ '\v^\s*\d+\s.*'
            " echom 3 * &shiftwidth + (g:permas_dat_int_chars - len(get(split(l:curline), 0, '')))
            return 3 * &shiftwidth + (g:permas_dat_int_chars - len(get(split(l:curline), 0, '')))
          elseif l:curline =~ '\v^\s*\d+\..*'
            return 3 * &shiftwidth + (g:permas_dat_real_chars - stridx(get(split(l:curline), 0, ''), '.'))
          else
            return 3 * &shiftwidth
          endif
        endif
      endif

    endfor
  endif
  return 0
endfunction

let b:permas_dat_indent = 1

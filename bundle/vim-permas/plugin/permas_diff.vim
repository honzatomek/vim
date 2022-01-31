if exists("b:permas_diff")
    finish
endif

" ignore leading and trailing whitespaces (the -w option)
" ignore comments also possible
function! PermasDiff()
  let l:opt = ''
  if &diffopt =~? 'icase'
    let l:opt .= '-i '
  endif
  if &diffopt =~? 'iwhite'
    let l:opt .= '-w '  " -w instead of -b to ignore all white spaces
  endif
  if join(g:permas_diffopt, ';') =~? 'iblank'
    let l:opt .= '-b '
  endif
  if join(g:permas_diffopt, ';') =~? 'icline'
    let l:opt .= '-I ' . "'" . '^[[:blank:]]*\!' . "' "
  endif
  if join(g:permas_diffopt, ';') =~? 'icomment'
    let l:file_in = StripComments(v:fname_in)
    let l:file_new = StripComments(v:fname_new)
    let l:command = '!diff -a --binary ' . l:opt . ' ' . l:file_in . ' ' .l:file_new . ' > ' . v:fname_out
    echom l:command
    silent execute l:command
  else
    silent execute '!diff -a --binary ' . l:opt . v:fname_in . ' ' . v:fname_new . ' > ' . v:fname_out
  endif
endfunction

function! StripComments(fname)
  " strip all comments before sending the file to diff tool
  let l:fname = '<(sed ' . "'" . 's/[[:blank:]]*\!.*$//' . "' " . a:fname . ')'
  echom l:fname
  return l:fname
endfunction

let b:permas_diff = 1

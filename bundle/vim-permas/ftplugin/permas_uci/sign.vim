if exists("b:permas_uci_sign")
  finish
endif

silent sign define stopline linehl=ErrorMsg

function! PermasUCIPlaceSigns()
  let l:line = 1
  silent execute 'sign unplace *'
  while l:line <= line('$')
    if getline(l:line) =~# '\v\c^\s*stop(\s*|\s+!.*)$'
      silent execute 'sign place 1 name=stopline line=' . l:line . ' file=' . expand('%')
    endif
    let l:line += 1
  endwhile
endfunction

let b:permas_uci_sign = 1

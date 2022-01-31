if exists("b:permas_dat_sign")
  finish
endif

silent sign define stopline linehl=ErrorMsg

function! PermasDatPlaceSigns()
  let l:line = 1
  silent execute 'sign unplace *'
  while l:line <= line('$')
    if getline(l:line) =~# '\v\c^\s*\$fin(\s*|\s+!.*)$'
      silent execute 'sign place 1 name=stopline line=' . l:line . ' file=' . expand('%')
    endif
    let l:line += 1
  endwhile
endfunction

let b:permas_dat_sign = 1

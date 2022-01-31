if exists("b:permas_augroups")
  finish
endif

augroup au_permas_dat
  autocmd!
"   au TextChangedI *.dat\d* if !pumvisible() && !exists("b:permas_complete_on") && matchstr(getline('.'),'\%'.col('.').'c.') != '$' | silent call feedkeys("\<c-x>\<c-k>\<c-p>", "n") | endif
"   au InsertEnter *.dat\d* setlocal iskeyword+=$
"   au InsertLeave *.dat\d* setlocal iskeyword-=$
augroup END

let b:permas_augroups = 1

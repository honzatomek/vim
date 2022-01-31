if exists("b:permas_dat_complete")
  finish
endif

nmap <silent> <leader>pi <Plug>PermasComplete_InsertSnippetN
vmap <silent> <leader>pi <Plug>PermasComplete_InsertSnippetV
nmap <silent> <leader>ps <Plug>PermasComplete_StoreSnippetN
vmap <silent> <leader>ps <Plug>PermasComplete_StoreSnippetV

execute "set dictionary+=" . expand("<sfile>:h:h:h") . '/permas_complete/uci_keywords.txt'

let b:permas_dat_complete = 1

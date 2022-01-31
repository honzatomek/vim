" Vim plugin file for Permas *.dat1 Code Completion
"
"     Plugin:  vim-permas/permas_complete.vim
"     Author:  AKKA Czech republic - Jan Tomek <jan.tomek@mbeng.cz>
"     Date:    27.04.2020
"     Version: 0.1.0
"
"#############################################################################

" load autoload script only once ======================================== {{{1
if exists("g:permas_complete_autoload_loaded")
  finish
endif

" function! permas_complete#Insert(mode) range ========================== {{{1
function! permas_complete#Insert(mode) range
  let b:permas_complete_from_insert = 0
  if a:mode ==# 'n'
    echom "[i] PermasComplete: called from 'normal' mode."
  elseif a:mode ==# 'v'
    echom "[i] PermasComplete: called from 'visual' mode."
    normal ddO
  elseif a:mode ==# 'i'
    echom "[i] PermasComplete: called from 'insert' mode."
    let b:permas_complete_from_insert = 1
  endif

  execute 'let b:permas_complete_snippet_ftlocation = g:permas_complete_snippets_' . &filetype
  echom '[i] PermasComplete: snippets location - ' . b:permas_complete_snippet_ftlocation

  " check if any snippets are stored for the current filetype
  if !isdirectory(b:permas_complete_snippet_ftlocation)
    echom '[-] PermasComplete: no snippets directory for ' . &filetype . ' filetype.'
    return
  elseif len(globpath(b:permas_complete_snippet_ftlocation, "**/*.*", 0, 1)) == 0
    echom '[-] PermasComplete: no snippets stored for ' . &filetype . ' filetype.'
    return
  endif

  silent call permas_complete#SetDefaults(['<cr>', '<kEnter>', '<c-y>', '<c-x>'])

  if b:permas_complete_from_insert
    setlocal completefunc=permas_complete#CompleteInteractive
    let &completeopt = "menuone,preview,noselect"
  else
    setlocal completefunc=permas_complete#Complete
    let &completeopt = "menuone,preview"
  endif
"   setlocal completeopt=menu,menuone,preview

  inoremap <buffer> <silent> <expr> <cr>     permas_complete#MapEnter()
  inoremap <buffer> <silent> <expr> <kEnter> permas_complete#MapEnter()
  inoremap <buffer> <silent> <expr> <c-y>    permas_complete#MapCtrlY()
  inoremap <buffer> <silent> <expr> <c-x>    permas_complete#MapCtrlX()
  inoremap <buffer> <silent> <expr> <esc>    permas_complete#MapEsc()

  normal! o
  normal! k

  startinsert
  call feedkeys("\<c-x>\<c-u>")
endfunction

" function! permas_complete#Complete(findstart, base) =================== {{{1
function! permas_complete#Complete(findstart, base)
  if a:findstart
    return 1
  else
    echom '[i] PermasComplete: permas_complete#Complete() called'
    if &filetype ==# 'permas_dat'
      let l:items = permas_complete#GetSnippets_Dat()
    else
      let l:items = permas_complete#GetSnippets()
    endif
    return l:items
  endif
endfunction

" function! permas_complete#CompleteInteractive(findstart, base) ======== {{{1
function! permas_complete#CompleteInteractive(findstart, base)
  " find start of completion
  if a:findstart
    echom "Complete start: " . string(match(getline("."), "\$") + 1)
    return match(getline("."), "\$") + 1
  " populate completion list
  else
    let l:header = {"component": ['\v\c^\s*\$enter\s+component', '\v\c^\s*\$exit\s+component'],
                   \"material": ['\v\c^\s*\$enter\s+material', '\v\c^\s*\$exit\s+material']}
    let l:closest_header = s:IsInside(l:header)
    echom "[i] PermasComplete: Closest Header " . l:closest_header
    if l:closest_header ==# "none"
      let l:permas_complete_snippets_location = b:permas_complete_snippet_ftlocation . "/"
      echom l:permas_complete_snippets_location
      let l:relpath = substitute(l:permas_complete_snippets_location, escape(b:permas_complete_snippet_ftlocation, '.*()|') . "/", "", "")
      echom l:relpath
      for l:line in readfile(b:permas_complete_snippet_ftlocation . "/tags", "")
        let [l:tag, l:file; l:rest] = split(l:line, '\t')
"         if l:tag =~? "^" . a:base
        if fnamemodify(l:file, ":h") ==? l:relpath
          call complete_add({"word": l:tag, "info": join(readfile(b:permas_complete_snippet_ftlocation . "/" . l:file, ""), "\n"), "dup": 0, })
        endif
        if complete_check()
          break
        endif
      endfor
      return []
    else
      let l:permas_complete_snippets_location = b:permas_complete_snippet_ftlocation . "/" . l:closest_header
      let l:variant_names = globpath(l:permas_complete_snippets_location, "*/", 0, 1)
      call map(l:variant_names, "fnamemodify(v:val[:-2], ':t')")
      let l:variant = {}
      for l:v in l:variant_names
        call extend(l:variant, {l:v : ['\v\c^\s*\$' . l:v , '\v\c^\s*\$end\s+' . l:v]})
      endfor
      echom "[i] PermasComplete: Available Variants " . join(values(l:variant), " ")
      let l:closest_variant = s:IsInside(l:variant)
      echom "[i] PermasComplete: Closest Variant " . l:closest_variant

      if l:closest_variant !=# "none"
        let l:permas_complete_snippets_location .= "/" . l:closest_variant
      endif
      let l:relpath = substitute(l:permas_complete_snippets_location, escape(b:permas_complete_snippet_ftlocation, '.*()|') . "/", "", "")

      for l:line in readfile(b:permas_complete_snippet_ftlocation . "/tags", "")
        let [l:tag, l:file; l:rest] = split(l:line, '\t')
"         if fnamemodify(l:file, ":h:t") ==? fnamemodify(l:permas_complete_snippets_location, ":t")
        if fnamemodify(l:file, ":h") ==? l:relpath
          echom fnamemodify(l:file, ":h") " : " l:relpath
          call complete_add({"word": l:tag, "info": join(readfile(b:permas_complete_snippet_ftlocation . "/" . l:file, ""), "\n"), "dup": 0, })
        endif
        if complete_check()
          break
        endif
      endfor
      return []
    endif
  endif

"     let l:res = {"words": [], "refresh": "always"}
"     for l:line in readfile(b:permas_complete_snippet_ftlocation . "/tags", "")
"       let [l:tag, l:file; l:rest] = split(l:line, '\t')
"       let l:filelocal = substitute(l:file, escape(b:permas_complete_snippet_ftlocation, '.*()|') . "/", "", "")
"
"       echom l:filelocal
"       if l:tag =~? "^" . a:base
"         call complete_add({"word": l:tag, "info": join(readfile(l:file, ""), "\n"), "dup": 0, })
"       endif
"       if complete_check()
"         break
"       endif
"     endfor
"     return []
"   endif
endfunction


" function! permas_complete#GetSnippets() =============================== {{{1
function! permas_complete#GetSnippets()
  let l:snippets = []
  silent! call extend(l:snippets, globpath(b:permas_complete_snippet_ftlocation, "*.*", 0, 1))
  silent! call extend(l:snippets, globpath(b:permas_complete_snippet_ftlocation, "*/*.*", 0, 1))
  silent! call extend(l:snippets, globpath(b:permas_complete_snippet_ftlocation, "*/**/*.*", 0, 1))
  silent! call map(l:snippets, "{\"word\": substitute(v:val, \"" . escape(b:permas_complete_snippet_ftlocation, '.*()|') . "/\", \"\", \"\"), \"info\": join(readfile(v:val, \"\"), \"\n\"),}")
  return l:snippets
endfunction

" function! permas_complete#GetSnippets_Dat() =========================== {{{1
function! permas_complete#GetSnippets_Dat()
  let l:header = {"component": ['\v\c^\s*\$enter\s+component', '\v\c^\s*\$exit\s+component'],
                 \"material": ['\v\c^\s*\$enter\s+material', '\v\c^\s*\$exit\s+material']}

  let l:closest_header = s:IsInside(l:header)
  echom "[i] PermasComplete: Closest Header " . l:closest_header
  if l:closest_header ==# "none"
    return permas_complete#GetSnippets()
  else
    let l:permas_complete_snippets_location = b:permas_complete_snippet_ftlocation . "/" . l:closest_header
    let l:variant_names = globpath(l:permas_complete_snippets_location, "*/", 0, 1)
    call map(l:variant_names, "fnamemodify(v:val[:-2], ':t')")

    let l:variant = {}
    for l:v in l:variant_names
      call extend(l:variant, {l:v : ['\v\c^\s*\$' . l:v , '\v\c^\s*\$end\s+' . l:v]})
    endfor

    echom "[i] PermasComplete: Available Variants " . join(values(l:variant), " ")

    let l:closest_variant = s:IsInside(l:variant)
    echom "[i] PermasComplete: Closest Variant " . l:closest_variant

    if l:closest_variant ==# "none"
      let l:snippets = globpath(l:permas_complete_snippets_location, "*.*", 0, 1)
    else
      let l:permas_complete_snippets_location .= "/" . l:closest_variant
      let l:snippets = globpath(l:permas_complete_snippets_location, "*.*", 0, 1)
    endif
  endif
  silent! call map(l:snippets, "{\"word\": substitute(v:val, \"" . escape(b:permas_complete_snippet_ftlocation, '.*()|') . "/\", \"\", \"\"), \"info\": join(readfile(v:val, \"\"), \"\n\"),}")
  return l:snippets
endfunction

" function! permas_complete#InsertSnippet() ============================= {{{1
function! permas_complete#InsertSnippet()
  " replace completion result with the contents of the snippet
  " save unnamed register
  let l:tmpUnnamedReg = @
  " remove empty line if it exists
  if len(getline(".")) == 0
    normal! ddk
  endif
  " get the filename from current line and set path
  if b:permas_complete_from_insert
    let l:line = <SID>Strip(getline("."))
    for l:tag in readfile(b:permas_complete_snippet_ftlocation . "/tags")
      if split(l:tag, "\t")[0] =~# l:line
        let l:filename = b:permas_complete_snippet_ftlocation . "/" . split(l:tag, "\t")[1]
        break
      endif
    endfor
  else
    let l:filename = b:permas_complete_snippet_ftlocation . "/" . getline(".")
  endif
  " check if the file is readable and insert it
  if filereadable(l:filename)
    silent! execute "read " . l:filename
    normal! kdd
  else
    normal! <c-y>
  endif
  " restore unnamed register
  let @@ = l:tmpUnnamedReg
  " restore backed-up defaults
  silent! call permas_complete#RestoreDefaults(0)
endfunction

" function! permas_complete#Store(mode) range =========================== {{{1
function! permas_complete#Store(mode) range
  " set filetype specific location for snippets to be read from
  execute "let b:permas_complete_snippet_ftlocation = g:permas_complete_snippets_" . &filetype
  " store the whole file or just selected lines as a snippet
  " check mode
  if a:mode ==# "n"  " normal mode
    let l:snippet = getline(1, "$")
  elseif a:mode ==# "v"  " visual mode
    let l:snippet = getline("'<", "'>")
  else
    echom '[-] permas_complete: this mode (' . a:mode . ') invocation of permas_complete#Store(mode) is not supported'
    return
  endif
  " trim empty lines at beginning and end of the snippet
  let l:snippet = split(substitute(join(l:snippet, "\r"), "\v(^(\r(\r|\s)*\r)|(\r(\r|\s)*\r\s*$)", "", ""), "\r")
  " undo indent of the snippet
  let l:indent = match(l:snippet[0], "\\S")
  call map(l:snippet, 'v:val[:' . l:indent . '] =~# "\\s*" ? strpart(v:val, ' . l:indent . ') : v:val')
  " store current working directory
  let l:cwd = getcwd()
  " check if the snippets directory exists for current filetype, creates it if
  " not
  if !isdirectory(b:permas_complete_snippet_ftlocation)
    silent! call mkdir(b:permas_complete_snippet_ftlocation, "p")
    echom "[+] PermasComplete: created the Snippets directory  " . b:permas_complete_snippet_ftlocation
  endif
  " change path to the snippets directory for autocompletion purposes
  silent! execute ":cd " . b:permas_complete_snippet_ftlocation
  " get snippet name
  let l:snippet_name = permas_complete#GetUserInput('Input Snippet Name: ', '', 'file')
  if l:snippet_name ==# "" | return | endif
  " if no file extension has been input, add current file extension
  if fnamemodify(l:snippet_name, ":e") ==# ""
    let l:snippet_name .= '.' . expand("%:e")
  endif
  " check if the snippet path exists, if not, create it
  if !isdirectory(l:snippet_name)
    silent! call mkdir(fnamemodify(l:snippet_name, ":h"), "p")
  endif
  " write the file and wait for finish
  silent! call writefile(l:snippet, l:snippet_name, "s")
  silent! call permas_complete#CreateTags()
  " change the path back
  silent! execute ":cd " . l:cwd
endfunction

" function! permas_complete#GetUserInput(prompt, default, completion) === {{{1
function! permas_complete#GetUserInput(prompt, default, completion)
    silent! call inputsave()
    let l:retVal = input(a:prompt, a:default, a:completion)
    silent! call inputrestore()
    return l:retVal
endfunction

" function! permas_complete#SetDefaults(mappings) ======================= {{{1
function! permas_complete#SetDefaults(mappings)
  if !exists("b:permas_complete_on")
    let b:permas_complete_on = 1
  endif
  if !empty(&completefunc)
    execute "let b:permas_complete_completefunc_backup = '" . &completefunc . "'"
  endif
  if !empty(&completeopt)
    execute "let b:permas_complete_completeopt_backup = '" . &completeopt . "'"
  endif
  let b:permas_complete_mappings_backup = permas_complete#SaveMappings(a:mappings, 'i', 0)

  let g:permas_complete_current_filetype = &filetype

  augroup PermasComplete_Preview
    autocmd!
    autocmd BufWinEnter * if &previewwindow | echom '[i] PermasComplete: Created Preview' | endif
    autocmd BufWinEnter * if &previewwindow | setlocal nowrap nonumber nofoldenable | endif
    autocmd BufWinEnter * if &previewwindow && exists("g:permas_complete_current_filetype") | execute "setlocal filetype=" . g:permas_complete_current_filetype | endif

"     autocmd BufWinEnter * if &previewwindow | silent! execute 'wincmd L' | endif
"     autocmd BufWinEnter * if &previewwindow | execute ":vertical resize 60" | endif
    autocmd BufWinEnter * if &previewwindow | execute "let g:permas_complete_preview_bufwinnr = " . bufwinnr(bufnr("%")) | endif
    autocmd BufWinEnter * if &previewwindow | wincmd H | vertical resize 60 | endif
  augroup END

  echom '[+] PermasComplete: defaults backed up.'
endfunction

" function! permas_complete#RestoreDefaults() =========================== {{{1
function! permas_complete#RestoreDefaults(cancel)
  if exists("b:permas_complete_completefunc_backup")
    execute "setlocal completefunc=" . b:permas_complete_completefunc_backup
  else
    execute "setlocal completefunc="
  endif
  if exists("b:permas_complete_completeopt_backup")
    execute "setlocal completeopt=" . b:permas_complete_completeopt_backup
"     let &completeopt = b:permas_complete_completeopt_backup
  else
    execute "setlocal completeopt="
  endif
  if exists("b:permas_complete_mappings_backup")
    silent! call permas_complete#RestoreMappings(b:permas_complete_mappings_backup)
  endif

  augroup PermasComplete_Preview
    autocmd!
  augroup END

  if exists("g:permas_complete_preview_bufwinnr")
    echom '[i] PermasComplete: Preview BufWinNur ' . g:permas_complete_preview_bufwinnr
    silent! execute "wincmd P"
    silent! execute "close!"
"     silent execute ":" . g:permas_complete_preview_bufwinnr . "close!"
    echom '[i] PermasComplete: Preview Closed'
  endif

  unlet g:permas_complete_current_filetype

  echom '[+] PermasComplete: defaults restored'
  if b:permas_complete_from_insert
    if a:cancel
      normal! ddO$
      startinsert!
    else
      startinsert
    endif
  endif
  if exists("b:permas_complete_on")
    unlet b:permas_complete_on
  endif
endfunction

" function! permas_complete#SaveMappings(keys, mode, global) abort ====== {{{1
function! permas_complete#SaveMappings(keys, mode, global) abort
" From: https://vi.stackexchange.com/questions/7734/how-to-save-and-restore-a-mapping
  let mappings = {}

  if a:global
    for l:key in a:keys
      let buf_local_map = maparg(l:key, a:mode, 0, 1)

      silent! execute a:mode.'unmap <buffer> '.l:key

      let map_info        = maparg(l:key, a:mode, 0, 1)
      let mappings[l:key] = !empty(map_info)
                          \ ? map_info
                          \ : {'unmapped' : 1,
                          \    'buffer'   : 0,
                          \    'lhs'      : l:key,
                          \    'mode'     : a:mode,}

      call Restore_mappings({l:key : buf_local_map})
    endfor

  else
    for l:key in a:keys
      let map_info        = maparg(l:key, a:mode, 0, 1)
      let mappings[l:key] = !empty(map_info)
                          \ ? map_info
                          \ : {'unmapped' : 1,
                          \    'buffer'   : 1,
                          \    'lhs'      : l:key,
                          \    'mode'     : a:mode,}
    endfor
  endif

  return mappings
endfunction

" function! permas_complete#RestoreMappings(mappings) abort ============= {{{1
function! permas_complete#RestoreMappings(mappings) abort
" From: https://vi.stackexchange.com/questions/7734/how-to-save-and-restore-a-mapping
  for mapping in values(a:mappings)
    if !has_key(mapping, 'unmapped') && !empty(mapping)
      execute mapping.mode
         \ . (mapping.noremap ? 'noremap   ' : 'map ')
         \ . (mapping.buffer  ? ' <buffer> ' : '')
         \ . (mapping.expr    ? ' <expr>   ' : '')
         \ . (mapping.nowait  ? ' <nowait> ' : '')
         \ . (mapping.silent  ? ' <silent> ' : '')
         \ .  mapping.lhs
         \ . ' '
         \ . substitute(mapping.rhs, '<SID>', '<SNR>'.mapping.sid.'_', 'g')

    elseif has_key(mapping, 'unmapped')
      silent! execute mapping.mode.'unmap '
            \ .(mapping.buffer ? ' <buffer> ' : '')
            \ . mapping.lhs
    endif
  endfor
endfunction

" function! permas_complete#MapCtrlY() ================================== {{{1
function! permas_complete#MapCtrlY()
    if !pumvisible()
        return "\<C-Y>"
    else
        return "\<ESC>:call permas_complete#InsertSnippet()\<CR>"
    endif
endfunction

" function! permas_complete#MapEnter() ================================== {{{1
function! permas_complete#MapEnter()
    if !pumvisible()
        return "\<CR>"
    else
        return "\<CR>\<ESC>:call permas_complete#InsertSnippet()\<CR>"
    endif
endfunction

" function! permas_complete#MapEsc() ==================================== {{{1
function! permas_complete#MapEsc()
    if !pumvisible()
        return "\<ESC>"
    else
        return "\<ESC>:normal dd\<CR>:silent! call permas_complete#RestoreDefaults(1)\<CR>"
    endif
endfunction

" function! permas_complete#MapCtrlX() ================================== {{{1
function! permas_complete#MapCtrlX()
    if !pumvisible()
        return "\<C-X>"
    else
        return "\<ESC>:normal dd\<CR>:silent! call permas_complete#RestoreDefaults(1)\<CR>"
    endif
endfunction

" function! permas_complete#CreateTags() ================================ {{{1
function! permas_complete#CreateTags()
  " set filetype specific location for snippets to be read from
  execute "let b:permas_complete_snippet_ftlocation = g:permas_complete_snippets_" . &filetype
  if !delete(b:permas_complete_snippet_ftlocation . "/tags")
    echom "[+] PermasComplete: Tags file removed."
  else
    echom "[-] PermasComplete: Tags file not removed!"
  endif

  let l:snippets = []
  silent! call extend(l:snippets, globpath(b:permas_complete_snippet_ftlocation, "*.*", 0, 1))
  silent! call extend(l:snippets, globpath(b:permas_complete_snippet_ftlocation, "*/*.*", 0, 1))
  silent! call extend(l:snippets, globpath(b:permas_complete_snippet_ftlocation, "*/*/*.*", 0, 1))
"   silent! call extend(l:snippets, globpath(b:permas_complete_snippet_ftlocation, "*/**/*.*", 0, 1))

  let l:tags = []

  for l:snippet in l:snippets
    let l:relpath = substitute(l:snippet, escape(b:permas_complete_snippet_ftlocation, '.*()|') . "/", "", "")
    for l:line in readfile(l:snippet)
      if l:line =~? '\v^\s*\$\a.*'
          silent! call add(l:tags, join([<SID>Strip(l:line), l:relpath, "1"], "\t"))
        break
      endif
    endfor
  endfor

  call sort(l:tags)
  call writefile(l:tags, b:permas_complete_snippet_ftlocation . "/tags")
  echom "[+] PermasComplete: Tags file generated."
endfunction

" function! s:Strip(input_string) ======================================= {{{1
function! s:Strip(input_string)
  " substitute tabs
  let l:input_string = substitute(a:input_string, '\v\t', ' ', 'g')
  " substitute multiple spaces
  let l:input_string = substitute(l:input_string, '\v\s+', ' ', 'g')
  " trim starting and leading spaces
  let l:input_string = substitute(l:input_string, '\v^\s*(.{-})\s*$', '\1', '')
  return l:input_string
"   return substitute(substitute(a:input_string, '\v^\s*(.{-})\s*$', '\1', ''), '\v(\s|\t)+', ' ', '')
endfunction

" function! s:Map(list, expr) =========================================== {{{1
function! s:Map(list, expr)
  let l:list = deepcopy(a:list)
  call map(l:list, a:expr)
  return l:list
endfunction

" function! s:GetMinItem(dict) ========================================== {{{1
function! s:GetMinItem(dict)
  let l:dict = <SID>Map(a:dict, "search(v:val, 'nb')")
  call filter(l:dict, "v:val > 0")
  if len(l:dict) == 0
    return ["none", 0]
  else
    let l:idx = min(l:dict)
    call filter(l:dict, "v:val == " . l:idx)
    return [keys(l:dict)[0], values(l:dict)[0]]
  endif
endfunction

" function! s:IsInside(dict) ============================================ {{{1
function! s:IsInside(dict)
  echom '[i] PermasComplete: s:IsInside Called'
  let l:dict = deepcopy(a:dict)
"   echom string(l:dict)

  call filter(l:dict, "search(v:val[0], 'nbW') > search(v:val[1], 'nbW')")
"   echom string(l:dict)

  call map(l:dict, "[search(v:val[0], 'nbW'), search(v:val[1], 'nW')]")
"   echom string(l:dict)
  call filter(l:dict, "v:val[0] > 0 || v:val[1] > 0")
"   echom string(l:dict)
  if len(l:dict) == 0
    return "none"
  else
    call map(l:dict, "v:val[0] < line('.') && v:val[1] > line('.')")
    call filter(l:dict, "v:val")
    if len(l:dict) == 0
      return "none"
    else
      return keys(l:dict)[0]
  endif
endfunction
" }}}

let g:permas_complete_autoload_loaded = 1
" vim: set fdm=marker ft=vim

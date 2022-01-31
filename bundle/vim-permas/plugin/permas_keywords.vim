" permas_keywords.vim - file crawler for permas keywords
if exists("g:permas_keywords_loaded")
  finish
endif

let g:permas_plugin = expand("<sfile>:p:h:h")
let g:permas_snippets = g:permas_plugin . "/permas_complete"
let g:permas_dir = "/proj/P1148/permas"
let g:permas_dat = ["addmodes", "anregungen", "av-systeme", "dato", "handarm_system", "kopplung", "lasten", "material", "matrix_input", "matrix-gen", "matrix-input"]
let g:permas_uci = ["rechnungen", "permas_einstellungen"]

function! s:Crawl(directory, extension)
  let l:keywords = []
  let l:files = globpath(a:directory, '*.' . a:extension, 0, 1)
  let l:num = len(l:files)
  if l:num > 0
    for l:i in range(l:num)
      let l:file = l:files[l:i]
      echom "PERMAS Crawl [" . l:i . "/" . l:num . "] : " . l:file
      if getfsize(l:file) < (1024 * 1024 * 10) && getfsize(l:file) > 0
        for l:line in readfile(l:file)
          if l:line !=? "\v^\s*!.*$"
            let l:fields = split(<SID>Strip(l:line), ' ')
            for l:field in l:fields
              if l:field =~? '\v^\$=\a\w+$'
"               if l:field =~? '\v^\$=\u+\d*$'
  "               echom l:field
                call add(l:keywords, toupper(l:field))
              endif
            endfor
          endif
        endfor
        let l:keywords = uniq(sort(l:keywords))
      endif
    endfor
  endif

  let l:subdirs = globpath(a:directory, '*/', 0, 1)
  if len(l:subdirs) > 0
    for l:subdir in l:subdirs
      let l:subkeywords = <SID>Crawl(l:subdir, a:extension)
      if len(l:subkeywords) > 0
        let l:keywords = extend(l:keywords, l:subkeywords)
      endif
    endfor
  endif

  return l:keywords
endfunction

function! s:Strip(string)
  let l:string = substitute(a:string, "\v(\s|\t)+", ' ', 'g')
  let l:string = substitute(l:string, "\v!.*$", '', '')
  let l:string = substitute(l:string, "\v^\s*(.*)\s*$", '\1', '')
  return l:string
endfunction

function! s:GetDatKeywords()
  if filereadable(g:permas_snippets . "/dat_keywords.txt")
    let l:keywords = readfile(g:permas_snippets . "/dat_keywords.txt")
  else
    let l:keywords = []
  endif
  for l:dir in g:permas_dat
    if isdirectory(g:permas_dir . "/" . l:dir)
      let l:keywords = uniq(sort(extend(l:keywords, <SID>Crawl(g:permas_dir . "/" . l:dir, "dat1"))))
    endif
  endfor
  call writefile(l:keywords, g:permas_snippets . "/dat_keywords.txt")
endfunction

function! s:GetUCIKeywords()
  if filereadable(g:permas_snippets . "/uci_keywords.txt")
    let l:keywords = readfile(g:permas_snippets . "/uci_keywords.txt")
  else
    let l:keywords = []
  endif
  for l:dir in g:permas_uci
    if isdirectory(g:permas_dir . "/" . l:dir)
      let l:keywords = uniq(sort(extend(l:keywords, <SID>Crawl(g:permas_dir . "/" . l:dir, "uci"))))
    endif
  endfor
  call writefile(l:keywords, g:permas_snippets . "/uci_keywords.txt")
endfunction

let g:permas_keywords_loaded = 1
"!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
finish

silent! call <SID>GetDatKeywords()
echom "PERMAS Crawl: Dat Keywords Written."
silent! call <SID>GetUCIKeywords()
echom "PERMAS Crawl: UCI Keywords Written."
" echom join(<SID>Crawl(g:permas_dir . "/" . g:permas_dat[0], "dat1"), ", ")


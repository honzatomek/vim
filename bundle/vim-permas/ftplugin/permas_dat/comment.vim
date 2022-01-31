if exists("b:permas_dat_comment")
  finish
endif

let b:permas_comment = '!'

" modes: 0 - comment
"        1 - uncomment
"        2 - toggle
function! s:PermasDATComment(is_visual, mode) range
  let l:unnamed_reg = @
  if a:is_visual == 0
    let l:lines = [line("."), line(".")]
  else
    let l:lines = [line("'<"), line("'>")]
  endif

  let l:index = l:lines[0]
  while l:index <= l:lines[1]
    if a:mode == 0
      if s:PermasDATIsComment(l:index) == 0
"         echom 'is not comment'
        call s:PermasDATCommentOn(l:index)
      endif
    elseif a:mode == 1
      if s:PermasDATIsComment(l:index) > 0
        call s:PermasDATCommentOff(l:index)
      endif
    elseif a:mode == 2
      if s:PermasDATIsComment(l:index) > 0
        call s:PermasDATCommentOff(l:index)
      else
        call s:PermasDATCommentOn(l:index)
      endif
    endif
    let l:index += 1
  endwhile

  let @@ = l:unnamed_reg
endfunction

function! s:PermasDATCommentOn(linenr)
  call setline(a:linenr, substitute(getline(a:linenr), '\v^(\s*)(.*)$', '\1' . b:permas_comment . ' \2', ''))
endfunction

function! s:PermasDATCommentOff(linenr)
  call setline(a:linenr, substitute(getline(a:linenr), '\M^\(\s\*\)\(' . escape(b:permas_comment, '^$\%#') . '\s\*\)\(\.\*\)$', '\1\3', ''))
endfunction

function! s:PermasDATIsComment(linenr)
  let l:line = getline(a:linenr)
  let l:trimmed = substitute(l:line, '\M^\s\*', '', '')
"   echom l:trimmed
  if l:trimmed[0] =~# b:permas_comment
"     echom 'is comment'
    return len(matchstr(l:trimmed, '\M^' . escape(b:permas_comment, '$\^#%') . '\s\*'))
  else
"     echom 'is not comment'
    return 0
  endif
endfunction

nnoremap <buffer> <leader>cc :call <SID>PermasDATComment(0,0)<cr>
nnoremap <buffer> <leader>cd :call <SID>PermasDATComment(0,1)<cr>
nnoremap <buffer> <leader>C  :call <SID>PermasDATComment(0,2)<cr>
vnoremap <buffer> <leader>cc :<c-u>call <SID>PermasDATComment(1,0)<cr>
vnoremap <buffer> <leader>cd :<c-u>call <SID>PermasDATComment(1,1)<cr>
vnoremap <buffer> <leader>C  :<c-u>call <SID>PermasDATComment(1,2)<cr>

let b:permas_dat_comment = 1

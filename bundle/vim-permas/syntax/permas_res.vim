" Vim syntax file
" Language: PERMAS RES
" Maintainer: dx2tomek
" Latest Revision: 03 February 2020

if exists("b:current_syntax")
    finish
endif

syn match resTable "|"
syn match resTable "[-=]\{2,}"
syn match resTable ">" contained
syn match resTable "\s*\(+\||\)\(+\|-\)*\(+\||\)\s*"
syn match resTableName "^\s*>\s.*$" contains=resTable

" syn match resInt "\s-\=\d\+\(\s\|$\)"ms=s+1
syn match resInt "\s-\=\d\+"ms=s+1
" syn match resDouble "\s-\=\d\+\.\d\+\([eE][+-]\d\+\|\)\(\s\|$\)"ms=s+1
syn match resDouble "\(\s\|,\)\{1}[-+]\=\d\+\.\d\+\([eE][+-]\d\+\|\)\=%\="ms=s+1
syn match resProcent "\s[%.]\{2,}\s"ms=s+1,me=e-1
syn match resProcent "\s[%.]\{2,}$"ms=s+1

syn match resIdent "\w\+\s*="me=e-1 contained nextgroup=resVal
syn match resVal "=\s*\(\S\|,\)\+"ms=s+1 contained

syn match resVals "\w\+\s*=\s*\S\+" contains=resIdent,resVal

syn match resPermasC "!.\{-}$" contained
syn match resPermas "\$\w.*$" contains=resVals,resPermasC

syn match resNormal "\d\+/\d\+" contained
syn match resComment "\d\+/\d\+" contained
syn match resWarning "\d\+/\d\+" contained
syn match resError "\d\+/\d\+" contained

syn region resFailure start="^\s*\*F\*\s" end="\sERRORS\s*$" contains=resError
syn match resError "^\s*\*E\*\s.*$"  contains=resWarning
syn match resWarning "^\s*\*W\*\s.*$" contains=resComment
syn match resComment "^\s*\*C\*\s.*$" contains=resNormal

let b:current_syntax = "permas_res"

highlight resTable           ctermfg=173
highlight resTableName       ctermfg=14
highlight resInt             ctermfg=14
highlight resDouble          ctermfg=12
highlight resProcent         ctermfg=9

highlight resIdent           ctermfg=172
highlight resVal             ctermfg=12
highlight resPermas          ctermfg=2
highlight resPermasC         ctermfg=247

highlight resFailure         ctermfg=LightGrey    ctermbg=129      cterm=bold
highlight resError           ctermfg=14                            cterm=bold
highlight resWarning         ctermfg=9                             cterm=bold
highlight resComment         ctermfg=70                            cterm=bold
highlight resNormal          ctermfg=LightGrey


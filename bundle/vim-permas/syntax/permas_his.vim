" Vim syntax file
" Language: PERMAS HIS File
" Maintainer: dx2tomek
" Latest Revision: 15 July 2020

if exists("b:current_syntax")
    finish
endif

syn match hisNegative "-\d\+" contained
syn match hisPositive "+\d\+" contained
syn match hisExp "[eE][+-]\d\+" contained contains=hisPositive,hisNegative

syn match hisInt "[ .:_]-\=\d\+"ms=s+1
" syn match hisDoublePositive "\(\s\|,\)\{1}[-+]\=\d\+\.\d\+\([eE][+-]\d\+\|\)\=%\="ms=s+1 contains=hisExp
syn match hisDoublePositive "\(\s\|,\)\{1}+\=\d\+\.\d\+\([eE][+-]\d\+\|\)\=%\="ms=s+1 contains=hisExp
syn match hisDoubleNegative "\(\s\|,\)\{1}-\d\+\.\d\+\([eE][+-]\d\+\|\)\=%\="ms=s+1 contains=hisExp

syn match hisComment "^/.*"

let b:current_syntax = "permas_his"

highlight hisInt             ctermfg=14
highlight hisDoublePositive  ctermfg=12
highlight hisDoubleNegative  ctermfg=9
highlight hisExp             ctermfg=14
highlight hisNegative        ctermfg=9
highlight hisPositive        ctermfg=10
highlight hisComment         ctermfg=248

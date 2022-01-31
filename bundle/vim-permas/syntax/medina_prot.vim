" Vim syntax file
" Language: Medina Protocol File
" Maintainer: dx2tomek
" Latest Revision: 22 July 2020

if exists("b:current_syntax")
    finish
endif

syn match protVal "=\zs\S\+\ze\(\s\|$\)"

" syn match protNegative "-\d\+" contained
" syn match protPositive "+\d\+" contained
syn match protPositive "+\=\d\+"
syn match protNegative "-\d\+"
syn match protExp "[eE][+-]\d\+" contained contains=protPositive,protNegative

" syn match protInt "[ .:_,=]-\=\d\+"ms=s+1
" syn match protDoublePositive "\(\s\|,\)\{1}[-+]\=\d\+\.\d\+\([eE][+-]\d\+\|\)\=%\="ms=s+1 contains=protExp
syn match protDoublePositive "\(\s\|,\|=\)\{1}+\=\d*\.\d*\([eE][+-]\d\+\|\)\=%\="ms=s+1 contains=protExp
syn match protDoubleNegative "\(\s\|,\|=\)\{1}-\d*\.\d*\([eE][+-]\d\+\|\)\=%\="ms=s+1 contains=protExp

syn match protString "\".\{-}\""

syn match protComment "^\s*\*.*$"

syn keyword protOK _ok _Ok _OK

let b:current_syntax = "permas_prot"

" highlight protInt             ctermfg=14
highlight protDoublePositive  ctermfg=12
highlight protDoubleNegative  ctermfg=9
highlight protExp             ctermfg=14
highlight protNegative        ctermfg=9
highlight protPositive        ctermfg=10
highlight protComment         ctermfg=248
highlight protString          ctermfg=1
highlight protOK              ctermfg=3
highlight protVal             ctermfg=6

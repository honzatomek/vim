" Vim syntax file
" Language: PERMAS DAT
" Maintainer: dx2tomek <jan.tomek@mbeng.cz>
" Latest Revision: 12.05.2020

if exists("b:current_syntax")
    finish
endif

syn match datOperator "\v^\s*\&"
syn match datOperator "\v\:"
syn match datOperator "\v,"

syn match datData "\v\$\a*"

syn match datExit "\v\c\$exit\s*component"
syn match datExit "\v\c\$exit\s*material"

syn region datHighHeader start="\v\c\$enter\s*component" end="$" contains=datEnter,datParams,datComment
syn region datHighHeader start="\v\c\$enter\s*material" end="$" contains=datEnter,datParams,datComment
syn match datEnter "\v\c\$enter\s*component" contained
syn match datEnter "\v\c\$enter\s*material" contained
syn match datParams "\v\s\a+\s*\="hs=s+1,he=e-1

syn match datLPat1 "\v[1-9]\d*\.\S*" contained
syn match datLPat "\v\c^\s*lpat\s*\=.*$" contains=datLPat1,datComment,datParams

syn match datVarHeader "\v\c\$structure(\s+.*)=$" contains=datVarStart,datParams,datComment
syn match datVarHeader "\v\c\$situation(\s+.*)=$" contains=datVarStart,datParams,datComment
syn match datVarHeader "\v\c\$system(\s+.*)=$" contains=datVarStart,datParams,datComment
syn match datVarHeader "\v\c\$constraints(\s+.*)=$" contains=datVarStart,datParams,datComment
syn match datVarHeader "\v\c\$loading(\s+.*)=$" contains=datVarStart,datParams,datComment
syn match datVarHeader "\v\c\$modification(\s+.*)=$" contains=datVarStart,datParams,datComment
syn match datVarHeader "\v\c\$results(\s+.*)=$" contains=datVarStart,datParams,datComment
syn match datVarHeader "\v\c\$material(\s+.*)=$" contains=datVarStart,datParams,datComment

syn match datVarEnd "\v\c\$end\s*structure"
syn match datVarEnd "\v\c\$end\s*situation"
syn match datVarEnd "\v\c\$end\s*system"
syn match datVarEnd "\v\c\$end\s*constraints"
syn match datVarEnd "\v\c\$end\s*loading"
syn match datVarEnd "\v\c\$end\s*modification"
syn match datVarEnd "\v\c\$end\s*results"
syn match datVarEnd "\v\c\$end\s*material"

syn match datVarStart "\v\c\$\a*" contained

syn match datLoop "\v\c\$defvar>" contained
syn match datLoop "\v\c\$loop" contained
syn match datLoopHead "\v\c^\s*\$loop(\s+.*)=$" contains=datLoop,datParams,datComment
syn match datLoop "\v\c^\s*\$endloop>"
syn match datDefVar "\v\c^\s*\$defvar(\s+.*)=$" contains=datLoop,datParams,datComment
syn match datLoop "\v\c\$echo\s+(on|off|header|gen)>"

syn match datFin "\v\c^\s*\$fin>"

syn match datComment "\v!.*$"
syn match datHeader "\v[-+=#]{3}\s\S.*\S\s[-+=#]{3}"hs=s+3,he=e-3 contained
syn match datHeaderLine "\v^\s*!.*!$" contains=datHeader
syn match datHeader "\v^!!\s*(\a+\s+)+" contained
syn match datHeaderLine "\v^!!.*$" contains=datHeader
" syn match datHeader "\v!!SDM HEADER (BEGIN|END)"

hi def link datComment     Comment       " Comment
hi def link datHeaderLine  Comment       " Comment
hi def link datHeader      Todo          " Title         " Comment
" highlight datHeader        Title         " ctermfg=LightBlue cterm=bold

hi def link datEnter       Title         " Todo
hi def link datExit        Title         " Todo
hi def link datParams      Label
hi def link datFin         Error

hi def link datVarStart    Function " Identifier
hi def link datVarEnd      Function " Identifier
hi def link datData        String
hi def link datLPat1       Define        " String
hi def link datLoop        Statement     " Keyword    " Type

hi def link datOperator    Delimiter     " String
" highlight datOperator      ctermfg=Red

colorscheme permas_dat
let b:current_syntax = "permas_dat"

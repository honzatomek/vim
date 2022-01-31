" Vim syntax file
" Language: PERMAS PRO
" Maintainer: dx2tomek
" Latest Revision: 03 February 2020

if exists("b:current_syntax")
    finish
endif

syn match proTable "|"
syn match proTable "[-=]\{2,}"
syn match proTable ">" contained
syn match proTable "\s*\(+\||\)\(+\|-\)*\(+\||\)\s*"
syn match proTableName "^\s>\s.*$" contains=proTable

syn match proInt "\s-\=\d\+"ms=s+1
syn match proDouble "\(\s\|,\)\{1}[-+]\=\d\+\.\d\+\([eE][+-]\d\+\|\)\=%\="ms=s+1

syn match proSec "\d\d" contained
syn match proMin "\d\d" contained nextgroup=proSec
syn match proHour "\d\d" contained nextgroup=proMin
syn match proTime "^\s\d\{6}\s"ms=s+1,me=e-1 contains=proHour,proMin,proSec
syn match proTime "\s\d\{6}\s"ms=s+1,me=e-1 contained contains=proHour,proMin,proSec

syn match proIdent "\w\+\s*="me=e-1 contained nextgroup=proVal
syn match proVal "=\s*\(\S\|,\)\+"ms=s+1 contained

syn match proVals "\w\+\s*=\s*\S\+" contains=proIdent,proVal

syn match proPermasC "!.\{-}$" contained
syn match proPermas "^\s*>.*$" contains=proVals,proPermasC

syn match proStepInfo "\s\d\+\.\d\+\s\a\+" contained contains=proDouble
syn match proStepName "\s\u\(\u\|\d\|_\)\+\s"ms=s+1,me=e-1 contained nextgroup=proStepInfo

syn match proStep "\<\(Proc\|Step\|Pr\w\{2}\)\>" contained nextgroup=proStepName
syn match proStep "\(Exit\)" contained nextgroup=proStepInfo
syn match proStep "\(Start\)" contained

syn match proPermasMsg "^\s*\d\{6}\s>Msg\s.*$" contains=proTime
syn match proPermasStep "^\s*\d\{6}\sStep\s.*$" contains=proTime,proStep,proStepName
syn match proPermasStep "^\s*\d\{6}\sStep\s.*Exit.*$" contains=proTime,proStep,proStepName,proStepInfo ",proDouble
syn match proPermasStep "^\s*\d\{6}\sPr\w\{2}\s.*$" contains=proTime,proStep,proStepName
syn match proPermasProc "^\s*\d\{6}\sProc\s.*Start.*$" contains=proTime,proStep,proStepName
syn match proPermasProc "^\s*\d\{6}\sPr\w\{2}\s.*Exit.*$" contains=proTime,proStep,proStepName,proStepInfo,proDouble

syn match proPermasVarName "\s\w\+" contained
syn match proPermasVariant "\(Component\|Situation\)\s\w\+" contains=proPermasVarName

syn match proNormal "\d\+/\d\+" contained
syn match proComment "\d\+/\d\+" contained
syn match proWarning "\d\+/\d\+" contained
syn match proError "\d\+/\d\+" contained

syn region proFailure start="^\s*\*F\*\s" end="\sERRORS\s*$" contains=proError
syn match proError "^\s*\*E\*\s.*$"  contains=proWarning
syn match proWarning "^\s*\*W\*\s.*$" contains=proComment
syn match proComment "^\s*\*C\*\s.*$" contains=proNormal

let b:current_syntax = "permas_pro"

highlight proTable           ctermfg=173
highlight proTableName       ctermfg=14
highlight proInt             ctermfg=14
highlight proDouble          ctermfg=12
highlight proSec             ctermfg=172
highlight proMin             ctermfg=2
highlight proHour            ctermfg=LightGrey

highlight proIdent           ctermfg=172
highlight proVal             ctermfg=12
highlight proPermas          ctermfg=2
highlight proPermasC         ctermfg=247

highlight proPermasStep      ctermfg=2
highlight proStep            ctermfg=156
highlight proStepName        ctermfg=227
highlight proStepInfo        ctermfg=5

highlight proPermasProc      ctermfg=5
highlight proPermasMsg       ctermfg=LightGrey

highlight proPermasVarName   ctermfg=12                            cterm=bold
highlight proPermasVariant   ctermfg=173

highlight proFailure         ctermfg=LightGrey    ctermbg=129      cterm=bold
highlight proError           ctermfg=14                            cterm=bold
highlight proWarning         ctermfg=9                             cterm=bold
highlight proComment         ctermfg=70                            cterm=bold
highlight proNormal          ctermfg=LightGrey


" Vim syntax file
" Language: PERMAS UCI
" Maintainer: dx2tomek
" Latest Revision: 28 January 2020

if exists("b:current_syntax")
    finish
endif

setlocal shiftwidth=2
setlocal softtabstop=2
setlocal expandtab

" /home/dx2tomek/.elisp/gold/permas_uci.el

" PERMAS DAT Direct Input
syn match uciDatEntry "\c\<read\s*\permas\s*$"
syn match uciDatEntry "\c\$\a*"

" TASK
syn match uciTask "\c\<task\>"
syn match uciTask "\c\<task\>\s*\a\+\>"

" NEW, STARTUP
syn match uciNew "\cnew\|startup"

" SECTION
syn case ignore
syn keyword uciSection exec export input license print select user return
syn case match

" PARAM, DEFINE, SET
syn region uciDefine start="\c\<param\>\|\c\<default\>\|\c\<set\>\|\c\<sitinput\>\|\c\<define\>\|\c\<modify\>" end="\>\s*="he=s

" CLOOP
syn match uciCloop "\c\<cloop\s.*$"

" CURRENT, ACTIVE, ACTIVATE, ITEM, CLEAR
syn region uciCurrent start="\c\<current\>\|\c\<active\>\|\c\<activate\>\|\c\<clear\>" end="\>\s*="he=e-1
syn match uciCurrent "\c\<current\s\+reset\>"
syn match uciCurrent "\c\<active\s\+\(reset\|\(list\s\+\)\?\(eset\|nset\)\|show\)\>" contains=uciESet,uciNSet
syn match uciESet  "\c\<eset\>"
syn match uciNSet  "\c\<nset\>"
syn match uciItem "\c\<item\>"
syn match uciItem "\c\<item\s\+clear\>"

syn match uciESet "\c\<et_"
syn match ucinSet "\c\<of_"

" CLEAR
syn match uciStop "\m^\s*\(\cclear\s\+situation\)\s\+=\s\+'\(.*\l.*\)%.*'"

" PORT, TRAP
syn region uciPort start="\c\<port\>\|\c\<trap\>" end="\>\s*$"he=s

" GO
syn match uciFile "\c\<go\s\+.*$"

" FILE
syn region uciFile start="\c^.*file\>" end="\>\s*="he=s

" CALL
syn match uciCall "\c\<call\s\+\S\+\>"

" Literal Strings
syn region uciString start="'" end="'" contains=uciVariantName,uciExpand

" Comment
syn match uciComment "\v(^\s*|\s=)!.*$" contains=uciVariantName,uciFileName
syn match uciHeader '\v[-+=#]{3}\s\S.*\S\s[-+=#]{3}'hs=s+3,he=e-3 contained
syn match uciHeaderLine "\v^\s*!.*!$" contains=uciHeader

" Model name
syn match uciVariantName "\d\{4}\a_\S\{3}_\S\{4}_\d\{4}"
syn match uciVariantName "\a\{2}\d\{4}\a_\S\{3}_\S\{4}_\d\{4}"
syn match uciVariantName "\a\{2}\d\{2}\a_\S\{3}_\S\{4}_\d\{4}"
syn match uciVariantName "\a\{4}\d\{2}\a_\S\{3}_\S\{4}_\d\{4}"

syn match uciFileName "\w\+\.bif\>"
syn match uciFileName "\w\+\.uci\>"
syn match uciFileName "\w\+\.dat\d*\>"

" STOP
syn match uciStop "\c^\s\{-}\<set\>\s\+\<\(rigdig\|modenorm\|massnorm\)\>\s\{-}=\s\{-}\S\+"
syn match uciStop "\c\<stop\>"

" PERMAS Self-expanding format
syn match uciExpand "%\S*(\a\{-})"

" request modules
syn match uciModule "!\s*request\.modules\s*=.*$"

let b:current_syntax = "permas_uci"

hi def link uciComment        Comment
hi def link uciHeaderLine     Comment
hi def link uciHeader         Comment
highlight uciHeader ctermfg=LightBlue cterm=bold
hi def link uciModule         Reversed  " Underlined
hi def link uciTask           Todo
hi def link uciCloop          Todo
hi def link uciStop           Error
hi def link uciCall           Error
hi def link uciCurrent        Label
hi def link uciNew            Identifier
hi def link uciDefine         Statement
hi def link uciString         Statement
hi def link uciSection        Function
hi def link uciFile           String
hi def link uciPort           Keyword " Statement
hi def link uciVariantName    Constant
hi def link uciFileName       Constant
"highlight uciDatEntry   ctermfg=LightGreen
hi def link uciDatEntry       Special
hi def link uciItem           Type
hi def link uciNSet           Type
hi def link uciESet           Constant
hi def link uciExpand         Keyword


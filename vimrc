" Author: Jan Tomek
" Email:  rpi3.tomek@protonmail.com
" Date:   18.04.2020
"

" <--- colorscheme ------------------------------------------------------------> {{{1
" colorscheme darcula                     " set colorscheme
colorscheme jellybeans                  " set colorscheme
if "$TERM" == 'xterm-256color'
    set t_Co=256
endif

" <--- pathogen ---------------------------------------------------------------> {{{1
" start pathogen from bundle/ directory
set nocompatible
runtime bundle/vim-pathogen/autoload/pathogen.vim
let g:pathogen_disabled = ["vim-lsdyna", "YouCompleteMe", "vim-flake8"]
execute pathogen#infect()
syntax on
filetype off
filetype plugin indent on               " autodetect filetype and use plugin if exists, use indent

" <--- NERDtree ---------------------------------------------------------------> {{{1
" set NERDTree width
let g:NERDTreeWinSize=40

" <--- undotree ---------------------------------------------------------------> {{{1
" set Undotree layout
let g:undotree_WindowLayout = 3
" set undotree width
let g:undotree_SplitWidth = 40
" set undotree diffpane height
let g:undotree_DiffpanelHeight = 15

" <--- better whitespace ------------------------------------------------------> {{{1
" let g:better_whitespace_operator=',s'
let g:better_whitespace_filetypes_blacklist=['diff', 'gitcommit', 'unite', 'qf',
                                           \ 'help', 'markdown', 'git', 'idlang']

" <--- vim-flake8 -------------------------------------------------------------> {{{1
" let g:flake8_quickfix_location="rightbelow"

" <--- vim-syntastic ----------------------------------------------------------> {{{1
let g:syntastic_check_on_wq = 0
let g:syntastic_check_on_open = 0
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 0
let g:syntastic_aggregate_errors = 1
let g:syntastic_python_checkers = ['flake8']
let g:syntastic_python_flake8_exec = '/home/pi/.local/bin/flake8'
let g:syntastic_sh_checkers = ['shellcheck']
let g:syntastic_python_shellcheck_exec = '/usr/bin/shellcheck'
let g:syntastic_mode_map = {"mode": "passive", "active_filetypes": [], "passive_filetypes": ["python"],}

" <--- vimwiki ----------------------------------------------------------------> {{{1
let wiki = {}
let wiki.path = '~/vimwiki'
let wiki.nested_syntaxes = {'python': 'python',
                         \  'bash': 'sh', 'sh': 'sh',
                         \  'vim': 'vim',
                         \  'git': 'git', 'gitconfig': 'gitconfig',}
let g:vimwiki_list = [wiki]

" <--- add custom settings ----------------------------------------------------> {{{1
" set nocompatible                        " turn off compatibility with vi, be iMproved
" syntax   on                             " turn syntax highlighting on

set hidden
set wildmenu                            " enhanced completion
set showcmd                             " show command and visual selection
set hlsearch                            " highlight search

set ignorecase                          " ignore case in search patterns
set smartcase                           " smarter ignore case option

set backspace=indent,eol,start          " backspace works over indent, end-of-line, start-of-line
set autoindent                          " copy indent from current line when starting new line
set nostartofline                       " when jumping through file keep cursor in the same column
                                        " if  possible
set ruler                               " show line and column number in status line
set laststatus=2                        " last window will always have status line

set confirm                             " require cofirmation for commands such as :q :w

set visualbell                          " use visual bell instead of beeping (t_vb=character_for_bell)
set t_vb=

set mouse=a                             " enable the use of mouse
set cmdheight=2                         " height of command window

set number                              " show line number next to each line

set pastetoggle=<f11>                   " toggle paste options (paste/no paste)

set shiftwidth=4                        " set number of chars for indent
set softtabstop=4                       " number of chars for a tab in insert mode
set expandtab                           " replace tab by spaces

                                        " overrides default recognition of numbers as octal or hex,
set nrformats=
                                        " works for <c-a> and <c-x> (increment/decrement)

set cursorline                          " shows cursor as a line

set binary                              " reads all files as binary -> dos carriage return as ^M

set modeline
set encoding=utf-8

set splitright                          " vertical splits open right
set nosplitbelow                        " horizontal splits open above

set wildmenu                            " enhanced commandline completion - show suggestions upon <tab> over statusline
" set scrolloff=999                       " current line is always in the middle of screen
set scrolloff=10                        " current line is always 10 lines from edge of screen
set undolevels=500                      " max 500 undos (default is 1000)
set history=500                         " history of : and search commands (default is 50)
set linebreak                           " when linewrap is on, do not wrap in the middle of words
set dir=$HOME/.vim_swap//               " all swap files in one directory
set backupdir=$HOME/.vim_swap//         " all backupfiles in one directory
set undofile undodir=$HOME/.vim_undo//  " persistent undo tree, all in one directory
set virtualedit=block,onemore           " visualblock selection can go beyond the last line character
set nojoinspaces                        " when joining lines only one space is used
set breakindent                         " wrapped lines keep their indent level
set formatoptions+=j                    " when applicable delete comment char when joining commented lines (:help fo-table, default = tcq)

set timeout                             " key mappings timeout on
set timeoutlen=500                      " key mappings timeout length in ms
set ttimeout                            " key codes timeout on
set ttimeoutlen=100                     " key codes timeout in ms

let mapleader=","

" <--- custom mapping ---------------------------------------------------------> {{{1
" open .vimrc
nnoremap <silent>      <leader>ev   :vertical rightbelow split $MYVIMRC<cr>
" source .vimrc
nnoremap <silent>      <leader>sv   :source $MYVIMRC<cr>
" copy to the end of line
nnoremap               Y            y$
" use jk and instead of <esc> in insert mode
inoremap <nowait>      jk           <esc>
" H to move to the beginnig of line
nnoremap               H            0
" L to move to the end of line
nnoremap               L            $

" Toggle windows
nnoremap <silent>      <tab>        <c-w><c-w>
nnoremap <silent>      <s-tab>      <c-w>W
" Move between windows
nnoremap <silent>      <c-left>     <c-w>h
nnoremap <silent>      <c-right>    <c-w>l
nnoremap <silent>      <c-up>       <c-w>k
nnoremap <silent>      <c-down>     <c-w>j

" refresh of screen will also turn off search highlighting
" nnoremap               <c-l>        :nohl<cr>execute "let @/=\"\""<cr><c-l>
nnoremap               <c-l>        :nohl<cr>:let @/=""<cr><c-l>
" clear last search pattern
let @/=""
" F4 key will forcfully quit the file without save, if in diff mode, then forced quit of all windows
noremap  <expr>        <f4>         &diff ? ':windo q!<cr>' : ':q!<cr>'

" Toggle scroll lock for all open windows
nnoremap <silent>      <leader>b    :windo set scrollbind!<cr>
" Toggle compare mode for all open windows
nnoremap <expr>        <leader>d    &diff ? ':windo diffoff<cr>' : ':windo diffthis<cr>'

" Write backup <file>_backup.<ext>
nnoremap <buffer>      <leader>bak  :execute "w ".expand('%:r').'_backup.'.expand("%:e")<cr>

" Move current line down
nnoremap <silent>      <c-j>        :m .+1<cr>
inoremap <silent>      <c-j>        <esc>:m .+1<cr>gi
vnoremap <silent>      <c-j>        :m '>+1<cr>gv
" Move current line up
nnoremap <silent>      <c-k>        :m .-2<cr>
inoremap <silent>      <c-k>        <esc>:m .-2<cr>gi
vnoremap <silent>      <c-k>        :m '<-2<cr>gv

" German keyboard Jump to tag and back
nnoremap <silent>      ü            <c-]>
nnoremap <silent>      Ü            <c-o>

" <--- search mapping ---------------------------------------------------------> {{{1
" Create a search pattern for word under cursor
nnoremap               <leader>w    :%s/\<<c-r><c-w>\>//gc<left><left><left>
" Create a search - replace calculator
nnoremap               <leader>sd   :%s/\([+-]\{,1}\d\+\.\d*\(E[+-]\{,1}\d\+\)\{,1}\)/\=printf('%.6E',str2float(submatch(0))+)/c<left><left><left>

" <--- file path under cursor -------------------------------------------------> {{{1
" open file right
nnoremap               gl           :vertical rightbelow wincmd f<cr>:lcd %:p:h<cr>
" open file left
nnoremap               gh           :vertical aboveleft wincmd f<cr>:lcd %:p:h<cr>
" open file below
nnoremap               gj           :rightbelow wincmd f<cr>:lcd %:p:h<cr>
" open file above
nnoremap               gk           :aboveleft wincmd f<cr>:lcd %:p:h<cr>
" open explorer right
nnoremap               ge           :vertical rightbelow new<cr>:Explore<cr>
" open new file right
nnoremap               gn           :vertical rightbelow new<cr>
nnoremap               <c-w>N       :vertical rightbelow new<cr>
" open new file in new tab
nnoremap               tn           :tabnew
" open file under cursor in new tab
nnoremap               tf           :tabnew <cfile><cr>
" open directory under cursor
noremap <buffer>       gd           :execute "vertical rightbelow split ".expand('<cfile>:p:h')<cr>

" <--- edit mappings ----------------------------------------------------------> {{{1
" convert curent word to UPPERCASE
nnoremap <buffer>      <leader>u    viwoU<esc>el
inoremap <buffer>      <c-u>        <esc>hviwU<esc>ea
" wrap current expression surrounded by blanks in " quotes
nnoremap <buffer>      <leader>"    viWo<esc>i"<esc>Ea"<esc>
vnoremap <buffer>      <leader>"    <esc>`<i"<esc>`>a"<esc>`<lv`>
" wrap current expression surrounded by blanks in ' quotes
nnoremap <buffer>      <leader>'    viWo<esc>i'<esc>Ea'<esc>
vnoremap <buffer>      <leader>'    <esc>`<i'<esc>`>a'<esc>`<lv`>
" wrap current expression surrounded by blanks in * characters
nnoremap <buffer>      <leader>*    viWo<esc>i*<esc>Ea*<esc>
vnoremap <buffer>      <leader>*    <esc>`<i*<esc>`>a*<esc>`<lv`>
" wrap current expression surrounded by blanks in () parentheses
nnoremap <buffer>      <leader>(    viWo<esc>i(<esc>Ea)<esc>
vnoremap <buffer>      <leader>(    <esc>(<i*<esc>`>a)<esc>`<lv`>
" wrap current expression surrounded by blanks in {} parentheses
nnoremap <buffer>      <leader>{    viWo<esc>i{<esc>Ea}<esc>
vnoremap <buffer>      <leader>{    <esc>{<i*<esc>`>a}<esc>`<lv`>
" wrap current expression surrounded by blanks in [] parentheses
nnoremap <buffer>      <leader>{    viWo<esc>i[<esc>Ea]<esc>
vnoremap <buffer>      <leader>{    <esc>[<i*<esc>`>a]<esc>`<lv`>

" <--- operator pending mapping -----------------------------------------------> {{{1
" Inside Next parentheses
" onoremap <silent>      in(          :<c-u>normal! f(vi(<cr>
onoremap <silent>      in(          :<c-u>execute "normal! /(\r:nohlsearch\rvi("<cr>
onoremap <silent>      in{          :<c-u>execute "normal! /{\r:nohlsearch\rvi{"<cr>
onoremap <silent>      in[          :<c-u>execute "normal! /[\r:nohlsearch\rvi["<cr>
" Inside Last parentheses
" onoremap <silent>      il(          :<c-u>normal! F)vi(<cr>
onoremap <silent>      il(          :<c-u>execute "normal! ?)\r:nohlsearch\rvi("<cr>
onoremap <silent>      il{          :<c-u>execute "normal! ?}\r:nohlsearch\rvi{"<cr>
onoremap <silent>      il[          :<c-u>execute "normal! ?]\r:nohlsearch\rvi["<cr>
" Operator pending mapping for other special characters
" Inside:   i
" Around:   a
for char in [':', '.', ',', '_', '<bar>', '/', '<bslash>', '*', '+', '-', '#', '"', "'"]
  execute 'xnoremap i' . char . ' :<c-u>normal! T' . char . 'vt' . char . '<cr>'
  execute 'onoremap i' . char . ' :normal vi' . char . '<cr>'
  execute 'xnoremap a' . char . ' :<c-u>normal! F' . char . 'vf' . char . '<cr>'
  execute 'onoremap a' . char . ' :normal va' . char . '<cr>'
endfor

" <--- diff mode --------------------------------------------------------------> {{{1
" go to next diff
nnoremap <expr>        <c-n>        &diff ? ']c' : '<c-n>'
" go to prev diff
nnoremap <expr>        <c-p>        &diff ? '[c' : '<c-p>'

" <--- better whitespace ------------------------------------------------------> {{{1
noremap                <leader>s    :StripWhitespace<cr>

" <--- NERDtree ---------------------------------------------------------------> {{{1
nmap                  <leader>nt   <plug>NERDTreeMirrorToggle<cr>

" <--- undotree ---------------------------------------------------------------> {{{1
nnoremap              <leader>ut   :UndotreeToggle<cr>

" <--- vim-syntastic ----------------------------------------------------------> {{{1
nnoremap              <f7>         :SyntasticCheck<cr>:SyntasticSetLoclist<cr>

" <--- slimux -----------------------------------------------------------------> {{{1
map                   <leader>tl   :SlimuxREPLSendLine<cr>
vmap                  <leader>tl   :SlimuxREPLSendSelection<cr>
map                   <leader>tb   :SlimuxREPLSendBuffer<cr>
map                   <leader>ts   :SlimuxShellPrompt<cr>
map                   <leader>tk   :SlimuxSendKeysPrompt<cr>

" <--- augroups ---------------------------------------------------------------> {{{1
augroup tomek_help
    autocmd!
    autocmd BufEnter *.txt if &buftype == 'help' | wincmd L | endif
    autocmd BufEnter *.txt if &buftype == 'help' | execute ":vertical resize 78" | endif
augroup END

" augroup tomek_quickfix
    " autocmd!
    " autocmd BufEnter * if &buftype == 'quickfix' | wincmd L | set nowrap | vertical resize 60 | endif
" augroup END

augroup tomek_vim
    autocmd!
    autocmd FileType vim setlocal foldmethod=marker
    autocmd FileType vim setlocal shiftwidth=2 softtabstop=2 expandtab
    autocmd FileType vim nnoremap <script> <buffer> <leader>c :call <SID>toggle_comment('" ', 0)<cr>
    autocmd FileType vim vnoremap <script> <buffer> <leader>c :call <SID>toggle_comment('" ', 1)<cr>
augroup END

augroup tomek_python
    autocmd!
    autocmd FileType python setlocal shiftwidth=4 softtabstop=4 expandtab
    autocmd FileType python setlocal foldmethod=indent nofoldenable
    autocmd FileType python nnoremap <script> <buffer> <leader>c :call <SID>toggle_comment('# ', 0)<cr>
    autocmd FileType python vnoremap <script> <buffer> <leader>c :call <SID>toggle_comment('# ', 1)<cr>
augroup END

augroup tomek_bash
    autocmd!
    autocmd FileType sh setlocal shiftwidth=2 softtabstop=2 expandtab
    autocmd FileType sh nnoremap <script> <buffer> <leader>c :call <SID>toggle_comment('# ', 0)<cr>
    autocmd FileType sh vnoremap <script> <buffer> <leader>c :call <SID>toggle_comment('# ', 1)<cr>
augroup END

" <--- functions --------------------------------------------------------------> {{{1
function s:toggle_comment(comment_chars, is_visual) range
    if a:is_visual == 0
        let l:lines = [line('.'), line('.')]
    else
        let l:lines = [line("'<"), line("'>")]
    endif
    let l:unnamed_reg = @

    let l:index = l:lines[0]
    let l:comment = (getline(l:lines[0]) =~# '\v^\s*' . a:comment_chars)
    echom l:comment
    while l:index <= l:lines[1]
        call cursor(l:index, 0)
        if l:comment
            if getline(l:index) =~# '\v^\s*' . a:comment_chars
                execute "normal ^" . strlen(a:comment_chars) . "x"
            endif
        else
            execute "normal 0i" . a:comment_chars
        endif
        let l:index += 1
    endwhile
    if a:is_visual
	normal '<V'>
    endif
    let @@ = l:unnamed_reg
endfunction


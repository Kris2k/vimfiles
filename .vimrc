set nocompatible
" setlocal fo+=aw for vim mutt
""""""""""""""""""""""""""""""
" => Pathogen plugin
"""""""""""""""""""""""""""""""
source ~/.vim/bundle/pathogen/autoload/pathogen.vim
call pathogen#infect()
" add xpt templates personal folder to runtimepath
let &runtimepath .=',~/.vim/personal'

""""""""""""""""""""""""""""""
" => nfs go code plugin bulshit
"""""""""""""""""""""""""""""""
let g:gonfs_dir = $HOME . '/Projects/gocode/src/github.com/nsf/gocode/vim/'
if isdirectory(g:gonfs_dir)
  let &runtimepath .= ',' . g:gonfs_dir
  " gocode have to be in path etc
endif

""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""
if has("gui_running")
    " no buffer menu for me
    let no_buffers_menu = 1
    " disable  menu, Toolbar, Left scorllbar
    set guioptions -=m
    set guioptions -=T
    set guioptions -=L
    set fileencodings=utf-8
    set encoding=utf8
    " set fileencodings=ucs-bom,utf-8,latin1
    " polis settings for gui
    set mouse=""
endif

"if v:lang =~ "utf8$" || v:lang =~ "UTF-8$"
"    set termencoding=utf8
"endif

set title
syntax enable
filetype plugin indent on

"Enable or not enable ?
set modeline
set incsearch
set hlsearch
set history=100

set relativenumber
set softtabstop=4
set shiftwidth=4
set shiftround
set tabstop=4
set expandtab smarttab
let g:tex_flavor='latex'
"""""""""""""""""""""""""
" => Files backups are off
"""""""""""""""""""""""""
set nobackup         "do not create backup file
set nowritebackup    "no create backup when overwriting file
set noswapfile    " enabled to prevent double editing

if !isdirectory($HOME . '/.vim/tmp/swap')
    call mkdir($HOME . '/.vim/tmp/swap', 'p', 0700)
endif
set dir=$HOME/.vim/tmp/swap

if has("persistent_undo")
    if !isdirectory($HOME. '/.vim/tmp/undo')
        call mkdir($HOME. '/.vim/tmp/undo', 'p', 0700)
    endif
    set undodir=$HOME/.vim/tmp/undo
    set undofile
endif

set autoread    "auto read when a file is changed from outside
set hidden      "warn on exit with unsaved changes

" Set backspace config
set backspace=indent,eol,start
set whichwrap+=<,>,h,l
set linebreak

set ignorecase "Ignore case when searching
set smartcase

set laststatus=2         " commandline display and tab in cmdline
set wildchar=<Tab> wildmenu wildmode=list:longest,full

set clipboard+=unnamed "  yanks go to system clipboard too and back on Focus
autocmd FocusGained * let @z=@+

" match pairs for <> (default for (:) [:] )
set matchpairs+=<:>
" Set a shorter timeout
set timeoutlen=350
" Fast exit from insert mode
inoremap jk <Esc>
inoremap JK <Esc>
inoremap Jk <Esc>
inoremap jK <Esc>
""" for omni compleation because I can't type if sth is entered
inoremap <c-x><c-o> <c-x><c-o><c-p>

" Wrapped lines goes down/up to next row, rather than next line in file.
"nnoremap j gj
"nnoremap k gk

""""""""""""""""""""""""""""""""""
" => Terminal/gui settings (gvim)
""""""""""""""""""""""""""""""""""
if !has('win32') && !has('win64')
    set term=$TERM       " Make arrow and other keys work
endif

if ( &term == "linux" && ! has('gui_running') )
    " console vim backup that looks on 16 colors
    colorscheme peachpuff
else
    " I want all colors
    set t_Co=256
    colorscheme kchrisk
endif

" This also breaks something
if match($TERM, "screen")!=-1
  set term=xterm-256color
endif
" https://github.com/bitc/vim-bad-whitespace/blob/master/plugin/bad-whitespace.vim
" Highlight trailing whitespace and lines longer than 80 columns.
highlight LongLine ctermbg=DarkYellow guibg=DarkYellow
highlight WhitespaceEOL ctermbg=124 guibg=Red

function! ToggleLongLine()
    if exists('w:long_line_match')
        silent! call matchdelete(w:long_line_match)
        unlet w:long_line_match
        echo "Disable Long Line Highlight"
        return
    endif
    call StartLongLineHighLigh()
    echo "Enable Long Line Highlight"
endfunction

function! ToggleLongLine()
    if exists('w:long_line_match')
        silent! call matchdelete(w:long_line_match)
        unlet w:long_line_match
    endif
    call StartLongLineHighLigh()
    echo "Enable Long Line Highlight"
endfunction

nnoremap <silent> <Leader>d :call ToggleLongLine()<cr>

if v:version >= 702
    " Lines longer than 80 columns.
    augroup highlightWhitespaceEOL
    autocmd!
        autocmd BufWinEnter * let w:m1=matchadd('WhitespaceEOL', '\s\+$', -1)
    augroup END
    augroup highlightLongLines
    autocmd!
    augroup END
else
    augroup highlight
    autocmd!
        autocmd BufRead,BufNewFile * syntax match LongLine /\%>80v.\+/
        autocmd InsertEnter * syntax match WhitespaceEOL /\s\+\%#\@<!$/
        autocmd InsertLeave * syntax match WhitespaceEOL /\s\+$/
    augroup END
endif
"
" autocmd InsertEnter * syn clear EOLWS | syn match EOLWS excludenl /\s\+\%#\@!$/
" autocmd InsertLeave * syn clear EOLWS | syn match EOLWS excludenl /\s\+$/
" highlight EOLWS ctermbg=124 guibg=Red

""""""""""""""""""""""""""""""
" => helper functions
"""""""""""""""""""""""""""""""
function! GetBufferList()
  redir =>buflist
  silent! ls
  redir END
  return buflist
endfunction

"quickfix hack
function! ToggleList(bufname, pfx,num,switchTo)
  let buflist = GetBufferList()
  for bufnum in map(filter(split(buflist, '\n'), 'v:val =~ "'.a:bufname.'"'), 'str2nr(matchstr(v:val, "\\d\\+"))')
  if bufwinnr(bufnum) != -1
    exec(a:pfx.'close')
    return
  endif
  endfor
  if a:pfx == 'l' && len(getloclist(0)) == 0
    echohl ErrorMsg
    echo "Location List is Empty."
    return
  endif
  let winnr = winnr()
  exec('botright '.a:pfx.'open'.' '.a:num)
  if winnr() != winnr
    if a:switchTo == 'yes'
      wincmd p
    endif
  endif
endfunction

"Function that opens a file
" in split if there is file opened, diffenent that unnamed["No Name"]
" as only file if there is no other file
function! NiceOpen(fname)
    if len(bufname("%")) == 0
        exec("edit ". strtrans(a:fname))
    else
        exec("vsplit ". strtrans(a:fname))
    endi
endfunction

""""""""""""""""""""""""""""""
" => mapleader
"""""""""""""""""""""""""""""""
"let mapleader=' '
"let mapleader='-'
let mapleader=','
let maplocalleader = "\\"

"let g:makeJobNumber='-j4'
let g:makeJobNumber='4'
let g:makeTarget=''


" tests that call make  and commandT becaluse it bothers makegreen
" hasmapto('MakeGreen') is ok but this line makes problems
"nnoremap <unique> <silent> <Leader>t :call MakeGreen()<cr>

" noremap <silent> <leader>x :s/\ *$//g<cr>
" FIXME: this hack works for gnu screen problems when invoked make
nnoremap <leader><leader> :make <cr>:redraw!<cr>
nnoremap <leader>s :w!<cr>
nnoremap <leader>x :qall!<cr>
noremap  <silent> <leader>d :cd %:h<cr>
nnoremap <silent> <leader>a :Ack <C-R><C-W><CR>
nmap <silent> <leader>c <Plug>CommentaryLine
xmap <silent> <leader>c <Plug>Commentary
nnoremap <silent> <leader>g :grep <C-R><C-W> . <CR>
""Fast vimrc access
nnoremap <silent> <leader>eu :call NiceOpen("/etc/portage/package.use")<cr>
nnoremap <silent> <leader>em :call NiceOpen("/etc/portage/make.conf")<cr>
nnoremap <silent> <leader>ev :call NiceOpen("$MYVIMRC")<cr>
nnoremap <silent> <leader>et :call NiceOpen("$HOME/.tmux.conf")<cr>
nnoremap <silent> <leader>es :call NiceOpen("$HOME/.screenrc")<cr>
nnoremap <silent> <leader>ez :call NiceOpen("$HOME/.zshrc")<cr>
nnoremap <silent> <leader>eg :call NiceOpen("$HOME/.gitconfig")<cr>
nnoremap <silent> <leader>eh :call NiceOpen("$HOME/.ssh/config")<cr>
nnoremap <silent> <leader>en :call NiceOpen("/home/chris/Projects/utils/git-dotfiles/notes-programing.txt")<cr>

nnoremap <Leader>f :CommandT<CR>
" Quick fix list window
nmap <silent> <leader>l :call ToggleList("Location List", 'l','5','no')<CR>
nmap <silent> <leader>q :call ToggleList("Quickfix List", 'c','5','no')<CR>
""
" sourcing Hacks
nnoremap <silent> <leader>sv :source $MYVIMRC<cr>
nnorema <leader>w :!clang-format -i <C-R><C-W><cr>

" fast  no magic searching
nnoremap <silent> <leader>v /\v<C-R><C-W><CR>

"""""""""""""""""""""""""""""""
" => diff mode  mappings
"""""""""""""""""""""""""""""""
if &diff
    map <leader>1 :diffget LOCAL<CR>
    map <leader>2 :diffget BASE<CR>
    map <leader>3 :diffget REMOTE<CR>
    map <leader>k [c
    map <leader>j ]c
endif


"Fast search & replace
noremap "" :s:::g<Left><Left><Left>
noremap "} :%s:::g<Left><Left><Left>
noremap "? :%s///g<Left><Left><Left>

" Mapping of jumps
nnoremap ' `
nnoremap ` '

"  <|>  stays in insert mode
"vnoremap < <gv
"vnoremap > >gv

" Common typos and Minibuffer Explorer hack
command! W :w
command! Wq wqall
command! WQ wqall
command! Q qall


" jumps remeber remeber '' is great
noremap gI `.

" use arrows for something usefull
nnoremap <M-right> <C-W>>2
nnoremap <M-left>  <C-W><2
nnoremap <M-up>    <Esc>:resize -2 <CR>
nnoremap <M-down>  <Esc>:resize +2 <CR>

nnoremap <left>  :colder<cr>zvzz
nnoremap <right> :cnewer<cr>zvzz
nnoremap <up>    :cprev<cr>zvzz
nnoremap <down>  :cnext<cr>zvzz

" Select (charwise) the contents of the current line, excluding indentation.
" Great for pasting Python lines into REPLs.
nnoremap vv ^vg_
vnoremap q <c-c>
""""""""""""""""""""""""""""""
" => Fn  Shortcuts and others
"""""""""""""""""""""""""""""""
function! CursorLineToggle()
    if &cursorline
        set nocursorline
    else
        set cursorline
    endif
endfunction

function! NumberInv()
    if &relativenumber
        set number
        return
    endif
    if &number
        set nonumber
        return
    else
        set relativenumber
        return
    endif
endfunction

" hack 4 F1 map b/c vim cant handle multiple nmap F1 w/h complain
if !exists('f1_mapped')
nmap <unique> <F1>  <Plug>ZoomWin
let f1_mapped=1
endif
noremap <silent> <F2> :set ignorecase! noignorecase?<CR>
" noremap <silent> <F3> :set hlsearch! hlsearch?<CR>
noremap <silent> <F3> :GitGutterToggle<CR>
noremap  <silent> <F4> :call NumberInv()<CR>
noremap  <silent> <F5> :setlocal spell! spell?<CR>
noremap  <silent> <F6> :call CursorLineToggle()<cr>
" copy by F7
" vnoremap <silent> <F7> "+ygv"zy`>
vnoremap <silent> <F7> "+ygv"zy`>
""paste (Shift-F7 to paste after normal cursor, Ctrl-F7 to paste over visual selection)
nnoremap <silent> <F7> "+gP
nnoremap <silent> <S-F7> "+gp
inoremap <silent> <F7> <C-r><C-o>+
vnoremap <silent> <C-F7> "+zp`]
noremap  <silent> <F8> :TMiniBufExplorer <CR>
set pastetoggle=<F9>
" map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
"       \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
"       \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

" buffer switching
nnoremap <silent> <C-h> :bprevious<CR>
nnoremap <silent> <C-l> :bnext<CR>

" conflicts with windows keys ....those keyborad hacks
nnoremap <silent> <M-h> <C-w>h
nnoremap <silent> <M-j> <C-w>j
nnoremap <silent> <M-k> <C-w>k
nnoremap <silent> <M-l> <C-w>l


" replace paste or swap
vnoremap rp "0p
""""""""""""""""""""""""""""""
" => grep in vim
"""""""""""""""""""""""""""""""
" -I ignore binary files -Hn is for printing file name and line number
set grepprg=grep\ -Hn\ -I\ --exclude-dir='.svn'\ --exclude-dir='.git'\ --exclude='tags*'\ --exclude='cscope.*'\ --exclude='*.html'\ --exclude-dir='.waf-*'\ -r

""""""""""""""""""""""""""""""""""""
" => Ack  settings to disable html
""""""""""""""""""""""""""""""""""""
let g:ackprg="ack -H --nocolor --nogroup --column --nohtml"

""""""""""""""""""""""""""""""
" => Custom Commands
"""""""""""""""""""""""""""""""
" Strip end of lines  can be done autocomand
function! <SID>StripTrailingWhitespace()
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " Do the business:
    %s/\s\+$//e
    " Clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction

command! Strip :call <SID>StripTrailingWhitespace()<cr>

" generate Ctags cscope database for C,C++ files
command! CtagCscopeRegen exe '! find . -regex  ".*\.\(c\|cc\|cpp\|h\|hpp\)$"  -print > cscope.files && cscope -bq && ctags --c++-kinds=+p --fields=+iaS --extra=+q --sort=foldcase -L cscope.files '

map <silent> <C-F12> :CtagCscopeRegen<CR>

"""""""""""""""""""""""""""""""
" => Minibuffer plugin
"""""""""""""""""""""""""""""""
let g:miniBufExplorerMoreThanOne = 2
let g:miniBufExplTabWrap         = 1
let g:miniBufExplStatusLineText = ''
" hack for sourcing again the vimrc and setting coulorsheme
" if exists("g:did_minibufexplorer_syntax_inits")
"     unlet g:did_minibufexplorer_syntax_inits
" endif

"""""""""""""""""""""""""
" => Tlist plugin
"""""""""""""""""""""""""
let Tlist_Use_Right_Window = 1

"""""""""""""""""""""""""
" => command-t plugin
"""""""""""""""""""""""""
set wildignore+=*.html,*.o,*.obj,*.so,*.swp,*.zip,*.git,.svn

"""""""""""""""""""""""""
" => ctrl-p plugin
"""""""""""""""""""""""""
" disable for now
let g:loaded_ctrlp = 1
let g:ctrlp_regexp = 1
let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'
let g:ctrlp_prompt_mappings = { 'PrtAdd(".*")': ['<space>'] }
""""""""""""""""""""""""""""""
" => Robot framework plugin detection
"""""""""""""""""""""""""""""""
" let g:robot_syntax_for_txt=1

""""""""""""""""""""""""""""""
" => rainbow_parenthsis plugin
"""""""""""""""""""""""""""""""
" FIXME: under terminal 12 max colors make some parenthes difficult tosee
" FIXME: still blue is diffictult to display on black backroudn
let g:rbpt_max = 8

let g:rbpt_colorpairs = [
    \ ['brown',       'RoyalBlue3'],
    \ ['DarkYellow',    'SeaGreen3'],
    \ ['darkgray',    'DarkOrchid3'],
    \ ['darkgreen',   'firebrick3'],
    \ ['darkcyan',    'RoyalBlue3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['brown',       'firebrick3'],
    \ ['gray',        'RoyalBlue3'],
    \ ['black',       'SeaGreen3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['Darkblue',    'firebrick3'],
    \ ['darkgreen',   'RoyalBlue3'],
    \ ['darkcyan',    'SeaGreen3'],
    \ ['darkred',     'DarkOrchid3'],
    \ ['red',         'firebrick3'],
    \ ['darkred',     'SeaGreen3'],
    \ ]
" dark red is bad

augroup RainbowsParentheses
    autocmd!
    au VimEnter * RainbowParenthesesToggle
    au Syntax * RainbowParenthesesLoadRound
    au Syntax * RainbowParenthesesLoadSquare
    au Syntax * RainbowParenthesesLoadBraces
""""""""""""""""""""""""""""""
" => Robot framework plugin detection
"""""""""""""""""""""""""""""""
" let g:robot_syntax_for_txt=1

""""""""""""""""""""""""""""""
" => rainbow_parenthsis plugin
"""""""""""""""""""""""""""""""
" FIXME: under terminal 12 max colors make some parenthes difficult tosee
" FIXME: still blue is diffictult to display on black backroudn
let g:rbpt_max = 8

let g:rbpt_colorpairs = [
    \ ['brown',       'RoyalBlue3'],
    \ ['DarkYellow',    'SeaGreen3'],
    \ ['darkgray',    'DarkOrchid3'],
    \ ['darkgreen',   'firebrick3'],
    \ ['darkcyan',    'RoyalBlue3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['brown',       'firebrick3'],
    \ ['gray',        'RoyalBlue3'],
    \ ['black',       'SeaGreen3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['Darkblue',    'firebrick3'],
    \ ['darkgreen',   'RoyalBlue3'],
    \ ['darkcyan',    'SeaGreen3'],
    \ ['darkred',     'DarkOrchid3'],
    \ ['red',         'firebrick3'],
    \ ['darkred',     'SeaGreen3'],
    \ ]
" dark red is bad

augroup RainbowsParentheses
    autocmd!
    au VimEnter * RainbowParenthesesToggle
    au Syntax * RainbowParenthesesLoadRound
    au Syntax * RainbowParenthesesLoadSquare
    au Syntax * RainbowParenthesesLoadBraces
    " This will break for loop for ( int i=0; i<4; i++) see >
    " au Syntax * RainbowParenthesesLoadChevrons
augroup END

""""""""""""""""""""""""""""""
" => xptemplate plugin
"""""""""""""""""""""""""""""""
" This is cool but somewhat like too bulky
let g:SuperTabMappingForward              = '<tab>'
" if nothing matched in xpt, try supertab
"let g:xptemplate_fallback                 = '<Plug>supertabKey'
let g:xptemplate_key                      = '<c-\>'
let g:xptemplate_vars                     = "Rloop              = \n&SPcmd = "
let g:xptemplate_brace_complete           = ''
"let g:xptemplate_brace_complete = '([{'
let g:xptemplate_bundle                   = 'cpp_autoimplem'
" xpt triggers only when you typed whole name of a snippet. Optional
"let g:xptemplate_minimal_prefix = 'full'
let g:xptemplate_vars = "author=Krzysztof (Chris) Kanas&email=krzysztof.kanas@__at__@gmail.com&kelvatek_author=Krzysztof (Chris) Kanas&kelvatek_email=k.kanas@__at__@kelvatek.com&..."

"""""""""""""""""""""""""
" => clang_complete plugin
"""""""""""""""""""""""""
let g:clang_complete_copen    = 1
"let g:clang_periodic_quickfix = 1
let g:clang_periodic_quickfix = 0
let g:clang_conceal_snippets  = 0
let g:clang_complete_patterns = 0
let g:clang_complete_macros   = 1

"let g:clang_use_library       = 1
"let g:clang_library_path      = '/usr/lib64/llvm'
" clang to set for proper cross compiler header path
"let g:clang_user_options      = '-isystem PATH'
"  window for compleation that gives nothing for cpp
"set completeopt-=preview


"""""""""""""""""""""""""
" =>  syntatctic
"""""""""""""""""""""""""
"let g:pyflakes_use_quickfix = 1
"autocmd FileType python set omnifunc=pythoncomplete#Complete

let g:syntastic_enable_signs=0

"""""""""""""""""""""""""
" => cscope database auto add see :help cscopequickfix
"""""""""""""""""""""""""
if has("cscope") && filereadable("/usr/bin/cscope")
    " nice cscope menu see help
    set cscopequickfix=s-,g-,c-,d-,i-,t-,e-
    set csprg=/usr/bin/cscope
    set csto=0
    set cst
    " add cscope database local or form env
    set nocsverb
    if filereadable("cscope.out")
        cs add cscope.out
    elseif $CSCOPE_DB != ""
        cs add $CSCOPE_DB
    endif
    set csverb
endif


function! SetMakePrg()
    if filereadable('wscript')
        setlocal makeprg='./waf'
        return 0
    endif
    if filereadable('bam.lua') && filereadable('./bam')
        setlocal makeprg='./bam'
        return
    endif
    if glob('?akefile') != ''
        setlocal makeprg=make\ -j4\ $*
        return 0
    endif
    if bufname("%") =~ ".*\.tex"
        setlocal makeprg=latexmk\ -pdf
        return 0
    endif

    if bufname("%") =~ ".*\.c$"
        setlocal makeprg=gcc\ -Wall\ -g\ %
        return 0
    endif
    if  bufname("%") =~ ".*\.cpp"
        setlocal makeprg=g++\ -Wall\ -std=c++0x\ %
        return 0
    endif
    return 1
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Quickfix sort
""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! s:CompareQuickfixEntries(i1, i2)
  if bufname(a:i1.bufnr) == bufname(a:i2.bufnr)
    return a:i1.lnum == a:i2.lnum ? 0 : (a:i1.lnum < a:i2.lnum ? -1 : 1)
  else
    return bufname(a:i1.bufnr) < bufname(a:i2.bufnr) ? -1 : 1
  endif
endfunction

function! s:SortUniqQFList()
  let sortedList = sort(getqflist(), 's:CompareQuickfixEntries')
  let uniqedList = []
  let last = ''
  for item in sortedList
    let this = bufname(item.bufnr) . "\t" . item.lnum
    if this !=# last
      call add(uniqedList, item)
      let last = this
    endif
  endfor
  call setqflist(uniqedList)
endfunction
" this needs messue up the compliation
" autocmd! QuickfixCmdPost * call s:SortUniqQFList()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Autocmds Makefiles autocmd, kernel makefiles etc
""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has("autocmd")

    augroup vimscipt
        autocmd FileType vim setlocal tabstop=2 shiftwidth=2 softtabstop=2
    augroup END

    augroup plugin_commentary
        autocmd!
        autocmd FileType *conf-d setlocal commentstring=#\ %s
        autocmd FileType *config setlocal commentstring=#\ %s
        autocmd FileType go setlocal commentstring=//\ %s
        autocmd FileType c,cpp setlocal commentstring=//\ %s
        autocmd BufEnter *.conf setlocal commentstring=#\ %s
        autocmd FileType robot setlocal commentstring=Comment\ \ \ \ %s
        autocmd FileType cfg setlocal commentstring=#\ %s
        autocmd FileType fstab setlocal commentstring=#\ %s
        autocmd FileType gentoo-init-d setlocal commentstring=#\ %s
        autocmd FileType htmldjango setlocal commentstring={#\ %s\ #}
        autocmd FileType clojurescript setlocal commentstring=;\ %s
        autocmd FileType puppet setlocal commentstring=#\ %s
        autocmd FileType fish setlocal commentstring=#\ %s
        autocmd FileType tmux setlocal commentstring=#\ %s
        autocmd FileType gitconfig setlocal commentstring=#\ %s
    augroup END

    augroup Build
        autocmd!
        autocmd BufEnter *  call SetMakePrg()
    augroup END

    augroup Makefile
        autocmd!
        autocmd BufEnter  ?akefile*	set iskeyword+=-
        autocmd BufLeave  ?akefile*	set iskeyword-=-
        autocmd BufEnter  *.mk	    set iskeyword+=-
        autocmd BufLeave  *.mk	set iskeyword-=-
    augroup END

    augroup CodeFormatters
        autocmd!
        " autocmd  Filetype gentoo-init-d setlocal 
        " autocmd  BufReadPost,FileReadPost   *.py    :silent %!PythonTidy.py
        " autocmd  BufReadPost,FileReadPost   *.p[lm] :silent %!perltidy -q
        " autocmd  BufReadPost,FileReadPost   *.xml   :silent %!xmlpp -t -c -n
        " autocmd  BufReadPost,FileReadPost   *.[ch]  :silent %!indent
    augroup END

    augroup formating "FIXME:  %s/\ \+$//ge changes currsor possition
        autocmd!
        autocmd BufEnter *.tex   setlocal textwidth=80
        " autocmd BufWritePre *.c,*.cpp,*.h,*.hpp,*.py,*.vim,.vimrc  %s/\ \+$//ge
        autocmd FileType svn,gitcommit setlocal spell
        " disable autocomand for paste with comments
        " when pasting comments span across multiple lines
        autocmd FileType * setlocal formatoptions-=tcro
    augroup END

    augroup cpp
        autocmd!
        autocmd BufEnter  *.cpp,*.c,*.h,*.hpp	set completeopt-=preview
        autocmd BufLeave  *.cpp,*.c,*.h,*.hpp	set completeopt+=preview
        " autocmd BufEnter  *.cpp,*.c,*.h,*.hpp	set iskeyword+=:
        " autocmd BufLeave  *.cpp,*.c,*.h,*.hpp	set iskeyword-=:
    augroup END

    augroup quickfix
        autocmd!
        autocmd BufReadPost quickfix  set number
    augroup END

    augroup pythonAu
        autocmd!
        autocmd BufNewFile,BufRead *.py compiler nose
    augroup END

endif

""""""""""""""""""""""""""""""""""""""""""
" => ctags
""""""""""""""""""""""""""""""""""""""""""
"set tags+=~/.vim/tags/stl.tags

""""""""""""""""""""""""""""""""""""""""""
" => GO
""""""""""""""""""""""""""""""""""""""""""
augroup GoFormater
  autocmd FileType go setlocal makeprg=go\ run\ %
augroup END


""""""""""""""""""""""""""""""""""""""""""
" =>  GitGutter
""""""""""""""""""""""""""""""""""""""""""
hi SignColumn ctermbg=NONE

nnoremap <silent> gf :GitGutterPrevHunk<cr>
nnoremap <silent> gh :GitGutterNextHunk<cr>

""""""""""""""""""""""""""""""""""""""""""
" =>  Cammel case motion to the recue
""""""""""""""""""""""""""""""""""""""""""
" map <silent> w <Plug>CamelCaseMotion_w
" map <silent> b <Plug>CamelCaseMotion_b
" map <silent> e <Plug>CamelCaseMotion_e
" sunmap w
" sunmap b
" sunmap e

""""""""""""""""""""""""""""""""""""""""""
" =>  Avoid hit enter, for man and any other cmd
""""""""""""""""""""""""""""""""""""""""""
command! -nargs=1 Silent | execute ':silent !'.<q-args>
      \ | execute ':redraw!'

"FIXME: this have no support for diffenet manual pages
" nnoremap <silent> K :Silent man <C-R><C-W><cr>

""""""""""""""""""""""""""""""""""""""""""
" =>  abbreviation to the spelling rescue
""""""""""""""""""""""""""""""""""""""""""
" convenience
cabbrev b buffer
cabbrev E Explore
" spelling
iabbrev prevous previous
iabbrev prefxi prefix

iabbrev neccesary necessary
iabbrev acction action
iabbrev destyni destiny
iabbrev specyfiyng specifying
iabbrev soruce source
iabbrev veryfy verify
iabbrev veryfi verify
iabbrev vecotr vector

iabbrev timedout timed out
iabbrev timeouted timed out
iabbrev readed  read
iabbrev sended send
iabbrev succesfull  successful
"
"""""""""""""""""""""""""
" => Some Notes that I keep forgeting
"""""""""""""""""""""""""
":AlignCtrl W :<,>Align     Align some text not mater white spaces/words in front and in back


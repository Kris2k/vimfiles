""""""""""""""""""""""""""""""
" => Pathogen plugin
"""""""""""""""""""""""""""""""
source ~/.vim/bundle/pathogen/autoload/pathogen.vim
call pathogen#infect()
" add xpt templates personal folder to runtimepath
let &runtimepath .=',~/.vim/personal'

""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""
if v:lang =~ "utf8$" || v:lang =~ "UTF-8$"
   set fileencodings=ucs-bom,utf-8,latin1
   " polis settings for gui
   se enc=iso-8859-2
   se tenc=utf8
endif

syntax enable
filetype plugin indent on

set incsearch " very usefful for fast find 
set hlsearch 
set history=100

set relativenumber 
set softtabstop=4
set shiftwidth=4
set shiftround
set tabstop=4
set expandtab


"set modeline 
" disable autocomand for paste with comments
if has("autocmd") 
    autocmd FileType * setlocal formatoptions-=ro
    autocmd BufNewFile,BufRead *.py compiler nose 
endif

        
"""""""""""""""""""""""""
" => Files backups are off
"""""""""""""""""""""""""
set nobackup    "do not create backup file
set nowb        "no create backup when overwriting file
set noswapfile

set autoread    "auto read when a file is changed from outside
set hidden      "warn on exit with unsaved changes


" Set backspace config
set backspace=indent,eol,start
set whichwrap+=<,>,h,l
set linebreak

set ignorecase "Ignore case when searching
set smartcase

set laststatus=2         " commandline display and tab in cmdline
set wildchar=<Tab> wildmenu wildmode=full

set clipboard+=unnamed "  yanks go to system clipboard too and back on Focus
autocmd FocusGained * let @z=@+


"set timeoutlen=350 " Set a shorter timeout for jj motion
inoremap jk <Esc>
inoremap JK <Esc>
inoremap Jk <Esc>
inoremap jK <Esc>

" as well as I don't want to use esc key - i like using arrows to compleation
" and F9 in insert mode this mapping takes it all
"inoremap <Esc> <nop> "

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

""""""""""""""""""""""""""""""
" => mapleader
"""""""""""""""""""""""""""""""
let mapleader=','
let g:mapleader=','

nnoremap <leader>w :w!<cr>
let g:makeJobNumber='-j4'
let g:makeTarget=''

" paralel builds 
nnoremap <leader>m :execute "make ".makeJobNumber." ".makeTarget<cr>
"echo "make -j".makeJobNumber." ".makeTarget

" tests that call make  and commandT becaluse it bothers makegreen
nnoremap <unique> <silent> <Leader>t :call MakeGreen()<cr>
nnoremap <Leader>f :CommandT<CR>

" Quick fix list window
"nmap <leader>c :botright copen 5<cr>
nmap <silent> <leader>l :call ToggleList("Location List", 'l','5','no')<CR>
nmap <silent> <leader>c :call ToggleList("Quickfix List", 'c','5','no')<CR>

" Fast  command line history
nmap <leader>q q:

"fast buffer access 
noremap <leader>b :buff <Right>

nnoremap <silent> <leader>a :Ack <C-R><C-W><CR>
nnoremap <silent> <leader>g :grep <C-R><C-W> . <CR>

"Fast vimrc access
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <leader>et :vsplit $HOME/.tmux.conf<cr>
nnoremap <leader>es :vsplit $HOME/.screenrc<cr>
nnoremap <leader>ez :vsplit $HOME/.zshrc<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

" fast  no magic searching  
nnoremap <silent> <leader>v /\v<C-R><C-W><CR>

" fast openig files in current dir
if has("unix")
    map <leader>e :e <C-R>=expand("%:p:h") . "/" <CR>
else
    map <leader>e :e <C-R>=expand("%:p:h") . "\" <CR>
endif
""""""""""""""""""""""""""""""
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
noremap ;' :%s:::g<Left><Left><Left>

" Common typos and Minibuffer Explorer hack
command! W :w
command! Wq wqall
command! WQ wqall
command! Q qall


"""""""""""""""""""""""""""""""
" => Compleation mappings insert mode
""""""""""""""""""""""""""""""""
inoremap <c-p> <c-x><c-p>
inoremap <c-f> <c-x><c-f>
inoremap <c-]> <c-x><c-]>

" jumps remeber remeber '' is great 
noremap gI `.

" use arrows for something usefull
"nnoremap <left>  :lnext<cr>zvzz
"nnoremap <right> :lprev<cr>zvzz
nnoremap <left>  :colder<cr>zvzz
nnoremap <right> :cnewer<cr>zvzz
nnoremap <up>    :cprev<cr>zvzz
nnoremap <down>  :cnext<cr>zvzz

" Select (charwise) the contents of the current line, excluding indentation.
" Great for pasting Python lines into REPLs.
nnoremap vv ^vg_

""""""""""""""""""""""""""""""
" => Fn  Shortcuts and others
"""""""""""""""""""""""""""""""
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


nnoremap <F1>  :ZoomWin<CR>
noremap  <F2> :set ignorecase! noignorecase?<CR>
noremap  <F3> :set hlsearch! hlsearch?<CR>
noremap  <F4> :call NumberInv()<CR>
noremap  <F5> :setlocal spell! spell?<CR>
let g:qb_hotkey = "<F6>"
" copy by F7
vnoremap <F7> "+ygv"zy`>
""paste (Shift-F7 to paste after normal cursor, Ctrl-F7 to paste over visual selection)
nnoremap <F7> "zgP
nnoremap <S-F7> "zgp
inoremap <F7> <C-r><C-o>z
vnoremap <C-F7> "zp`]
cnoremap <F7> <C-r><C-o>z
noremap  <F8> :TMiniBufExplorer <CR>
set pastetoggle=<F9>
" buffer switching
nnoremap <silent> <C-h> :bprevious<CR>
nnoremap <silent> <C-l> :bnext<CR>


""""""""""""""""""""""""""""""
" => grep in vim
"""""""""""""""""""""""""""""""
" -I ignore binary files -Hn is for printing file name and line number
set grepprg=grep\ -Hn\ -I\ --exclude-dir='.svn'\ --exclude-dir='.git'\ --exclude='tags*'\ --exclude='cscope.*'\ -r 


""""""""""""""""""""""""""""""
" => Custom Commands
"""""""""""""""""""""""""""""""

" Strip end of lines  can be done autocomand
command!  Strip  :%s/\s\+$//e

" generate Ctags cscope database for C,C++ files
command! CtagCscopeRegen exe '! find . -regex  ".*\.\(c\|cc\|cpp\|h\|hpp\)$"  -print > cscope.files && cscope -bq && ctags --c++-kinds=-p --fields=+iaS --extra=q --sort=foldcase -L cscope.files '

map <C-F12> :CtagCscopeRegen<CR>


""""""""""""""""""""""""""""""
" => Minibuffer plugin
"""""""""""""""""""""""""""""""
let g:miniBufExplorerMoreThanOne = 2
let g:miniBufExplTabWrap         = 1
" hack for sourcing again the vimrc and setting coulorsheme
if exists("g:did_minibufexplorer_syntax_inits")
    unlet g:did_minibufexplorer_syntax_inits 
endif
""""""""""""""""""""""""""""""
" => SuperTab plugin
"""""""""""""""""""""""""""""""
let g:SuperTabDefaultCompletionType        = "context"
let g:SuperTabContextDefaultCompletionType = "<c-p>"
let g:SuperTabCompletionContexts           = ['s:ContextText', 's:ContextDiscover']
let g:SuperTabContextTextOmniPrecedence    = [ '&completefunc', '&omnifunc']
let g:SuperTabContextDiscoverDiscovery     = ["&completefunc:<c-x><c-u>", "&omnifunc:<c-x><c-o>"]

""""""""""""""""""""""""""""""
" => xptemplate plugin
"""""""""""""""""""""""""""""""
" xpt supertab avoid key conflict
let g:SuperTabMappingForward              = '<Plug>supertabKey'
" if nothing matched in xpt, try supertab
let g:xptemplate_fallback                 = '<Plug>supertabKey'
let g:xptemplate_key                      = '<Tab>'
let g:xptemplate_vars                     = "Rloop              = \n&SPcmd = "
let g:xptemplate_brace_complete           = ''
"let g:xptemplate_brace_complete = '([{'
let g:xptemplate_bundle                   = 'cpp_autoimplem'
" xpt triggers only when you typed whole name of a snippet. Optional
"let g:xptemplate_minimal_prefix = 'full'
let g:xptemplate_vars = "author=Krzysztof (Chris) Kanas&email=krzysztof.kanas@__at__@gmail.com&kelvatek_author=Krzysztof (Chris) Kanas&kelvatek_email=k.kanas@__at__@kelvatek.com&..."

""""""""""""""""""""""""""""""
" => rainbow_parenthsis plugin
"""""""""""""""""""""""""""""""
if exists("g:btm_rainbow_color") && g:btm_rainbow_color
    call rainbow_parenthsis#LoadSquare ( )
    call rainbow_parenthsis#LoadRound  ( )
    call rainbow_parenthsis#Activate   ( )
endif

"""""""""""""""""""""""""
" => Tlist plugin
"""""""""""""""""""""""""
let Tlist_Use_Right_Window = 1

"""""""""""""""""""""""""
" => command-t plugin
"""""""""""""""""""""""""
set wildignore+=*.html,*.o,*.obj,.git,.svn "for command-t ignore objects

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
" => pyflakes and python
"""""""""""""""""""""""""
let g:pyflakes_use_quickfix = 1
autocmd FileType python set omnifunc=pythoncomplete#Complete

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

"""""""""""""""""""""""""
" => Ack  settings to disable html
"""""""""""""""""""""""""
let g:ackprg="ack -H --nocolor --nogroup --column --nohtml"

"""""""""""""""""""""""""
" => Autocmds Makefiles autocmd, kernel makefiles etc
"""""""""""""""""""""""""
autocmd BufEnter  ?akefile*	set iskeyword+=-
autocmd BufLeave  ?akefile*	set iskeyword-=-
autocmd BufEnter  *.mk	    set iskeyword+=-
autocmd BufLeave  *.mk	set iskeyword-=-

autocmd BufEnter  *.cpp,*.c,*.h,*.hpp	set completeopt-=preview
autocmd BufLeave  *.cpp,*.c,*.h,*.hpp	set completeopt+=preview
autocmd BufReadPost quickfix  set number

"set tags+=~/.vim/tags/stl.tags

colorscheme kchrisk

" small function to make background not transparetn
function! InvertBblackBackground()
    if ! exists("g:kchrisk_black_background")
        let g:kchrisk_black_background = 0
    endif
    "if revrite minibuffer explorer  !exists("g:did_minibufexplorer_syntax_inits")
    " so the colors are retainged
    if g:kchrisk_black_background
        let g:kchrisk_black_background = 0 
        colorscheme kchrisk 
    elseif  ! g:kchrisk_black_background
        let g:kchrisk_black_background = 1 
        colorscheme kchrisk 
    endif
endfunction 
command! BlackInvert call InvertBblackBackground()

set term=xterm-256color
set t_Co=256

"""""""""""""""""""""""""
" =>  abreviation to the spelling resuce
"""""""""""""""""""""""""
iabbrev prevous previous
iabbrev prefxi prefix

"""""""""""""""""""""""""
" => Some Notes that I keep forgeting 
"""""""""""""""""""""""""
":AlignCtrl W :<,>Align     Align some text not mater white spaces/words in front and in back

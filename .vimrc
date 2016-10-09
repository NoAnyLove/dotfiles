" vim:fdm=marker
" General Settings {{{"
set nocompatible
syntax on
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set cindent
set number
set autoindent
set ignorecase
set smartcase
set infercase
set ruler
set laststatus=2
"set nowrap
" enable instant search
set incsearch
" enable vim command-line completion
set wildmenu

" automatically reload .vimrc when it saving
autocmd BufWritePost $MYVIMRC source $MYVIMRC

" enable fold
set foldmethod=syntax
set nofoldenable

" enable mouse support
set mouse=a
set ttymouse=xterm2
behave xterm
set selectmode=mouse

" enable filetype
filetype on
filetype indent on
filetype plugin on

" disable expandtab for Makefile
autocmd FileType make setlocal noexpandtab

" set utf-8 encoding
if has("multi_byte")
  if &termencoding == ""
    let &termencoding = &encoding
  endif
  set encoding=utf-8
  setglobal fileencoding=utf-8
  "setglobal bomb
  set fileencodings=ucs-bom,utf-8,cp936,euc-cn,latin1
endif

" set filename completion case insensitive
if exists("&wildignorecase")
  set wildignorecase
endif

" GUI settings
if has("gui_running")
  if has('gui_win32')
    set guifont=Fantasque_Sans_Mono:h16
  else
    set guifont=Fantasque\ Sans\ Mono\ 16
  endif
  " disable blink
  set gcr=a:block-blinkon0
  " remove scroll bar
  set guioptions-=l
  set guioptions-=L
  set guioptions-=r
  set guioptions-=R
  " remove menu bar and toolbar
  set guioptions-=m
  set guioptions-=T
endif

if has("persistent_undo")
    set undodir=~/.vim/.undo_history/
    set undofile
endif

" jump to the last position when reopening a file
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" }}}

" normal shortcuts {{{
" loacate to the begin/end of a line
nmap LB 0
nmap LE $

" split navigations (Optional)
"nnoremap <C-J> <C-W><C-J>
"nnoremap <C-K> <C-W><C-K>
"nnoremap <C-L> <C-W><C-L>
"nnoremap <C-H> <C-W><C-H>

" traverse window
nnoremap nw <C-W><C-W>

" quick movements in Insert-Mode
inoremap II <Esc>I
inoremap AA <Esc>A
inoremap OO <Esc>o

" mimic Eclipse Shift+Enter, but only works with vim GUI
inoremap <S-CR> <Esc>o

" allow saving file as sudo when forgot to start vim using sudo
cmap w!! w !sudo tee > /dev/null %
" }}}

" Leader shortcuts {{{
let mapleader = "\<Space>"

" save file
nnoremap <Leader>w :w<CR>
" copy to system clipboard
vnoremap <Leader>y "+y
" paste from system clipboard
nmap <Leader>p "+p
nmap <Leader>P "+P

" quickly jump to window
nnoremap <Leader>hw <C-W>h
nnoremap <Leader>jw <C-W>j
nnoremap <Leader>kw <C-W>k
nnoremap <Leader>lw <C-W>l

" jump between matchings
"nmap <Leader>m %
nmap <Leader>M %

" toggle invisible character
" note: space option is available after 7.4.711
if has("patch-7.4.711")
  set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<,space:␣
else
  set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<
endif
nmap <Leader>la :set list!<CR>

" toggle paste mode (this setting may cause incorrectly paste)
"set pastetoggle=<leader>p

" }}}

" Setting vim-plugin {{{
" Pre-defined {{{
" install Vim-Plug if it's not installed
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
                \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

function! BuildYCM(info)
  " info is a dictionary with 3 fields
  " - name:   name of the plugin
  " - status: 'installed', 'updated', or 'unchanged'
  " - force:  set on PlugInstall! or PlugUpdate!
  if a:info.status == 'installed' || a:info.force
    "!./install.py
    !./install.py --clang-completer
  endif
endfunction

" }}}

call plug#begin('~/.vim/plugged')

" Navigation enhancement {{{
Plug 'ctrlpvim/ctrlp.vim'
Plug 'majutsushi/tagbar'
Plug 'easymotion/vim-easymotion'
Plug 'dkprice/vim-easygrep'
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'Shougo/unite.vim' | Plug 'Shougo/vimproc.vim', {'do' : 'make'} | Plug 'Shougo/neomru.vim'
" }}}

" UI enhancement {{{
Plug 'nathanaelkane/vim-indent-guides'
Plug 'kshenoy/vim-signature'
Plug 'bling/vim-airline'
Plug 'edkolev/tmuxline.vim'
Plug 'mhinz/vim-startify'
" }}}

" Code Completion enhancement {{{
"Plug 'Rip-Rip/clang_complete'
"Plug 'ervandew/supertab'
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
"Plug 'Valloric/YouCompleteMe', { 'do': function('BuildYCM') }
Plug 'oblitum/YouCompleteMe', { 'do': function('BuildYCM') }
Plug 'Valloric/ListToggle'
" }}}

" Edit enhancement {{{
Plug 'scrooloose/nerdcommenter'
Plug 'terryma/vim-multiple-cursors'
Plug 'tommcdo/vim-exchange'
Plug 'tpope/vim-surround'
Plug 'sjl/gundo.vim'
"Plug 'vim-scripts/Auto-Pairs'
Plug 'Chiel92/vim-autoformat'
Plug 'tpope/vim-unimpaired'
" }}}

" Misc {{{
Plug 'fholgado/minibufexpl.vim'
Plug 'vim-utils/vim-man'
Plug 'derekwyatt/vim-fswitch'
" }}}

" taskwiki {{{
Plug 'vimwiki/vimwiki', { 'branch': 'dev' }
Plug 'tbabej/taskwiki', { 'for': 'vimwiki' }
Plug 'blindFS/vim-taskwarrior', { 'for': 'vimwiki' }
Plug 'powerman/vim-plugin-AnsiEsc', { 'for': 'vimwiki' }
" }}}

" Python {{{
Plug 'davidhalter/jedi-vim', { 'for': 'python'}
Plug 'klen/python-mode', { 'for': 'python'}
" }}}

" Color theme {{{
Plug 'tomasr/molokai'
Plug 'jnurmine/Zenburn'
Plug 'chriskempson/base16-vim'
Plug 'sheerun/vim-wombat-scheme'
" }}}

Plug 'ryanoasis/vim-devicons'

call plug#end()

"source $VIMRUNTIME/ftplugin/man.vim

" }}}

" Plugin Settings {{{

" ctrlp.vim {{{
" use Mixed mode as default Ctrl-P, which search files, buffers and MRU files at the same time
let g:ctrlp_cmd = 'CtrlPMixed'
" }}}

" Tagbar Settings {{{
nmap <F8> :TagbarToggle<CR>
" }}}

" EasyMotion Settings {{{
let g:EasyMotion_smartcase = 1

nmap <Leader>s <Plug>(easymotion-s2)
nmap <Leader>t <Plug>(easymotion-t2)
nmap <Leader>f <Plug>(easymotion-f2)

map <Leader>/ <Plug>(easymotion-sn)
"map / <Plug>(easymotion-sn)

map <Leader>n <Plug>(easymotion-next)
map <Leader>N <Plug>(easymotion-prev)
"map  n <Plug>(easymotion-next)
"map  N <Plug>(easymotion-prev)
" }}}

" NERDTree Settings {{{
map <F10> :NERDTreeToggle<CR>
" }}}

" Unite Settings {{{
nnoremap <Leader>uf :Unite -start-insert file_mru file_rec/async<CR>
" }}}

" vim-indent-guides {{{
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1
:nmap <silent> <Leader>i <Plug>IndentGuidesToggle
" }}}

" vim-airline {{{
" use dark theme
let g:airline_theme = 'dark'
" ensure vim-airline always visible
set laststatus=2
let g:airline_powerline_fonts=1
" using symbols as seperator
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
" powerline symbols
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''
" }}}

" vim-airline {{{
let g:tmuxline_preset = {
      \'a'    : '#H',
      \'b'    : '#S',
      \'win'  : ['#I', '#W'],
      \'cwin' : ['#I', '#W', '#F'],
      \'y'    : ['%F', '%R', '%a'],
      \'z'    : ['#(whoami)', '#(uptime | cut -d " " -f 1,2,3)']}
" }}}

" vim-startify {{{
let g:startify_list_order = ['sessions', 'files', 'dir', 'bookmarks',
        \ 'commands']
" }}}

" clang_complete {{{
set pumheight=10
set completeopt=menu,longest
let g:clang_complete_auto=0
"let g:clang_library_path='/usr/lib/llvm-3.8/lib/libclang.so.1'
let g:clang_library_path='/usr/bin/cygclang-3.8.dll'
let g:clang_snippets=1
let g:clang_snippets_engine='ultisnips'
let g:clang_auto_select=2
" }}}

" Supertab Settings {{{
let g:SuperTabDefaultCompletionType='context'
let g:SuperTabCompletionContexts = ['s:ContextText', 's:ContextDiscover']
"let g:SuperTabContextTextOmniPrecedence = ['&completefunc', '&omnifunc']
let g:SuperTabContextDiscoverDiscovery =
    \ ["&completefunc:<c-x><c-u>", "&omnifunc:<c-x><c-o>"]
" }}}

" UltiSnips Settings {{{
" use Ctrl-e to expand abbreviation
let g:UltiSnipsExpandTrigger="<c-e>"
" jump to next placeholder
let g:UltiSnipsJumpForwardTrigger="<c-j>"
" jump to previous placeholder
let g:UltiSnipsJumpBackwardTrigger="<c-k>"
" }}}

" YouCompleteMe Settings {{{
let g:ycm_seed_identifiers_with_syntax = 1
let g:ycm_always_populate_location_list = 1

" YCM command shortcut
nnoremap <leader>fc :YcmForceCompileAndDiagnostics<CR>
nnoremap <leader>gc :YcmCompleter GoToDeclaration<CR>
nnoremap <leader>gf :YcmCompleter GoToDefinition<CR>
nnoremap <leader>gi :YcmCompleter GoToInclude<CR>
nnoremap <leader>gg :YcmCompleter GoTo<CR>
nnoremap <leader>gd :YcmCompleter GetDoc<CR>

" make jedi-vim compatible with YCM
let g:jedi#auto_initialization = 1
let g:jedi#completions_enabled = 0
let g:jedi#auto_vim_configuration = 0
let g:jedi#smart_auto_mappings = 0
let g:jedi#popup_on_dot = 0
let g:jedi#completions_command = ""
let g:jedi#show_call_signatures = "1"
let g:jedi#show_call_signatures_delay = 0
" }}}

" ListToggle Settings {{{
let g:lt_location_list_toggle_map = '<Leader>ll'
let g:lt_quickfix_list_toggle_map = '<Leader>q'
let g:lt_height = 5
" }}}

" NerdCommenter Settings {{{
let g:NERDSpaceDelims = 1
let g:NERDCompactSexyComs = 1
let g:NERDDefaultAlign = 'left'
" }}}

" Gundo Settings {{{
nnoremap <F9> :GundoToggle<CR>
let g:gundo_prefer_python3 = 1
" }}}

" vim-autoformat {{{
nmap <Leader>f :Autoformat<CR>
let g:formatters_python = ['yapf']
let g:formatter_yapf_style = 'pep8'
" }}}

" MiniBufExpl Settings {{{
" next buffer, cycle switch buffers
noremap <Leader>nb :bn<CR>
noremap <Leader>pb :bp<CR>
" close current buffer without close window (not work correctly with Vim 7.4.942)
"noremap <Leader>bc :MBEbd<CR>
nmap <Leader>db :bdelete<CR>
" }}}

" vim-fswitch Settings {{{
nmap <silent> <Leader>sw :FSHere<cr>
" }}}

" taskwiki Settings {{{
let g:taskwiki_sort_order='depends+,due+'
let g:vimwiki_folding='expr'
" }}}

" python-mode Settings {{{
let g:pymode_rope = 0
let g:pymode_rope_completion = 0
let g:pymode_doc = 0
let g:pymode_folding = 0
" }}}

" base16-vim Settings {{{
let g:base16_shell_path='$HOME/.zgen/NoAnyLove/base16-shell-master/scripts'
let base16colorspace=256
colorscheme base16-default-dark
" }}}

" }}}

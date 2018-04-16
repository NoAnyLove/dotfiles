" vim:fdm=marker sw=2

" General Settings {{{
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
  set nowrap
  set autochdir

  " enable instant search
  set incsearch
  " enable vim command-line completion
  set wildmenu

  " enable fold
  set foldmethod=syntax
  set nofoldenable

  " enable mouse support
  set mouse=a
  if !has('nvim')
    set ttymouse=xterm2
  endif
  behave xterm
  set selectmode=mouse

  " (optional) always use the system clipboard for all operations
  "set clipboard+=unnamedplus

  " enable filetype
  filetype on
  filetype indent on
  filetype plugin on

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
  set wildignorecase

  " GUI setting for gvim
  if !has('nvim') && has("gui_running")
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
      if !has('nvim')
          set undodir=~/.vim/.undo_history/
      endif
      set undofile
  endif

  " jump to the last position when reopening a file
  if has("autocmd")
    au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
  endif

  " automatically reload .vimrc when it saving
  autocmd BufWritePost $MYVIMRC source $MYVIMRC

  " disable expandtab for Makefile
  autocmd FileType make setlocal noexpandtab

" General Settings END }}}

" Shortcuts {{{

  " Set Leader key
  let mapleader = "\<Space>"

  " Tabs {{{

    " create new Tab
    nnoremap <C-t> :tabnew<CR>
    inoremap <C-t> <Esc>:tabnew<CR>

    " traverse Tabs
    nnoremap <Leader>nt :tabnext<CR>
    nnoremap <Leader>pt :tabprev<CR>
    nnoremap <Leader>dt :tabclose<CR>
  " Tabs END }}}

  " Windows {{{
    " traverse window
    nnoremap nw <C-W><C-W>

    " quickly jump to window
    nnoremap <Leader>hw <C-W>h
    nnoremap <Leader>jw <C-W>j
    nnoremap <Leader>kw <C-W>k
    nnoremap <Leader>lw <C-W>l

    " split window navigations (Optional)
    "nnoremap <C-J> <C-W><C-J>
    "nnoremap <C-K> <C-W><C-K>
    "nnoremap <C-L> <C-W><C-L>
    "nnoremap <C-H> <C-W><C-H>

  " Windows END }}}

  " Buffers {{{
    " traverse buffers
    noremap <Leader>nb :bn<CR>
    noremap <Leader>pb :bp<CR>
    nmap <Leader>db :bdelete<CR>
    " force delete buffer even it's not saved
    "nmap <Leader>ddb :bdelete!<CR>

  " Buffers END }}}

  " Move {{{
    " loacate to the begin/end of a line
    nmap LB 0
    nmap LE $

    " quick movements in Insert-Mode
    inoremap II <Esc>I
    inoremap AA <Esc>A
    inoremap OO <Esc>o

    " jump between matchings
    nnoremap <Leader>M %
  " Move END }}}

  " Edit {{{

    " copy to system clipboard
    vnoremap <Leader>y "+y

    " paste from system clipboard
    nnoremap <Leader>p "+p
    vnoremap <Leader>p "+p
    nnoremap <Leader>P "+P
    vnoremap <Leader>P "+P

    " mimic Eclipse Shift+Enter, but only works with vim GUI
    inoremap <S-CR> <Esc>o

    " enable <Shift-Insert> shortcut in gui mode
    map! <S-Insert> <C-R>+

    " toggle paste mode (this setting may cause incorrectly paste)
    "set pastetoggle=<leader>p

  " Edit END }}}

  " Misc {{{
    " save file
    nnoremap <Leader>w :w<CR>

    " allow saving file as sudo when forgot to start vim using sudo
    cmap w!! w !sudo tee > /dev/null %

    " toggle invisible character
    " note: space option is available after 7.4.711
    if has("patch-7.4.711")
      set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<,space:␣
    else
      set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<
    endif
    nmap <Leader>la :set list!<CR>
  " Misc END }}}

" Shortcuts END }}}

" Load plugin {{{

  " pre-defined {{{
    " install vim-plug if it's not installed
    let path = {}
    if has('nvim')
      if has('win32')
        let path['plug.vim'] = '~\appdata\local\nvim\autoload\plug.vim'
        let path['plugged'] = '~\appdata\local\nvim\plugged'
      else
        let path['plug.vim'] = '~/.local/share/nvim/site/autoload/plug.vim'
        let path['plugged'] = '~/.local/share/nvim/plugged'
      endif
    else
      if has('win32')
        let path['plug.vim'] = '~\vimfiles\autoload\plug.vim'
        let path['plugged'] = '~\vimfiles\plugged'
      else
        let path['plug.vim'] = '~/.vim/autoload/plug.vim'
        let path['plugged'] = '~/.vim/plugged'
      endif
    endif

    let path['plug.vim'] = expand(path['plug.vim'])
    let path['plugged'] = expand(path['plugged'])

    if empty(glob(path['plug.vim']))
      execute 'silent !curl -flo ' . path['plug.vim'] . ' --create-dirs ' .
          \ 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
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

  " pre-defined END }}}

  " Vim-plug begin
  call plug#begin(path['plugged'])

  " Navigation enhancement {{{
    Plug 'ctrlpvim/ctrlp.vim'
    Plug 'majutsushi/tagbar'
    Plug 'easymotion/vim-easymotion'
    Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
    Plug 'Xuyuanp/nerdtree-git-plugin', { 'on': 'NERDTreeToggle' }
    "Plug 'Shougo/unite.vim' | Plug 'Shougo/vimproc.vim', {'do' : 'make'} | Plug 'Shougo/neomru.vim'
    Plug 'Shougo/denite.nvim', { 'do': ':UpdateRemotePlugins' } | Plug 'Shougo/neomru.vim'
  " }}}

  " UI enhancement {{{
    "Plug 'nathanaelkane/vim-indent-guides'
    Plug 'Yggdroot/indentLine'
    Plug 'kshenoy/vim-signature'
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'edkolev/tmuxline.vim'
    Plug 'mhinz/vim-startify'
  " }}}

  " Code Completion enhancement {{{
    "Plug 'Rip-Rip/clang_complete'
    "Plug 'ervandew/supertab'
    Plug 'Sirver/ultisnips' | Plug 'honza/vim-snippets'
    "Plug 'Valloric/YouCompleteMe', { 'do': function('BuildYCM') }
    Plug 'Valloric/ListToggle'
    Plug 'roxma/nvim-completion-manager'
    " This is a refactored version of clang_complete for better integration with
    " nvim-completion-manager
    Plug 'roxma/clang_complete'
    " choose one of syntastic and ale
    "Plug 'vim-syntastic/syntastic'
    Plug 'w0rp/ale'
    "Plug 'autozimu/LanguageClient-neovim', { 'do': ':UpdateRemotePlugins' }
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
    "Plug 'dkprice/vim-easygrep'
    "Plug 'mhinz/vim-grepper'
    "Plug 'brooth/far.vim'
    Plug 'dyng/ctrlsf.vim'
    Plug 'editorconfig/editorconfig-vim'
    Plug 'michaeljsmith/vim-indent-object'
  " }}}

  " Misc {{{
    "Plug 'fholgado/minibufexpl.vim'
    "Plug 'vim-utils/vim-man'
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
    Plug 'chriskempson/base16-vim'
  " }}}

  " Last load {{{
    " vim-devicons must be loaded last to support other plugins
    Plug 'ryanoasis/vim-devicons'
  " }}}

  call plug#end()

" Load plugin END }}}

" Plugin Settings {{{

  " Navigation enhancement {{{

    " ctrlp.vim {{{
      " use Mixed mode as default Ctrl-P, which search files, buffers and MRU files at the same time
      let g:ctrlp_cmd = 'CtrlPMixed'

      " use external scanner rg or ag to speed up indexing
      let g:user_command_async = 1
      if executable('rg')
        let g:ctrlp_user_command = 'rg --files -F --color never --hidden --follow --glob "!.git/*" %s'
      elseif executable('ag')
        let g:ctrlp_user_command = 'ag %s -l --nocolor --nogroup --hidden --ignore .git -g ""'
      endif
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

    " Denite Settings {{{
      nnoremap <Leader>uf :Denite file_mru file_rec<cr>
      nnoremap <Leader>ub :Denite buffer<cr>
      nnoremap <Leader>ul :Denite line<cr>
      nnoremap <Leader>uc :Denite colorscheme<cr>
    " }}}

  " }}}

  " UI enhancement {{{

    " vim-indent-guides Settings {{{
      let g:indent_guides_enable_on_vim_startup = 1
      let g:indent_guides_start_level = 2
      let g:indent_guides_guide_size = 1
      "nmap <silent> <Leader>i <Plug>IndentGuidesToggle
    " }}}

    " indentLine Settings {{{
      " candidates: ¦, ┆, │, ⎸, ▏
      let g:indentLine_char = '▏'
      nmap <silent> <Leader>i :IndentLinesToggle<cr>
    " }}}

    " vim-airline Settings {{{

      " ensure vim-airline always visible
      set laststatus=2

      let g:airline_powerline_fonts = 1
      let g:airline_theme = 'base16_default'


      " " customize powerline symbols as seperator
      " if !exists('g:airline_symbols')
      "   let g:airline_symbols = {}
      " endif
      " " powerline symbols
      " let g:airline_left_sep = ''
      " let g:airline_left_alt_sep = ''
      " let g:airline_right_sep = ''
      " let g:airline_right_alt_sep = ''
      " let g:airline_symbols.branch = ''
      " let g:airline_symbols.readonly = ''
      " let g:airline_symbols.linenr = ''

    " }}}

    " tmuxline.vim {{{
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
      let g:startify_files_number = 20
    " }}}

  " }}}

  " Code Completion enhancement {{{

    " clang_complete {{{
      set pumheight=10
      set completeopt=menu,longest
      let g:clang_complete_auto=0
      let g:clang_snippets=1
      let g:clang_snippets_engine='ultisnips'
      let g:clang_auto_select=2

      " Set g:clang_library_path to your local libclang dynamic library path
      " in local.vim. For examples,
      "let g:clang_library_path='/usr/lib/llvm-4.0/lib/libclang.so.1'
      "let g:clang_library_path='/usr/bin/cygclang-4.0.dll'
      "let g:clang_library_path='C:\LLVM\bin\libclang.dll'
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
      " let g:ycm_seed_identifiers_with_syntax = 1
      " let g:ycm_always_populate_location_list = 1

      " " YCM command shortcut
      " nnoremap <leader>fc :YcmForceCompileAndDiagnostics<CR>
      " nnoremap <leader>gc :YcmCompleter GoToDeclaration<CR>
      " nnoremap <leader>gf :YcmCompleter GoToDefinition<CR>
      " nnoremap <leader>gi :YcmCompleter GoToInclude<CR>
      " nnoremap <leader>gg :YcmCompleter GoTo<CR>
      " nnoremap <leader>gd :YcmCompleter GetDoc<CR>

    " }}}

    " ListToggle Settings {{{
      let g:lt_location_list_toggle_map = '<Leader>l'
      let g:lt_quickfix_list_toggle_map = '<Leader>q'
      let g:lt_height = 5
    " }}}

    " nvim-completion-manager {{{
      " use <TAB> to select the popup menu
      inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
      inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

      " use <Enter> to select the only candidates
      "inoremap <expr> <CR> (pumvisible() ? "\<c-n>\<cr>" : "\<CR>")
    " }}}

    " Syntastic Settings {{{
      "set statusline+=%#warningmsg#
      "set statusline+=%{SyntasticStatuslineFlag()}
      "set statusline+=%*

      let g:syntastic_always_populate_loc_list = 1
      let g:syntastic_auto_loc_list = 1
      let g:syntastic_check_on_open = 1
      let g:syntastic_check_on_wq = 0

      " set the height of location list
      let g:syntastic_loc_list_height = 3

      let g:syntastic_python_checkers = ['python', 'flake8']
      let g:syntastic_python_python_exec = "python3"

    " }}}

    " ale Settings {{{
      let g:ale_linters = {
      \   'python': ['flake8'],
      \}

      let g:ale_set_highlights = 0
      let g:ale_set_loclist = 1
      let g:ale_list_window_size = 3
      let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
      " automatically open location/quickfix list
      let g:ale_open_list = 1
      " keep location/quickfix list open
      "let g:ale_keep_list_window_open = 1

      " do not check files when input text, it's quite noisy
      let g:ale_lint_on_text_changed = 'never'
      " check when leave insert mode is more reasonable
      let g:ale_lint_on_insert_leave = 1

      " Set this. Airline will handle the rest.
      "let g:airline#extensions#ale#enabled = 1
    " }}}

    " LanguageClient-neovim {{{
      " " Required for operations modifying multiple buffers like rename.
      " set hidden

      " let g:LanguageClient_serverCommands = {
      "     \ 'python': ['pyls'],
      "     \ }

      " " Automatically start language servers.
      " let g:LanguageClient_autoStart = 1

      " nnoremap <silent> K :call LanguageClient_textDocument_hover()<CR>
      " nnoremap <silent> gd :call LanguageClient_textDocument_definition()<CR>
      " nnoremap <silent> <F2> :call LanguageClient_textDocument_rename()<CR>
    " }}}

  " }}}

  " Edit enhancement {{{

    " NerdCommenter Settings {{{
      let g:NERDSpaceDelims = 1
      let g:NERDCompactSexyComs = 1
      let g:NERDDefaultAlign = 'left'
    " }}}

    " vim-multiple-cursors Settings {{{
      " turn search results into cursors with Alt-j
      nnoremap <silent> <M-j> :MultipleCursorsFind <C-R>/<CR>
      vnoremap <silent> <M-j> :MultipleCursorsFind <C-R>/<CR>
    " }}}

    " Gundo Settings {{{
      nnoremap <F9> :GundoToggle<CR>
      let g:gundo_prefer_python3 = 1
    " }}}

    " vim-autoformat {{{
    "
      " if formatter is not in PATH, add following settings in local.vim
      "let g:formatterpath = ['/some/path/to/a/folder', '/home/superman/formatters']

      nmap <Leader>f :Autoformat<CR>

      " use autopep8 to format Python code
      "let g:formatters_python = ['autopep8']

      " use yapf to format Python code
      let g:formatters_python = ['yapf']
      let g:formatter_yapf_style = 'pep8'

      " for debugging use
      "let g:autoformat_verbosemode = 1
    " }}}

    " vim-grepper Settings {{{
      nmap gs <Plug>(GrepperOperator)
      xmap gs <Plug>(GrepperOperator)

      let g:grepper               = {}
      let g:grepper.next_tool     = '<Leader>g'
    " }}}

    " far.vim ettings {{{
      let g:far#window_width = max([80, winwidth(0) / 2])
    " }}}

    " ctrlsf.vim ettings {{{
        " ctrlsf.vim ettings {{{
        " input :CtrlSF in command line
        nmap     <Leader>ff <Plug>CtrlSFPrompt
        " input :CtrlSF + current visual selected word
        vmap     <Leader>ff <Plug>CtrlSFVwordPath
        " execute :CtrlSF + current visual selected wordimmediately
        vmap     <Leader>fF <Plug>CtrlSFVwordExec
        " input :CtrlSF + word in the cursor
        nmap     <Leader>fn <Plug>CtrlSFCwordPath
        " input :CtrlSF + last search pattern
        nmap     <Leader>fp <Plug>CtrlSFPwordPath
        " reopen CtrlSF windows if it is closed, or focus it if is not closed
        nnoremap <Leader>fo :CtrlSFOpen<CR>
        " open/close CtrlSF window
        nnoremap <Leader>ft :CtrlSFToggle<CR>
        " this mapping affects input, so we don't use it
        "inoremap <Leader>ft <Esc>:CtrlSFToggle<CR>
    " }}}

  " }}}

  " Misc {{{

    " MiniBufExpl Settings {{{
      " next buffer, cycle switch buffers
    " }}}

    " vim-fswitch Settings {{{
      nmap <silent> <Leader>sw :FSHere<cr>
    " }}}

  " }}}

  " taskwiki {{{

    " taskwiki Settings {{{
      let g:taskwiki_sort_order='depends+,due+'
      let g:vimwiki_folding='expr'
    " }}}

  " }}}

  " Python {{{

    " jedi-vim {{{
      " only use the show document and go to definition
      let g:jedi#auto_initialization = 1
      let g:jedi#completions_enabled = 0
      let g:jedi#auto_vim_configuration = 0
      let g:jedi#popup_on_dot = 0
      let g:jedi#force_py_version = 3
      "let g:jedi#show_call_signatures = 1
      "let g:jedi#show_call_signatures_delay = 0

      " shortcuts
      let g:jedi#goto_command = "<leader>g"
      let g:jedi#goto_assignments_command = "ga"
      let g:jedi#goto_definitions_command = "gd"
      let g:jedi#documentation_command = "K"
      let g:jedi#usages_command = "gu"
      let g:jedi#completions_command = "<C-Space>"
      let g:jedi#rename_command = "<leader>r"
    " }}}

    " python-mode Settings {{{
      let g:pymode_rope = 0
      let g:pymode_rope_completion = 0
      let g:pymode_doc = 0
      let g:pymode_folding = 1
      let g:pymode_run = 0
      let g:pymode_lint = 0
      "let g:pymode_doc_bind = 'K'
      "let g:pymode_rope_goto_definition_bind = "<C-]>"
      let g:pymode_python = 'python3'

      " set the maximum line length to 79. This opion will affect vim-autoformat
      "let g:pymode_options_max_line_length = 79
    " }}}

  " }}}

  " Color theme {{{

    " base16-vim Settings {{{
      let g:base16_shell_path='$HOME/.zgen/chriskempson/base16-shell-master/scripts'
      let base16colorspace=256
      " avoid E185 error when base16-vim is not installed
      try
        colorscheme base16-default-dark
      catch
        colorscheme desert
      endtry
    " }}}

  " }}}

" Plugin Settings END }}}

" Local customization {{{

  " source localized configuration
  if has('nvim')
    let local_path = glob(fnamemodify($MYVIMRC, ':s?init.vim?local.vim?'))
    if filereadable(local_path)
      execute 'source ' . fnameescape(local_path)
    endif
  endif

  " Things you need to localized in local.vim:
  " * Python interpreter path, e.g.,
  "   let g:python3_host_prog = 'C:\Python36\Python3.exe'
  "   let g:python_host_prog = 'C:\Python27\Python.exe'
  " * set clang library path for clang_complete, e.g.
  "   let g:clang_library_path='C:\LLVM\bin\libclang.dll'

" Local customization END }}}

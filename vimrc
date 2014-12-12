" vimrc
" Current author: David Majnemer
" Original author: Saleem Abdulrasool <compnerd@compnerd.org>
" vim: set ts=3 sw=3 et nowrap:

if has('multi_byte')      " Make sure we have unicode support
   scriptencoding utf-8    " This file is in UTF-8

   " ---- Terminal Setup ----
   if ($ANSWERBACK !=# "PuTTY")
      if (&termencoding == "" && (&term =~ "xterm" || &term =~ "putty")) || (&term =~ "rxvt-unicode") || (&term =~ "rxvt-256color") || (&term =~ "screen")
         set termencoding=utf-8
      endif
   endif
   set encoding=utf-8      " Default encoding should always be UTF-8
endif

" ---- General Setup ----
set tabstop=2              " 2 spaces for tabs
set shiftwidth=2           " 2 spaces for indents
set expandtab              " use spaces
set smarttab               " Tab next line based on current line
set autoindent             " Automatically indent next line
if has('smartindent')
   set smartindent         " Indent next line based on current line
endif
set incsearch              " Enable incremental searching
set hlsearch               " Highlight search matches
set ignorecase             " Ignore case when searching...
set smartcase              " ...except when we don't want it
set infercase              " Attempt to figure out the correct case
set showfulltag            " Show full tags when doing completion
set virtualedit=block      " Only allow virtual editing in block mode
set lazyredraw             " Lazy Redraw (faster macro execution)
set wildmenu               " Menu on completion please
set wildmode=longest,full  " Match the longest substring, complete with first
set wildignore=*.o,*~      " Ignore temp files in wildmenu
set scrolloff=3            " Show 3 lines of context during scrolls
set sidescrolloff=2        " Show 2 columns of context during scrolls
set backspace=2            " Normal backspace behavior
set textwidth=80           " Break lines at 80 characters
set hidden                 " Allow flipping of buffers without saving
set noerrorbells           " Disable error bells
set visualbell             " Turn visual bell on
set t_vb=                  " Make the visual bell emit nothing
set showcmd                " Show the current command
set number
set diffopt+=iwhite
set showmatch
set display=lastline,uhex
set shiftround
set splitbelow             " make new horizontal splits below
set splitright             " make new horizontal splits to the right
let mapleader=","          " comma is leader
set shortmess=atI          " use a lot of abbreviations
set laststatus=2           " always show a statusline

" ---- plug ----
call plug#begin('~/.vim/bundle')
Plug 'mileszs/ack.vim'
Plug 'sjl/gundo.vim'
Plug 'pangloss/vim-javascript'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/syntastic'
Plug 'godlygeek/tabular'
Plug 'jinfield/vim-nginx'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-fugitive'
Plug 'vim-perl/vim-perl'
Plug 'othree/html5.vim'
Plug 'kien/ctrlp.vim'
Plug 'bling/vim-airline'
Plug 'elzr/vim-json'
Plug 'mattn/emmet-vim'
Plug 'plasticboy/vim-markdown'
Plug 'rking/ag.vim'
Plug 'jaxbot/github-issues.vim'
Plug 'jeetsukumaran/vim-filebeagle'
Plug 'nanotech/jellybeans.vim'
Plug 'drmikehenry/vim-fontdetect'
Plug 'fatih/vim-go'
call plug#end()

" ---- Load colorscheme after pathogen ----
set background=dark
colorscheme jellybeans

" ---- Filetypes ----
if has('syntax')
   syntax on
endif

if has('eval')
   filetype on             " Detect filetype by extension
   filetype indent on      " Enable indents based on extensions
   filetype plugin on      " Load filetype plugins
endif

" ---- Folding ----
if has('eval')
   fun! WideFold()
      if winwidth(0) > 90
         setlocal foldcolumn=1
      else
         setlocal foldcolumn=0
      endif
   endfun

   let g:detectindent_preferred_expandtab = 1
   let g:detectindent_preferred_indent = 2

   fun! <SID>DetectDetectIndent()
      try
         :DetectIndent
      catch
      endtry
   endfun
endif

if has('autocmd')
   "autocmd BufEnter * :call WideFold()
   if has('eval')
      autocmd BufReadPost * :call s:DetectDetectIndent()
   endif

   if has('viminfo')
      autocmd BufReadPost *
         \ if line("'\"") > 0 && line("'\"") <= line("$") |
         \   exe "normal g`\"" |
         \ endif
   endif
endif

" ---- Spelling ----
if (v:version >= 700)
   set spelllang=en_us        " US English Spelling please

   " Toggle spellchecking with F10
   nnoremap <silent><leader>s :set spell!<CR>
endif

" Show trailing whitespace visually
" Shamelessly stolen from Ciaran McCreesh <ciaranm@gentoo.org>
if (&termencoding == "utf-8") || has("gui_running")
   if v:version >= 700
      set list listchars=tab:»·,trail:·,extends:…,nbsp:‗
   else
      set list listchars=tab:»·,trail:·,extends:…
   endif
else
   if v:version >= 700
      set list listchars=tab:>-,trail:.,extends:>,nbsp:_
   else
      set list listchars=tab:>-,trail:.,extends:>
   endif
endif

if has('mouse')
   " Dont copy the listchars when copying
   set mouse=nvi
endif

if has('autocmd')
   " always refresh syntax from start
   autocmd BufEnter * syntax sync fromstart
endif

" ---- cscope/ctags setup ----
if has('cscope') && executable('cscope') == 1
   " Search cscope and ctags, in that order
   set cscopetag
   set cscopetagorder=0

   set nocsverb
   if filereadable('cscope.out')
      cs add cscope.out
   endif
   set csverb
endif

" ---- Key Mappings ----

" improved lookup
if has('eval')
   fun! GoDefinition()
      let pos = getpos(".")
      normal! gd
      if getpos(".") == pos
         exe "tag " . expand("<cword>")
      endif
   endfun

   nmap <C-]> :call GoDefinition()<CR>
endif

" Append modeline after last line in buffer.
" Use substitute() (not printf()) to handle '%%s' modeline in LaTeX files.
if has('eval')
   fun! AppendModeline()
      let save_cursor = getpos('.')
      let append = ' vim: set ts='.&tabstop.' sw='.&shiftwidth.' tw='.&textwidth.': '
      $put =substitute(&commentstring, '%s', append, '')
      call setpos('.', save_cursor)
   endfun
   nnoremap <silent> <Leader>ml :call AppendModeline()<CR>
endif

" tab indents selection
vmap <silent> <Tab> >gv

" shift-tab unindents
vmap <silent> <S-Tab> <gv

" Page using space
noremap <Space> <C-F>

" shifted arrows are stupid
inoremap <S-Up> <C-O>gk
noremap  <S-Up> gk
inoremap <S-Down> <C-O>gj
noremap  <S-Down> gj

" Y should yank to EOL
map Y y$

" vK is stupid
vmap K k

" :W and :Q are annoying
if has('user_commands')
   command! -nargs=0 -bang Q q<bang>
   command! -nargs=0 -bang W w<bang>
   command! -nargs=0 -bang WQ wq<bang>
   command! -nargs=0 -bang Wq wq<bang>
endif

" just continue
nmap K K<cr>

" stolen from auctex.vim
if has('eval')
   fun! EmacsKill()
      if col(".") == strlen(getline(line(".")))+1
         let @" = "\<CR>"
         return "\<Del>"
      else
         return "\<C-O>D"
      endif
   endfun
endif

" some emacs-isms are OK
map! <C-a> <Home>
map  <C-a> <Home>
map! <C-e> <End>
map  <C-e> <End>
imap <C-f> <Right>
imap <C-b> <Left>
map! <M-BS> <C-w>
map  <C-k> d$
if has('eval')
   inoremap <buffer> <C-K> <C-R>=EmacsKill()<CR>
endif

" Disable q and Q
map q <Nop>
map Q <Nop>

" Toggle numbers with <leader>n
nnoremap <silent><leader>n :set number!<CR>
nnoremap <silent><leader><space> :noh<CR>
function! ToggleNumber()
   if(&relativenumber == 1)
      set norelativenumber
      set number
   else
      set relativenumber
   endif
endfunc
nmap <silent><leader>r :call ToggleNumber()<CR>

" Don't force column 0 for #
inoremap # X<BS>#

" Always map <C-h> to backspace
" Both interix and cons use C-? as forward delete,
" besides those two exceptions, always set it to backspace
" Also let interix use ^[[U for end and ^[[H for home
map  <C-h> <BS>
map! <C-h> <BS>
if (&term =~ "interix")
   map  <C-?> <DEL>
   map! <C-?> <DEL>
   map <C-[>[H <Home>
   map <C-[>[U <End>
elseif (&term =~ "^sun")
   map  <C-?> <DEL>
   map! <C-?> <DEL>
elseif (&term !~ "cons")
   map  <C-?> <BS>
   map! <C-?> <BS>
endif

if (&term =~ "^xterm")
   map  <C-[>[H <Home>
   map! <C-[>[H <Home>
   map  <C-[>[F <End>
   map! <C-[>[F <End>
   map  <C-[>[5D <C-Left>
   map! <C-[>[5D <C-Left>
   map  <C-[>[5C <C-Right>
   map! <C-[>[5C <C-Right>
endif

" highlight last inserted text
nnoremap gV `[v`]

" Terminal.app does not support back color erase
if ($TERM_PROGRAM ==# "Apple_Terminal" && $TERM_PROGRAM_VERSION <= 273)
   set t_ut=
endif

" Python specific stuff
if has('eval')
   let python_highlight_all = 1
   let python_slow_sync = 1
endif

" call functions and preserve state
fun! Preserve(command)
   " save cursor position and search
   let _s = @/
   let l = line(".")
   let c = col(".")
   execute a:command
   " restore saved state
   let @/ = _s
   call cursor(l, c)
endfun

" remove trailing whitespace
nnoremap <silent><leader>ws :call Preserve("%s/\\s\\+$//e")<CR>

" ---- matchit ----
if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
   runtime! macros/matchit.vim
endif

" ---- Gundo ----
nnoremap <leader>u :GundoToggle<CR>

" ---- NERDCommenter ----
let g:NERDSpaceDelims = 1
let g:NERDRemoveExtraSpaces = 1

" ---- HTML5 Indenting ----
let g:html_indent_inctags = "html,body,head,tbody"
let g:html_indent_script1 = "inc"
let g:html_indent_style1 = "inc"

" ---- emmet ----
let g:user_emmet_settings = {
\  'html': {
\     'default_attributes': {
\        'polymer-element': [{'name': ''}, {'attributes': ''}],
\        'link:import': [{'rel': 'import'}, {'href': ''}]
\     },
\     'expandos': {
\        'polymer-element': 'polymer-element > template + script'
\     }
\  }
\}

" ---- airline ----
let g:airline_enable_branch = 1
let g:airline_branch_empty_message = ''
let g:airline_detect_modified = 1
let g:airline_detect_paste = 1
let g:airline_inactive_collapse = 1
let g:airline_detect_whitespace = 1
let g:airline_enable_syntastic = 1

" ---- syntastic ----
let g:syntastic_mode_map = { 'passive_filetypes': ['html'] }
let g:syntastic_ignore_files = ['\.min\.js$']
" let g:syntastic_check_on_open = 1
" Jump to first error line
let g:syntastic_auto_jump = 2
nnoremap <silent><leader>sc :SyntasticCheck<CR>
nnoremap <silent><leader>se :Errors<CR>

" ---- markdown ----
let g:vim_markdown_folding_disabled = 1

" ---- CtrlP ----
nnoremap <silent><leader>b :CtrlPBuffer<CR>
let g:ctrlp_custom_ignore = {
\ 'dir': '\v[\/](node_modules|bower_components)'
\}

" ---- github-issues ----
let g:gissues_lazy_load = 1

" Handy vanilla Vim settings
set background=dark
set wildmenu
set wildmode=longest,list
set backspace=indent,eol,start
set laststatus=2
set ruler
set scrolloff=3
set nocompatible
set noswapfile
syntax on

" Search configuration
set hlsearch
set incsearch
set ignorecase
set smartcase

" Put contents of unnamed register into clipboard.
command Clip call system('xclip -i -selection clipboard', @")
" Paste contents of clipboard into buffer.
command Clop put = system('xclip -o -selection clipboard')

" Enable the Shell command.  This runs shell commands and outputs to the
" scratch space.
command! -complete=shellcmd -nargs=+ Shell call s:RunShellCommand(<q-args>)
function! s:RunShellCommand(cmdline)
  echo a:cmdline
  let expanded_cmdline = a:cmdline
  for part in split(a:cmdline, ' ')
     if part[0] =~ '\v[%#<]'
        let expanded_part = fnameescape(expand(part))
        let expanded_cmdline = substitute(expanded_cmdline, part, expanded_part, '')
     endif
  endfor
  botright new
  setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap
  call setline(1, 'You entered:    ' . a:cmdline)
  call setline(2, 'Expanded Form:  ' .expanded_cmdline)
  call setline(3,substitute(getline(2),'.','=','g'))
  execute '$read !'. expanded_cmdline
  setlocal nomodifiable
  1
endfunction

" Insert unicode ✓ and ✗!
imap <F5> <C-V>u2713
imap <F6> <C-V>u2717

" Save while in insert mode (and same shortcut for 'normal' too)
inoremap <F2> <Esc>:w<CR>
nnoremap <F2> :w<CR>

" Better controls for switching between tabs.
nnoremap th :tabfirst<CR>
nnoremap tj :tabnext<CR>
nnoremap tk :tabprev<CR>
nnoremap tl :tablast<CR>
nnoremap tt :tabedit<Space>
nnoremap tn :tabnext<Space>
nnoremap tm :tabm<Space>
nnoremap td :tabclose<CR>

" Indenting things
set autoindent
set expandtab
set smarttab
set shiftwidth=4
set tabstop=4
set cino+=(0"

" Highlight trailing whitespace, or whitespace before a tab
highlight ExtraWhitespace ctermbg=darkred guibg=darkred
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=darkred guibg=darkred
match ExtraWhitespace /\s\+$\| \+\ze\t/

" Strip trailing whitespace on save
autocmd BufWritePre * :%s/\s\+$//e

" Line number toggling
function! NumberToggle()
  if(&relativenumber != 1 && &number != 1)
    set number
    highlight LineNr ctermfg=gray
  elseif(&relativenumber != 1 && &number == 1)
    set relativenumber
    highlight LineNr ctermfg=darkgray
  else
    set norelativenumber
    set nonumber
  endif
endfunc
nnoremap <C-n> :call NumberToggle()<CR>

" By default use relative line numbering
set relativenumber
highlight LineNr ctermfg=darkgray

" Simple plugin settings
let g:rainbow_active = 1
let g:sh_no_error = 1

" PyMode settings.
let g:pymode = 1
let g:pymode_lint = 1
let g:pymode_lint_unmodified = 1
let g:pymode_lint_ignore = "E265"
let g:pymode_rope = 0
let g:pymode_doc = 1
let g:pymode_folding = 0
let g:pymode_python = 'python3'
let g:pymode_options_max_line_length = 79

" Syntastic settings
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
" let g:syntastic_always_populate_loc_list = 1
" let g:syntastic_auto_loc_list = 1
" let g:syntastic_check_on_open = 1
" let g:syntastic_check_on_wq = 0
" Disable GCC checking, as it's not feasible with huge codebases.
let g:syntastic_c_checkers=[]

" Cscope options:
set csprg=gtags-cscope
set nocsverb
cs add GTAGS
set csverb
"set cscopequickfix=s-,c+,d-,i-,t-,e-
" This one replaces tags with cscope tagging.
set cst
" Cscope shortcuts.
noremap <leader>s :cs<space>f<space>s<space>
map <C-\>g :cs find g <C-R>=expand("<cword>")<CR><CR>
map <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR>
map <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>
" Better navigating for references.
set cscopequickfix=s-,c-,d-,i-,t-,e-
nmap <leader>, :lprevious<CR>
nmap <leader>. :lnext<CR>
nnoremap <C-\>, :lolder<CR>
nnoremap <C-\>. :lnewer<CR>
"nmap <leader>, :lopen<CR>
"nmap <leader>. :lclose<CR>
nmap <C-\>s :lcs f s <C-r><C-w><CR> :lw<CR>

" F5 for buffers list
nmap <f5> :buffers<CR>:buffer<space>

" Ctrl-P options:
set wildignore+=*.tmp,*.swp,*.so,*.zip,*.cache,*.class
let g:ctrlp_max_files = 910000
let g:ctrlp_use_caching = 1
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_dotfiles = 0
let g:ctrlp_cache_dir = $HOME.'/.cache/ctrlp'

" Tag searching wth CtrlP
noremap <leader>g :CtrlPGtags<CR>
set rtp+=$HOME/.vim/bundle/CtrlPGtags

" Autocomment
nnoremap <C-\>a :ToggleAutoComment<CR>
nnoremap <leader>a :AutoComment<CR>

" Vundle options:
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Let Vundle manage itself (required)
Bundle 'VundleVim/Vundle.vim'

" My Bundles:
"
" Github repos
Bundle 'ctrlpvim/ctrlp.vim'
Bundle 'python-mode/python-mode'
Bundle 'JazzCore/ctrlp-cmatcher'
Bundle 'rking/ag.vim'
Bundle 'scrooloose/syntastic'
Plugin 'vimwiki'
Plugin 'godlygeek/tabular'
Plugin 'plasticboy/vim-markdown'
Plugin 'DiscoViking/CtrlPGtags'

" status line
Plugin 'bling/vim-airline'
" If you need to change .tmux.conf.statusline, install this plugin, then run
" ':Tmuxline airline' and 'TmuxlineSnapshot! ~/.tmux.statusline.conf
Plugin 'edkolev/tmuxline.vim'
Plugin 'leafgarland/typescript-vim'
Plugin 'peitalin/vim-jsx-typescript'

call vundle#end()
filetype plugin on " Required for Vundle
"
" Brief help
" :BundleList          - list configured bundles
" :BundleInstall(!)    - install(update) bundles
" :BundleSearch(!) foo - search(or refresh cache first) for foo
" :BundleClean(!)      - confirm(or auto-approve) removal of unused bundles
"
" see :h vundle for more details or wiki for FAQ
" NOTE: comments after Bundle command are not allowed..

" vim-airline
let g:airline_powerline_fonts=1
set laststatus=2
set ttimeoutlen=50
let g:airline#extensions#tmuxline#enabled = 0 " Don't override Tmux theme when opening Vim

" Remember position when opening
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" Set a ruler at 80 characters.
set colorcolumn=80

" set filetypes as typescript.tsx
autocmd BufNewFile,BufRead *.tsx,*.jsx set filetype=typescript.tsx


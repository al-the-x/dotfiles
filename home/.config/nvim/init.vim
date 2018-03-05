"" Make sessions play nice with Pathogen et al
set sessionoptions-=options

"" Load and enable Pathogen
" runtime bundle/vim-pathogen/autoload/pathogen.vim
" call pathogen#infect()

se rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
  Plugin 'VundleVim/Vundle.vim'

  "" General utilities
  Plugin 'flazz/vim-colorschemes'
  Plugin 'tpope/vim-sensible'
  Plugin 'google/vim-maktaba'
  Plugin 'google/vim-codefmt'
  Plugin 'google/vim-coverage'
  Plugin 'google/vim-glaive'
  Plugin 'tpope/vim-dispatch'
  Plugin 'editorconfig/editorconfig-vim'
  Plugin 'tpope/vim-commentary'
  Plugin 'tpope/vim-repeat'
  Plugin 'tpope/vim-surround'
  Plugin 'tpope/vim-unimpaired'
  Plugin 'tpope/vim-vinegar'
  Plugin 'tpope/vim-scriptease'
  "" ^^^ Mainly for `:Verbose`
  Plugin 'tpope/vim-abolish'
  "" ^^^ For case coercion: https://github.com/tpope/vim-abolish#coercion
  ""     See `:Verbose nmap | /crs

  "" Use `git` from within `vim`
  Plugin 'tpope/vim-fugitive'
  Plugin 'airblade/vim-gitgutter'
  Plugin 'alexdavid/vim-min-git-status'
  Plugin 'tpope/vim-rhubarb'

  "" Buffer and file management
  Plugin 'artnez/vim-wipeout'
  Plugin 'ctrlpvim/ctrlp.vim'
  Plugin 'tpope/vim-obsession'

  "" Syntax-checking and highlighting...
  Plugin 'scrooloose/syntastic'

  Plugin 'burnettk/vim-angular'
  Plugin 'pangloss/vim-javascript'
  Plugin 'fatih/vim-go'
  Plugin 'digitaltoad/vim-pug'
  Plugin 'tmux-plugins/vim-tmux'
  Plugin 'tpope/vim-eunuch'
  Plugin 'tpope/vim-markdown'
  Plugin 'mattn/emmet-vim'
  Plugin 'tpope/vim-ragtag'
  Plugin 'kylef/apiblueprint.vim'
call vundle#end()
filetype plugin indent on

"" Configure Glaive-enabled plugins
call glaive#Install()
Glaive codefmt plugin[mappings]

"" Configure `statusline` with help from `tpope/fugitive`
set statusline=%<%f\ %h%m%r[%{fugitive#head()}]%=%-14.(%l,%c%V%)\ %P

"" Configure `scrooloose/syntastic`
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_javascript_checkers=['eslint']

"" Add Syntastic to `statusline`
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

"" Make tag jumping use cscope files, if possible
set cscopetag


"" Configure `ctrlpvim/ctrlp.vim`
let g:ctrlp_switch_buffer="ETVH"
let g:ctrlp_working_path_mode='wca'

"" Make `netrw` display in tree mode...
let g:netrw_liststyle=3

syntax on

colorscheme desert
set background=light
if &diff
  colorscheme industry
endif

"" More sane defaults
set number
set foldmethod=indent
set colorcolumn=80
set laststatus=2
set formatoptions+=rol

"" Use 2-space tabs by default
set tabstop=2
set shiftwidth=2
set expandtab

"" Make `<C-A>` increment alphabetic characters
set nrformats+=alpha

"" Make `/` and `?` ignore case unless mixedCase
set ignorecase
set smartcase

"""
" Key Mappings
""

"" Kill the help key...
noremap! <F1> <Nop>

"" Faster panel switching...
nmap <C-H> <C-W>h
nmap <C-L> <C-W>l
nmap <C-J> <C-W>j
nmap <C-K> <C-W>k

"""
" Leader-key Mappings
""

"" Press <Leader><ESC> to clear search highlighting until the next search...
nnoremap <Leader><ESC> :noh<CR>

"" Extend prezto shortcuts to vim...
nmap <Leader>gws :Gministatus<CR>
nmap <Leader>gc :Gcommit -v<CR>
nmap <Leader>gwd :Gdiff<CR>

"" Setup autocomplete...
autocmd FileType php set omnifunc=phpcomplete#CompletePHP
autocmd FileType ruby set omnifunc=rubycomplete#Complete
autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags

"" Map extension `.md` to Markdown instead of default...
autocmd FileType md set filetype=markdown

"" To work with crontab files...
autocmd FileType crontab set nobackup nowritebackup

"" Help NeoVim check for modified files: https://github.com/neovim/neovim/issues/2127
autocmd BufEnter,FocusGained * checktime

""
" Execute a :s[earch] without clobbering the search register, with all the
" regular features of the command.
""
function! SafeSearch( line1, line2, cmd )
    let r = @/
    execute a:line1 . ',' . a:line2 . a:cmd
    let @/ = r
endfunction

"" Map ":Sa[feSearch]" to the "SafeSearch" function for convenience...
command! -range -nargs=* SafeSearch call SafeSearch(<line1>, <line2>, 's' . <q-args>)

"""
 " Trim any trailing whitespace from a file just before saving it.
 ""
function! TrimTrailingWhitespace( line1, line2 )
    execute a:line1 . ',' . a:line2 . 'SafeSearch/\s\+$//e'
endfunction

"" Map ":Trim" to the "TrimTrailingWhitespace" function for convenience...
command! -range Trim call TrimTrailingWhitespace(<line1>, <line2>)

"" ALWAYS remove trailing whitespace when saving a file...
augroup FIXUP
    autocmd! BufWritePre * %Trim
augroup END

"""
 " Extract the links from a buffer and return them as a List
 ""
function! ExtractLinks()
  let LINKS=[ ]
  substitute(getline(1,$),
    'https?://[\w\.-]\+[/\w\d-\.%]\+',
    \=len(add(LINKS, submatch(0))) ? submatch(0) : '',
  'ge')
  if len(LINKS)
    put =LINKS
  endif
endfunction

try
  let s:local_rc=system('print $(git-root)/.nvimrc')
  execute 'source' s:local_rc
catch
  if $DEBUG
    confirm echo 'failed loading' s:local_rc ':' v:exception
  endif
endtry

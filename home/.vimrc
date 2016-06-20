"" Make sessions play nice with Pathogen et al
set sessionoptions-=options

"" Load and enable Pathogen
" runtime bundle/vim-pathogen/autoload/pathogen.vim
" call pathogen#infect()

"" TODO: Switch to Vundle one day? https://github.com/VundleVim/Vundle.vim
"" source ~/.vim/bundle.vim
runtime bundle/Vundle.vim
call vundle#begin()
  Plugin 'VundleVim/Vundle.vim'
  Plugin 'tpope/vim-sensible'
  Plugin 'ctrlpvim/ctrlp.vim'
  Plugin 'editorconfig/editorconfig-vim'
  Plugin 'mattn/emmet-vim'
  Plugin 'scrooloose/syntastic'
  Plugin 'tpope/vim-commentary'
  Plugin 'tpope/vim-dispatch'
  Plugin 'tpope/vim-eunuch'
  Plugin 'tpope/vim-fugitive'
  Plugin 'fatih/vim-go'
  Plugin 'tpope/vim-markdown'
  Plugin 'tpope/vim-obsession'
  Plugin 'tpope/vim-pathogen'
  Plugin 'tpope/vim-ragtag'
  Plugin 'tpope/vim-repeat'
  Plugin 'tpope/vim-surround'
  Plugin 'tmux-plugins/vim-tmux'
  Plugin 'tpope/vim-unimpaired'
  Plugin 'tpope/vim-vinegar'
  Plugin 'artnez/vim-wipeout'
call vundle#end()
filetype plugin indent on

syntax on

colorscheme desert

set tabstop=2
set shiftwidth=2
set expandtab
set cindent
set number
set foldmethod=indent
set ignorecase
set smartcase
set colorcolumn=80
set laststatus=2
set backspace=2
set formatoptions+=rol

"" Make `<C-A>` increment alphabetic characters
set nrformats+=alpha

"" Kill the help key...
noremap! <F1> <Nop>

"" Faster panel switching...
nmap <C-H> <C-W>h
nmap <C-L> <C-W>l
nmap <C-J> <C-W>j
nmap <C-K> <C-W>k

"" Press <Leader><ESC> to clear search highlighting until the next search...
nnoremap <Leader><ESC> :noh<RETURN>

"" Settings for netrw file browsing...
let g:netrw_liststyle=3

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

"" Settings for http://github.com/vim-scripts/vimwiki
let g:vimwiki_list=[{'path': '~/vimwiki', 'syntax': 'markdown', 'ext': '.md' }]

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

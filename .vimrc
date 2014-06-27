runtime bundle/vim-pathogen/autoload/pathogen.vim
call pathogen#infect()

syntax on

colorscheme desert

set tabstop=4
set shiftwidth=4
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

map! <F1> <Nop>

nmap <C-H> <C-W>h
nmap <C-L> <C-W>l
nmap <C-J> <C-W>j
nmap <C-K> <C-W>k
nmap <C-W><C-A> :set columns=240<CR>
nmap <C-W><C-Z> :set columns=120<CR>

autocmd FileType php set omnifunc=phpcomplete#CompletePHP
autocmd FileType ruby set omnifunc=rubycomplete#Complete
autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
autocmd FileType md set shiftwidth=2 filetype=markdown
autocmd FileType crontab set nobackup nowritebackup

"""
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

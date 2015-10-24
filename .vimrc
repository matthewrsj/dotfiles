" turn off auto adding comments on next line
" so you can cut and paste reliably
" http://vimdoc.sourceforge.net/htmldoc/change.html#fo-table
set fo=tcq
set nocompatible
set modeline
set bg=dark
set number
set mouse=a

syntax on

" set default comment color to cyan instead of darkblue
" which is not very legible on a black background.
" Not doing this right now, I think darkblue looks better
" and is plenty readable
highlight comment ctermfg=darkblue

set tabstop=2
set expandtab
set softtabstop=2
set shiftwidth=2

" Uncomment next four lines to hilight trailing whitespace
highlight LiteralTabs ctermbg=darkgreen guibg=darkgreen
match LiteralTabs /\s\  /
highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
match ExtraWhitespace /\s\+$/

" Show me a ruler
set ruler

" Set up puppet manifest and spec options
au BufRead,BufNewFile *.pp
 \ set filetype=puppet
au BufRead,BufNewFile *_spec.rb
 \ nmap <F8> :!rspec --color %<CR>

filetype plugin indent on

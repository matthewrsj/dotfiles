" turn off auto adding comments on next line
" so you can cut and paste reliably
" http://vimdoc.sourceforge.net/htmldoc/change.html#fo-table
execute pathogen#infect()
"colorscheme desert
set fo=tcq
set nocompatible
set modeline
set mouse=a

" For git updating
set updatetime=250

syntax on

set tabstop=8
"set expandtab
set softtabstop=8
set shiftwidth=8

" Set up puppet manifest and spec options
au BufRead,BufNewFile *.pp
 \ set filetype=puppet
au BufRead,BufNewFile *_spec.rb
 \ nmap <F8> :!rspec --color %<CR>

filetype plugin indent on

set ai " Always set auto-indenting on
"set backup " Keep a backup file
set bs=2 " Allow backspacing over everything in insert mode
set cmdwinheight=4 "Use four lines for the command window
set encoding=utf-8 "Set default character encoding
set fileformats=unix,dos "Try different eol formats when opening files
set history=50 " keep 50 lines of command history
set hlsearch "Highlight all matches for a search pattern
set ignorecase "Ignore case in search patterns
set incsearch "Display match for search pattern halfway through typing
set lazyredraw "Don't refresh the screen when running macros
set linebreak "Don't break words in the middle
set modelines=0 " Don't use modelines by default for security purposes
set mousehide "Hides mouse pointer while typing
set nocompatible " Use Vim defaults (much better!)
set nolinebreak "No linebreak
set nowrap "No line wrap
set ruler " Show the cursor position all the time
set showcmd "Display incomplete commands in lower right corner
set showmatch "Show matching brackets
set smartcase "Override 'ignorecase' option if search pattern contains uppercase
set spellsuggest=5 "Only display the top 5 alternative spellings
set viminfo='20,\"50 " read/write a .viminfo file -- limit to only 50
set virtualedit=onemore "Cursor can be placed where there are no actual characters
set wildmode=longest,list,full "Set completion modes
set winminheight=0 "Set the minimum window height to 0

" Use command line tab completion
set wildmenu
set wildignore+=*.o,*~,.lo
set suffixes+=.in,.a,.1

if v:lang =~ "^ko"
  set fileencodings=euc-kr
  set guifontset=-*-*-medium-r-normal--16-*-*-*-*-*-*-*
elseif v:lang =~ "^ja_JP"
  set fileencodings=euc-jp
  set guifontset=-misc-fixed-medium-r-normal--14-*-*-*-*-*-*-*
elseif v:lang =~ "^zh_TW"
  set fileencodings=big5
  set guifontset=-sony-fixed-medium-r-normal--16-150-75-75-c-80-iso8859-1,-taipei-fixed-medium-r-normal--16-150-75-75-c-160-big5-0
elseif v:lang =~ "^zh_CN"
  set fileencodings=gb2312
  set guifontset=*-r-*
endif
if v:lang =~ "utf8$" || v:lang =~ "UTF-8$"
  set fileencodings=utf-8,latin1
endif

if has("autocmd")
    " When editing a file, always jump to the last cursor position
    autocmd BufReadPost *
    \ if line("'\"") > 0 && line ("'\"") <= line("$") |
    \   exe "normal g'\"" |
    \ endif
endif


"execute pathogen#infect()
set background=dark
let g:solarized_termcolors=256
set t_Co=256
let g:gruvbox_contrast_light="hard"
let g:gruvbox_contrast_dark="hard"
colorscheme gruvbox

" Setting both relativenumber and number turns on hybrid number
"set relativenumber
set number

set cursorline
"highlight ColorColumn ctermbg=4
set colorcolumn=80

set modeline
set modelines=5

" Enable folding
set foldmethod=indent
set foldlevel=99
nnoremap <space> za

set list lcs=trail:·,tab:»·
hi NonText ctermfg=7 guifg=gray
hi SpecialKey ctermbg=none guibg=NONE
set laststatus=2

"if &term =~ "xterm\\|rxvt"
"  " use an orange cursor in insert mode
"  let &t_SI = "\<Esc>]12;orange\x7"
"  " use a red cursor otherwise
"  let &t_EI = "\<Esc>]12;red\x7"
"  silent !echo -ne "\033]12;red\007"
"  " reset cursor when vim exits
"  autocmd VimLeave * silent !echo -ne "\033]112\007"
"  " use \003]12;gray\007 for gnome-terminal
"endif
let mapleader=","
map <C-n> :NERDTreeToggle<CR>

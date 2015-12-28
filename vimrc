""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Sections:                                                                  "
"   01. General ................. General Vim behavior                       "
"   02. Events .................. General autocmd events                     "
"   03. Theme/Colors ............ Colors, fonts, etc.                        "
"   04. Vim UI .................. User interface behavior                    "
"   05. Text Formatting/Layout .. Text, tab, indentation related             "
"   06. Custom Commands ......... Any custom command aliases                 "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 01. General                                                                "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Get rid of Vi compatibility mode
set nocompatible          

" Tell Vim for Windows ~/.vim exists. By default it only uses ~/vimfiles.
if has("win32") && isdirectory(expand("$HOME")."/.vim") &&
            \!isdirectory(expand("$HOME")."/vimfiles") 
    let &rtp="$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,
                \$VIM/vimfiles/after,$HOME/.vim/after" 
endif 

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 02. Events                                                                 "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Filetype detection for smart auto-indenting and filetype specific plugins
filetype indent plugin on

" In Makefiles, use tabs
autocmd FileType make setlocal noexpandtab

" Enable omnicompletion (to use, hold Ctrl+X then Ctrl+O while in Insert mode.
set ofu=syntaxcomplete#Complete

" Automatically cd into the directory that the file is in
autocmd BufEnter * execute "chdir ".escape(expand("%:p:h"), ' ')

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 03. Theme/Colors                                                           "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
syntax enable             " Enable syntax highlighting; allow using :highlight
set background=dark       " Use dark mode of solarized
if !has('gui_running')    " Degrade solarized colorscheme if not using gVim
    let g:solarized_termcolors=256
endif
colorscheme solarized     " Use solarized colorscheme

" Prettify JSON files
autocmd BufRead,BufNewFile *.json set filetype=json
autocmd Syntax json sou ~/.vim/syntax/json.vim

" Prettify Markdown files
augroup markdown
    au!
    au BufNewFile,BufRead *.md,*.markdown setlocal filetype=ghmarkdown
augroup END

" Highlight characters that go over 80 columns
if exists('+colorcolumn')
    set colorcolumn=81
    highlight ColorColumn ctermbg=red
else
    highlight OverLength ctermbg=red ctermfg=white guibg=#592929
    match OverLength /\%81v.\+/
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 04. Vim UI                                                                 "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set number                " Show line numbers
set numberwidth=6         " Make the number gutter 6 characters wide
set cul                   " Highlight current line
set laststatus=2          " Last window always has a statusline
set nohlsearch            " Don't continue to highlight searched phrases.
set incsearch             " But do highlight as you type your search.
set ignorecase            " Make searches case-insensitive.
set ruler                 " Always show info along bottom.
set showmatch             " Hint at location of matching brace
set matchtime=3           " Delay to move cursor to matching brace
set statusline=%<%f\%h%m%r%=%-20.(line=%l\ \ col=%c%V\ \ totlin=%L%)\ \ \%h%m%r%=%-40(bytval=0x%B,%n%Y%)\%P
set visualbell
set hidden                " Switch buffers w/o writing or losing changes
set wildmenu              " Better command-line completion
set wildmode=list:longest,full " Complete to longest matching command, list all completions on menu
set showcmd               " Show partial commands on the last line
set mouse=a               " Enable use of the mouse for all modes
set cmdheight=2           " avoid 'Hit <Enter> to continue' by adding space

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 05. Text Formatting/Layout                                                 "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set autoindent            " Non filetype-specific indenting
set softtabstop=4         " Unify
set shiftwidth=4          " Indent/outdent by 2 columns
set shiftround            " Indent/outdent to the nearest tabstop
set expandtab             " Use spaces instead of tabs
set nowrap                " Don't wrap text
set backspace=indent,     " Fix issue of backspace getting stuck 
            \eol,start 

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 06. Custom Commands                                                        "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Y -> Yank until EOL, rather than act as yy
map Y y$

" <Tab> and <Shift-Tab> -> Cycle through hidden buffer in normal mode
nnoremap <Tab> :bnext<CR>
nnoremap <S-Tab> :bprevious<CR>

" % -> Jump to matching braces and select inner text
noremap % v%

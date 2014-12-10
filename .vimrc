set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

Plugin 'pyflakes/pyflakes'
Plugin 'kien/ctrlp.vim'
Plugin 'bling/vim-airline' " precisa instalar as fontes https://github.com/powerline/fonts/blob/master/install.sh

call vundle#end()            " required
filetype plugin indent on    " required

"airline config
let g:airline_powerline_fonts = 1

set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.pyc,*.pyo     " MacOSX/Linux

if has("gui_running")
   set guioptions-=T " disable toolbar
   set guioptions-=m " disable menu
   set guioptions-=r
endif


map <S-Insert> <MiddleMouse>

"Mapping para ligar e desligar a sintaxe
map <F7> :syntax on<CR>
map <F8> :syntax off<CR>
map <F1> <esc>a{}<esc>i%%<esc>i<space><space><esc>ha

"Mapping para NERDTree
map <C-T> :NERDTreeToggle<return>
let NERDTreeIgnore = ['\.pyc$', '\.pyo$', 'bin$', 'local$', 'share$', 'include$', 'build$', 'public$']
let NERDChristmasTree = 1

function ToggleFold()
   if foldlevel('.') == 0
      " No fold exists at the current line,
      " so create a fold based on indentation

      let l_min = line('.')   " the current line number
      let l_max = line('$')   " the last line number
      let i_min = indent('.') " the indentation of the current line
      let l = l_min + 1

      " Search downward for the last line whose indentation > i_min
      while l <= l_max
         " if this line is not blank ...
         if strlen(getline(l)) > 0 && getline(l) !~ '^\s*$'
            if indent(l) <= i_min

               " we've gone too far
               let l = l - 1    " backtrack one line
               break
            endif
         endif
         let l = l + 1
      endwhile

      " Clamp l to the last line
      if l > l_max
         let l = l_max
      endif

      " Backtrack to the last non-blank line
      while l > l_min
         if strlen(getline(l)) > 0 && getline(l) !~ '^\s*$'
            break
         endif
         let l = l - 1
      endwhile

      "execute "normal i" . l_min . "," . l . " fold"   " print debug info

      if l > l_min
         " Create the fold from l_min to l
         execute l_min . "," . l . " fold"
      endif
   else
      " Delete the fold on the current line
      normal zd
   endif
endfunction

"Mapping para code fold
vmap <space> zf
nmap <space> :call ToggleFold()<CR>

syntax on
colorscheme darkspectrum

set autoread            "altera o arquivo no vim caso seja alterado por uma fonte externa
set autoindent          "identação automática
set softtabstop=4       "makes backspacing over spaced out tabs work real nice
set expandtab           "expand tabs to spaces
set shiftwidth=4
set tabstop=4
set termencoding=utf-8
set nobackup
set fileencodings=ucs-bom,utf-8,default,latin1
set smartindent
set showmatch
set showcmd
set showmode
set number
set hlsearch
set paste
set cursorline
set virtualedit=all
set noswapfile
set guifont=Ubuntu\ Mono\ 11,5
":match Search '\%>80v.\+'

autocmd FileType html,htmldjango,jinjahtml,eruby,mako let b:closetag_html_style=1
autocmd FileType html,xhtml,xml,htmldjango,jinjahtml,eruby,mako source ~/.vim/scripts/closetag.vim

" Show tabs and trailing whitespace visually
if (&termencoding == "utf-8") || has("gui_running")
    if v:version >= 700
        set list listchars=tab:»\ ,trail:·,extends:…,nbsp:‗
    else
        set list listchars=tab:»\ ,trail:·,extends:…
    endif
else
    if v:version >= 700
        set list listchars=tab:>\ ,trail:.,extends:>,nbsp:_
    else
        set list listchars=tab:>\ ,trail:.,extends:>
    endif
endif

" remove ^M characters from windows files
map <C-M> mvggVG:s/<C-V><CR>//g<CR>`v
"

"http://vim.wikia.com/wiki/Remove_unwanted_spaces#Automatically_removing_all_trailing_whitespace
autocmd BufWritePre * :%s/\s\+$//e

"rot13 dmca-grade encryption
"this is useful to obfuscate whatever it is that you're working on temporarily
"if someone walks by (vim pr0n?)
map <F5> mzggVGg?`z

"good tab completion - press <tab> to autocomplete if there's a character
"previously
function InsertTabWrapper()
      let col = col('.') - 1
      if !col || getline('.')[col - 1] !~ '\k'
          return "\<tab>"
      else
          return "\<c-p>"
      endif
endfunction

inoremap <C-tab> <c-r>=InsertTabWrapper()<cr>

" Author: Bernardo Fontes <falecomigo@bernardofontes.net>
" Website: http://www.bernardofontes.net
" This code is based on this one: http://www.cmdln.org/wp-content/uploads/2008/10/python_ipdb.vim
" I worked with refactoring and it simplifies a lot the remove breakpoint feature.
" To use this feature, you just need to copy and paste the content of this file at your .vimrc file! Enjoy!
python << EOF
import vim
import re

ipdb_breakpoint = 'import ipdb; ipdb.set_trace()'

def set_breakpoint():
    breakpoint_line = int(vim.eval('line(".")')) - 1

    current_line = vim.current.line
    white_spaces = re.search('^(\s*)', current_line).group(1)

    vim.current.buffer.append(white_spaces + ipdb_breakpoint, breakpoint_line)

def remove_breakpoints():
    op = 'g/^.*%s.*/d' % ipdb_breakpoint
    vim.command(op)

def line_up():
    current_line_number = int(vim.eval('line(".")'))
    current_line = vim.current.line
    dest_line_number = current_line_number - 1

    if current_line_number != 1:
        vim.current.buffer.append(current_line, dest_line_number - 1)
        op = str(current_line_number + 1) + 'd'
        vim.command(op)
        vim.command(str(dest_line_number))

def line_down():
    current_line_number = int(vim.eval('line(".")'))
    current_line = vim.current.line
    dest_line_number = current_line_number + 1

    if current_line_number != len(vim.current.buffer):
        vim.current.buffer.append(current_line, dest_line_number)
        op = str(current_line_number) + 'd'
        vim.command(op)
        vim.command(str(dest_line_number))

vim.command('map <C-Up> :py line_up()<cr>')
vim.command('map <C-Down> :py line_down()<cr>')
vim.command('map <C-I> :py set_breakpoint()<cr>')
#vim.command('map <C-P> :py remove_breakpoints()<cr>')

EOF

map <C-S-Left> <c-w><
map <C-S-Right> <c-w>>
map <C-S-Up> <c-w>-
map <C-S-Down> <c-w>+

map <silent> <A-Up> :wincmd k<CR>
map <silent> <A-Down> :wincmd j<CR>
map <silent> <A-Left> :wincmd h<CR>
map <silent> <A-Right> :wincmd l<CR>

execute pathogen#infect()

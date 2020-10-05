let g:ycm_python_binary_path = '/usr/bin/python3'

set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
"" alternatively, pass a path where Vundle should install plugins
""call vundle#begin('~/some/path/here')
"
"Plugin 'pyflakes/pyflakes'
Plugin 'preservim/nerdtree'
Plugin 'gmarik/Vundle.vim'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'tacahiroy/ctrlp-funky'
Plugin 'bling/vim-airline' " precisa instalar as fontes https://github.com/powerline/fonts/blob/master/install.sh
Plugin 'vim-airline/vim-airline-themes'
Plugin 'ycm-core/YouCompleteMe'
Plugin 'brooth/far.vim'
Plugin 'nvie/vim-flake8'
Plugin 'pangloss/vim-javascript'
Plugin 'mxw/vim-jsx'
Plugin 'editorconfig/editorconfig-vim'
Plugin 'ayu-theme/ayu-vim'
Plugin 'romainl/vim-qf'
Plugin 'Raimondi/delimitMate'
Plugin 'RRethy/vim-illuminate'
Plugin 'ryanoasis/vim-devicons'
Plugin 'tiagofumo/vim-nerdtree-syntax-highlight'
Plugin 'markonm/traces.vim'
Plugin 'dyng/ctrlsf.vim'
Plugin 'tidalcycles/vim-tidal'
"
call vundle#end()            " required
filetype plugin on           " required

"airline config
let g:airline_powerline_fonts = 1
let g:airline_section_z = ''
let g:airline_section_b = ''

let g:ycm_autoclose_preview_window_after_insertion = 1
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.pyc,*.pyo,__pycache__,*.sqlite3    " MacOSX/Linux

if has("gui_running")
   set guioptions-=T " disable toolbar
   set guioptions-=m " disable menu
   set guioptions-=r
   autocmd StdinReadPre * let s:std_in=1
   autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
   autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
endif


map <S-Insert> <MiddleMouse>

"Mapping para ligar e desligar a sintaxe
map <F7> :syntax on<CR>
map <F8> :syntax off<CR>
map <F1> <esc>a{}<esc>i%%<esc>i<space><space><esc>ha

"Mapping para NERDTree
map <C-T> :NERDTreeToggle<return>
let NERDTreeIgnore = ['\.pyc$', '\.pyo$', 'share$', 'include$', 'build$', '\.db$', '__pycache__$', 'node_modules$', '\.sqlite3$']
let NERDChristmasTree = 1
let g:NERDTreeFileExtensionHighlightFullName = 1
let g:NERDTreeExactMatchHighlightFullName = 1
let g:NERDTreePatternMatchHighlightFullName = 1
let g:NERDTreeHighlightFolders = 1 " enables folder icon highlighting using exact match
let g:NERDTreeHighlightFoldersFullName = 1 " highlights the folder name

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
set termguicolors     " enable true colors support
"let ayucolor="light"  " for light version of theme
"let ayucolor="dark"   " for dark version of theme
"let ayucolor="mirage" " for mirage version of theme
"colorscheme ayu

set autoread            "altera o arquivo no vim caso seja alterado por uma fonte externa
set autoindent          "identação automática
set softtabstop=4       "makes backspacing over spaced out tabs work real nice
set expandtab           "expand tabs to spaces
set shiftwidth=4
set tabstop=4
set termencoding=utf-8
set encoding=UTF-8
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
"set guifont=Dank\ Mono\ Regular\ 12
set guifont=Ubuntu\ Mono\ Regular\ 14
"set guifont=Ubuntu\ Nerd\ Font\ Mono\ 14


if !has("gui_running")
    :match Search '\%>80v.\+'
endif

autocmd FileType html,htmldjango,jinjahtml,eruby,mako let b:closetag_html_style=1
autocmd FileType html,xhtml,xml,htmldjango,jinjahtml,eruby,mako source ~/.vim/scripts/closetag.vim
autocmd FileType js,jsx setlocal shiftwidth=2 tabstop=2 softtabstop=2

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
autocmd BufWritePost *.py call flake8#Flake8()
autocmd BufWritePost *.pyde call flake8#Flake8()
let g:flake8_show_in_gutter=1  " show
let g:flake8_show_quickfix=1

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

map <C-S-Left> <c-w><
map <C-S-Right> <c-w>>
map <C-S-Up> <c-w>-
map <C-S-Down> <c-w>+

map <silent> <A-Up> :wincmd k<CR>
map <silent> <A-Down> :wincmd j<CR>
map <silent> <A-Left> :wincmd h<CR>
map <silent> <A-Right> :wincmd l<CR>

"map <C-X> :YcmCompleter GoTo<CR>
"map <C-A> :YcmCompleter GoToReferences<CR>

let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$|node_modules|bin|docs|build'

let mapleader=","
nnoremap <leader>W :CtrlSF

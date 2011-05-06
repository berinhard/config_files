map <S-Insert> <MiddleMouse>

map <F2> :bp<CR>
map <F3> :bn<CR>
map <F7> :syntax on<CR>
map <F8> :syntax off<CR>

map <C-T> :NERDTreeToggle<return>
let NERDTreeIgnore = ['\.pyc$', '\.pyo$']

vmap <space> zf

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
"         " Create the fold from l_min to l
         execute l_min . "," . l . " fold"
      endif
   else
      " Delete the fold on the current line
      normal zd
   endif
endfunction

nmap <space> :call ToggleFold()<CR>

vmap <C-S-c> :s/^/#/g <CR>
vmap <C-S-x> :s/^#//g <CR>

syntax on
colorscheme darkspectrum

set softtabstop=4       "makes backspacing over spaced out tabs work real nice
set expandtab           "expand tabs to spaces
set shiftwidth=4
set tabstop=4
set termencoding=utf-8
set nobackup
set fileencodings=ucs-bom,utf-8,default,latin1
set guifont=Monaco
set smartindent
set autoindent
set showmatch
set showcmd
set showmode
set ai

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

inoremap <tab> <c-r>=InsertTabWrapper()<cr>

set number
set hlsearch
set paste

set cursorline
:match Search '\%>80v.\+'

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
vim.command('map <C-P> :py remove_breakpoints()<cr>')

EOF

if has("gui_running")
  " If the current buffer has never been saved, it will have no name,
  " call the file browser to save it, otherwise just save it.
  :map <silent> <C-S> :if expand("%") == ""<CR>:browse confirm w<CR>:else<CR>:confirm w<CR>:endif<CR>
endif

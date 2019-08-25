" Enable Pathogen
execute pathogen#infect()
Helptags " Generate plugin docs

" If the terminal does not support underlines, highlight misspelled words by
" changing their background.
if !has("gui_running")
	let g:gruvbox_guisp_fallback = "bg"
endif
syntax on
color gruvbox

filetype indent on

let mapleader = ' '

set smartindent
set hidden
set wildmenu
set incsearch
set bg=dark
set colorcolumn=80
set number
set guifont=Monospace\ Regular\ 13
set showcmd
set splitright
set nohlsearch

" For per-project vimrc files
set exrc
set secure

" ---- Autocmds: ----

" Use different format options for mail and code.
set formatoptions=croqaj
augroup format_options
	autocmd!
	autocmd FileType mail,diff,gitcommit set formatoptions=trqlanw
augroup END

" Since I don't often work with C++, default all .h files to c instead of cpp
augroup h_filetype
	autocmd!
	autocmd BufRead,BufNewFile *.h set filetype=c
augroup END

" Strip trailing whitespace except for the file types in ignoreStripWhitespace
fun! StripWhitespace()
	let l:save = winsaveview()
	keeppatterns %s/\s\+$//e
	call winrestview(save)
endfun

let ignoreStripWhitespace = ['plaintext', 'mail', 'diff', 'gitcommit']
augroup strip_whitespace
	autocmd!
	autocmd BufWritePre * if index(ignoreStripWhitespace, &ft) < 0 | call StripWhitespace()
augroup END

" Set spellcheck on git commits, mails and patches
augroup auto_spell
	autocmd!
	autocmd FileType mail,diff,gitcommit,text set spell
augroup END

" Wrap lengths
augroup line_wrap
	autocmd!
	autocmd FileType mail,diff,gitcommit set textwidth=72
augroup END

" vim-fugitive by default collapses the diff body when viewing commits. Don't
" do that.
augroup fugitive_no_fold
	autocmd!
	autocmd FileType git set nofoldenable
augroup END

" ---- Plugin configs: ----

" Airline
let g:airline_section_warning = []
let g:airline_powerline_fonts = 1

" Ctrl-P
let g:ctrlp_switch_buffer = 'e'

" ---- Mappings: ----

" Add newlines without going into insert mode
nnoremap <S-Enter> O<Esc>
nnoremap <CR> o<Esc>

" Map window switching shortcuts
nnoremap <Leader>v :vsplit<CR>
nnoremap <Leader>l <C-w>l
nnoremap <Leader>h <C-w>h
nnoremap <Leader>j <C-w>j
nnoremap <Leader>k <C-w>k

" Paste/yank to/from system clipboard
nnoremap <Leader>p "+p
nnoremap <Leader>y "+y
vnoremap <Leader>y "+y

" Mappings for handling buffers
nnoremap <Leader>b :b<Space>
nnoremap <Leader>bd :bd<CR>
nnoremap <Leader>bb :b#<CR>
nnoremap <Leader>bl :ls<CR>

nnoremap <Leader>w :w<CR>

" When searching for something, set mark at a for where we start
nnoremap / ma/
nnoremap ? ma?
nnoremap * ma*
nnoremap # ma#

nnoremap Y y$

" Toggle search highlighting
nnoremap <Leader>s :set hlsearch!<CR>

" Quick binding to set filetype for git-send-email files I open from mutt and
" turn off spelling.
nnoremap <Leader>se :set ft=gitsendemail<CR>:set nospell<CR>

" Toggle spelling
nnoremap <Leader>sp :set nospell!<CR>

nnoremap <Leader>= <C-W>

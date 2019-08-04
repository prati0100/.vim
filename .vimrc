syntax on
filetype indent on
set smartindent
set hidden
set wildmenu
set incsearch

" Since I don't often work with C++, default all .h files to c instead of cpp
augroup h_filetype
	autocmd!
	autocmd BufRead,BufNewFile *.h set filetype=c
augroup END

" Enable Pathogen
execute pathogen#infect()
Helptags " Generate plugin docs

" If the terminal does not support underlines, highlight misspelled words by
" changing their background.
if !has("gui_running")
	let g:gruvbox_guisp_fallback = "bg"
endif
color gruvbox
set bg=dark

set colorcolumn=80
set number
set guifont=Monospace\ Regular\ 13
let mapleader = ","
set showcmd
set splitright

" Add newlines without going into insert mode
nmap <S-Enter> O<Esc>
nmap <CR> o<Esc>

" Commenting blocks of code.
augroup comment_block
	autocmd!
	autocmd FileType c,cpp,java,scala let b:comment_leader = '// '
	autocmd FileType sh,ruby,python   let b:comment_leader = '# '
	autocmd FileType conf,fstab,make  let b:comment_leader = '# '
	autocmd FileType tcl              let b:comment_leader = '# '
	autocmd FileType tex              let b:comment_leader = '% '
	autocmd FileType mail             let b:comment_leader = '> '
	autocmd FileType vim              let b:comment_leader = '" '
	noremap <silent> <Leader>cc :<C-B>silent <C-E>s/^/<C-R>=escape(b:comment_leader,'\/')<CR>/<CR>:nohlsearch<CR>
	noremap <silent> <Leader>cu :<C-B>silent <C-E>s/^\V<C-R>=escape(b:comment_leader,'\/')<CR>//e<CR>:nohlsearch<CR>
augroup END

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

" Airline config
let g:airline_section_warning = []

let g:ctrlp_switch_buffer = 'e'

" Mappings for handling buffers
nnoremap <Leader>b :b<Space>
nnoremap <Leader>bd :bd<CR>
nnoremap <Leader>bb :b#<CR>

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

inoremap jj <Esc>
cnoremap jj <C-c>

" Set spellcheck on git commits, mails and patches
augroup auto_spell
	autocmd!
	autocmd FileType mail,diff,gitcommit set spell
augroup END

" For per-project vimrc files
set exrc
set secure

" Wrap lengths
augroup line_wrap
	autocmd!
	autocmd FileType mail,diff,gitcommit set textwidth=72
augroup END

" Auto extend comment lines
set formatoptions+=r

nnoremap <Leader>w :w<CR>

" When searching for something, set mark at a for where we start
nnoremap / ma/
nnoremap ? ma?
nnoremap * ma*
nnoremap # ma#

nnoremap Y y$

set nohlsearch

" Toggle search highlighting
nnoremap <Leader>s :set hlsearch!<CR>

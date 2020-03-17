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
set guifont=DejaVu\ Sans\ Mono\ Book\ 13
set showcmd
set splitright
set nohlsearch
set go+=c
set nojoinspaces
set linebreak
set ttimeoutlen=0
set notimeout
set ttimeout
set backspace=indent,start,eol
set commentstring=#\ %s

" For MUComplete
set completeopt+=menuone
set completeopt+=noselect
set previewheight=2
set shortmess+=c
set dictionary+=spell

" For per-project vimrc files
set exrc
set secure

" ---- Autocmds: ----

" Use different format options for mail and code.
set formatoptions=croqaj
augroup format_options
	autocmd!
	autocmd FileType mail,markdown setlocal formatoptions=trqlanw |
		\ setlocal nosmartindent
	autocmd FileType gitcommit,diff,gitsendemail setlocal formatoptions=trqlan |
		\ setlocal nosmartindent
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

let ignoreStripWhitespace = ['plaintext', 'mail', 'diff', 'gitcommit', 'markdown']
augroup strip_whitespace
	autocmd!
	autocmd BufWritePre * if index(ignoreStripWhitespace, &ft) < 0 | call StripWhitespace()
augroup END

" Set spellcheck on git commits, mails and patches
augroup auto_spell
	autocmd!
	autocmd FileType mail,diff,gitcommit,text,markdown set spell
augroup END

" Wrap lengths
augroup line_wrap
	autocmd!
	autocmd FileType mail,diff,gitcommit,gitsendemail set textwidth=72
augroup END

augroup fugitive_config
	autocmd!
	" vim-fugitive by default collapses the diff body when viewing
	" commits. Don't do that.
	autocmd FileType git set nofoldenable
	" Mappings for signoff commits. Using 'cs' in the mappings adds
	" delay to the 'cs' binding for squash! commits, but let's see
	" how it pans out.
	autocmd FileType fugitive
		\ nnoremap csc :Gcommit -vs<CR> |
		\ nnoremap css :Gcommit -s<CR>
augroup END

" Comment strings for vim-commentary
augroup comment_strings
	autocmd!
	autocmd FileType mail setlocal commentstring=>\ %s
	autocmd FileType lua setlocal commentstring=--\ %s
	autocmd FileType c setlocal commentstring=//\ %s
	autocmd FileType vim setlocal commentstring="\ %s
augroup END

augroup omni
	autocmd!
	autocmd FileType c setlocal omnifunc=ccomplete#Complete
augroup END

" ---- Plugin configs: ----

" Airline
let g:airline_section_warning = []
let g:airline_powerline_fonts = 1

" Ctrl-P
let g:ctrlp_switch_buffer = 'e'
let g:ctrlp_user_command =
	\ ['.git', 'cd %s && git ls-files -co --exclude-standard']

" Disable default buffergator bindings
let g:buffergator_suppress_keymaps = 1

" Disable bufferline echo
let g:bufferline_echo = 0

" Obsession
"
" This will disable saving of session on buffer creation and change in
" vim-obsession because switching buffers gets really slow, especially on a
" hard disk.
"
" This means that the session will only be saved on exit, and if vim crashes,
" the session won't be saved, but I don't really care that much about my
" sessions. Performance is more important.

let g:obsession_no_bufenter = 1

" MUComplete
let g:mucomplete#enable_auto_at_startup = 1
let g:mucomplete#tab_when_no_results = 1
let g:mucomplete#minimum_prefix_length = 4
let g:mucomplete#completion_delay = 350

" Autocompletion sources for various file types.
let g:mucomplete#chains = {
	\ 'tcl'          : ['path', 'tags', 'c-n', 'c-p', 'incl'],
	\ }

" Fugitive convenience commands
:command Glogb Glog master..
:command -nargs=* Gp Gpush <args>
:command -nargs=* Gpf Gpush -f <args>

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

nnoremap <Leader>H <C-w>H
nnoremap <Leader>L <C-w>L

" Paste/yank to/from system clipboard
nnoremap <Leader>p "+p
nnoremap <Leader>y "+y
vnoremap <Leader>y "+y

" Mappings for handling buffers
nnoremap <Leader>b :b
nnoremap <Leader>bb :BuffergatorOpen<CR>
nnoremap <Leader>bd :bd<CR>
nnoremap <Leader>bl :ls<CR>
nnoremap <Leader>bp :b#<CR>

nnoremap <Leader>w :w<CR>

" When searching for something, set mark at a for where we start
nnoremap / ma/
nnoremap ? ma?
nnoremap * ma*
nnoremap # ma#

nnoremap Y y$

" Toggle search highlighting
nnoremap <Leader>sh :set hlsearch!<CR>

" Quick binding to set filetype for git-send-email files I open from mutt and
" turn off spelling.
nnoremap <Leader>se :set ft=gitsendemail<CR>:set nospell<CR>

" Toggle spelling
nnoremap <Leader>sp :set nospell!<CR>

nnoremap <Leader>= <C-W>

nnoremap 22 @@

" Select the recently pasted text in visual mode, just like gv does for
" recently selected text.
nnoremap gp `[v`]

fun! s:dismiss_or_delete()
	return pumvisible()
		\ && len(matchstr(getline('.'), '\S*\%'.col('.').'c')) <= get(g:, 'mucomplete#minimum_prefix_length', 4)
		\ ? "\<c-e>\<bs>" : "\<bs>"

endf
inoremap <expr> <bs> <sid>dismiss_or_delete()

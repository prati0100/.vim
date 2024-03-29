let mapleader = ' '
let maplocalleader = ','
syntax on
filetype plugin on
filetype indent on

" Enable Pathogen
execute pathogen#infect()
Helptags " Generate plugin docs

color gruvbox

set smartindent
set hidden
set wildmenu
set incsearch
set bg=dark
set colorcolumn=80
set number
set relativenumber
set guifont=Inconsolata\ Regular\ 14
set showcmd
set splitright
set nohlsearch
set guioptions=ac
set nojoinspaces
set linebreak
set ttimeoutlen=0
set notimeout
set ttimeout
set backspace=indent,start,eol
set commentstring=#\ %s
set cursorline
set tabstop=8

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
	autocmd FileType mail,markdown setlocal formatoptions=trqla2w |
		\ setlocal nosmartindent
	autocmd FileType gitcommit,diff,gitsendemail setlocal formatoptions=trqla2 |
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
	autocmd FileType git nnoremap <silent> yh :let @+ = fugitive#Object(@%)<CR>
	autocmd FileType fugitive nmap <Tab> =
augroup END

" Comment strings for vim-commentary
augroup comment_strings
	autocmd!
	autocmd FileType mail setlocal commentstring=>\ %s
	autocmd FileType lua setlocal commentstring=--\ %s
	autocmd FileType c setlocal commentstring=//\ %s
	autocmd FileType vim setlocal commentstring=\"\ %s
augroup END

augroup omni
	autocmd!
	autocmd FileType c setlocal omnifunc=lsp#complete
augroup END

augroup quickfix
	autocmd!
	autocmd FileType qf setlocal norelativenumber
augroup END

augroup org
	autocmd!
	" Highlight ticked checkboxes as comments

	" Ugh! This is so ugly. It is simple to highlight done checkboxes as
	" comments if you assume they will only be one line. But I often have
	" long text in them and want them to be multi-line.
	"
	" And so this pattern comes in the picture. The start condition is
	" simple: any line that starts with "   - [X]". The problem is the end
	" pattern. Right now this is a hack that ends the pattern if either of
	" the 3 conditions are met:
	"
	" 1. The line starts with "   -"
	" 2. The line starts with non-whitespace. This includes "*", etc.
	" 3. The line is blank.
	"
	" The "me=s-1" says that the end of region should be considered at
	" _before_ the start of matched patter.
	"
	" I am sure this misses a huge number of corner cases. But until I
	" learn writing vim syntax highlighting in Python this seems like my
	" best bet.
	autocmd FileType org syntax region MyOrgDone start='^\s\+- \[X\].*' end='^\s\+-\|^\S\|^$'me=s-1
	autocmd FileType org highlight default link MyOrgDone Comment

	autocmd FileType org setlocal cc=0 fo-=a nofoldenable sw=2 et sts=2
	autocmd FileType org nnoremap <silent> <Leader>D :call <SID>orgmode_todo_archive()<CR>
augroup END

augroup agit
	autocmd!
	" If I hit <Leader>l and I'm in the upper half of the log, it will
	" move me to the stat window. I do not want to go to the stat very
	" often. So instead make <Leader>l go left and down. That will always
	" land me in the diff window. Then I can use <Leader>k to go to stats
	" if I want.
	autocmd FileType agit nnoremap <Leader>l <C-w>b
	autocmd FileType agit set colorcolumn=0
augroup END

augroup mail_external
	autocmd!
	autocmd FileType mail :silent! %s/\(Subject:.*\)\[EXTERNAL\]\s*/\1/ |
		\ :silent! g/CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you can confirm the sender and know the content is safe.$/,+3d
augroup END

" ---- Plugin configs: ----

" Airline
let g:airline_section_warning = []
let g:airline_powerline_fonts = 1

" Disable default buffergator bindings
let g:buffergator_suppress_keymaps = 1

" Disable bufferline echo
let g:bufferline_echo = 0

" MUComplete
let g:mucomplete#enable_auto_at_startup = 1
let g:mucomplete#tab_when_no_results = 1
let g:mucomplete#minimum_prefix_length = 4

" Autocompletion sources for various file types.
let g:mucomplete#chains = {
	\ 'tcl'          : ['path', 'tags', 'c-n', 'c-p', 'incl'],
	\ }

" Fugitive convenience commands
:command Glogb Glog master..
:command -nargs=* Gp Gpush <args>
:command -nargs=* Gpf Gpush -f <args>

" Agit
let g:agit_max_author_name_width = -1

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
nnoremap <Leader>K <C-w>K
nnoremap <Leader>J <C-w>J

" Paste/yank to/from system clipboard
nnoremap <Leader>p "+p
nnoremap <Leader>P "+P
nnoremap <Leader>y "+y
nnoremap <Leader>Y "+y$
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

" Select the recently pasted text in visual mode, just like gv does for
" recently selected text.
nnoremap gp `[v`]

nnoremap <Leader>-a :set fo-=a<CR>
nnoremap <Leader>+a :set fo+=a<CR>

nnoremap <C-P> :Files<CR>

nnoremap <silent> <Leader>* :call <SID>rg()<CR>

nnoremap <Leader>gr iReviewed-by: Pratyush Yadav <ptyadav@amazon.de><ESC>

" ---- Custom Functions ----

" Move org mode todo item to archive (done.org)
function! s:orgmode_todo_archive()
	" Delete the subtree into the @0 register.
	normal "0dar
	let l:tree = @0
	let l:data = split(l:tree, '\n')

	" See if done.org can be found
	let l:target_dir = expand('%:p:h')
	let l:todo_file = expand('%:p')
	let l:done_file = substitute(l:todo_file, 'todo.org$', 'done.org', '')
	if !filewritable(l:done_file) && !filewritable(l:target_dir)
		echoerr "Can't write to file 'done.org'"
		return
	endif

	call writefile(l:data, l:done_file, "a")
endfunction

function! s:rg()
	let l:word = expand("<cword>")
	exe ":Rg " . l:word
endfunction

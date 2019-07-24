filetype indent on
set smartindent

" Enable Pathogen
execute pathogen#infect()
Helptags " Generate plugin docs

color dracula
set colorcolumn=80
set number
set guifont=Monospace\ Regular\ 12
let mapleader = ","
set showcmd
set splitright

" Add newlines without going into insert mode
nmap <S-Enter> O<Esc>
nmap <CR> o<Esc>

" Commenting blocks of code.
autocmd FileType c,cpp,java,scala let b:comment_leader = '// '
autocmd FileType sh,ruby,python   let b:comment_leader = '# '
autocmd FileType conf,fstab,make  let b:comment_leader = '# '
autocmd FileType tex              let b:comment_leader = '% '
autocmd FileType mail             let b:comment_leader = '> '
autocmd FileType vim              let b:comment_leader = '" '
noremap <silent> <Leader>cc :<C-B>silent <C-E>s/^/<C-R>=escape(b:comment_leader,'\/')<CR>/<CR>:nohlsearch<CR>
noremap <silent> <Leader>cu :<C-B>silent <C-E>s/^\V<C-R>=escape(b:comment_leader,'\/')<CR>//e<CR>:nohlsearch<CR>

" Map window switching shortcuts
nnoremap <Leader>v :vsplit<CR>
nnoremap <Leader>l <C-w>l
nnoremap <Leader>h <C-w>h
nnoremap <Leader>j <C-w>j
nnoremap <Leader>k <C-w>k

" Paste from system clipboard
nnoremap <Leader>p "+p

" Airline config
" Enable the list of buffers
let g:airline#extensions#tabline#enabled = 1

" Show just the filename
let g:airline#extensions#tabline#fnamemod = ':t'

" Show tab numbers
let g:airline#extensions#tabline#buffer_nr_show = 1

let g:ctrlp_switch_buffer = 'e'

" Shortcut to switch to a numbered buffer so I don't have to type ':b' every time
nnoremap <Leader>b :b<Space>
nnoremap <Leader>bd :bd<CR>

" Strip trailing whitespace except for the file types in ignoreStripWhitespace
fun! StripWhitespace()
	let l:save = winsaveview()
	keeppatterns %s/\s\+$//e
	call winrestview(save)
endfun

let ignoreStripWhitespace = ['plaintext', 'mail', 'diff']
autocmd BufWritePre * if index(ignoreStripWhitespace, &ft) < 0 | call StripWhitespace()

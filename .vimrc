if v:lang =~ "utf8$" || v:lang =~ "UTF-8$"
   set fileencodings=utf-8,latin1
endif

set nocompatible	" Use Vim defaults (much better!)
set bs=indent,eol,start		" allow backspacing over everything in insert mode
"set ai			" always set autoindenting on
"set backup		" keep a backup file
set viminfo='20,\"50	" read/write a .viminfo file, don't store more
			" than 50 lines of registers
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time

" Only do this part when compiled with support for autocommands
if has("autocmd")
  " In text files, always limit the width of text to 78 characters
  autocmd BufRead *.txt set tw=78
  " When editing a file, always jump to the last cursor position
  autocmd BufReadPost *
  \ if line("'\"") > 0 && line ("'\"") <= line("$") |
  \   exe "normal! g'\"" |
  \ endif
endif

if has("cscope") && filereadable("/usr/bin/cscope")
   set csprg=/usr/bin/cscope
   set csto=0
   set cst
   set nocsverb
   " add any database in current directory
   if filereadable("cscope.out")
      cs add cscope.out
   " else add database pointed to by environment
   elseif $CSCOPE_DB != ""
      cs add $CSCOPE_DB
   endif
   set csverb
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

filetype plugin on

if &term=="xterm"
     set t_Co=8
     set t_Sb=[4%dm
     set t_Sf=[3%dm
endif

" Don't wake up system with blinking cursor:
" http://www.linuxpowertop.org/known.php
let &guicursor = &guicursor . ",a:blinkon0"

"colorscheme anotherdark
set splitright
set incsearch
set number
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=0
set smartindent
set laststatus=2
set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [POS=%04l,%04v][%p%%]\ [LEN=%L]
set vb t_vb=

inoremap { {}<LEFT>
inoremap [ []<LEFT>
inoremap ( ()<LEFT>
nnoremap <SPACE>w :w<ENTER>
nnoremap <SPACE>q :q<ENTER>
nnoremap <SPACE>c :!perl -wc -Ilib -It/inc %<ENTER>
nnoremap <SPACE>p :!prove -lr -It/inc %<ENTER>
nnoremap <C-n> :bel vne 
noremap <C-m> :Align 
noremap <C-i> :Align =><ENTER>
" ½ÄÊ¬³ä¤·¤¿¸å¡¢¥«¡¼¥½¥ë²¼¤Î¥¿¥°¤Ø¥¸¥ã¥ó¥×
nnoremap ss :vsplit<ENTER><C-]>

" search_pm
noremap <C-h> :call Search_pm('vne')<ENTER>
noremap ff :call Search_pm('e')<ENTER>
noremap fd :call Search_pm('sp')<ENTER>

noremap <C-t> :call LoadTest('bel vne')<ENTER>
noremap <C-l> :call LoadTest('bel vne', 'directory')<ENTER>
 
"inoremap " ""<LEFT>
"inoremap ' ''<LEFT>
vnoremap { "zdi^V{<C-R>z}<ESC>
vnoremap [ "zdi^V[<C-R>z]<ESC>
vnoremap ( "zdi^V(<C-R>z)<ESC>
vnoremap " "zdi^V"<C-R>z"<ESC>
vnoremap ' "zdi^V'<C-R>z'<ESC>
" ÁªÂòÈÏ°Ï¤«¤é¸¡º÷ÍÑ
vnoremap z/ <ESC>/\%V
silent! nmap <unique> <SPACE> <Plug>(quickrun))

" #/usr/bin/perl¤ÎÌµ¤¤.t¸þ¤±filetype set
au BufNewFile,BufRead *.t set filetype=perl

"let g:neocomplcache_enable_at_startup = 1

" Ê¸»ú¥³¡¼¥É¤Î¼«Æ°Ç§¼±
if &encoding !=# 'utf-8'
  set encoding=japan
  set fileencoding=japan
endif
if has('iconv')
  let s:enc_euc = 'euc-jp'
  let s:enc_jis = 'iso-2022-jp'
  " iconv¤¬eucJP-ms¤ËÂÐ±þ¤·¤Æ¤¤¤ë¤«¤ò¥Á¥§¥Ã¥¯
  if iconv("\x87\x64\x87\x6a", 'cp932', 'eucjp-ms') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'eucjp-ms'
    let s:enc_jis = 'iso-2022-jp-3'
  " iconv¤¬JISX0213¤ËÂÐ±þ¤·¤Æ¤¤¤ë¤«¤ò¥Á¥§¥Ã¥¯
  elseif iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'euc-jisx0213'
    let s:enc_jis = 'iso-2022-jp-3'
  endif
  " fileencodings¤ò¹½ÃÛ
  if &encoding ==# 'utf-8'
    let s:fileencodings_default = &fileencodings
    let &fileencodings = s:enc_jis .','. s:enc_euc .',cp932'
    let &fileencodings = &fileencodings .','. s:fileencodings_default
    unlet s:fileencodings_default
  else
    let &fileencodings = &fileencodings .','. s:enc_jis
    set fileencodings+=utf-8,ucs-2le,ucs-2
    if &encoding =~# '^\(euc-jp\|euc-jisx0213\|eucjp-ms\)$'
      set fileencodings+=cp932
      set fileencodings-=euc-jp
      set fileencodings-=euc-jisx0213
      set fileencodings-=eucjp-ms
      let &encoding = s:enc_euc
      let &fileencoding = s:enc_euc
    else
      let &fileencodings = &fileencodings .','. s:enc_euc
    endif
  endif
  " Äê¿ô¤ò½èÊ¬
  unlet s:enc_euc
  unlet s:enc_jis
endif
" ÆüËÜ¸ì¤ò´Þ¤Þ¤Ê¤¤¾ì¹ç¤Ï fileencoding ¤Ë encoding ¤ò»È¤¦¤è¤¦¤Ë¤¹¤ë
if has('autocmd')
  function! AU_ReCheck_FENC()
    if &fileencoding =~# 'iso-2022-jp' && search("[^\x01-\x7e]", 'n') == 0
      let &fileencoding=&encoding
    endif
  endfunction
  autocmd BufReadPost * call AU_ReCheck_FENC()
endif
" ²þ¹Ô¥³¡¼¥É¤Î¼«Æ°Ç§¼±
set fileformats=unix,dos,mac
" ¢¢¤È¤«¡û¤ÎÊ¸»ú¤¬¤¢¤Ã¤Æ¤â¥«¡¼¥½¥ë°ÌÃÖ¤¬¤º¤ì¤Ê¤¤¤è¤¦¤Ë¤¹¤ë
if exists('&ambiwidth')
  set ambiwidth=double
endif

" Align¤òÆüËÜ¸ì´Ä¶­¤Ç»ÈÍÑ¤¹¤ë¤¿¤á¤ÎÀßÄê
:let g:Align_xstrlen = 3


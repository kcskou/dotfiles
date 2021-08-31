" Set default font to DejaVu Sans Mono and Lucida Console as fallback
if has("gui_gtk2")        " Linux
    set guifont=DejaVu\ Sans\ Mono\ 10,Lucida\ Console\ 10
  elseif has("gui_photon")
    set guifont=DejaVu\ Sans\ Mono:s10,Lucida\ Console:s10
  elseif has("gui_kde")
    set guifont=DejaVu\ Sans\ Mono/10/-1/5/50/0/0/0/1/0,
                \Lucida\ Console/10/-1/5/50/0/0/0/1/0
  elseif has("x11")
    set guifont=-*-courier-medium-r-normal-*-*-180-*-*-m-*-*
  else                    " Windows
    set guifont=DejaVu_Sans_Mono:h10:cDEFAULT,
                \Lucida_Console:h10:cDEFAULT
endif

set guioptions-=m         " Remove menu bar
set guioptions-=T         " Remove toolbar
set guioptions-=r         " Remove right-hand scrollbar

" <Shift-F1> -> Toggle gVim menu bar
nnoremap <S-F1> :if &go=~#'m'<Bar>set go-=m<Bar>else<Bar>set go+=m<Bar>endif<CR>

" <Shift-F2> -> Toggle gVim toolbar
nnoremap <S-F2> :if &go=~#'T'<Bar>set go-=T<Bar>else<Bar>set go+=T<Bar>endif<CR>

" <Shift-F3> -> Toggle gVim right-hand scrollbar
nnoremap <S-F3> :if &go=~#'r'<Bar>set go-=r<Bar>else<Bar>set go+=r<Bar>endif<CR>

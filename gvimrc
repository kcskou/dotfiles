set guioptions-=m         " Remove menu bar
set guioptions-=T         " Remove toolbar
set guioptions-=r         " Remove right-hand scrollbar

" <Shift-F1> -> Toggle gVim menu bar
nnoremap <S-F1> :if &go=~#'m'<Bar>set go-=m<Bar>else<Bar>set go+=m<Bar>endif<CR>

" <Shift-F2> -> Toggle gVim toolbar
nnoremap <S-F2> :if &go=~#'T'<Bar>set go-=T<Bar>else<Bar>set go+=T<Bar>endif<CR>

" <Shift-F3> -> Toggle gVim right-hand scrollbar
nnoremap <S-F3> :if &go=~#'r'<Bar>set go-=r<Bar>else<Bar>set go+=r<Bar>endif<CR>

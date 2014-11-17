if has('autocmd')
    autocmd GuiEnter * set t_vb=  " Disable the visual bell
endif

" Get rid of the annoying UI
set guioptions-=t       " Disable menu tear-offs
set guioptions-=T       " Disable the toolbar
set guioptions-=m       " Disable the menu
set guioptions-=R       " Disable the (right) scrollbar
set guioptions-=r       " Disable the (right) scrollbar
set guioptions-=l       " Disable the (left) scrollbar
set guioptions-=L       " Disable the (left) scrollbar
set guioptions-=a       " Share the copy buffer with visual mode

" gtk tabs are ugly
if has('gui_gtk')
    set guioptions-=e       " Kill off the GUI tabs
    if fontdetect#hasFontFamily("Source Code Pro for Powerline,Sauce Code Powerline")
        set guifont=Sauce\ Code\ Powerline\ 10
        let g:airline_powerline_fonts = 1
    elseif fontdetect#hasFontFamily("Droid Sans Mono")
        set guifont=DroidSansMono\ 10
    else
        set guifont=monospace\ 10
    endif
elseif has('gui_macvim')
    if fontdetect#hasFontFamily("Source Code Pro for Powerline")
        set guifont=Sauce\ Code\ Powerline:h12
        let g:airline_powerline_fonts = 1
    else
        set guifont=menlo:h12
    endif
endif

if exists("g:dejava_loaded")
    finish
endif
let g:dejava_loaded = 1

func! s:FindDecompiler() abort
    if executable("procyon-decompiler")
        return "procyon-decompiler"
    elseif executable("procyon")
        return "procyon"
    endif
endf

func! s:Decompile() abort
    let decompiler_exec = s:FindDecompiler()

    if empty(decompiler_exec)
        echo "You need to install *Procyon* to decompile java class file."
        return
    endif

    let tempfile = tempname()
    if tempfile !~# '\.class$'
        let tempfile .= ".class"
    endif
    exec "%w! ++bin " . tempfile

    silent %d _
    undojoin | silent keepjumps exec "%r !" decompiler_exec . " " . tempfile

    setl ft=java
    setl syntax=java
    setl readonly
    setl nomodified
endf

com! DejavaThis call <SID>Decompile()

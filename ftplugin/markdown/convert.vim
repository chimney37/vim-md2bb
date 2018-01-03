:command! Md2bb :call ConvertMarkdownToBBCode()
" Get SetextHeading ---------{{{
function! GetSetextHeadingFromText(text, start, count, type)
    if a:type == 1
        " bloody hack here for using (\w|[:])
        let setext_heading_regex = '\v\s{0,3}(\w|[:;\.\\,~\_])+(\s(\w|[:;\.\\,~\_])+)*\n\s{0,3}\=+'
    elseif a:type == 2
        let setext_heading_regex = '\v\s{0,3}(\w|[:;\.\\,~\_])+(\s(\w|[:;\.\\,~\_])+)*\n\s{0,3}\-+'
    endif
    "echom strpart(a:text,0,30)
    "echom match(a:text, setext_heading_regex, a:start)
    return matchstrpos(a:text, setext_heading_regex, a:start)
endfunction
"}}}

" Output BB Code to Buffer ---------------{{{
function! OutputToBBCodeBuffer(bufferstr)
    " Underscores indicate this is buffer,not a normal file
    let buf = bufwinnr('__BBCode__')
    if ( buf == -1)
        vsplit __BBCode__
    else
        execute buf . "wincmd w"  
    endif
    " Delete everything in this buffer (for using this buffer more than once
    silent normal! ggdG
    " set file type
    setlocal filetype=bbcode
    " buftype=nofile tells Vim that it should never write to disk
    setlocal buftype=nofile
    call append(0, split(a:bufferstr, '\v\n'))
endfunction
"}}}

" Conversion Functions -------------------{{{
function! ConvertSetextType1ToBB(matchlist)
    " do some filtering where necessary
    let matchsetextheading = substitute(a:matchlist[0],'\n','',"g")
    let matchsetextheading = substitute(matchsetextheading,'=','',"g")

    " Example: Convert to BBCode for H1
    return "[size=32]" . matchsetextheading . "[/size]"
endfunction

function! ConvertSetextType2ToBB(matchlist)
    " do some filtering where necessary
    let matchsetextheading = substitute(a:matchlist[0],'\n','',"g")
    let matchsetextheading = substitute(matchsetextheading,'-','',"g")

    " Example: Convert to BBCode for H2
    return "[size=24]" . matchsetextheading . "[/size]"
endfunction
"}}}

function! ConvertMarkdownToBBCode()
    echom "Converting from Markdown to Bulletin Board Code"
    " get content of all buffer
    let mdcodelist = getbufline(bufnr("%"), 1, "$")
    let mdcode = join(mdcodelist, "\n")
    "echom mdcodelist[0] 
    "echom strpart(mdcode, 0,30)

    " parse Setext headings
    " TODO:  Make this a loop, with recursive for nested,etc.
    
    let matchlist = GetSetextHeadingFromText(mdcode, 0, 1, 1)
    " matchlist[0] is matched text, matchlist[1] is start index, matchlist[2]
    " is endindex
    echom matchlist[0] . " " . string(matchlist[1]) . " " . string(matchlist[2])

    let bufferstr  = ""
    let bufferstr .= ConvertSetextType2ToBB(matchlist) . "\n"

    let matchlist = GetSetextHeadingFromText(mdcode, matchlist[2] + 1, 1, 2)

    echom matchlist[0] . " " . string(matchlist[1]) . " " . string(matchlist[2])

    let bufferstr .= ConvertSetextType2ToBB(matchlist) . "\n"

    call OutputToBBCodeBuffer(bufferstr)
endfunction



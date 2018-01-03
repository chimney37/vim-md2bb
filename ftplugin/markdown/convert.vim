:command! Md2bb :call ConvertMarkdownToBBCode()
" Get SetextHeading ---------{{{
function! GetSetextHeadingFromText(text, start, ...)
    if a:1 == 1
        " bloody hack here for using (\w|[:])
        let setext_heading_regex = '\v\s{0,3}(\w|[:;\.\\,~\_])+(\s(\w|[:;\.\\,~\_])+)*\n\s{0,3}\=+'
    elseif a:1 == 2
        let setext_heading_regex = '\v\s{0,3}(\w|[:;\.\\,~\_])+(\s(\w|[:;\.\\,~\_])+)*\n\s{0,3}\-+'
    endif
    "echom strpart(a:text,0,30)
    "echom match(a:text, setext_heading_regex, a:start)
    return matchstrpos(a:text, setext_heading_regex, a:start)
endfunction

function! GetAnyText(text, start, ...)
   let regex = '\v\S+(\s\S+)*\n'
   return matchstrpos(a:text, regex, a:start)
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
    return "[size=24]" . matchsetextheading . "[/size]" . "\n"
endfunction

function! ConvertOtherToBB(matchlist)
    return substitute(a:matchlist[0],'\n','',"g") . "\n"
endfunction

"}}}

function! ConvertMarkdownToBBCode()
    echom "Converting from Markdown to Bulletin Board Code"
    let line_ending = {"unix": "\n", "dos": "\r\n", "mac": "\r"}[&fileformat]
    " get content of all buffer
    let mdcodelist = getline(1, "$")
    let mdcode = join(mdcodelist, line_ending).line_ending
    "echom mdcodelist[0] 
    "echom strpart(mdcode, 0,30)

    let currentidx = 0
    let endidx = strchars(mdcode, 0) + len(mdcodelist) -1
    
    " parse Setext headings
    " TODO:  Make this a loop, with recursive for nested,etc.
    "echom string(len(mdcodelist))
    "echom mdcodelist[35]
    " Dict structure: Key:<ParseFunction>
    " Value:[[ParseFuncArgs],{<ConversionFuncName>:[ConversionFuncArgs]}]
    let functions = [
                \["GetSetextHeadingFromText",
                \ ["mdcode","startidx","1"],
                \ "ConvertSetextType1ToBB"],
                \["GetSetextHeadingFromText",
                \ ["mdcode","startidx","2"],
                \ "ConvertSetextType2ToBB"],
                \["GetAnyText",
                \ ["mdcode","startidx","0"],
                \ "ConvertOtherToBB"]
                \]
    let bufferstr  = ""
    let funclen = len(functions)
    "echom funclen
    while(currentidx < endidx)
        let n = 0
        while(n < funclen)
            "let matchlist = GetSetextHeadingFromText(mdcode, 0, 1)
            "echom string(functions[0])
            execute 'let matchlist = ' . substitute(string(functions[n][0]),"'","","g") . '(mdcode,' . string(currentidx).','. string(functions[n][1][2]).')'
            " matchlist[0] is matched text, matchlist[1] is start index, matchlist[2]
            " is endindex
            " Check if matchlist is empty
            if matchlist[1] >= 0
                "echom functions[n][0]
                echom matchlist[0] . " " . string(matchlist[1]) . " " . string(matchlist[2])
                execute 'let bufferstr .=' . substitute(string(functions[n][2]),"'","","g") . '(matchlist)'
                let currentidx = matchlist[2] 
                break
            else
                let n += 1
            endif
            "let bufferstr .= ConvertSetextType1ToBB(matchlist) . "\n"

            "let matchlist = GetSetextHeadingFromText(mdcode, matchlist[2] + 1, 2)
            "let bufferstr .= ConvertSetextType2ToBB(matchlist) . "\n"
        endwhile
        let currentidx += 1
    endwhile
    call OutputToBBCodeBuffer(bufferstr)
endfunction



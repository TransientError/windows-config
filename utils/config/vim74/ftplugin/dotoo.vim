iabbrev <buffer> <s #+begin_src<cr>#+end_src<Esc>O
nnoremap <buffer> >> I*<esc>
nnoremap <buffer> << 0x<esc>

function! s:smart_cr()
  let l:line = getline('.')
  let l:i = 0
  while l:line[i] == "*" && l:i < len(l:line)
    let l:i += 1
  endwhile

  let l:todo = ""
  if l:i + 4 < len(l:line)
    let l:org_keyword = l:line[l:i + 1:l:i + 4]
    if l:org_keyword ==# "TODO" || l:org_keyword ==# "DONE"
      let l:todo = " TODO"
    endif
  endif

  if l:i > 0
    return "\r\ed0xi" . repeat("*", l:i) . l:todo . "\<space>"
  else
    return "\r"
  endif
endfunction

inoremap <expr> <buffer> <CR> <sid>smart_cr()


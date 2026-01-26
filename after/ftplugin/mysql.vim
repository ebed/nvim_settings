" after/ftplugin/mysql.vim

" Limpia cualquier mapping previo en este buffer
silent! nunmap <buffer> <CR>
silent! xunmap <buffer> <CR>
silent! sunmap <buffer> <CR>

" Función: ejecutar el statement actual (delimitado por ';' o línea en blanco)
function! s:DBRunStmt() abort
  let l:cur  = line('.')
  let l:last = line('$')

  let l:s = l:cur
  while l:s > 1
    let l:prev = getline(l:s - 1)
    if l:prev =~ '^\s*$' || l:prev =~ ';[ \t]*$'
      break
    endif
    let l:s -= 1
  endwhile

  let l:e = l:cur
  while l:e <= l:last
    let l:ln = getline(l:e)
    if l:ln =~ ';[ \t]*$'
      break
    endif
    if l:ln =~ '^\s*$'
      let l:e -= 1
      break
    endif
    let l:e += 1
  endwhile

  if l:e < l:s | let l:e = l:s | endif
  if l:e > l:last | let l:e = l:last | endif

  execute printf('%d,%dDB', l:s, l:e)
endfunction

" Normal: Enter => ejecutar bloque actual
nnoremap <buffer> <silent> <CR> :<C-u>call <SID>DBRunStmt()<CR>

" Visual: Enter => ejecutar selección (necesita ':' para pasar '<,>')
xnoremap <buffer> <silent> <CR> :<C-u>DB<CR>

" Ejecutar todo el archivo
nnoremap <buffer> <silent> <leader><CR> :%DB<CR>

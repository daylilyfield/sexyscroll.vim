if g:did_load_sexyscroll
    finish
endif

let g:did_load_sexyscroll = 1

let g:sexyscroll_updatetime_backup = &updatetime

let g:sexyscroll_current_scrolling_buffers = {}

let g:sexyscroll_update_display_per_milliseconds =
        \ get(g:, 'sexyscroll_update_display_per_milliseconds' ,33)

let g:sexyscroll_map_recommended_settings =
        \ get(g:, 'sexyscroll_map_recommended_settings', 1)

let b:direction = ''
let b:lines = 0
let b:duration = 0
let b:total_moved = 0
let b:start_time = 0

function! g:sexyscroll(direction, lines, duration)

    if !s:is_currently_running()

        call s:check_arguments(a:direction, a:lines, a:duration)
    
        let b:direction = a:direction
        let b:lines = a:lines
        let b:duration = a:duration
    
        call s:install_autocmd()
    
        if empty(g:sexyscroll_current_scrolling_buffers)
            let g:updatetime_backup = &updatetime
            let &updatetime = g:sexyscroll_update_display_per_milliseconds
        endif
    
        let g:sexyscroll_current_scrolling_buffers[bufnr('%')] = 1
        let b:start_time = s:get_comparable_current_time()

    endif

endfunction

function! s:is_currently_running()

    return has_key(g:sexyscroll_current_scrolling_buffers, bufnr('%'))

endfunction

function! s:check_arguments(direction, lines, duration)
    
    if a:direction != 'up' && a:direction != 'down'
        echoerr 'illegal argument is specified. direction argument can accept "up" or "down".'
        finish
    endif

    if a:lines < 1
        echoerr 'illegal argument is specified. lines argument can accept positive number.'
        finish
    endif
 
    if a:duration < g:sexyscroll_update_display_per_milliseconds
        echoerr 'illegal argument is specified. duration argument can accept a positive number that is bigger than g:sexyscroll_update_display_per_milliseconds.'
    endif

endfunction

function! s:step()
    
    let current_time = s:get_comparable_current_time()
    let delta_time = current_time - b:start_time

    let factor = delta_time / (b:duration + 0.0)

    if factor >= 1.0 || s:is_on_edge()
        call s:finish_scrolling()
    else
        let delta_lines = float2nr(round(b:lines * factor)) 
        let next_move_amount = delta_lines - b:total_moved
        if next_move_amount >= 1
            if b:direction == 'up'
                let move_command = "normal " . string(next_move_amount) . "\<C-y>k"
            elseif b:direction == 'down'
                let move_command = "normal " . string(next_move_amount) . "\<C-e>j"
            endif
            execute move_command
            let b:total_moved = b:total_moved + next_move_amount
            redraw
        endif
        call feedkeys("f\e", 'n')
    endif
endfunction

function! s:is_on_edge()
    
    if b:direction == 'down' && line('w$') == line('$')
            \ || b:direction == 'up' && line('w0') == 1
        call s:finish_scrolling()
    endif

endfunction

function! s:finish_scrolling()

    call remove(g:sexyscroll_current_scrolling_buffers, bufnr('%'))
    if empty(g:sexyscroll_current_scrolling_buffers)
        call s:uninstall_autocmd()
        let &updatetime = g:sexyscroll_updatetime_backup
    endif
    let b:direction = ''
    let b:lines = 0
    let b:duration = 0
    let b:start_time = 0
    let b:total_moved = 0

endfunction

function! s:uninstall_autocmd()

    augroup sexyscroll
        autocmd!
    augroup end

endfunction

function! s:install_autocmd()

    augroup sexyscroll
        autocmd!
        autocmd CursorHold <buffer> :call <SID>step()
    augroup end

endfunction

function! s:get_comparable_current_time()

    let current_time = reltimestr(reltime())
    let seconds = strpart(current_time, 6, 4)
    let milliseconds = strpart(current_time, 11, 3)
    return seconds . milliseconds

endfunction

if g:sexyscroll_map_recommended_settings
    nnoremap <buffer> <C-d> :<C-u>call g:sexyscroll('down', &scroll, 500)<CR>
    nnoremap <buffer> <C-u> :<C-u>call g:sexyscroll('up', &scroll, 500)<CR>
    nnoremap <buffer> <C-f> :<C-u>call g:sexyscroll('down', &scroll * 2, 500)<CR>
    nnoremap <buffer> <C-b> :<C-u>call g:sexyscroll('up', &scroll * 2, 500)<CR>
endif

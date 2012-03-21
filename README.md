** sexyscroll.vim **
====================

To use this plugin, you can scroll your vim with smooth animation. You never
get lost if you press `<C-u>` or `<C-d>` many times.

How to Install
--------------

Place this plugin into vimfiles or .vim directory. I recommend pakcage
manager; [pathogen](https://github.com/tpope/vim-pathogen) or
[NeoBundle](https://github.com/Shougo/neobundle.vim) or something like that.

How to Use
----------

At first, please press `C-d`. As you see, a buffer scroll down with smooth scroll. Key maps that sexyscroll.vim asigns by default are described below.

- `<C-u>`: scroll up as much as `scroll` option value in 500 milliseconds.
- `<C-d>`: scroll down as much as `scroll` option value in 500 milliseconds.
- `<C-b>`: scroll up as much as double `scroll` option value in 500 milliseconds.
- `<C-f>`: scroll down as much as double `scroll` option value in 500 milliseconds.

Of course, you can set your own mappings.

How to Customize
---------------

sexyscroll.vim provides some global variables to customize its behavior.

- `g:sexyscroll_update_display_per_milliseconds`

  To use this variable, you canspecify display refresh rate.By default, this
  variable set to 33 milliseconds. So display refreshes approximately 30
  frames per secons. 

- `g:sexyscroll_map_recommended_settings`

  To use this variable, you can omit default key mappings described above. If
  you want to do so, you set this variable to `0`. 

Public APIs
-----------

sexyscroll.vim provides a public api.

- `g:sexyscroll(direction, lines, duration)`

  Start scroll up or down.

  `direction`: scroll direction. specify either `up` or `down`.
  `lines`: scroll amount.
  `duration`: scroll duration. specify it as milliseconds.

Caution
-------

This plugin uses and changes `updatetime` option to use animation for a limited
time. By default, plugin changes `updatetime` to 33 milliseconds for 500
millisecons. This settings required to run plugin on MacVim. If you are
worried about it, I recomend not to use this plugin.

VerifiedEnvironment
-------------------

- MacVim 7.3 (Kaoriya)
- Vim 7.3 (Kaoriya)

vim: tw=78

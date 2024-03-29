" ============================================================
" custom
"
" URL:
" Author: pnlybubbles
" License: Apache
" Last Change: 2017/03/24 13:37
" ============================================================

let g:airline#themes#custom#palette = {}

let s:normal1 = [ "#ff2a5f", "#1c1c1c", 197, 134 ]
let s:normal2 = [ "#292929", "#4e4e4e", 15, 239 ]
let s:normal3 = [ "#292929", "#4e4e4e", 15, 239 ]
let g:airline#themes#custom#palette.normal = airline#themes#generate_color_map(s:normal1, s:normal2, s:normal3)

let s:insert1 = [ "#4e4e4e", "#1c1c1c", 15, 114 ]
let s:insert2 = [ "#292929", "#4e4e4e", 15, 239 ]
let s:insert3 = [ "#292929", "#4e4e4e", 15, 239 ]
let g:airline#themes#custom#palette.insert = airline#themes#generate_color_map(s:insert1, s:insert2, s:insert3)

let s:replace1 = [ "#ffdf00", "#1c1c1c", 15, 203 ]
let s:replace2 = [ "#292929", "#4e4e4e", 15, 239 ]
let s:replace3 = [ "#292929", "#4e4e4e", 15, 239 ]
let g:airline#themes#custom#palette.replace = airline#themes#generate_color_map(s:replace1, s:replace2, s:replace3)

let s:visual1 = [ "#00afff", "#1c1c1c", 15, 209 ]
let s:visual2 = [ "#292929", "#4e4e4e", 15, 239 ]
let s:visual3 = [ "#292929", "#4e4e4e", 15, 239 ]
let g:airline#themes#custom#palette.visual = airline#themes#generate_color_map(s:visual1, s:visual2, s:visual3)

let s:inactive1 = [ "#292929", "#4e4e4e", 253, 239 ]
let s:inactive2 = [ "#292929", "#4e4e4e", 253, 239 ]
let s:inactive3 = [ "#292929", "#4e4e4e", 243, 239 ]
let g:airline#themes#custom#palette.inactive = airline#themes#generate_color_map(s:inactive1, s:inactive2, s:inactive3)


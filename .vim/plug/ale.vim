Plug 'dense-analysis/ale'

set completeopt=menu,menuone,preview,noselect,noinsert
let g:ale_completion_enabled = 1

let g:ale_linters = {'rust': ['analyzer']}

let g:ale_fixers = {'rust': ['rustfmt', 'trim+whitespaces', 'remove_trailing_lines']}

let g:ale_linters_explicit = 1

nnoremap <C-Enter> :ALEGoToDefinition<CR>

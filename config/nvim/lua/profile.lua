-- globals

local cmd = vim.cmd
local g = vim.g
local opt = vim.opt

local function map(mode, lhs, rhs, opts)
  local options = { noremap = true }
  if opts then options = vim.tbl_extend('force', options, opts) end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- remap space as leader.
vim.api.nvim_set_keymap('', '<Space>', '<Nop>', { noremap = true, silent = true })
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- show preview on search-replace.
cmd "set inccommand=split"

-- disable line wraps.
cmd ":set wrap!"

cmd "set updatetime=300"

-- use configured colours instead of cterm.
-- @url https://www.reddit.com/r/neovim/comments/dfe7gq/why_does_termguicolors_change_the_way_things_are/
cmd "set termguicolors"

-- enable syntax processing.
cmd "syntax enable"

-- fold all by default.
-- @todo Seems to be broken on live_grep?
-- @url https://stackoverflow.com/questions/2362914/fold-function-in-vim
-- cmd "set foldmethod=syntax"

-- always show 10 lines on scroll.
cmd "set scrolloff=10"

-- tab defaults.
cmd "set autoindent"
cmd "set backspace=indent,eol,start"
cmd "set complete-=i"
cmd "set smarttab"

-- clear search.
map('n', '<c-l>', ':let @/ = ""<CR>', { silent = true, noremap = true })

-- read detected changes outside vim.
cmd "set autoread"

-- set command history.
cmd "set history=1000"

-- enable line numbers.
cmd "set number"

-- show last command.
cmd "set showcmd"

-- highlight current line.
cmd "set cursorline"

-- show current position.
cmd "set ruler"

-- ignore case when searching.
cmd "set ignorecase"

-- add mapping to toggle right margin.
map('n', '<leader>c', ':execute "set colorcolumn=" . (&colorcolumn == "" ? "80" : "")<CR>')

-- 1 tab == 2 spaces.
cmd "set tabstop=2 softtabstop=0 expandtab shiftwidth=2 smarttab"

-- always show sign column.
-- :help signcolumn
cmd ":set signcolumn=yes"

-- enable mouse mode.
cmd ":set mouse=a"

-- map ESC to exit terminal mode.
-- @url https://neovim.io/doc/user/nvim_terminal_emulator.html
map('t', '<Esc>', '<C-\\><C-n>')

-- set shell to fish.
cmd ":set shell=/usr/bin/fish"

-- disable line numbers in terminal mode.
-- @url https://stackoverflow.com/questions/63906439/how-to-disable-line-numbers-in-neovim-terminal
cmd "autocmd TermOpen * setlocal nonumber norelativenumber"

-- theme: tokyonight.nvim

g.tokyonight_style = 'night'
g.tokyonight_hide_inactive_statusline = 1
g.tokyonight_italic_comments = 0
g.tokyonight_italic_keywords = 0
g.tokyonight_italic_functions = 0
g.tokyonight_italic_variables = 0
g.tokyonight_dark_float = 1
g.tokyonight_transparent_sidebar = 1

-- enable theme.
cmd "colorscheme tokyonight"

-- right margin background.
cmd "highlight ColorColumn ctermbg=0 guibg=#db4b4b"

-- enable spellcheck.
cmd ":set spell"

-- set telescope bg to match editor bg.
cmd "highlight TelescopeNormal guibg=#1a1b26"
cmd "highlight TelescopeBorder guibg=#1a1b26 guifg=#303145"
cmd "highlight TelescopeSelection guibg=#1a1b26"

-- plugin: lualine.nvim

require('lualine').setup({
  options = {
    icons_enabled = false,
    theme = 'tokyonight',
    component_separators = {
      left = '|',
      right = '|'
    },
    section_separators = {
      left = '',
      right = ''
    },
  },
  sections = {
    lualine_a = {
      'mode'
    },
    lualine_b = {},
    lualine_c = {
      'branch',
      {
        'diagnostics',
        symbols = {
          error = 'ERR:',
          warn = 'WRN:',
          info = 'INF:'
        }
      },
      'filename',
    },
    lualine_x = {
      'encoding',
      'fileformat',
      'filetype'
    },
    lualine_y = {
      'progress'
    },
    lualine_z = {
      'location'
    }
  }
})

-- plugin: nvim-tree.lua

g.nvim_tree_indent_markers = 1

g.nvim_tree_show_icons = {
  git = 1,
  folders = 1,
  files = 0,
  folder_arrows = 0,
}

g.nvim_tree_icons = {
  git = {
    unstaged = '∘',
    staged = '•',
    renamed = '•',
    untracked = '∘',
    deleted = "•",
  },
  folder = {
    arrow_open = "▿",
    arrow_closed = "▹",
    default = "▹",
    open = "▿",
    empty = "▫",
    empty_open = "▿",
    symlink = "▫",
    symlink_open = "▿",
  }
}

map('n', '<c-n>', ':NvimTreeToggle<CR>')

-- disable style for executables.
-- @url https://github.com/kyazdani42/nvim-tree.lua/issues/273
cmd "hi! def NvimTreeExecFile guifg=none guibg=none gui=NONE"

require('nvim-tree').setup({
  view = {
    width = 40,
    hide_root_folder = true,
  }
})

-- plugin: gitsigns.nvim

require('gitsigns').setup({
  current_line_blame = true
})

map('n', '<leader>hf', '<cmd>Gitsigns next_hunk<CR>')
map('n', '<leader>hb', '<cmd>Gitsigns prev_hunk<CR>')
map('n', '<leader>hs', '<cmd>Gitsigns stage_hunk<CR>')
map('n', '<leader>hr', '<cmd>Gitsigns reset_hunk<CR>')
map('n', '<leader>hS', '<cmd>Gitsigns stage_buffer<CR>')
map('n', '<leader>hu', '<cmd>Gitsigns undo_stage_hunk<CR>')
map('n', '<leader>hR', '<cmd>Gitsigns reset_buffer<CR>')
map('n', '<leader>hp', '<cmd>Gitsigns preview_hunk<CR>')

-- plugin: coc.nvim

vim.api.nvim_set_keymap('n', '<leader>dn', '<Plug>(coc-diagnostic-next)', { silent = true })
vim.api.nvim_set_keymap('n', '<leader>dp', '<Plug>(coc-diagnostic-prev)', { silent = true })
vim.api.nvim_set_keymap('n', '<leader>gd', '<Plug>(coc-definition)', { silent = true })
vim.api.nvim_set_keymap('n', '<leader>gi', '<Plug>(coc-implementation)', { silent = true })
vim.api.nvim_set_keymap('n', '<leader>gt', '<Plug>(coc-type-definition)', { silent = true })
vim.api.nvim_set_keymap('n', '<leader>rn', '<Plug>(coc-rename)', { silent = true })
vim.api.nvim_set_keymap('n', '<leader>ca', '<Plug>(coc-codeaction-selected)', { silent = true })
vim.api.nvim_set_keymap('n', '<leader>ol', ':call CocActionAsync("showOutline")<CR>', { silent = true })
vim.api.nvim_set_keymap('n', '<leader>do', ':call CocActionAsync("doHover")<CR>', { silent = true, noremap = true })
vim.api.nvim_set_keymap('n', '<leader>fo', ':call CocActionAsync("fold")<CR>', { silent = true, noremap = true })
vim.api.nvim_set_keymap('n', '<leader>li', ':CocCommand eslint.executeAutofix<CR>', { silent = true, noremap = true })
vim.api.nvim_set_keymap('n', '<leader>cl', '<Plug>(coc-codelens-action)', {})

-- highlight the symbol and its references when holding the cursor.
-- @url https://stackoverflow.com/questions/41416072/change-the-hold-time-of-the-cursor
cmd "autocmd CursorHold * silent call CocActionAsync('highlight')"

-- plugin: telescope.nvim

local tcpd = '{ prompt_title = "", results_title = "", preview_title = "" }'

local prompt_defaults = {
  prompt_title = "",
  results_title = "",
  preview_title = ""
}

require('telescope').setup({
  defaults = {
    theme = "tokyonight",
    selection_caret = "⇒ ",
    prompt_prefix = "$ ",
    layout_config = {
      preview_width = .6
    },
  },
  pickers = {
    find_files = prompt_defaults,
    live_grep = prompt_defaults,
    buffers = prompt_defaults,
    diagnostics = prompt_defaults,
    coc_diagnostics = prompt_defaults
  }
})

map('n', '<leader>sp', '<cmd>:lua require("telescope.builtin").spell_suggest(' .. tcpd .. ')<cr>')
map('n', '<leader>mk', '<cmd>:lua require("telescope.builtin").marks(' .. tcpd .. ')<cr>')
map('n', '<leader>fgs', '<cmd>:lua require("telescope.builtin").git_status(' .. tcpd .. ')<cr>')

-- plugin: telescope-fzf.nvim

require('telescope').load_extension('fzf')

map('n', '<leader>ff', '<cmd>lua require("telescope.builtin").find_files()<cr>')
map('n', '<leader>fsf', '<cmd>lua require("telescope.builtin").live_grep()<cr>')
map('n', '<leader>fsb', '<cmd>lua require("telescope.builtin").current_buffer_fuzzy_find()<cr>')
map('n', '<leader>fwf', '<cmd>lua require("telescope.builtin").grep_string()<cr>')
map('n', '<leader>fh', '<cmd>lua require("telescope.builtin").help_tags()<cr>')
map('n', '<leader>fb', '<cmd>lua require("telescope.builtin").buffers()<cr>')

-- plugin: telescope-coc.nvim

require('telescope').load_extension('coc')

local tcc = 'lua require("telescope").load_extension("coc")'
map('n', '<leader>di', '<cmd>' .. tcc .. '.diagnostics(' .. tcpd .. ')<cr>')
map('n', '<leader>re', '<cmd>' .. tcc .. '.references(' .. tcpd .. ')<cr>')
map('n', '<leader>sy', '<cmd>' .. tcc .. '.workspace_symbols(' .. tcpd .. ')<cr>')

-- show line numbers on preview.
-- NOTE: There is a known bug, see https://github.com/nvim-telescope/telescope.nvim/issues/1661
-- @url https://github.com/nvim-telescope/telescope.nvim/issues/1186
vim.cmd "autocmd User TelescopePreviewerLoaded setlocal number"

-- plugin: indent-blankline.nvim

require('indent_blankline').setup()

-- plugin: which-key.nvim

local wk = require('which-key')

wk.register({
  ["<leader>"] = {
    f = {
      name = "file",
      z = "Do something"
    },
  },
})

-- plugin: zen.nvim

require('zen-mode').setup({
  window = {
    width = 80,
    backdrop = 1
  }
})

map('n', '<leader>zm', ':ZenMode<cr>')

-- plugin: diffview.nvim

require('diffview').setup({
  use_icons = false,
  enhanced_diff_hl = true,
  icons = {
    folder_closed = "▹",
    folder_open = "▿"
  },
  signs = {
    fold_closed = "▹",
    fold_open = "▿"
  },
  file_panel = {
    width = 45
  }
})


map('n', '<leader>dvc', ':DiffviewClose<cr>')
map('n', '<leader>dvf', ':DiffviewToggleFiles<cr>')
cmd 'command! -nargs=* DV lua require"diffview".open(<q-args>)<cr>'
cmd 'command! -nargs=* DVH lua require"diffview".file_history(<q-args>)<cr>'

-- plugin: autopairs.nvim

require('nvim-autopairs').setup{{
  map_cr = true
}}


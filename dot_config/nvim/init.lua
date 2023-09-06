-- ╭──────────────────────────────────────────────────────────────────────────────╮
-- │                                                                              │
-- │                                   init.vim                                   │
-- │                                                                              │
-- ╰──────────────────────────────────────────────────────────────────────────────╯
-- ╭────────────────────────────────╮
-- │ 0.1. Define functions for init │
-- ╰────────────────────────────────╯
local function set_host_progs()
  -- let node_host_path = '/Users/steve.loveless/.nvm/versions/node/v16.16.0/bin'
  -- let $PATH = node_host_path . ':' . $PATH
  -- let g:node_host_prog = node_host_path . '/node'
  -- vim.g.node_host_prog = 'Users/steve.loveless/.nvm/versions/node/v16.16.0/lib/node_modules'
  -- vim.g.python_host_prog = vim.g.turboladen_homebrew_prefix .. '/bin/python2'
  -- vim.g.python3_host_prog = vim.g.turboladen_homebrew_prefix .. '/bin/python3'
end

-- ╭───────────────────────────────────────────────────────────────────────────────╮
-- │ Note to self: When I switched to nvim-oxi, I switched to follow its convention│
-- │ for loading the .so: put it in a dir that's in rtp, letting us load that by   │
-- │ simply doing:                                                                 │
-- │ lua require('init_rs')                                                        │
-- ╰───────────────────────────────────────────────────────────────────────────────╯
local function load_init_rs()
  local ffi = require("ffi")

  ffi.cdef [[
void init_mappings(void);
void init_options(void);
]]

  local project_path = vim.env.HOME .. "/Development/projects/init.rs"
  local suffix = ffi.os == "OSX" and ".dylib" or ".so"

  local lib = ffi.load(project_path .. "/target/release/libinit_rs" .. suffix)
  -- local lib = ffi.load(project_path .. "/target/debug/libnvim_rust_init" .. suffix)
  lib.init_mappings()
  lib.init_options()
end

local function define_wasm_autocmds()
  -- vim -b : edit binary using xxd-format!
  local wasm_group = vim.api.nvim_create_augroup("WasmGroup", {})

  vim.api.nvim_create_autocmd({ 'BufReadPre' }, {
    pattern = "*.wasm",
    group = wasm_group,
    command = "let &bin=1"
  })

  vim.api.nvim_create_autocmd({ 'BufReadPost' }, {
    pattern = "*.wasm",
    group = wasm_group,
    command = "if &bin | %!xxd"
  })
  vim.api.nvim_create_autocmd({ 'BufReadPost' }, {
    pattern = "*.wasm",
    group = wasm_group,
    command = "set ft=xxd | endif"
  })

  vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
    pattern = "*.wasm",
    group = wasm_group,
    command = "if &bin | %!xxd -r"
  })
  vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
    pattern = "*.wasm",
    group = wasm_group,
    command = "endif"
  })

  vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
    pattern = "*.wasm",
    group = wasm_group,
    command = "if &bin | %!xxd"
  })
  vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
    pattern = "*.wasm",
    group = wasm_group,
    command = "set nomod | endif"
  })
end

local function set_wild_opts()
  vim.opt.wildmode = { 'longest', 'full' }
  vim.opt.wildmenu = true

  vim.opt.wildignore = {
    -- Disable output and VCS files
    '*.o', '*.out', '*.obj', '*.rbc', '*.rbo',

    -- Disable archive files
    '*.zip', '*.tar.gz', '*.tar.bz2', '*.rar', '*.tar.xz',

    -- Ignore rails temporary asset caches
    '*/tmp/cache/assets/*/sprockets/*', '*/tmp/cache/assets/*/sass/*',

    -- Disable temp and backup files
    '*.swp', '*~', '._*',

    -- Ignore simplecov generated coverage docs
    'coverage/*',
  }
end

-- ╭────────────────────────────╮
-- │ 0. Load packer stuff first │
-- ╰────────────────────────────╯
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.loaded_perl_provider = 0
vim.opt.termguicolors = true

-- lazy.nvim things
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins", {
  dev = {
    path = "~/Development/projects/",
    patterns = { "turboladen" },
  },
  install = {
    colorscheme = { "nightfox" }
  },
  checker = {
    enabled = true
  }
})

-- Set the global var for the homebrew prefix.
-- require('turboladen/homebrew').prefix()

set_host_progs()
-- load_init_rs()

-- ╭────────────────────╮
-- │ 4. displaying text │
-- ╰────────────────────╯
-- set guifont=MonoLisaCustom\ Nerd\ Font:h13:i
vim.opt.guifont = 'MonoLisaCustom Nerd Font:h13:i'

vim.cmd.colorscheme("nightfox")
-- vim.cmd.colorscheme("kanagawa")
-- vim.cmd.colorscheme("everforest")
-- vim.cmd.colorscheme("material")
-- vim.cmd.colorscheme("falcon")
-- vim.cmd.colorscheme("github_dark_default")
-- vim.cmd.colorscheme("kosmikoa")
-- vim.cmd.colorscheme("kuroi")
-- vim.cmd.colorscheme("nordbuddy")
-- vim.cmd.colorscheme("uwu")

-- For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
vim.env.NVIM_TUI_ENABLE_TRUE_COLOR = true

-- ╭──────────────────────────────────────╮
-- │ 5. syntax, highlighting and spelling │
-- ╰──────────────────────────────────────╯
define_wasm_autocmds()

-- ╭────────────────────────────────────────────────────────────────────────╮
-- │ 17. mappings                                                           │
-- │ Trying out these options before deciding to keep them around (and move │
-- │ to their proper spot).                                                 │
-- ╰────────────────────────────────────────────────────────────────────────╯
local wk = require("which-key")

wk.register({
  n = { "execute('normal! ' . v:count1 . 'n')<CR><cmd>lua require('hlslens').start()" },
  N = { "execute('normal! ' . v:count1 . 'N')<CR><cmd>lua require('hlslens').start()" },
  p = { "p`]", "Paste, then move to end of text" },
  S = { "i<CR><ESC>^mwgk:silent! s/\v +$/<CR>:noh<CR>", "Split line, remove whitespace" },
  y = { "y`]", "Yank, then move to end of text", mode = "v" },
  -- ["<ESC>"] = { "<C-\\><C-N>", "Terminal: exit", mode = "t" },

  ["*"] = { "*<cmd>lua require('hlslens').start()<CR>" },
  ["#"] = { "#<cmd>lua require('hlslens').start()<CR>" },
  ["g*"] = { "g*<cmd>lua require('hlslens').start()<CR>" },
  ["g#"] = { "g#<cmd>lua require('hlslens').start()<CR>" },

  ["<C-l>"] = { "<C-w>l", "Move to right pane" },
  ["<C-h>"] = { "<C-w>h", "Move to left pane" },
  ["<C-j>"] = { "<C-w>j", "Move to down pane" },
  ["<C-k>"] = { "<C-w>k", "Move to up pane" },

  ["<leader><space>"] = { require('telescope.builtin').find_files, "Telescope: find_files" },
  ["<leader><cr>"] = { require('telescope.builtin').buffers, "Telescope: buffers" },
  ["<leader>/"] = { require('telescope.builtin').live_grep, "Telescope: live_grep" },

  ["<leader>["] = {
    "lua require('trouble').next({skip_groups = true, jump = true})",
    "Trouble: next item"
  },

  ["<leader>]"] = {
    "lua require('trouble').previous({skip_groups = true, jump = true})",
    "Trouble: previous item"
  },

  ["<leader>."] = { "<cmd>Rg<space>", "rg" },

  ["<leader>d"] = {
    name = "+dap",
    c = { require('dap').continue, "DAP: continue" },
    k = { require('dap').step_out, "DAP: step out" },
    l = { require('dap').step_into, "DAP: step into" },
    j = { require('dap').step_over, "DAP: step over" },
    b = { require('dap').toggle_breakpoint, "DAP: toggle breakpoint" },
    r = { require('dap').repl.open, "DAP: open REPL" },
    L = { require('dap').run_last, "DAP: open REPL" },
    e = { "lua require('dap').set_exception_breakpoints({'all'})", "DAP: set breakpoints on all exceptions" },
    t = { require('dap.ui').toggle, "DAP UI: toggle" },
    -- i = { require('dap.ui.variables').visual_hover },
    -- ["?"] = { require('dap.ui.variables').scopes },
  },

  ["<leader>e"] = {
    name = "+edit",
    v = { "vsplit $MYVIMRC", "Edit init.lua" },
    p = { "vsplit $HOME/.config/nvim/lua/plugins", "Edit plugins/" },
    l = { "vsplit $HOME/.config/nvim/lua/plugins/lsp.lua", "Edit lsp.lua" },
  },

  ["<leader>f"] = {
    name = "+find",
    k = { require('telescope.builtin').grep_string, "Telescope: grep_string" },
    m = { require('telescope.builtin').marks, "Telescope: marks" },
    o = { require('telescope.builtin').oldfiles, "Telescope: oldfiles" },
    t = { "<cmd>lua require('telescope.builtin').grep_string({search = 'TODO'})", "Telescope: TODOs" },
  },

  ["<leader>g"] = {
    name = "+git",
    s = { "<cmd>lua require('neogit').open({kind = 'split'})", "Open neogit" }
  },

  ["<leader>l"] = { require('lint').try_lint, "Lint" },

  ["<leader>st"] = { require("turboladen").strip_tabs, "Strip tabs!" },

  ["<leader>t"] = {
    name = "+test",
    n = { "<cmd>TestNearest<cr>", "Test: nearest" },
    f = { "<cmd>TestFile<cr>", "Test: file" },
    a = { "<cmd>TestSuite<cr>", "Test: all" },
    l = { "<cmd>TestLast<cr>", "Test: last" },
    v = { "<cmd>TestVisit<cr>", "Test: visit" },
  },

  ["<leader>x"] = {
    name = "+diagnostics",
    x = { "<cmd>Trouble<cr>", "Trouble" },
    w = { "<cmd>TroubleToggle workspace_diagnostics<cr>", "Trouble: workspace diags" },
    d = { "<cmd>TroubleToggle document_diagnostics<cr>", "Trouble: doc diags" },
    R = { "<cmd>TroubleToggle lsp_references<cr>", "Trouble: LSP references" },
    D = { "<cmd>TroubleToggle lsp_definitions<cr>", "Trouble: LSP definitions" },
    T = { "<cmd>TroubleToggle lsp_type_definitions<cr>", "Trouble: LSP typedefs" },
    r = { "<cmd>TroubleRefresh<cr>", "Trouble: refresh" },
    l = { "<cmd>TroubleToggle loclist<cr>", "Trouble: loclist" },
    q = { "<cmd>TroubleToggle quickfix<cr>", "Trouble: quickfix" },
  },
})

-- Visual mode mappings
wk.register({
  p = { "\"_dP", "Paste, then move to end of text" },
}, {
  mode = "v"
})

vim.cmd([[setglobal expandtab]])

-- ╭──────────────────────────╮
-- │ 20. command line editing │
-- ╰──────────────────────────╯
set_wild_opts()

vim.api.nvim_create_autocmd('BufRead', {
  group = vim.api.nvim_create_augroup('meowersdfsd', {}),
  pattern = "lua",
  callback = function(ev)
    vim.opt_local.expandtab = true
  end,
})

vim.api.nvim_create_autocmd({ "BufNewFile", 'BufRead' }, {
  group = vim.api.nvim_create_augroup('justfile_detect', {}),
  pattern = "justfile",
  callback = function()
    vim.opt_local.filetype = "just"
  end,
})

--------------------------------------

-- 2. moving around, searching and patterns
-- vim.opt.smartcase = true

-- 4. Displaying text
vim.opt.breakindent = true
vim.opt.cmdheight = 2
-- vim.opt.linebreak = true
vim.opt.list = true
vim.opt.listchars = "tab:▸ ,trail:.,nbsp:_,extends:❯,precedes:❮"
vim.opt.number = true
vim.opt.scrolloff = 2
vim.opt.showtabline = 2

-- 5. Syntax, highlighting and spelling
vim.opt.colorcolumn = "80,120"
vim.opt.cursorline = true
vim.opt.spelllang = "en_us"
vim.opt.spell = true
vim.opt.synmaxcol = 250
vim.opt.termguicolors = true

-- 6. Multiple windows
vim.opt.splitbelow = true
vim.opt.splitright = true

-- 11. Messages and info
vim.opt.shortmess:append('c')

-- 12. Selecting text
-- vim.opt.clipboard = "unnamed,unnamedplus"
vim.opt.completeopt = "menu,menuone,noselect"
vim.opt.undofile = true

-- 13. Tabs and indenting
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.smartindent = true
vim.opt.softtabstop = 2
vim.opt.tabstop = 2

-- 14. Folding
vim.opt.foldenable = false

-- 17. reading and writing files
vim.opt.writebackup = false

-- 18. the swap file
vim.opt.swapfile = false

-- 19. command line editing
vim.opt.history = 300

-- 21. running make and jumping to errors (quickfix)
vim.opt.grepprg = "rg --vimgrep --files"

-- 24. various
vim.opt.signcolumn = "yes"

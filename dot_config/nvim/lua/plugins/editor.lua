return {
  -- ╭──────────────────────────────────────────────────────────╮
  -- │    A file manager for Neovim which lets you edit your    │
  -- │              filesystem like you edit text               │
  -- ╰──────────────────────────────────────────────────────────╯
  {
    "elihunter173/dirbuf.nvim",
    event = "VeryLazy"
  },

  -- ╭─────────────────────────────────────────────────────╮
  -- │ Find, Filter, Preview, Pick. All lua, all the time. │
  -- ╰─────────────────────────────────────────────────────╯
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    -- lazy = false,
    dependencies = {
      "yamatsum/nvim-nonicons",
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "nvim-telescope/telescope-symbols.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = function()
      local icons = require("nvim-nonicons")

      return {
        defaults = {
          mappings = {
            i = {
              ["<esc>"] = require("telescope.actions").close,
            },
          },
          prompt_prefix = "  " .. icons.get("telescope") .. "  ",
          selection_caret = " ❯ ",
          entry_prefix = "   ",
        },
        pickers = {
          buffers = {
            theme = "cursor",
            previewer = false,
          },
          find_files = {
            theme = "dropdown",
            previewer = false,
          },
          lsp_code_actions = {
            theme = "cursor",
            layout_config = { height = 15 },
          },
          oldfiles = {
            theme = "dropdown",
          },
        },
      }
    end,
    keys = function()
      local utils = require("plugins.editor.telescope_utils")
      local builtins = require("telescope.builtin")

      return {
        {
          "<leader><space>",
          builtins.find_files,
          desc = "tele: find",
        },
        {
          "<leader><cr>",
          builtins.buffers,
          desc = "tele: buffers find",
        },
        {
          "<leader>/",
          builtins.live_grep,
          desc = "tele: live grep",
        },
        {
          "<leader>fk",
          builtins.grep_string,
          desc = "tele: string grep",
        },
        {
          "<leader>fm",
          builtins.marks,
          desc = "tele: marks",
        },
        {
          "<leader>fo",
          builtins.oldfiles,
          desc = "tele: old files",
        },
        {
          "<leader>fn",
          utils.nvim_config_files,
          desc = "Show files in ~/.config/nvim/",
        },
        {
          "<leader>fy",
          utils.yadm_files,
          desc = "Show YADM files",
        },
        {
          "<leader>fa",
          "<cmd>Telescope telescope-alternate alternate_file<CR>",
          desc = "Show alternate file",
        },
        {
          "<leader>fs",
          "<cmd>Telescope aerial<CR>",
          desc = "Show symbols via aerial",
        },
      }
    end
  },

  -- ╭───────────────────────────────────────────────────────────────────────╮
  -- │ Alternate between common files using pre-defined regexp. Just map the │
  -- │ patterns and starting navigating between files that are related.      │
  -- ╰───────────────────────────────────────────────────────────────────────╯
  {
    "otavioschwanck/telescope-alternate",
    dependencies = { "nvim-telescope/telescope.nvim" },
    opts = {
      mappings = {
        { "app/(.*)/(.*).js", {
          { "app/[1]/adapter.js",                                       "Adapter" },
          { "app/[1]/controller.js",                                    "Controller" },
          { "app/[1]/model.js",                                         "Model" },
          { "app/[1]/route.js",                                         "Route" },
          { "app/[1]/service.js",                                       "Service" },
          { "app/[1]/template.hbs",                                     "Template" },
          { "app/[1]/view.js",                                          "View" },
          { "../backend/app/assets/javascripts/pods/[1]/adapter.js",    "Old Adapter" },
          { "../backend/app/assets/javascripts/pods/[1]/controller.js", "Old Controller" },
          { "../backend/app/assets/javascripts/pods/[1]/model.js",      "Old Model" },
          { "../backend/app/assets/javascripts/pods/[1]/route.js",      "Old Route" },
          { "../backend/app/assets/javascripts/pods/[1]/view.js",       "Old View" },
          { "tests/[1]/controller-test.js",                             "Controller Tests" },
          { "tests/[1]/route-test.js",                                  "Route Tests" },
          { "tests/[1]/model-test.js",                                  "Model Tests" },
          { "tests/[1]/service-test.js",                                "Service Tests" },
          { "tests/[1]/view-test.js",                                   "View Tests" },
        } }
      },
      presets = { "rails", "rspec" }
    },
    config = function(_, opts)
      local telescope = require("telescope")
      require("telescope-alternate").setup(opts)

      telescope.load_extension("telescope-alternate")
    end
  },

  --  ╭────────────────────────────────────╮
  --  │ 💥 Create key bindings that stick. │
  --  ╰────────────────────────────────────╯
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    -- init = function()
    --   vim.o.timeout = true
    --   vim.o.timeoutlen = 300
    -- end,
    opts = {
      plugins = { spelling = true },
      defaults = {
        ["g"] = { name = "+goto" },
        ["]"] = { name = "+next" },
        ["["] = { name = "+prev" },
        ["<leader><tab>"] = { name = "+tabs" },
        ["<leader>b"] = { name = "+buffer" },
        ["<leader>c"] = { name = "+code" },
        ["<leader>f"] = { name = "+file/find" },
        ["<leader>g"] = { name = "+git" },
        ["<leader>t"] = { name = "+test" },
        ["<leader>s"] = { name = "+search" },
        ["<leader>u"] = { name = "+ui" },
        ["<leader>w"] = { name = "+windows" },
        ["<leader>x"] = { name = "+diagnostics/quickfix" },
      }
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
      wk.register(opts.defaults)
    end
  },

  {
    "lewis6991/gitsigns.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "✚" },
        change = { text = "▎" },
        delete = { text = "✖" },
        changedelete = { text = "⇄" },
      },
      current_line_blame = true,
      yadm = { enable = true },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function get_next_hunk()
          if vim.wo.diff then return ']c' end
          -- vim.schedule(function() require("gitsigns").next_hunk() end)
          vim.schedule(function() gs.next_hunk() end)
          return '<Ignore>'
        end

        local function get_prev_hunk()
          if vim.wo.diff then return '[c' end
          -- vim.schedule(function() require("gitsigns").prev_hunk() end)
          vim.schedule(function() gs.prev_hunk() end)
          return '<Ignore>'
        end

        local function toggle_blame()
          -- require("gitsigns").toggle_current_line_blame()
          gs.toggle_current_line_blame({ full = true })
        end

        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
        end

        -- Actions
        map("n", "]c", get_next_hunk, "Next hunk")
        map("n", "[c", get_prev_hunk, "Previous hunk")
        map("n", "<leader>ghb", toggle_blame, "Toggle git blame line")
      end,
    },
    config = function(_, opts)
      require("gitsigns").setup(opts)
    end
  },


  -- ╭──────────────────────────────────────────────────────────────────────╮
  -- │ 🚦 A pretty diagnostics, references, telescope results, quickfix and │
  -- │ location list to help you solve all the trouble your code is causing.│
  -- ╰──────────────────────────────────────────────────────────────────────╯
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = { "Trouble", "TroubleRefresh", "TroubleToggle" },
    opts = {
      -- auto_preview = false,
      auto_close = true,
      use_diagnostic_signs = true
    },
    config = function(_, opts)
      require("trouble").setup(opts)
    end,
    keys = {
      {
        "<leader>xx",
        "<cmd>Trouble<cr>",
        desc = "Trouble",
      },
      {
        "<leader>xr",
        "<cmd>TroubleRefresh<cr>",
        desc = "Trouble: refresh",
      },
      {
        "<leader>xl",
        "<cmd>Trouble loclist<cr>",
        desc = "Trouble: -> loclist",
      },
      {
        "<leader>xq",
        "<cmd>Trouble quickfix<cr>",
        desc = "Trouble: -> quickfix",
      },
      {
        "<leader>xw",
        "<cmd>Trouble workspace_diagnostics<cr>",
        desc = "Trouble: workspace diags",
      },
      {
        "<leader>xd",
        "<cmd>Trouble document_diagnostics<cr>",
        desc = "Trouble: doc diags",
      },
      {
        "<leader>xR",
        "<cmd>Trouble lsp_references<cr>",
        desc = "Trouble: LSP references",
      },
      {
        "<leader>xD",
        "<cmd>Trouble lsp_definitions<cr>",
        desc = "Trouble: LSP definitions",
      },
      {
        "<leader>xT",
        "<cmd>Trouble lsp_type_definitions<cr>",
        desc = "Trouble: LSP type defs",
      },
      {
        "<leader>]",
        "<cmd>lua require('trouble').next({skip_groups = true, jump = true})<cr>",
        desc = "Trouble: next",
      },
      {
        "<leader>[",
        "<cmd>lua require('trouble').prev({skip_groups = true, jump = true})<cr>",
        desc = "Trouble: prev",
      },
    }
  },

  -- ╭─────────────────────────────────────────╮
  -- │ Neovim plugin for a code outline window │
  -- ╰─────────────────────────────────────────╯
  {
    "stevearc/aerial.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons"
    },
    lazy = true,
    opts = {
      filter_kind = false,
      on_attach = function(bufnr)
        local opts = { noremap = true, silent = true, buffer = bufnr }

        -- Aerial does not set any mappings by default, so you'll want to set some up
        -- Toggle the aerial window with <leader>a
        vim.keymap.set("n", "<leader>aa", require("aerial").toggle, opts)

        -- Jump forwards/backwards with '{' and '}'
        vim.keymap.set("n", "{", require("aerial").prev, opts)
        vim.keymap.set("n", "}", require("aerial").next, opts)

        -- Jump up the tree with '[[' or ']]'
        vim.keymap.set("n", "[[", require('aerial').prev_up, opts)
        vim.keymap.set("n", "]]", require('aerial').next_up, opts)
      end
    },
    config = function(_, opts)
      local telescope = require("telescope")
      require("aerial").setup(opts)
      telescope.load_extension('aerial')
    end
  },

  -- ╭──────────────────────────────────────────────────────────────────────────╮
  -- │ Highlight and search for todo comments like TODO, HACK, BUG in your      │
  -- │ code base.                                                               │
  -- ╰──────────────────────────────────────────────────────────────────────────╯
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = { "TodoTrouble", "TodoTelescope" },
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
    -- config = function(_, opts)
    --   vim.keymap.set("n", "]t", require("todo-comments").jump_next, { desc = "Next todo comment" })
    --   vim.keymap.set("n", "[t", require("todo-comments").jump_prev, { desc = "Previous todo comment" })
    -- end,
    keys = {
      { "]t",         function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
      { "[t",         function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
      { "<leader>xt", "<cmd>TodoTrouble<cr>",                              desc = "Todo (Trouble)" },
      { "<leader>xT", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>",      desc = "Todo/Fix/Fixme (Trouble)" },
      { "<leader>st", "<cmd>TodoTelescope<cr>",                            desc = "Todo" },
      { "<leader>sT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>",    desc = "Todo/Fix/Fixme" },
    },
  },

  -- ╭──────────────────────────╮
  -- │ Hlsearch Lens for Neovim │
  -- ╰──────────────────────────╯
  {
    "kevinhwang91/nvim-hlslens",
    keys = {
      {
        "n",
        [[<cmd>execute('normal! ' . v:count1 . 'n')<CR><cmd>lua require('hlslens').start()<CR>]],
        { desc = "Go to next search match" }
      },
      {
        "N",
        [[<cmd>execute('normal! ' . v:count1 . 'N')<CR><cmd>lua require('hlslens').start()<CR>]],
        { desc = "Go to previous search match" }
      },
      {
        "*",
        [[*<cmd>lua require('hlslens').start()<CR>]],
        { desc = "Search forward for <word> under cursor" }
      },
      {
        "#",
        [[#<cmd>lua require('hlslens').start()<CR>]],
        { desc = "Search backward for <word> under cursor" }
      },
      {
        "g*",
        [[g*<cmd>lua require('hlslens').start()<CR>]],
        { desc = "Search forward for word under cursor" }
      },
      {
        "g#",
        [[g#<cmd>lua require('hlslens').start()<CR>]],
        { desc = "Search backward for word under cursor" }
      },
      { "<leader>l", ":noh<CR>", { desc = "Stop highlighting the hlsearch" } },
    },
    opts = {}
  },
  -- ╭─────────────────────────────────────────────────────────────╮
  -- │ Vim sugar for the UNIX shell commands that need it the most │
  -- ╰─────────────────────────────────────────────────────────────╯
  {
    "tpope/vim-eunuch",
    cmd = {
      "Chmod",
      "Delete",
      "Mkdir",
      "Move",
      "Remove",
      "Rename",
      "Unlink",
    },
  },

  -- ╭──────────────────────────────────────────────────────────────────────────╮
  -- │ Asynchronous build and test dispatcher. Used for running specs in a      │
  -- │ separate tmux pane.                                                      │
  -- ╰──────────────────────────────────────────────────────────────────────────╯
  {
    "tpope/vim-dispatch",
    cmd = {
      "AbortDispatch",
      "Copen",
      "Dispatch",
      "FocusDispatch",
      "Make",
      "Spawn",
      "Start",
    },
    init = function()
      vim.g.dispatch_no_maps = 1
    end
  },

  -- ╭───────────────────────────────────────────────────────────╮
  -- │ Use RipGrep in Vim and display results in a quickfix list │
  -- ╰───────────────────────────────────────────────────────────╯
  {
    "jremmen/vim-ripgrep",
    cmd = "Rg",
    init = function()
      vim.g.rg_command = "rg --vimgrep --ignore-vcs"
      -- vim.g.rg_highlight = 1
    end
  },

  -- ╭────────────────────────────────────────────────────────╮
  -- │ Delete all the buffers except the current/named buffer │
  -- ╰────────────────────────────────────────────────────────╯
  { "vim-scripts/BufOnly.vim", cmd = "BufOnly" },

  -- ╭────────────────────────────────────────╮
  -- │ Enhanced terminal integration for Vim. │
  -- ╰────────────────────────────────────────╯
  {
    "wincent/terminus",
    event = "VeryLazy"
  },

  -- ╭──────────────────────────────────────────╮
  -- │ Change code right in the quickfix window │
  -- ╰──────────────────────────────────────────╯
  {
    "stefandtw/quickfix-reflector.vim",
    event = "VeryLazy"
  },
}

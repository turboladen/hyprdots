--         ╭──────────────────────────────────────────────────────────╮
--         │    ✨ Clarify and beautify your comments using boxes     │
--         │                        and lines.                        │
--         ╰──────────────────────────────────────────────────────────╯

---Make an centered box with centered text, then format. Good for file headers.
--
---@param style number
local function cc_box(style)
  style = style or 3
  require("comment-box").ccbox(style)
  vim.lsp.buf.format({ async = false })
end

function TurboladenCcBox(style)
  cc_box(style)
end

---Make an adapted box with left-aligned text, then format.
--
---@param style number
local function al_box(style)
  require("comment-box").albox(style)
  vim.lsp.buf.format({ async = false })
end

function TurboladenAlBox(style)
  al_box(style)
end

return {
  "LudoPinelli/comment-box.nvim",
  lazy = true,
  cmd = {
    --  ╭──────────────────────────────────────────────────────────╮
    --  │ Left aligned boxes                                       │
    --  ╰──────────────────────────────────────────────────────────╯
    "CBllbox", -- Left-aligned box of fixed size with Left-aligned text
    "CBlcbox", -- Left-aligned box of fixed size with centered text
    "CBlrbox", -- Left-aligned box of fixed size with Right-aligned text

    --         ╭──────────────────────────────────────────────────────────╮
    --         │ Centered boxes                                           │
    --         ╰──────────────────────────────────────────────────────────╯
    "CBclbox", -- Centered box of fixed size with Left-aligned text
    "CBccbox", -- Centered box of fixed size with centered text
    "CBcrbox", -- Centered box of fixed size with Right-aligned text

    --                  ╭──────────────────────────────────────────────────────────╮
    --                  │ Right aligned boxes                                      │
    --                  ╰──────────────────────────────────────────────────────────╯
    "CBrlbox", -- Right-aligned box of fixed size with Left-aligned text
    "CBrcbox", -- Right-aligned box of fixed size with centered text
    "CBrrbox", -- Right-aligned box of fixed size with Right-aligned text

    --  ╭───────────────╮
    --  │ Adapted boxes │
    --  ╰───────────────╯
    "CBalbox", -- Left-aligned adapted box
    "CBacbox", -- Centered adapted box
    "CBarbox", -- Right-aligned adapted box

    --  ────────────────────────────────────────────────────────────
    --    Line things
    --  ├──────────────────────────────────────────────────────────┤
    "CBline",  -- Left-aligned line
    "CBcline", -- Centered line
    "CBrline", -- Right-aligned line

    -- Show the catalog
    "CBcatalog"
  },
  keys = {
    { "<leader>bb", al_box, mode = { "n", "v" }, desc = "Left-aligned box; left-aligned text" },
    { "<leader>bt", cc_box, desc = "Title box" },
  }
}

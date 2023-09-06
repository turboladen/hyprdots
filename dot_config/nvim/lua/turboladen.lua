local function strip_tabs()
  vim.opt_local.expandtab = true
  vim.cmd("retab")
end

return {
  signs = { Error = " ", Warn = " ", Hint = " ", Info = " " },
  strip_tabs = strip_tabs
}

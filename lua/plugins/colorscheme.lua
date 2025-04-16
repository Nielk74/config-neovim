return {
  {
    "martinsione/darkplus.nvim",
    config = function()
      vim.cmd("colorscheme darkplus")

      -- Example tweaks (adjust as needed)
      vim.api.nvim_set_hl(0, "@function", { fg = "#DCDCAA" }) -- yellowish like VSCode
      vim.api.nvim_set_hl(0, "@type", { fg = "#4EC9B0" }) -- tealish
      vim.api.nvim_set_hl(0, "@variable", { fg = "#9CDCFE" }) -- blue
      vim.api.nvim_set_hl(0, "@keyword", { fg = "#C586C0" }) -- purple
    end,
  },
}

-- ~/.config/nvim/lua/plugins/telescope.lua
return {
  "nvim-telescope/telescope.nvim",
  opts = function(_, opts)
    -- Merge your custom config into LazyVim’s
    opts.defaults = vim.tbl_deep_extend("force", opts.defaults or {}, {
      prompt_prefix = "🔍 ",
      selection_caret = "➤ ",
      sorting_strategy = "ascending",
      layout_config = {
        prompt_position = "bottom",
        width = 0.8,
        height = 0.6,
      },
      layout_strategy = "horizontal",
      winblend = 10,
      border = true,
      file_ignore_patterns = { "node_modules", ".git/", "dist/", "build/" },
      mappings = {
        i = {
          ["<C-j>"] = "move_selection_next",
          ["<C-k>"] = "move_selection_previous",
        },
      },
    })
  end,
}

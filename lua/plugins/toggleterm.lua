-- ~/.config/nvim/lua/plugins/toggleterm.lua
return {
  "akinsho/toggleterm.nvim",
  version = "*",
  config = function()
    require("toggleterm").setup {
      -- Exemple de config de base
      size = 20,
      open_mapping = [[<C-\>]],
      direction = "float", -- float | vertical | horizontal | tab
      shade_terminals = true,
      start_in_insert = true,
      insert_mappings = true,
      terminal_mappings = true,
    }
  end,
}

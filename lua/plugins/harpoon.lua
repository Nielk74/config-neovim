-- plugins/harpoon.lua
return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2", -- latest version
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local harpoon = require("harpoon")

    harpoon:setup() -- basic setup

    -- Example keymaps
    local function map(lhs, rhs)
      vim.keymap.set("n", lhs, rhs, { desc = "Harpoon: " .. lhs })
    end
--vim.keymap.set("n", "<leader>e", function()
--  require("harpoon.ui"):toggle_quick_menu(require("harpoon"):list())
--end, { desc = "Harpoon: Toggle Menu" })

    map("<leader>a", function() harpoon:list():add() end)
--    map("<leader>e", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
    map("<leader>&", function() harpoon:list():select(1) end)
    map("<leader>é", function() harpoon:list():select(2) end)
    map("<leader>\"", function() harpoon:list():select(3) end)
    map("<leader>'", function() harpoon:list():select(4) end)
  end,
}

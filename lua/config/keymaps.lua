-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--vim.keymap.set("n", "<leader>tt", "<cmd>ToggleTerm direction=float<cr>", { desc = "Terminal flottant" })
--vim.keymap.set("n", "<leader>tv", "<cmd>ToggleTerm direction=vertical<cr>", { desc = "Terminal vertical" })
--vim.keymap.set("n", "<leader>th", "<cmd>ToggleTerm direction=horizontal<cr>", { desc = "Terminal horizontal" })
-- Fonction utilitaire pour créer un nouveau terminal avec un ID auto-incrémenté
local Terminal = require("toggleterm.terminal").Terminal
local term_id = 1000 -- point de départ, pour éviter les conflits avec les IDs par défaut

function OpenNewTerminal(direction)
  term_id = term_id + 1
  local new_term = Terminal:new({ direction = direction, count = term_id })
  new_term:toggle()
end

-- Mappings
vim.keymap.set("n", "<leader>th", function() OpenNewTerminal("horizontal") end, { desc = "Nouveau terminal horizontal" })
vim.keymap.set("n", "<leader>tv", function() OpenNewTerminal("vertical") end, { desc = "Nouveau terminal vertical" })
vim.keymap.set("n", "<leader>tf", function() OpenNewTerminal("float") end, { desc = "Nouveau terminal flottant" })




vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { desc = "Sortir du mode terminal" })

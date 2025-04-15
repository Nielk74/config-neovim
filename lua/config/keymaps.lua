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
vim.keymap.set("n", "<leader>th", function()
  OpenNewTerminal("horizontal")
end, { desc = "Nouveau terminal horizontal" })
vim.keymap.set("n", "<leader>tv", function()
  OpenNewTerminal("vertical")
end, { desc = "Nouveau terminal vertical" })
vim.keymap.set("n", "<leader>tf", function()
  OpenNewTerminal("float")
end, { desc = "Nouveau terminal flottant" })

vim.keymap.set("n", "H", "^", { desc = "Go to first non-blank character" })
vim.keymap.set("n", "L", "$", { desc = "Go to last non-blank character" })

--vim.keymap.set("n", "<leader>fh", function()
--  require("telescope").extensions.harpoon.marks()
--end, { desc = "Harpoon: Marks (Telescope)" })
--[[
vim.keymap.set("n", "<leader>hr", function()
  local harpoon = require("harpoon")
  local list = harpoon:list()
  local current_file = vim.fn.expand("%:p")
  for i, item in ipairs(list.items) do
    if item.value == current_file then
      list:removeAt(i)
      vim.notify("Removed current file from Harpoon")
      break
    end
  end
end, { desc = "Harpoon: Remove Current File" })
--]]
--vim.keymap.set("n", "<leader>fp", function()
--  require("telescope.builtin").find_files()
--end, { desc = "Telescope: Find Files" })

vim.keymap.set("n", "<leader>fp", function()
  require("telescope.builtin").find_files(require("telescope.themes").get_dropdown({
    -- previewer = false, -- disable preview for speed
    cwd = require("lazyvim.util").root(),
  }))
end, { desc = "Telescope: Find Files (Dropdown)" })

vim.keymap.set("n", "<leader>de", function()
  vim.diagnostic.open_float(nil, {
    focus = true,
    scope = "line",
    border = "rounded",
    max_width = 80,
  })
end, { desc = "LSP: Show full diagnostic message" })

-- Resize with arrow keys
vim.keymap.set("n", "<C-Up>", ":resize +2<CR>", { desc = "Increase height" })
vim.keymap.set("n", "<C-Down>", ":resize -2<CR>", { desc = "Decrease height" })
vim.keymap.set("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Decrease width" })
vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Increase width" })

vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { desc = "Sortir du mode terminal" })

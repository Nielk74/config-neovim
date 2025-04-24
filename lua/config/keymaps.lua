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
local telescope_builtin = require("telescope.builtin")
local telescope_theme = require("telescope.themes")
local get_root = require("lazyvim.util").root
local grep_rg = { "--line-number", "--column", "--smart-case", "--max-count", "1" }

-- Telescope live‑grep that lists only one entry per file but keeps a preview
-- Compatible with Neovim ≥0.10 (no deprecated vim.tbl_flatten)

local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local previewers = require("telescope.previewers")
local conf = require("telescope.config").values
local Path = require("plenary.path")
local root = require("lazyvim.util").root

-- base rg arguments: show line/column, smart‑case, stop after first hit per file
local rg_base = { "rg", "--line-number", "--column", "--smart-case", "--max-count", "1" }

-- helper: append one or more items to a list without vim.tbl_flatten
local function append_args(list, ...)
  local result = vim.deepcopy(list)
  for _, v in ipairs({ ... }) do
    table.insert(result, v)
  end
  return result
end

---Open a Telescope picker that shows files (one row) + preview first hit
---@param prompt string search text
local function rg_files_picker(prompt)
  if not prompt or prompt == "" then
    return
  end

  local cwd = root()
  local cmd = append_args(rg_base, prompt) -- { "rg", ..., prompt }

  pickers
    .new({}, {
      prompt_title = string.format("Files with %q", prompt),
      finder = finders.new_oneshot_job(cmd, {
        cwd = cwd,
        -- transform each line (file:lnum:col:text) into a Telescope entry
        entry_maker = function(line)
          local file, lnum, col = line:match("^([^:]+):(%d+):(%d+):")
          file = file or line -- fallback when parse fails
          local abs = Path:new(cwd, file):absolute()
          return {
            value = line, -- full text, unused but kept for completeness
            ordinal = file, -- for sorting/matching in picker
            display = file, -- row text: just the relative path
            filename = abs, -- absolute path for previewer
            lnum = tonumber(lnum) or 1,
            col = tonumber(col) or 1,
          }
        end,
      }),
      previewer = previewers.vim_buffer_vimgrep.new({}),
      sorter = conf.generic_sorter({}),
    })
    :find()
end

-- key‑maps -----------------------------------------------------------
-- Live‑grep prompt
vim.keymap.set("n", "<leader>fg", function()
  local query = vim.fn.input("Live grep for: ")
  rg_files_picker(query)
end, { desc = "Live‑grep (files list + preview)" })

-- Grep word under cursor
vim.keymap.set("n", "<leader>fw", function()
  rg_files_picker(vim.fn.expand("<cword>"))
end, { desc = "Grep word under cursor (files list + preview)" })

vim.keymap.set("n", "<leader>fp", function()
  telescope_builtin.find_files(telescope_theme.get_dropdown({
    cwd = get_root(),
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

vim.keymap.set("n", "<leader>do", ":DiffviewOpen<CR>", { desc = "Open Diffview" })
vim.keymap.set("n", "<leader>dc", ":DiffviewClose<CR>", { desc = "Close Diffview" })
vim.keymap.set("n", "<leader>dh", ":DiffviewFileHistory<CR>", { desc = "File History (All)" })
vim.keymap.set("n", "<leader>df", ":DiffviewFileHistory %<CR>", { desc = "File History (Current File)" })

-- Resize with arrow keys
vim.keymap.set("n", "<C-Up>", ":resize +2<CR>", { desc = "Increase height" })
vim.keymap.set("n", "<C-Down>", ":resize -2<CR>", { desc = "Decrease height" })
vim.keymap.set("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Decrease width" })
vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Increase width" })

vim.api.nvim_set_keymap("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", { noremap = true, silent = true })
-- Rename variable in current file with prompt (no LSP)
function RenameWord()
  -- Get the word under cursor
  local current_word = vim.fn.input("Rename word: ")

  -- Prompt the user for a new name
  local new_name = vim.fn.input("Rename '" .. current_word .. "' to: ")

  -- Only run if something was entered
  if new_name ~= current_word then
    -- Run the substitution command with confirmation
    vim.cmd(":%s/\\<" .. current_word .. "\\>/" .. new_name .. "/gc")
  end
end
vim.keymap.set("n", "<leader>rs", RenameWord, { noremap = true, silent = false })

vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { desc = "Sortir du mode terminal" })

return {
  "ojroques/nvim-osc52",
  config = function()
    require("osc52").setup({
      trim = false,
    })

    -- Auto-copy on yank
    local function copy()
      if vim.v.event.regname == "" then
        require("osc52").copy_register("")
      end
    end
    vim.api.nvim_create_autocmd("TextYankPost", { callback = copy })

    -- Mouse selection triggers yank
    vim.keymap.set("v", "<LeftRelease>", "y<LeftRelease>", { noremap = true, silent = true })
  end,
}

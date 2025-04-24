-- ~/.config/nvim/lua/plugins/ai.lua
return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "zbirenbaum/copilot.lua" }, -- you already use this
      { "nvim-lua/plenary.nvim" },
    },
    build = "make tiktoken", -- optional, speeds up token counting
    opts = {
      -- auto-context: prefer visual selection, otherwise whole buffer
      selection = function(source)
        local sel = require("CopilotChat.select")
        return sel.visual(source) or sel.buffer(source)
      end,
      -- sticky prompts that live at the top of every message
      sticky = { "> #buffer", "> Explain all changes you propose" },
    },
    keys = {
      { "<leader>cc", "<cmd>CopilotChatToggle<cr>", desc = "Toggle Copilot Chat window" },
      { "<leader>ce", "<cmd>CopilotChatExplain<cr>", desc = "Explain selected code" },
      { "<leader>cr", "<cmd>CopilotChatReview<cr>", desc = "Review selected code" },
      { "<leader>cf", "<cmd>CopilotChatFix<cr>", desc = "Fix selected code" },
      { "<leader>ct", "<cmd>CopilotChatTests<cr>", desc = "Generate tests for selection" },
      { "<leader>cd", "<cmd>CopilotChatDocs<cr>", desc = "Document selection" },
      { "<leader>cy", "<cmd>CopilotChatCommit<cr>", desc = "Generate commit message" },
      {
        "<leader>ci",
        "<cmd>CopilotChat<cr>#import references for this file",
        desc = "Import references for this file",
      },
    },
  },
}

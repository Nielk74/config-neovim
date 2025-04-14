-- ~/.config/nvim/lua/plugins/neotree.lua
return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    "MunifTanjim/nui.nvim",
    -- {"3rd/image.nvim", opts = {}}, -- Optional image support in preview window: See `# Preview Mode` for more information
  },
  lazy = false, -- neo-tree will lazily load itself
  ---@module "neo-tree"
  ---@type neotree.Config?
  opts = {
    -- fill any relevant options here
--    default_component_configs = {
--      icon = {
--        folder_closed = "x",
--        folder_open = "o",
 --       folder_empty = "-",
 --       default = "#", -- default file icon
 --       highlight = "NeoTreeFileIcon",
 --     },
--name = {
 --       use_webdevicons = true,      -- ensures file names include web-devicons
  --      highlight       = "NeoTreeFileName",
   --   },
   -- },
    -- Optionally, if you want to verify that file renderers include icon and name:
 --   renderers = {
 --     file = {
  --      { "icon" },
   --     { "name", use_webdevicons = true },
    --  },
   -- },  
},
}

return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  -- All configuration goes into the 'opts' table.
  -- Lazy.nvim automatically passes this to harpoon:setup()
  opts = {
    menu = {
      -- Calculate width dynamically if needed, or set a fixed preferred width
      -- Using a function here might be less reliable than setting it once
      -- Let's try setting a large fixed width or calculating on load in 'config' if necessary.
      -- For simplicity, let's use a large fixed width or calculate later.
      -- width = 100, -- Example fixed width
      width = vim.api.nvim_win_get_width(0) - 4, -- Keep dynamic width calculation
    },
    settings = {
      save_on_toggle = true, -- Save the list when adding/removing files
      sync_on_ui_close = true, -- Persist changes when the UI closes
      -- other harpoon settings...
    },
  },
  -- Define all keybindings using the 'keys' table for consistency
  keys = function()
    local harpoon = require("harpoon")
    local list = harpoon:list() -- Get the default list instance once

    return {
      -- Keybinding to TOGGLE (add or remove) the current file
      {
        "<leader>a", -- Changed from <leader>H for clarity (Add/Remove)
        function()
          local current_file = vim.fn.expand("%:p")
          local index_to_remove = nil

          -- Check if the file already exists in the list
          for i, item in ipairs(list.items) do
            if item.value == current_file then
              index_to_remove = i
              break
            end
          end

          if index_to_remove then
            -- File exists, remove it
            list:remove_at(index_to_remove)
            vim.notify("Harpoon: Fichier retiré: " .. vim.fn.fnamemodify(current_file, ":t"))
          else
            -- File does not exist, add it
            list:add()
            vim.notify("Harpoon: Fichier ajouté: " .. vim.fn.fnamemodify(vim.fn.expand("%:p"), ":t"))
          end
        end,
        desc = "Harpoon: Toggle Current File", -- Updated description
      },
      -- Keybinding to toggle the Quick Menu UI
      {
        "<leader>h",
        function()
          harpoon.ui:toggle_quick_menu(list) -- Use the list instance
        end,
        desc = "Harpoon: Toggle Quick Menu",
      },
      -- Keybinding to CLEAR the list
      {
        "<leader>hx",
        function()
          if #list.items > 0 then -- Check if list is not already empty
            list:clear()
            vim.notify("Harpoon: Liste vidée")
          else
            vim.notify("Harpoon: La liste est déjà vide")
          end
          -- No need to toggle the UI here unless you want to see it empty.
          -- If you want to see it, uncomment the next line:
          -- harpoon.ui:toggle_quick_menu(list)
        end,
        desc = "Harpoon: Clear List",
      },
      -- Navigation Keybindings (AZERTY layout)
      {
        "<leader>&",
        function()
          list:select(1)
        end,
        desc = "Harpoon: Go to item 1",
      },
      {
        "<leader>é",
        function()
          list:select(2)
        end,
        desc = "Harpoon: Go to item 2",
      },
      {
        '<leader>"',
        function()
          list:select(3)
        end,
        desc = "Harpoon: Go to item 3",
      },
      {
        "<leader>'",
        function()
          list:select(4)
        end,
        desc = "Harpoon: Go to item 4",
      },
      -- Add more navigation keys if needed (e.g., for 5, 6, etc.)
      -- { "<leader>(", function() list:select(5) end, desc = "Harpoon: Go to item 5" },
      -- Add bindings for next/prev item if desired
      -- { "<C-e>", function() list:select_next() end, desc = "Harpoon: Next item" },
      -- { "<C-y>", function() list:select_prev() end, desc = "Harpoon: Previous item" },
    }
  end,
  -- Removed the redundant config = function() ... end block
  -- as all setup is handled by 'opts' and keys by 'keys'
}

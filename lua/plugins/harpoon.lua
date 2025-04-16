-- Module-level counter for rotation (persist while the module is loaded)
local next_slot = 1

return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    menu = {
      width = vim.api.nvim_win_get_width(0) - 4,
    },
    settings = {
      save_on_toggle = true,
      sync_on_ui_close = true,
    },
  },
  keys = function()
    local harpoon = require("harpoon")
    local list = harpoon:list()

    local keymaps = {
      {
        "<leader>a",
        function()
          -- Get the absolute path to compare reliably
          local current_file_abs = vim.fn.fnamemodify(vim.fn.expand("%:p"), ":p")
          -- Create a relative path for storing in Harpoon
          local current_file_rel = vim.fn.fnamemodify(current_file_abs, ":.")

          -- Check if the file is already in the list (by comparing absolute paths)
          local index_in_list = nil
          for i, item in ipairs(list.items) do
            local item_abs = vim.fn.fnamemodify(item.value, ":p")
            if item_abs == current_file_abs then
              index_in_list = i
              break
            end
          end

          if index_in_list then
            list:remove_at(index_in_list)
            vim.notify(
              string.format(
                "Harpoon: Removed '%s' from slot [%d]",
                vim.fn.fnamemodify(current_file_abs, ":t"),
                index_in_list
              )
            )
            return
          end

          local slot
          if #list.items < 5 then
            -- Fewer than 5 items: add the new file
            list:add()
            slot = #list.items
            -- Overwrite the just-added item’s path to be relative
            list.items[slot].value = current_file_rel

            -- Set the next_slot counter for future rotations
            next_slot = slot + 1
            if next_slot > 5 then
              next_slot = 1
            end

            vim.notify(
              string.format("Harpoon: Added '%s' at slot [%d]", vim.fn.fnamemodify(current_file_abs, ":t"), slot)
            )
          else
            -- 5 or more items: rotate using the counter
            slot = next_slot
            list:replace_at(slot, { value = current_file_rel, context = {} })
            vim.notify(
              string.format("Harpoon: Rotated '%s' into slot [%d]", vim.fn.fnamemodify(current_file_abs, ":t"), slot)
            )
            next_slot = next_slot + 1
            if next_slot > 5 then
              next_slot = 1
            end
          end
        end,
        desc = "Harpoon: Toggle current file with rotating 5-slot logic",
      },
      {
        "<leader>h",
        function()
          harpoon.ui:toggle_quick_menu(list)
        end,
        desc = "Harpoon: Toggle Quick Menu",
      },
      {
        "<leader>hx",
        function()
          if #list.items > 0 then
            list:clear()
            vim.notify("Harpoon: List cleared")
          else
            vim.notify("Harpoon: List is already empty")
          end
        end,
        desc = "Harpoon: Clear List",
      },
    }

    -- Append jump mappings for items 1 through 8 in a flat manner
    for i = 1, 5 do
      table.insert(keymaps, {
        "<leader>" .. i,
        function()
          list:select(i)
        end,
        desc = string.format("Harpoon: Go to item %d", i),
      })
    end

    return keymaps
  end,
}

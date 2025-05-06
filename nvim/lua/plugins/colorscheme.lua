return {
  -- add gruvbox-material
  -- {
  --   'sainnhe/gruvbox-material',
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     -- Optionally configure and load the colorscheme
  --     -- directly inside the plugin declaration.
  --     vim.g.gruvbox_material_enable_italic = true
  --     vim.cmd.colorscheme('gruvbox-material')
  --     vim.g.gruvbox_material_background = "hard"
  --   end
  -- },

  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },

  -- Configure LazyVim to load gruvbox
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin-mocha",
    },
  },
}

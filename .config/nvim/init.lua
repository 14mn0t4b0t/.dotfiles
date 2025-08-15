-- ╭──────────────────────────────────────────────────────────────╮
-- │                          SETTINGS                            │
-- ╰──────────────────────────────────────────────────────────────╯

vim.opt.clipboard = "unnamedplus" -- use system clipboard

vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.tabstop = 2

vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.termguicolors = true

-- ╭──────────────────────────────────────────────────────────────╮
-- │                           PLUGINS                            │
-- ╰──────────────────────────────────────────────────────────────╯

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none",
  "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- ─────────────────────
    -- ADD YOUR PLUGINS HERE
    -- ─────────────────────

    -- https://github.com/nvim-telescope/telescope.nvim
    {
      "nvim-telescope/telescope-ui-select.nvim",
    },
   {
      "nvim-telescope/telescope.nvim",
     tag = "0.1.5",
     dependencies = { "nvim-lua/plenary.nvim" },
     config = function()
       require("telescope").setup({
         extensions = {
           ["ui-select"] = {
              require("telescope.themes").get_dropdown({}),
            },
          },
        })
        local builtin = require("telescope.builtin")
        vim.keymap.set("n", "<C-p>", builtin.find_files, {})
        vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
        vim.keymap.set("n", "<leader><leader>", builtin.oldfiles, {})
  
        require("telescope").load_extension("ui-select")
      end,
    },
  
    -- https://github.com/nvim-treesitter/nvim-treesitter
    {
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
      config = function()
        local config = require("nvim-treesitter.configs")
        config.setup({
          ensure_installed = { "c", "lua", "vim", "vimdoc",
          "query", "markdown", "markdown_inline", "python",
          "rust", "html", "css", "php", "bash", "csv",
          "arduino", "cmake", "zig", "xml",
          "javascript", "json", "java"},
          auto_install = true,
          highlight = { enable = true },
          indent = { enable = true },
        })
      end
    },

    -- ────────
    -- TREE BAR
    -- ────────

    {
      "nvim-neo-tree/neo-tree.nvim",
      branch = "v3.x",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        "nvim-tree/nvim-web-devicons", -- optional, but recommended
      }, 
      lazy = false, -- neo-tree will lazily load itself
    },

    
-- ╭──────────────────────────────────────────────────────────────╮
-- │                            THEME                             │
-- ╰──────────────────────────────────────────────────────────────╯

    -- ───────────
    -- STATUS LINE
    -- ───────────

    { "nvim-lualine/lualine.nvim", dependencies = { "nvim-tree/nvim-web-devicons" },
      config = function()
        require("lualine").setup({
         options = { theme = "iceberg_dark", component_separators = '|',
          section_separators = '', }
        })
      end
    },

    -- ────────────
    -- COLOR SCHEME
    -- ────────────

    -- https://github.com/olimorris/onedarkpro.nvim
    { "olimorris/onedarkpro.nvim", priority = 1000, 
      name = "onedarkpro",
      lazy = false,
      config = function()
        vim.cmd.colorscheme "onedark_dark"
        -- onedark, onelight, onedark_vivid, onedark_dark, 
        -- vaporwave
      end
    },

    -- https://github.com/catppuccin/nvim
    { "catppuccin/nvim", priority = 1000,
      name = "catppuccin", 
      lazy = true,
      config = function()
        vim.cmd.colorscheme "catppuccin-mocha"
        -- catppuccin, catppuccin-latte, catppuccin-frappe, 
        -- catppuccin-macchiato, catppuccin-mocha
      end
    },

    -- https://github.com/ellisonleao/gruvbox.nvim 
    { "ellisonleao/gruvbox.nvim", priority = 1000,
      name = "gruvbox", 
      lazy = true,
      config = function()
        vim.o.background = "dark" -- dark, light
        vim.cmd.colorscheme "gruvbox"
      end
    },

    -- https://github.com/vague2k/vague.nvim
    { "vague2k/vague.nvim", priority = 1000,
      name = "vague", 
      lazy = true,
      config = function()
        vim.cmd.colorscheme "vague"
      end
    },

    -- https://github.com/bluz71/vim-moonfly-colors
    { "bluz71/vim-moonfly-colors", priority = 1000,
      name = "vim-moonfly-colors", 
      lazy = true,
      config = function()
        vim.cmd.colorscheme "moonfly"
      end
    },


  },
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "onedark_dark" } },

  -- Configure any other settings here. See the documentation for more details.
  -- automatically check for plugin updates
  checker = { enabled = true },
})

-- ╭──────────────────────────────────────────────────────────────╮
-- │                           KEYMAPS                            │
-- ╰──────────────────────────────────────────────────────────────╯

-- Establecer la tecla líder como espacio
vim.g.mapleader = ' '

-- Mapear movimientos entre ventanas con <leader>h/j/k/l
vim.keymap.set('n', '<leader>h', '<C-w>h', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>j', '<C-w>j', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>k', '<C-w>k', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>l', '<C-w>l', { noremap = true, silent = true })


vim.keymap.set("n", "<C-n>", ":Neotree filesystem reveal left<CR>", {})

-- ╭──────────────────────────────────────────────────────────────╮
-- │                            EXTRA                             │
-- ╰──────────────────────────────────────────────────────────────╯




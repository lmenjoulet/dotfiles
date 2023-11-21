vim.o.number = true
vim.o.relativenumber = true
vim.o.scrolloff = 999

vim.o.tabstop = 2
vim.o.shiftwidth = 0
vim.o.expandtab = true

vim.o.cursorline = true
vim.o.splitright = true
vim.opt.termguicolors = true

vim.opt.clipboard = "unnamedplus"
vim.g.mapleader = " "

-- length wrapping for text files
vim.api.nvim_create_autocmd(
  "BufEnter",
  {
  pattern = { "*.txt", "*.tex", "*.md" },
  command = "set tw=80 fo+=t fo-=l",
  }
)

-- packages

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup{
  {
    "RRethy/nvim-base16",
    lazy = false,
    priority = 1000,
    config = function ()
      vim.cmd "colorscheme base16-default-dark"
    end
  },
  { 
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    opts = {}
  },
  {
    "nvim-treesitter/nvim-treesitter",
    config = function () 
      require("nvim-treesitter.configs").setup {
        ensure_installed = "all",
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false
        },
        indent = {
          enable = true
        }
      }    
      vim.wo.foldmethod = "expr"
      vim.wo.foldexpr = "nvim_treesitter#foldexpr()"
      vim.opt.foldenable = false
      vim.opt.fillchars = "fold: "
      vim.opt.foldlevel = 99
      vim.o.foldtext = "substitute(getline(v:foldstart),'\\\\t',repeat('\\ ',&tabstop),'g').'...'.trim(getline(v:foldend)) . ' (' . (v:foldend - v:foldstart + 1) . ' lines)'"
    end
  },
  {
    "nvim-telescope/telescope.nvim", branch = "0.1.x",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local builtin = require("telescope.builtin")
      vim.keymap.set('n', '<leader>fb', builtin.buffers, {}) 
      vim.keymap.set('n', '<leader>ff', builtin.find_files, {}) 
      vim.keymap.set('n', '<leader>ft', builtin.live_grep, {})  -- external dependency on ripgrep
      vim.keymap.set('n', '<leader>fh', builtin.help_tags, {}) 
    end
  },
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      options = {
        icons_enabled = false,
        component_separators = { left = "", right = ""},
        section_separators = { left = "", right = ""},
      }
    }
  },
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = "cd app && npm install"
  },
  {
    "jakewvincent/mkdnflow.nvim",
    ft = "markdown",
    opts = {}
  },
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",         -- required
      "nvim-telescope/telescope.nvim", -- optional
      "sindrets/diffview.nvim",        -- optional
    },
    config = true
  },
  {
    "akinsho/toggleterm.nvim",
    cmd = "ToggleTerm",
    keys = "<leader>t",
    opts = {
      open_mapping = "<leader>t",
      direction = "float"
    }
  }
}

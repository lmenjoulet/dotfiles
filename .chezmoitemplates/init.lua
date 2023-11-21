vim.o.number = true
vim.o.relativenumber = true
vim.o.scrolloff = 999

vim.o.tabstop = 2
vim.o.shiftwidth = 0
vim.o.expandtab = true

vim.o.cursorline = true
vim.o.splitright = true
vim.opt.termguicolors = true
vim.o.signcolumn = "yes"
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

require("lazy").setup {
  {
    "RRethy/nvim-base16",
    lazy = false,
    priority = 1000,
    config = function()
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
    config = function()
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
      vim.o.foldtext =
      "substitute(getline(v:foldstart),'\\\\t',repeat('\\ ',&tabstop),'g').'...'.trim(getline(v:foldend)) . ' (' . (v:foldend - v:foldstart + 1) . ' lines)'"
    end
  },
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local builtin = require("telescope.builtin")
      vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
      vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
      vim.keymap.set('n', '<leader>ft', builtin.live_grep, {}) -- external dependency on ripgrep
      vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
    end
  },
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      options = {
        icons_enabled = false,
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
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
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "neovim/nvim-lspconfig",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "L3MON4D3/LuaSnip",
      "petertriho/cmp-git"
    },
    config = function()
      vim.opt.pumheight = 10
      local cmp = require("cmp")

      cmp.setup {
        completion = {
          completeopt = "menu,menuone,insert"
        },
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end
        },
        mapping = {
          ["<Tab>"] = cmp.mapping.confirm { select = true },
          ["<C-k>"] = cmp.mapping.select_prev_item(),
          ["<C-j>"] = cmp.mapping.select_next_item(),
        },
        sources = cmp.config.sources {
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "path" },
        }
      }

      cmp.setup.filetype("gitcommit", {
        sources = cmp.config.sources { { name = "git" } }
      })

      cmp.setup.cmdline(":", {
        sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } })
      })
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      require("lspconfig")["nil_ls"].setup { capabilities = capabilities }
      require("lspconfig")["lua_ls"].setup {
        capabilities = capabilities,
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            diagnostics = { globals = { "vim" } },
            workspace = {
              library = {
                vim.fn.expand "$VIMRUNTIME/lua",
                vim.fn.expand "$VIMRUNTIME/lua/vim/lsp"
              }
            }
          }
        }
      }
      require("lspconfig")["marksman"].setup { capabilities = capabilities }
    end
  },
}

vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function()
    vim.lsp.buf.format { async = false }
  end
})

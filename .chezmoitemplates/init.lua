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

vim.g.mapleader = ";"

-- length wrapping for text files
vim.api.nvim_create_autocmd(
  "BufEnter",
  {
    pattern = { "*.txt", "*.tex", "*.md" },
    command = "set tw=80 fo+=t fo-=l",
  }
)

-- disable search highlight on insert
vim.api.nvim_create_autocmd(
  "InsertEnter",
  {
    command = "setlocal nohlsearch"
  }
)

local lsp_settings = {
  lua_ls = {
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
  },
  ltex = {
    ltex = {
      completionEnabled = true
    }
  }
}

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
    "Mofiqul/adwaita.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd("colorscheme adwaita")
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
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-ui-select.nvim"
    },
    config = function()
      require("telescope").setup {
        extensions = {
          ["ui-select"] = require("telescope.themes").get_dropdown {}
        }
      }
      require("telescope").load_extension("ui-select")
      local builtin = require("telescope.builtin")
      vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
      vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
      vim.keymap.set('n', '<leader>ft', builtin.live_grep, {}) -- external dependency on ripgrep
      vim.keymap.set('n', '<leader>fe', builtin.diagnostics, {})
      vim.keymap.set('n', "<leader>c", vim.lsp.buf.code_action, {})
    end
  },
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      options = {
        icons_enabled = false,
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        theme = "adwaita",
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
    opts = {
      links = {
        style = "wiki",
      },
      perspective = {
        priority = "current"
      }
    }
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
    end
  },
  {
    "hrsh7th/cmp-nvim-lsp",
    dependencies = { "neovim/nvim-lspconfig" },
    cond = vim.loop.os_uname().sysname == "Linux",
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local servers = { "lua_ls", "marksman", "ltex", "nil_ls", "tsserver", "pylsp" }
      for _, server in pairs(servers) do
        require("lspconfig")[server].setup {
          capabilities = capabilities,
          settings = lsp_settings[server]
        }
      end
    end
  },
  {
    "williamboman/mason.nvim",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "neovim/nvim-lspconfig"
    },
    cond = vim.loop.os_uname().sysname == "Windows_NT",
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup {
        ensure_installed = { "lua_ls", "marksman", "ltex", "powershell_es", "pylsp" }
      }
      require("mason-lspconfig").setup_handlers {
        function(server)
          require("lspconfig")[server].setup {
            settings = lsp_settings[server]
          }
        end
      }
    end
  }
}

vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function()
    vim.lsp.buf.format { async = false }
  end
})

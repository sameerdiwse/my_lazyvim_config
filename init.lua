-- Install lazy.lua
vim.g.mapleader = " "
vim.opt.backup = false
vim.opt.writebackup = false


local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.lua"
if not vim.loop.fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.lua:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("keymaps.keymaps").setup()

-- Setup plugins
require("lazy").setup({
  { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
  { 
    "nvim-neo-tree/neo-tree.nvim", 
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- optional, for file icons
      "MunifTanjim/nui.nvim",
    },
  },
  {
  "nvimtools/none-ls.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local null_ls = require("null-ls")
    null_ls.setup({
      sources = {
        null_ls.builtins.formatting.prettierd,
      },
    })
  end,
  },
  {
    'nvim-java/nvim-java',
    dependencies = 
  {
    'nvim-java/lua-async-await',
    'nvim-java/nvim-java-core',
    'nvim-java/nvim-java-test',
    'nvim-java/nvim-java-dap',
  },
  },
  {
    { "catppuccin/nvim", name = "catppuccin", priority = 1000 }
  },
  {
    {"nvim-treesitter/nvim-treesitter", build=":TSUpdate"}
  },
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup() -- Initialize mason.nvim
    end
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {"lua_ls", "ts_ls"}
      }) -- Initialize mason.nvim
    end
  },
  {
    "neovim/nvim-lspconfig",
      config = function()
      require("lspconfig").lua_ls.setup({}) -- for Lua
      require("lspconfig").ts_ls.setup({}) -- for JS
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
    end
  },
  {
    {
      "hrsh7th/cmp-nvim-lsp"
    },
    {
      "L3MON4D3/LuaSnip",
      dependencies = {
        "saadparwaiz1/cmp_luasnip",
        "rafamadriz/friendly-snippets",
      },
    },
    {
      "hrsh7th/nvim-cmp",
      config = function()
        local cmp = require("cmp")
        require("luasnip.loaders.from_vscode").lazy_load()
  
        cmp.setup({
          snippet = {
            expand = function(args)
              require("luasnip").lsp_expand(args.body)
            end,
          },
          window = {
            completion = cmp.config.window.bordered(),
            documentation = cmp.config.window.bordered(),
          },
          mapping = cmp.mapping.preset.insert({
            ["<C-b>"] = cmp.mapping.scroll_docs(-4),
            ["<C-f>"] = cmp.mapping.scroll_docs(4),
            ["<C-Space>"] = cmp.mapping.complete(),
            ["<C-e>"] = cmp.mapping.abort(),
            ["<CR>"] = cmp.mapping.confirm({ select = true }),
          }),
          sources = cmp.config.sources({
            { name = "nvim_lsp" },
            { name = "luasnip" }, -- For luasnip users.
          }, {
            { name = "buffer" },
          },{
            { name = "cmp_html" },
          }),
        })
      end,
    },
  },
  {
  "mfussenegger/nvim-jdtls"
  },
  {
  "folke/noice.nvim",
  event = "VeryLazy",
  opts = {
    -- add any options here
  },
  dependencies = {
    -- if you lazy-load any plugin below, make sure to add proper module="..." entries
    "MunifTanjim/nui.nvim",
    -- OPTIONAL:
    --   nvim-notify is only needed, if you want to use the notification view.
    --   If not available, we use mini as the fallback
    "rcarriga/nvim-notify",
    }
},
})

require("nvim-treesitter.configs").setup({
  ensure_installed = {"lua", "javascript", "java"},
  highlight =  { enable = true},
  indent = { enable = true},
})


require("catppuccin").setup()
vim.cmd.colorscheme "catppuccin"
vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function()
    vim.lsp.buf.format({ async = true })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "java",
  callback = function()
    vim.b.autoformat = false

    local jdtls = require("jdtls")
    local home = os.getenv("HOME")
    local workspace_dir = home .. "/.local/share/eclipse/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
    local config = {
      cmd = { "jdtls", "-data", workspace_dir },
      root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew" }),
    }
    jdtls.start_or_attach(config)
  end,
})


vim.api.nvim_create_user_command("TermHere", function()
  local dir = vim.fn.expand("%:p:h")
  vim.cmd("term")
  vim.fn.chansend(vim.b.terminal_job_id, "cd " .. dir .. "\n")
end, {})


require("config.options")



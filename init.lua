-- Install lazy.lua
vim.g.mapleader = " "

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
  { "neovim/nvim-lspconfig" },
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
      require("lspconfig").lua_ls.setup({}) -- Initialize mason.nvim
      require("lspconfig").ts_ls.setup({}) -- Initialize mason.nvim
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
    end
  },
})

require("nvim-treesitter.configs").setup({
  ensure_installed = {"lua", "javascript"},
  highlight =  { enable = true},
  indent = { enable = true},
})

require("catppuccin").setup()
vim.cmd.colorscheme "catppuccin"


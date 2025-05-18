local M = {}

function M.setup()
  -- Open/Close Neo-tree
  vim.keymap.set('n', '<leader>e', ':Neotree toggle<CR>', { noremap = true, silent = true })

  -- Reveal current file in Neo-tree
  vim.keymap.set('n', '<leader>o', ':Neotree reveal<CR>', { noremap = true, silent = true })

  -- Focus on Neo-tree window
  vim.keymap.set('n', '<leader>f', ':Neotree focus<CR>', { noremap = true, silent = true })

  -- Refresh Neo-tree
  vim.keymap.set('n', '<leader>r', ':Neotree refresh<CR>', { noremap = true, silent = true })

  -- Dismiss Noice Message
  vim.keymap.set("n", "<leader>nd", "<cmd>NoiceDismiss<CR>", { desc = "Dismiss Noice Message" })

  vim.keymap.set("n", "<leader>r", function()
  local file = vim.fn.expand("%:t")           -- e.g., HelloWorld.java
  local filename = vim.fn.expand("%:r")       -- e.g., HelloWorld
  vim.cmd("w")                                 -- Save the current file
  vim.cmd("!javac " .. file)                   -- Compile
  vim.cmd("!java " .. filename)                -- Run
end, { desc = "Compile and run Java file" })

  -- Toggle hidden files (dotfiles)
  vim.keymap.set('n', '<leader>h', ':Neotree toggle_hidden<CR>', { noremap = true, silent = true })

  vim.keymap.set('n', '<leader>ff', ':Telescope find_files<CR>', { noremap = true, silent = true })

  vim.keymap.set('n', '<leader>sv', ':vsplit<CR>', { noremap = true, silent = true })

  vim.keymap.set('n', '<leader>sh', ':split<CR>', { noremap = true, silent = true })

  vim.keymap.set('n', '<leader>wh', '<C-W>h', { noremap = true, silent = true })
  
  vim.keymap.set('n', '<leader>wl', '<C-W>l', { noremap = true, silent = true })

  vim.keymap.set('t', '<leader>tt', [[<C-\><C-n>:hide<CR>]], { noremap = true, silent = true })

  vim.keymap.set('n', '<leader>q', ':q<CR>', { noremap = true, silent = true })  -- Close current window

  vim.keymap.set('n', '<leader>ss', ':w<CR>', { noremap = true, silent = true })  -- Close current window

  --vim.keymap.set('n', '<leader>f', 'f', { noremap = true })


end

return M
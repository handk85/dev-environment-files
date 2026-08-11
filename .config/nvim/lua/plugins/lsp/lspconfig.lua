-- import cmp-nvim-lsp plugin safely
local cmp_nvim_lsp_status, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not cmp_nvim_lsp_status then
  return
end


local keymap = vim.keymap -- for conciseness

-- enable keybinds only for when lsp server available
local on_attach = function(client, bufnr)
  -- keybind options
  local opts = { noremap = true, silent = true, buffer = bufnr }

  -- set keybinds
  keymap.set("n", "gf", "<cmd>Lspsaga lsp_finder<CR>", opts) -- show definition, references
  keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts) -- got to declaration
  keymap.set("n", "gd", "<cmd>Lspsaga peek_definition<CR>", opts) -- see definition and make edits in window
  keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts) -- go to implementation
  keymap.set("n", "<leader>ca", "<cmd>Lspsaga code_action<CR>", opts) -- see available code actions
  keymap.set("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", opts) -- smart rename
  keymap.set("n", "<leader>D", "<cmd>Lspsaga show_line_diagnostics<CR>", opts) -- show  diagnostics for line
  keymap.set("n", "<leader>d", "<cmd>Lspsaga show_cursor_diagnostics<CR>", opts) -- show diagnostics for cursor
  keymap.set("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", opts) -- jump to previous diagnostic in buffer
  keymap.set("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", opts) -- jump to next diagnostic in buffer
  keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", opts) -- show documentation for what is under cursor
  keymap.set("n", "<leader>o", "<cmd>Lspsaga outline<CR>", opts) -- see outline on right hand side

  -- typescript specific keymaps (e.g. rename file and update imports)
  if client.name == "typescript-tools" then
    keymap.set("n", "<leader>rf", ":TSToolsRenameFile<CR>") -- rename file and update imports
    keymap.set("n", "<leader>oi", ":TSToolsOrganizeImports<CR>") -- organize imports
    keymap.set("n", "<leader>ru", ":TSToolsRemoveUnusedImports<CR>") -- remove unused variables
  end
end

-- used to enable autocompletion (assign to every lsp server config)
local capabilities = cmp_nvim_lsp.default_capabilities()

-- Diagnostic display configuration
vim.diagnostic.config({
  virtual_text = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN]  = " ",
      [vim.diagnostic.severity.HINT]  = "ﴞ ",
      [vim.diagnostic.severity.INFO]  = " ",
    },
  },
})

-- configure pyright language server
vim.lsp.config("pyright",{
  capabilities = capabilities,
  on_attach = on_attach,
  filetypes = { "python" },
})

-- configure typescript server via typescript-tools (replaces ts_ls direct config)
local typescript_tools_status, typescript_tools = pcall(require, "typescript-tools")
if typescript_tools_status then
  typescript_tools.setup({
    on_attach = on_attach,
    capabilities = capabilities,
  })
end

vim.lsp.config("jdtls",{
  capabilities = capabilities,
  on_attach = on_attach,
})

-- configure lua server (with special settings)
vim.lsp.config("lua_ls",{
  capabilities = capabilities,
  on_attach = on_attach,
  settings = { -- custom settings for lua
    Lua = {
      -- make the language server recognize "vim" global
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        -- make language server aware of runtime files
        library = {
          [vim.fn.expand("$VIMRUNTIME/lua")] = true,
          [vim.fn.stdpath("config") .. "/lua"] = true,
        },
      },
    },
  },
})

-- configure ltex language server
vim.lsp.config("ltex",{
  on_attach = on_attach,
  capabilities = capabilities,
  use_spellfile = false,
  filetypes = { "latex", "tex", "bib", "markdown", "gitcommit", "text" },
  settings = {
    ltex = {
      enabled = { "latex", "tex", "bib", "markdown" },
      language = "en-GB",
      disabledRules = {
        ["en-GB"] = { "OXFORD_SPELLING_Z_NOT_S" },
      },
      diagnosticSeverity = "information",
      sentenceCacheSize = 2000,
      dictionary = (function()
        local spellfile = vim.fn.stdpath("config") .. "/spell/en.utf-8.add"
        local words = {}
        local f = io.open(spellfile, "r")
        if f then
          for line in f:lines() do
            if line ~= "" then
              table.insert(words, line)
            end
          end
          f:close()
        end
        return { ["en-GB"] = words }
      end)(),
    },
  },
})

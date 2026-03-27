-- Setup null-ls with prettier
local null_ls = require("null-ls")

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
null_ls.setup({
  sources = {
    null_ls.builtins.formatting.prettier.with({
      extra_filetypes = { "markdown", "javascript", "typescript", "javascriptreact", "typescriptreact" },
    }),
  },
  on_attach = function(client, bufnr)
    if client:supports_method("textDocument/formatting") then
      -- Format on save
      vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({ async = false })
        end,
      })
    end
  end,
})

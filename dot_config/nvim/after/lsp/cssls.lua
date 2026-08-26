-- cssls requires snippetSupport to provide completions
return {
  cmd = { 'vscode-css-language-server', '--stdio' },
  filetypes = { 'css', 'scss', 'less' },
  root_markers = { 'package.json', '.git' },
  init_options = { provideFormatter = true },
  capabilities = vim.tbl_deep_extend('force', vim.lsp.protocol.make_client_capabilities(), {
    textDocument = { completion = { completionItem = { snippetSupport = true } } },
  }),
  settings = {
    css = { validate = true },
    scss = { validate = true },
    less = { validate = true },
  },
}

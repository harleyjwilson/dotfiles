-- html requires snippetSupport to provide completions
return {
  cmd = { 'vscode-html-language-server', '--stdio' },
  filetypes = { 'html' },
  root_markers = { 'package.json', '.git' },
  init_options = {
    provideFormatter = true,
    embeddedLanguages = { css = true, javascript = true },
    configurationSection = { 'html', 'css', 'javascript' },
  },
  capabilities = vim.tbl_deep_extend('force', vim.lsp.protocol.make_client_capabilities(), {
    textDocument = { completion = { completionItem = { snippetSupport = true } } },
  }),
  settings = {
    html = {
      validate = {
        scripts = true,
        styles = true,
      },
      hover = {
        documentation = true,
        references = true,
      },
    },
  },
}

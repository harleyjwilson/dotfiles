return {
  cmd = { 'biome', 'lsp-proxy' },
  filetypes = {
    'astro',
    'css',
    'graphql',
    'javascript',
    'javascriptreact',
    'json',
    'jsonc',
    'svelte',
    'typescript',
    'typescriptreact',
    'vue',
  },
  root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    local root = vim.fs.dirname(vim.fs.find({ 'biome.json', 'biome.jsonc', 'package.json' }, { path = fname, upward = true })[1])
    on_dir(root)
  end,
  single_file_support = false,
}

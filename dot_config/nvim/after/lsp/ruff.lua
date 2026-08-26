return {
  cmd = { 'ruff', 'server' },
  filetypes = { 'python' },
  root_markers = { 'pyproject.toml', 'ruff.toml', '.ruff.toml', '.git' },
  single_file_support = true,
  on_attach = function(client)
    -- Let pyright handle hover/navigation/type intelligence.
    client.server_capabilities.hoverProvider = false
  end,
}

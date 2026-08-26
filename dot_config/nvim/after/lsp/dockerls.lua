return {
  cmd = { 'docker-language-server', 'start', '--stdio' },
  filetypes = { 'dockerfile' },
  root_markers = { 'Dockerfile', '.git' },
  single_file_support = true,
}

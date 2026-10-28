-- Tokyo Night (night) colors using mini.hues highlighting, not folke's plugin.
-- Source: https://github.com/folke/tokyonight.nvim/blob/main/lua/tokyonight/colors/night.lua
-- Base hues and shade roles follow the upstream night palette; mini.hues fills
-- in the intermediate shades that Tokyo Night does not define.
local hues = require('mini.hues')
local palette = hues.make_palette({
  background = '#1a1b26',
  foreground = '#c0caf5',
  accent = 'blue',
})

palette.bg_edge = '#16161e'
palette.bg_edge2 = '#0c0e14'
palette.bg_mid = '#292e42'
palette.bg_mid2 = '#414868'
palette.fg_mid = '#a9b1d6'
palette.fg_mid2 = '#565f89'
palette.red = '#f7768e'
palette.orange = '#ff9e64'
palette.yellow = '#e0af68'
palette.green = '#9ece6a'
palette.cyan = '#7dcfff'
palette.azure = '#2ac3de'
palette.blue = '#7aa2f7'
palette.purple = '#bb9af7'
palette.accent = palette.blue
palette.red_bg = '#4a272f'
palette.green_bg = '#243e4a'
palette.blue_bg = '#3d59a1'

hues.apply_palette(palette)

-- mini.hues otherwise derives ANSI colors; use the upstream Tokyo Night set.
local terminal_colors = {
  '#15161e', '#f7768e', '#9ece6a', '#e0af68',
  '#7aa2f7', '#bb9af7', '#7dcfff', '#a9b1d6',
  '#414868', '#ff899d', '#9fe044', '#faba4a',
  '#8db0ff', '#c7a9ff', '#a4daff', '#c0caf5',
}
for index, color in ipairs(terminal_colors) do
  vim.g['terminal_color_' .. (index - 1)] = color
end
vim.g.colors_name = 'tokyonight-night'

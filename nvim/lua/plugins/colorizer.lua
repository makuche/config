return {
  'norcalli/nvim-colorizer.lua',
  config = function()
    require('colorizer').setup {
      '*', -- highlight color codes in all files
    }
  end,
}

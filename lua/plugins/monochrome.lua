if true then
  return {}
else
  return {
    "kdheepak/monochrome.nvim",
    lazy = false, -- load immediately (colorschemes should load early)
    priority = 1000, -- make sure it loads before other UI plugins
  }
end

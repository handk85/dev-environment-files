-- import comment plugin safely
local setup, autotag = pcall(require, "nvim-ts-autotag")
if not setup then
  return
end

autotag.setup({
  opts = {
    -- Defaults
    enable_close = true, -- Auto close tags
    enable_rename = true, -- Auto rename pairs of tags
    enable_close_on_slash = true, -- Auto close on trailing </
  },
})

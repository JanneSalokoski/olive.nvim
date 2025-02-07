# Olive.nvim - edit your file tree as a buffer

*Olive is active development and not ready to be used yet!*

Olive.nvim is a plugin that allows you to edit your filesystem tree
as a vim buffer, with all vims editing capabilities.

Olive takes massive amounts of inspiration from oil. That's where
the name comes from: what is common between oil and trees? Olives!

## Installation

Right now the plugin is in active development and not ready to be used.
Therefore it shouldn't be loaded from github, but from a local directory.

### lazy.nvim

```lua
return {
    dir = "~/sources/olive.nvim/",
    name = "olive",
    lazy = false,
    dev = true,
    opts = {},
    keys = {
        {
            "<leader>o",
            function() require("olive").open() end,
            desc = "Open olive"
        }
    }
}
```

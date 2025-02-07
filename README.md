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

## Roadmap

I want to implement these features, pretty much in the
order they are presented:

- [x] Open a custom Olive buffer
- [x] Read file-tree and write it to the buffer
- [x] Render metadata as virtual text
- [ ] Track buffer edits and modify real file-tree to match
    - [ ] Deletions and additions (rm, rmdir, touch, mkdir)
    - [ ] Renaming (mv)
    - [ ] Yanking and pasting (cp)
    - [ ] Show an action plan
    - [ ] Show a confirmation window
- [ ] Configurable options for columns / time_formats, etc
- [ ] mini.icons / webdev-icons support
- [ ] File operations done on temp first, not applied if errors
- [ ] Keymaps for toggling options
- [ ] Undo support (Vim undo and write might not be enough!)
- [ ] Floating window
- [ ] Preview window
- [ ] Fzf search + highlight (maybe not necessary, but nice to have)
- [ ] Cmdline commands as well as lua functions

I will most likely not be supporting windows or mac,
but that depends on how I will turn out to actually
implement the file operations.

# ___NeoVim Configuration Files___

My personal config files as windows user, with PowerShell as default shell.

## _Author_

- [@EricSiwakoti](https://github.com/EricSiwakoti)

## _Acknowledgements_

Inspired from multiple users with their own awesome configs. Thank you all.

## _Screenshots_

### Dashboard

![Dashboard](https://github.com/EricSiwakoti/Neovim_Config/blob/main/assets/Dashboard.png?raw=true)

### Workspace

![Workspace](https://github.com/EricSiwakoti/Neovim_Config/blob/main/assets/Workspace.png?raw=true)

### Telescope File Search

![Telescope](https://github.com/EricSiwakoti/Neovim_Config/blob/main/assets/Telescope%20File%20Search.png?raw=true)

# ___Awesome NeoVim Setup___

## _Table Of Contents_

1. [Dashboard](#dashboard-nvim)
2. [Copilot Integration](#copilot-integration)
3. [Autocompletion](#autocompletion)
4. [LSP and Autotagging](#lsp-and-autotagging)
5. [Navigation and File Management](#navigation-and-file-management)
6. [Code Analysis and Formatting](#code-analysis-and-formatting)
7. [Customization and Productivity](#customization-and-productivity)
8. [Miscellaneous Plugins](#miscellaneous-plugins)

<a name="dashboard-nvim"></a>
### Dashboard

- **dashboard-nvim**: A minimalist dashboard inspired by doom-emacs, providing quick access to frequently used commands and files.

<a name="copilot-integration"></a>
### Copilot Integration

- **copilot.lua**: Integrates GitHub Copilot for AI-powered autocomplete and chat functionality within Neovim.
- **CopilotChat.nvim**: Enhances the Copilot experience with a custom UI and additional features.

<a name="autocompletion"></a>
### Autocompletion

- **nvim-cmp**: A completion engine for Neovim that supports many sources and formats.
- **cmp-buffer**: Provides buffer completion for nvim-cmp.
- **cmp-nvim-lsp**: Offers LSP completion for nvim-cmp.
- **cmp_luasnip**: Supports Luasnip snippets for autocompletion.
- **friendly-snippets**: Provides friendly snippet completions for nvim-cmp.
- **lualine.nvim**: Displays the current mode, file type, and other useful information in the status line.

<a name="lsp-and-autotagging"></a>
### LSP and Autotagging

- **nvim-lspconfig**: Configures Language Server Protocol (LSP) clients for various languages.
- **mason.nvim**: Manages LSP servers and DAP (Debugger Attached Program) configurations.
- **nvim-treesitter**: Provides syntax highlighting and other tree-sitter functionality.
- **nvim-ts-autotag**: Automatically adds XML tags based on nvim-treesitter.

<a name="navigation-and-file-management"></a>
### Navigation and File Management

- **nvim-tree.lua**: Provides an enhanced file explorer for Neovim.
- **leap.nvim**: Offers fuzzy finding across project buffers and mru (most recently used) files.
- **telescope.nvim**: A powerful fuzzy finder for Neovim.

<a name="code-analysis-and-formatting"></a>
### Code Analysis and Formatting

- **indent-blankline.nvim**: Ensures consistent indentation for code blocks.
- **which-key.nvim**: Displays keybindings visually for easier navigation.

<a name="customization-and-productivity"></a>
### Customization and Productivity

- **nvim-autopairs**: Automatically adds closing brackets/parentheses/quotes.
- **noice.nvim**: Provides a highly customizable UI for messages, cmdline, and popup menu.
- **nui.nvim**: Offers a NERDTree-like sidebar for easy navigation.
- **true-zen.nvim**: Helps maintain focus by hiding distractions.

<a name="miscellaneous-plugins"></a>
### Miscellaneous Plugins

- **Comment.nvim**: Adds comment formatting capabilities.
- **lspsaga.nvim**: Provides an outline for LSP documents.
- **playground**: Offers interactive playgrounds for testing code snippets.
- **vim-fugitive**: Enhances Git integration within Neovim.
- **vim-illuminate**: Highlights matching pairs of parentheses, brackets, quotes, XML tags, etc.
- **nightfox.nvim**: Provides a set of color schemes for Neovim.

## _Installation_

To install this configuration, clone this repository and run the setup script. This will guide you through the installation process for all plugins listed above.

## _Configuration_

All plugin configurations are located in the `plugins.lua` file. You can customize each plugin's settings by modifying the corresponding configuration block.

## _Contributing_

Contributions are welcome! Please feel free to submit pull requests or open issues for any improvements or bug reports.

# my_nvim_config

most LSP's are setup with default settings set by the LSP plugins:

```lua
-- LSP CONFIG
require("mason").setup()
local mason_lspconfig = require("mason-lspconfig")
mason_lspconfig.setup({
	ensure_installed = { "lua_ls", "clangd", "pyright", "ts_ls" },
	automatic_installation = true,
})

local lspconfig = require("lspconfig")
mason_lspconfig.setup_handlers({

	-- sets up all servers with  default settings
	function(server_name)
		lspconfig[server_name].setup({
			capabilities = require("cmp_nvim_lsp").default_capabilities(),
		})
	end,
})
```

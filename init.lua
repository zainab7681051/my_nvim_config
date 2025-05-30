-- find: in command mode :?text and text will be highlighted
-- find and replace: in command mode ":%s/old-text/new-text/g". 'g' for instant replace 'gc' confirmation and '%' can be replace with range of lines ("1,100/old-text/new-text/g"), varients can also be used ("1,100/(old, Old, OLD)/(new, New, NEW)/g")

local current_theme = "catppuccin-mocha"
local enable_lsp = false
local enable_format_on_save = false
local setup_tabs = false
local enable_formatters = false
local default_shell = "pwsh.exe"

vim.cmd.colorscheme(current_theme)
vim.opt.number = true
-- vim.opt.relativenumber = true
vim.opt.syntax = "enable"
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.opt.mouse = "a"

vim.g.mapleader = " "

-- SET DEFAULT SHELL
vim.o.shell = default_shell

-- KEYMAPS
vim.keymap.set("n", "<leader>w", ":w<CR>", { noremap = true }) -- save file
vim.keymap.set("n", "<leader>x", ":wq<CR>", { noremap = true }) -- save and exit
vim.keymap.set("n", "<leader>q", ":q!<CR>", { noremap = true }) -- exit without save

vim.keymap.set("n", "<leader><leader>", ":", { noremap = true }) -- enter cmd mode

-- NAVIGATION
vim.keymap.set("n", "<leader>h", "<C-w>h", { noremap = true })
vim.keymap.set("n", "<leader>j", "<C-w>j", { noremap = true })
vim.keymap.set("n", "<leader>k", "<C-w>k", { noremap = true })
vim.keymap.set("n", "<leader>l", "<c-w>l", { noremap = true })

vim.keymap.set("n", "<leader>r", ":source %<CR>", { silent = true, noremap = true }) -- reload config file

vim.keymap.set({ "n", "v" }, "<leader>y", '"+y', { noremap = true }) -- copy text to system clipboard

vim.keymap.set("n", "r", "<c-r>", { noremap = true }) -- redo

-- RESIZING SPLIT SCREENS
--Increase/decrease height
vim.keymap.set("n", "<leader>w=", "<C-w>+", { noremap = true })
vim.keymap.set("n", "<leader>w-", "<C-w>-", { noremap = true })
--Increase/decrease width
vim.keymap.set("n", "<leader>w<", "<C-w><", { noremap = true })
vim.keymap.set("n", "<leader>w>", "<C-w>>", { noremap = true })
--Make all splits equal
vim.keymap.set("n", "<leader>w0", "<C-w>=", { noremap = true })
--Exchange the current window with the next ones
vim.keymap.set("n", "<leader>wx", "<c-w>x", { noremap = true })
--Rotate all windows
vim.keymap.set("n", "<leader>wr", "<C-w>r", { noremap = true })

-- TERMINAL
local term_s = ":split | resize 6 | term<CR> <c-w>x <c-w>j i"
vim.keymap.set("n", "<leader>t", term_s, { noremap = true }) -- bring up terminal split screen
vim.keymap.set("t", "<ESC>", "<C-\\><C-n>", { noremap = true }) -- exit terminal

vim.keymap.set("n", "<leader>v", "<C-q>", { noremap = false }) -- visual block

-- auto close pairs
local function smart_close_pair(char)
	local line = vim.fn.getline(".")
	local col = vim.fn.col(".")
	local next_char = line:sub(col, col)
	if next_char == char then
		return "<Right>"
	else
		if char == "{" then
			next_char = "}"
			return char .. next_char .. "<Left>"
		end
		if char == "(" then
			next_char = ")"
			return char .. next_char .. "<Left>"
		end
		if char == "[" then
			next_char = "]"
			return char .. next_char .. "<Left>"
		end
		return char .. char .. "<Left>"
	end
end

vim.keymap.set("i", '"', function()
	return smart_close_pair('"')
end, { noremap = true, expr = true })
vim.keymap.set("i", "'", function()
	return smart_close_pair("'")
end, { noremap = true, expr = true })
vim.keymap.set("i", "`", function()
	return smart_close_pair("`")
end, { noremap = true, expr = true })
vim.keymap.set("i", "(", function()
	return smart_close_pair("(")
end, { noremap = true, expr = true })
vim.keymap.set("i", "[", function()
	return smart_close_pair("[")
end, { noremap = true, expr = true })
vim.keymap.set("i", "{", function()
	return smart_close_pair("{")
end, { noremap = true, expr = true })

-- ----------------------------------------------------------------------------- --

local ensure_packer = function()
	local fn = vim.fn
	local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
	if fn.empty(fn.glob(install_path)) > 0 then
		fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
		vim.cmd([[packadd packer.nvim]])
		return true
	end
	return false
end

local packer_bootstrap = ensure_packer()

-- START PACKER
require("packer").startup(function(use)
	-- PLUGIN MANAGER
	use("wbthomason/packer.nvim")

	-- AUTOMATICALLY SET UP CONFIG AFTER CLONING PACKER
	if packer_bootstrap then
		require("packer").sync()
	end

	-- PLUGINS
	use({
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",
		requires = { { "nvim-lua/plenary.nvim" } },
	})
	use({
		"nvim-tree/nvim-web-devicons",
	})
	use({
		"nvim-tree/nvim-tree.lua",
	})
	use({
		"nvim-lualine/lualine.nvim",
		requires = { "nvim-tree/nvim-web-devicons", opt = true },
	})

	use("lewis6991/gitsigns.nvim")
	use("romgrk/barbar.nvim")

	--LSP
	use("williamboman/mason.nvim")
	use("williamboman/mason-lspconfig.nvim")
	use("neovim/nvim-lspconfig")
	use({
		-- Autocompletion engine
		"hrsh7th/nvim-cmp",
		requires = {
			"hrsh7th/cmp-nvim-lsp", -- LSP completions
			"hrsh7th/cmp-buffer", -- Text from buffer
			"hrsh7th/cmp-path", -- File paths
		},
	})
	-- THEMES
	use("catppuccin/nvim")
	use("Mofiqul/vscode.nvim")
	use("rebelot/kanagawa.nvim")

	-- FORMMATER
	use({
		"stevearc/conform.nvim",
	})
end)

-- SET UP AND CONFIGURE PLUGINS
require("nvim-web-devicons").setup({ default = true })

require("lualine").setup()

require("nvim-tree").setup({
	sort = {
		sorter = "case_sensitive",
	},
	view = {
		width = 20,
	},
	renderer = {
		group_empty = true,
	},
	-- SHOWS IGNORED FILES
	git = { enable = true, ignore = false, timeout = 2500 },
})
vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", {})

require("telescope").setup()
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })
--[[ default mappings for telescope fuzzy finder
<C-x>	Go to file selection as a split (horizental)
<C-v>	Go to file selection as a vsplit (vertical)
<C-t>	Go to a file in a new tab
<C-c>	Close telescope (insert mode)
<Esc>	Close telescope (in normal mode)
]]

vim.diagnostic.config({
	virtual_text = true,
	signs = true,
})

require("mason").setup()

-- LSP CONFIG
if enable_lsp then
	local mason_lspconfig = require("mason-lspconfig")
	mason_lspconfig.setup({
		ensure_installed = { "lua_ls", "clangd", "pyright", "ts_ls" },
		automatic_installation = true,
	})

	local lspconfig = require("lspconfig")
	mason_lspconfig.setup_handlers({

		-- sets up all servers with default settings
		function(server_name)
			lspconfig[server_name].setup({
				capabilities = require("cmp_nvim_lsp").default_capabilities(),
			})
		end,

		-- SPECIFIC SETTINGS FOR SPECIFIC LSP SERVERS
		-- LUA
		["lua_ls"] = function()
			lspconfig.lua_ls.setup({
				settings = {
					Lua = {
						runtime = { version = "LuaJIT" },
						diagnostics = { globals = { "vim" } },
						workspace = {
							library = {
								vim.env.VIMRUNTIME,
							},
							checkThirdParty = false,
						},
						telemetry = { enable = false },
					},
				},
			})
		end,

		-- C/C++
		["clangd"] = function()
			lspconfig.clangd.setup({
				capabilities = require("cmp_nvim_lsp").default_capabilities(),
				cmd = {
					"clangd",
					"--background-index",
					"--clang-tidy",
					"--header-insertion=never",
				},
			})
		end,

		-- PYTHON
		["pyright"] = function()
			lspconfig.pyright.setup({
				settings = {
					python = {
						analysis = {
							typeCheckingMode = "basic",
							autoSearchPaths = true,
							useLibraryCodeForTypes = true,
						},
					},
				},
				before_init = function(_, config)
					config.settings.python.pythonPath = "~/.venv/bin/python"
				end,
			})
		end,
	})
end

-- AUTOCOMPLETE SETUP
local cmp = require("cmp")
cmp.setup({
	sources = {
		{ name = "nvim_lsp" }, -- LSP-based completions
		{ name = "buffer" }, -- Words from current buffer
		{ name = "path" }, -- File paths
	},
	mapping = {
		["<CR>"] = cmp.mapping.confirm({ select = true }), -- Enter to confirm
		["<C-Space>"] = cmp.mapping.complete(), -- Ctrl+Space to trigger completions
		["<Tab>"] = cmp.mapping.select_next_item(), -- Navigate completions
		["<S-Tab>"] = cmp.mapping.select_prev_item(),
	},
})

-- FORMATTING
local conform_f = require("conform")
local function check_format_on_save()
	if enable_format_on_save then
		return {
			timeout_ms = 2500,
			lsp_fallback = true, -- Use LSP if no formatter defined
		}
	end
	return nil
end

conform_f.setup({
	formatters_by_ft = {
		lua = { "stylua" },
	},

	format_on_save = check_format_on_save(),

	-- FORMATTER OPTIONS
	formatters = {},
})

-- FORMAT
vim.keymap.set({ "n", "v" }, "<leader>f", function()
	conform_f.format({
		async = true,
		timeout_ms = 2500,
		lsp_fallback = true,
	})
end, { desc = "Format file or range (visual mode)" })

-- CODE NAVIGATION MAPPINGS
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "Find references" })
vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover documentation" })
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code actions" })

-- BARBAR TABS BAR SETUP & MAPPINGS
vim.g.barbar_auto_setup = false
if setup_tabs then
	require("barbar").setup({
		tabpages = true,
		clickable = true,
	})

	-- Move to previous/next
	vim.keymap.set("n", "<A-,>", "<Cmd>BufferPrevious<CR>", { noremap = true, silent = true })
	vim.keymap.set("n", "<A-.>", "<Cmd>BufferNext<CR>", { noremap = true, silent = true })

	-- Re-order to previous/next
	vim.keymap.set("n", "<A-<>", "<Cmd>BufferMovePrevious<CR>", { noremap = true, silent = true })
	vim.keymap.set("n", "<A->>", "<Cmd>BufferMoveNext<CR>", { noremap = true, silent = true })

	-- Goto buffer in position...
	vim.keymap.set("n", "<A-1>", "<Cmd>BufferGoto 1<CR>", { noremap = true, silent = true })
	vim.keymap.set("n", "<A-2>", "<Cmd>BufferGoto 2<CR>", { noremap = true, silent = true })
	vim.keymap.set("n", "<A-3>", "<Cmd>BufferGoto 3<CR>", { noremap = true, silent = true })
	vim.keymap.set("n", "<A-4>", "<Cmd>BufferGoto 4<CR>", { noremap = true, silent = true })
	vim.keymap.set("n", "<A-5>", "<Cmd>BufferGoto 5<CR>", { noremap = true, silent = true })
	vim.keymap.set("n", "<A-6>", "<Cmd>BufferGoto 6<CR>", { noremap = true, silent = true })
	vim.keymap.set("n", "<A-7>", "<Cmd>BufferGoto 7<CR>", { noremap = true, silent = true })
	vim.keymap.set("n", "<A-8>", "<Cmd>BufferGoto 8<CR>", { noremap = true, silent = true })
	vim.keymap.set("n", "<A-9>", "<Cmd>BufferGoto 9<CR>", { noremap = true, silent = true })
	vim.keymap.set("n", "<A-0>", "<Cmd>BufferLast<CR>", { noremap = true, silent = true })

	-- Pin/unpin buffer
	vim.keymap.set("n", "<A-p>", "<Cmd>BufferPin<CR>", { noremap = true, silent = true })

	-- Goto pinned/unpinned buffer
	--:BufferGotoPinned
	--:BufferGotoUnpinned

	-- Close buffer
	vim.keymap.set("n", "<A-c>", "<cmd>BufferClose<cr>", { noremap = true, silent = true })

	-- Wipeout buffer
	--:BufferWipeout
	-- Close commands
	--:BufferCloseAllButCurrent
	vim.keymap.set("n", "<A-a>", "<cmd>BufferCloseAllButCurrent<cr>", { noremap = true, silent = true })
	--:BufferCloseAllButPinned
	--:BufferCloseAllButCurrentOrPinned
	--:BufferCloseBuffersLeft
	--:BufferCloseBuffersRight

	-- Magic buffer-picking mode
	vim.keymap.set("n", "<C-p>", "<Cmd>BufferPick<CR>", { noremap = true, silent = true })
	vim.keymap.set("n", "<C-s-p>", "<Cmd>BufferPickDelete<CR>", { noremap = true, silent = true })

	-- Sort automatically by...
	vim.keymap.set("n", "<Space>bb", "<Cmd>BufferOrderByBufferNumber<CR>", { noremap = true, silent = true })
	vim.keymap.set("n", "<Space>bn", "<Cmd>BufferOrderByName<CR>", { noremap = true, silent = true })
	vim.keymap.set("n", "<Space>bd", "<Cmd>BufferOrderByDirectory<CR>", { noremap = true, silent = true })
	vim.keymap.set("n", "<Space>bl", "<Cmd>BufferOrderByLanguage<CR>", { noremap = true, silent = true })
	vim.keymap.set("n", "<Space>bw", "<Cmd>BufferOrderByWindowNumber<CR>", { noremap = true, silent = true })

	-- Other:
	--:BarbarEnable - enables barbar (enabled by default)
	--:BarbarDisable - very bad command, should never be used
end
---------------------------------

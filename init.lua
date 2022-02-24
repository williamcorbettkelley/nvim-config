-- Install packer
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
end
vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.hidden = true
vim.o.relativenumber = true
vim.o.number = true
vim.o.exrc = true
vim.o.errorbells = false
vim.o.smartindent = true
vim.o.hlsearch = false
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.swapfile = false
vim.o.backup = false
vim.o.undodir = '~/.config/nvim/undodir'
vim.o.undofile = true
vim.o.incsearch = true
vim.o.scrolloff = 6
vim.o.colorcolumn = '80'
vim.o.signcolumn = 'yes'
vim.g.mapleader = " "
vim.o.termguicolors = true
vim.cmd[[colorscheme zenburn]]
vim.o.mouse = 'a'

local use = require('packer').use
require('packer').startup(function()
    use 'wbthomason/packer.nvim'
    use 'nvim-lua/plenary.nvim'
    use {'nvim-telescope/telescope.nvim',
	requires = { {'nvim-lua/plenary.nvim'}}}
    use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}
    use 'kyazdani42/nvim-web-devicons'
    use 'neovim/nvim-lspconfig'
    use 'mfussenegger/nvim-dap'
    use { "rcarriga/nvim-dap-ui", requires = {"mfussenegger/nvim-dap"} }
    use 'tanvirtin/monokai.nvim'
    use 'tpope/vim-surround'
    use 'tpope/vim-fugitive'
    use 'terrortylor/nvim-comment'
    use 'mbbill/undotree'
    use 'vim-airline/vim-airline'
    use 'preservim/nerdtree'
    use 'vim-airline/vim-airline-themes'
    use 'williamboman/nvim-lsp-installer'
    use 'hrsh7th/nvim-cmp'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'saadparwaiz1/cmp_luasnip'
    use 'L3MON4D3/LuaSnip'
    use 'rafamadriz/friendly-snippets'
    use 'tpope/vim-endwise'
    use 'rstacruz/vim-closer'
    use 'klen/nvim-config-local'
    use 'akinsho/toggleterm.nvim'
    use 'ludovicchabant/vim-gutentags'
    use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
    use { "tami5/sqlite.lua" }
    use {'nvim-telescope/telescope-frecency.nvim', requires = 'tami15/sqlite.lua'}
    use 'theHamsta/nvim-dap-virtual-text'
end)

--util keymaps
local opts = {silent = true, remap = false}
vim.keymap.set({'n', 'v'}, 'j', 'gj', opts)
vim.keymap.set({'n', 'v'}, 'k', 'gk', opts)
vim.keymap.set('i', '<Down>', '<C-o>gj', opts)
vim.keymap.set('i', '<Up>', '<C-o>gk', opts)
vim.keymap.set('n', '<leader>hrr', ':so /home/wk/.config/nvim/init.lua<CR>', opts)
vim.keymap.set('n', ';;', '<escape>A;<escape>', opts)
vim.keymap.set('n', ',,', '<escape>A,<escape>', opts)
vim.keymap.set('n', '<leader>pi', ':PackerInstall<CR>', opts)
vim.keymap.set('n', '<leader>ps', ':PackerSync<CR>', opts)
vim.keymap.set('n', '<leader>wo', ':only<CR>', opts)




-- LSP Config
local lspconfig = require 'lspconfig'
local lsp_installer = require "nvim-lsp-installer"

-- Include the servers you want to have installed by default below
local servers = {
  "bashls",
  "pyright",
  "clangd",
  "sumneko_lua",
  "texlab",
}

for _, name in pairs(servers) do
    local server_is_found, server = lsp_installer.get_server(name)
    if server_is_found then
        if not server:is_installed() then
            print("Installing " .. name)
            server:install()
        end
    end
end

local on_attach = function(_, bufnr)
    --Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, {buffer = bufnr, table.unpack(opts)})
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {buffer = bufnr, table.unpack(opts)})
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, {buffer = bufnr, table.unpack(opts)})
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, {buffer = bufnr, table.unpack(opts)})
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, {buffer = bufnr, table.unpack(opts)})
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, {buffer = bufnr, table.unpack(opts)})
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, {buffer = bufnr, table.unpack(opts)})
    vim.keymap.set('n', '<space>wl', vim.inspect(vim.lsp.buf.list_workspac_folders()), {buffer = bufnr, table.unpack(opts)})
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, {buffer = bufnr, table.unpack(opts)})
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, {buffer = bufnr, table.unpack(opts)})
    vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, {buffer = bufnr, table.unpack(opts)})
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, {buffer = bufnr, table.unpack(opts)})
    vim.keymap.set('n', '<space>e', vim.lsp.diagnostic.show_line_diagnostics, {buffer = bufnr, table.unpack(opts)})
    vim.keymap.set('n', '[d', vim.lsp.diagnostic.goto_prev, {buffer = bufnr, table.unpack(opts)})
    vim.keymap.set('n', ']d', vim.lsp.diagnostic.goto_next, {buffer = bufnr, table.unpack(opts)})
    vim.keymap.set('n', '<space>q', vim.lsp.diagnostic.set_loclist, {buffer = bufnr, table.unpack(opts)})
    vim.keymap.set('n', '<space>=', vim.lsp.buf.formatting, {buffer = bufnr, table.unpack(opts)})
end

-- nvim-cmp supports additional completion capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

-- Enable the following language servers
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- luasnip setup
local luasnip = require 'luasnip'

-- nvim-cmp setup
local cmp = require'cmp'

cmp.setup({
    snippet = {
        -- REQUIRED - you must specify a snippet engine
        expand = function(args)
            luasnip.lsp_expand(args.body) -- For `luasnip` users.
        end,
    },
    mapping = {
        ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
        ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
        ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
        ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
        ['<C-e>'] = cmp.mapping({
            i = cmp.mapping.abort(),
            c = cmp.mapping.close(),
        }),
        ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    },
    sources = cmp.config.sources({
    { name = 'nvim_lsp' },
        { name = 'luasnip' }, -- For luasnip users.
    }, {
        { name = 'buffer' },
        })
})

  -- Set configuration for specific filetype.
  cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it. 
    }, {
      { name = 'buffer' },
    })
  })

  -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline('/', {
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })

local sumneko_binary_path = vim.fn.exepath('lua-language-server')
local sumneko_root_path = vim.fn.fnamemodify(sumneko_binary_path, ':h:h:h')

local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")
require'lspconfig'.sumneko_lua.setup {
    cmd = {sumneko_binary_path, "-E", sumneko_root_path .. "/main.lua"};
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = 'LuaJIT',
                -- Setup your lua path
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = {'vim'},
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                checkThirdParty = false,
                library = "${3rd}/love2d/library",
                preloadFileSize = 2000000
            },
            telemetry = {
                enable = true,
            },
        },
    },
}

-- LuaSnip
require("luasnip.loaders.from_vscode").load()
-- nvim comment
require('nvim_comment').setup()

-- dap
local dap = require('dap')
dap.adapters.cppdbg = {
  id = 'cppdbg',
  type = 'executable',
  command = '/home/wk/.vscode/extensions/ms-vscode.cpptools-1.8.4/debugAdapters/bin/OpenDebugAD7',
}

--  dap keymaps
local dapui = require 'dapui'
local dapend = nil
local dapmaps = {
    {'n', '<C-c>', function() dap.continue() end, opts},
    {'n', '<C-s>', function() dap.step_over() end, opts},
    {'n', '<C-d>', function() dap.step_into() end, opts},
    {'n', '<C-f>', function() dap.step_out() end, opts},
    {'n', '<C-v>', function() dap.run_to_cursor() end, opts},
    {'n', '<C-o>', function() dap.repl.toggle() end, opts},
    {'n', '<C-x>', function() dapend() end, opts},
}

function dapend ()
    dap.terminate()
    dapui.close()
    for _, map in ipairs(dapmaps) do
        vim.keymap.del(map[1], map[2])
    end
    vim.cmd(':bd! */bin/sh')
end
vim.keymap.set('n', '<leader>dd', dap.continue, opts)
vim.keymap.set('n', '<leader>dl', dap.run_last, opts)
vim.keymap.set('n', '<leader>dbb', dap.toggle_breakpoint, opts)
vim.keymap.set('n', '<leader>dbc', function() dap.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, opts)
vim.keymap.set('n', '<leader>dbp', function() dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end, opts)



-- ui
dapui.setup()

dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
    for _, map in ipairs(dapmaps) do
        vim.keymap.set(map[1], map[2], map[3], map[4])
    end
end
dap.listeners.after.event_terminated["dapui_config"] = function()
    dapui.close()
    for _, map in ipairs(dapmaps) do
        vim.keymap.del(map[1], map[2])
    end
    vim.cmd(':bd! */bin/sh')
end
-- toggleterm
vim.keymap.set('n', '<leader>tt', ':ToggleTerm<CR>', opts)

-- local configs
require('config-local').setup {
    -- Default configuration (optional)
    config_files = { ".vimrc.lua", ".vimrc" },  -- Config file patterns to load (lua supported)
    hashfile = vim.fn.stdpath("data") .. "/config-local", -- Where the plugin keeps files data
    autocommands_create = true,                 -- Create autocommands (VimEnter, DirectoryChanged)
    commands_create = true,                     -- Create commands (ConfigSource, ConfigEdit, ConfigTrust, ConfigIgnore)
    silent = true,                             -- Disable plugin messages (Config loaded/ignored)
}

-- telescope
local telescope = require('telescope')
local tel_built = require('telescope.builtin')
telescope.setup()
telescope.load_extension('fzf')
telescope.load_extension('frecency')

-- telescope Mappings
vim.keymap.set('n', '<leader>ff', tel_built.find_files, opts)
vim.keymap.set('n', '<leader>fg', tel_built.live_grep, opts)
vim.keymap.set('n', '<leader>fb', tel_built.buffers, opts)
vim.keymap.set('n', '<leader>fh', tel_built.help_tags, opts)

-- treesitter
require'nvim-treesitter.configs'.setup {
    highlight = { enable = true },
    incremental_selection = { enable = true },
    indent = { enable = true },
}

--dap virtual text
require('nvim-dap-virtual-text').setup {
    highlight_changed_variables = true,
    highlight_new_as_changed = true,
}
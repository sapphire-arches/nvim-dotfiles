plugins = require('plugins')

-- Treesitter config
require('nvim-treesitter.configs').setup {
  highlight = {
    enable = true,
  }
}

-- Select colorscheme
vim.cmd("colorscheme kanagawa")

-- Key binding utilities
function map(mode, shortcut, command)
  vim.api.nvim_set_keymap(mode, shortcut, command, { noremap = true, silent = true })
end

function nmap(shortcut, command)
  map('n', shortcut, command)
end

function imap(shortcut, command)
  map('i', shortcut, command)
end

-- Telescope config
require('telescope').setup {
  extensions = {
    fzf = {
      fuzzy = true,                    -- false will only do exact matching
      override_generic_sorter = true,  -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
    }
  }
}

require('telescope').load_extension('fzf')

nmap('<leader>p' , '<cmd>Telescope find_files<cr>')
nmap('<leader>b' , '<cmd>Telescope buffers<cr>')
nmap('<leader>s' , '<cmd>Telescope live_grep<cr>')
nmap('<leader>sl', '<cmd>lua require("telescope.builtin").live_grep({grep_open_files=true})<cr>')
nmap('<leader>st', '<cmd>Telescope treesitter<cr>')

-- LSP config
local lspconfig = require('lspconfig')

local on_attach = function(client, buffer) 
  local function map_buf(mode, shortcut, command)
    vim.api.nvim_buf_set_keymap(
      buffer, mode, shortcut, command, { noremap = true, silent = true }
    )
  end

  local function nmap_buf(shortcut, command) map_buf('n', shortcut, command) end

  nmap_buf('gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
  nmap_buf('K' , '<cmd>lua vim.lsp.buf.hover()<CR>')
  nmap_buf(',=', '<cmd>lua vim.lsp.buf.formatting()<CR>')

  nmap_buf('<leader>qf', '<cmd>lua vim.lsp.buf.code_action()<CR>')
  nmap_buf('<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>')

  nmap_buf(']g', '<cmd>lua vim.diagnostic.goto_next()<CR>')
  nmap_buf('[g', '<cmd>lua vim.diagnostic.goto_prev()<CR>')
  nmap_buf('<leader>e' , '<cmd>lua vim.diagnostic.open_float()<CR>')
end

-- Rust LSP config
require('rust-tools').setup({
  server = {
    on_attach = on_attach,
    -- TODO: move this script to somewhere under the nvim data directory
    cmd = { vim.fn.stdpath('config')..'/bin/rust-analyzer-from-path.sh' },
    settings = {
      ["rust-analyzer"] = {
        cargo = {
          runBuildScripts = true,
        },
        procMacro = {
          enable = true,
        }
      }
    }
  }
})

require('rust-tools.hover_actions').hover_actions()

-- Autocomplete config
local cmp = require 'cmp'
local luasnip = require 'luasnip'

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

cmp.setup {
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end,
    ['<S-Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end,
  },
  sources = {
    { name = 'nvim_lsp' },
    {
      name = 'buffer',
      options = {
        get_bufnrs = function()
          return vim.api.nvim_list_bufs()
        end
      }
    },
    {
      name = 'path',
      trigger_characters = { '/', '.' }
    },
    { name = 'luasnip' },
  },

  experimental = {
    ghost_text = true,
  }
}

-- Lualine config
require('lualine').setup {
  sections = {
    lualine_c = {
      {
        'filename',
        path=1
      }
    }
  }
}

-- Mappings to close things with the leader key
nmap('<leader>qqf', '<cmd>cclose<CR>')
nmap('<leader>qq', '<cmd>quit<CR>')

-- Mappings for vim-fugitive
nmap('<leader>gs', '<cmd>Git<CR>')

-- Generic vim UI tweaks
vim.cmd([[
" More sane complete 
set completeopt=menu,menuone,noselect

" Listchars
set list
exec "set listchars=tab:\\|\\ ,trail:\uF8"

" Prevent lhs width flapping
set signcolumn=yes

" Solve tabs vs spaces war
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab

]])

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
require('rc_telescope')

-- autopairs
require('nvim-autopairs').setup({
})

-- LSP config
require('bt_lsp')

-- Autocomplete config
local cmp = require 'cmp'
local cmp_autopairs = require 'nvim-autopairs.completion.cmp'
local cmp_nvim_lsp = require 'cmp_nvim_lsp'
local luasnip = require 'luasnip'

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
    ['<S-CR>'] = cmp.mapping.confirm {
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

cmp.event:on(
  'confirm_done',
  cmp_autopairs.on_confirm_done()
)

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

-- Configure Leap
require('leap').set_default_keymaps()

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

" Expose title to the window system
set title

]])

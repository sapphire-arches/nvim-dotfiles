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

-- clangd config
lspconfig.ccls.setup {
  on_attach = on_attach
}

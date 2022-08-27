local telescope = require('telescope')
local keymap = require('vim.keymap')

telescope.setup {
  extensions = {
    fzf = {
      fuzzy = true,                    -- false will only do exact matching
      override_generic_sorter = true,  -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
    }
  }
}

local telescope_grep = function(search, prompt_directory)
  local status = true

  args = {}

  if search then
    args['search'] = search
  else
    status, search = pcall(vim.fn.input, "Search: ")
    if not status then
      return
    end
    args['search'] = search
  end

  if prompt_directory then
    status, directory = pcall(vim.fn.input, "Directory: ", "", "file")
    if not status then
      print(vim.inspect(directory))
      return
    end
    args['cwd'] = directory
  end
  require("telescope.builtin").grep_string(args)
end

telescope.load_extension('fzf')

local telescope_map = function(key, command)
  keymap.set('n', '<Leader>' .. key, command, {
    noremap=true, silent=true
  })
end

telescope_map('p' , '<cmd>Telescope find_files<CR>')
telescope_map('s' , function ()
  local search = vim.fn.getreg('"')
  telescope_grep(search)
end)
telescope_map('ss', function ()
  telescope_grep(nil, false)
end)

telescope_map('sid', function()
  local search = vim.fn.getreg('"')
  telescope_grep(search, true)
end)
telescope_map('ssid', function()
  telescope_grep(nil, true)
end)

telescope_map('sib' , '<cmd>lua require("telescope.builtin").live_grep({ grep_open_files=true, })<CR><C-R>"')
telescope_map('ssib', '<cmd>lua require("telescope.builtin").live_grep({ grep_open_files=true, })<CR>')
-- telescope_map('ss', ':Rg ', false)
-- telescope_map('w', '<cmd>Telescope windows', true)
telescope_map('b', '<cmd>Telescope buffers<CR>')
telescope_map('sf', '<cmd>lua require("telescope.builtin").treesitter()<CR>')

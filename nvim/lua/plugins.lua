-- On ly required if you have packer in your `opt` pack
local packer_exists = pcall(vim.cmd, [[packadd packer.nvim]])

if not packer_exists then
  if vim.fn.input("Download Packer? (y for yes)") ~= "y" then
    return
  end

  local directory = string.format(
    '%s/site/pack/packer/opt/',
    vim.fn.stdpath('data')
  )

  vim.fn.mkdir(directory, 'p')

  local out = vim.fn.system(string.format(
      'git clone %s %s',
      'https://github.com/wbthomason/packer.nvim',
      directory .. '/packer.nvim'
    ))

  print(out)
  print("Downloading packer.nvim...")

  return
end

local init = {
  {'wbthomason/packer.nvim', opt = true},

  {'tpope/vim-commentary', keys = {'gc'}},
  'tpope/vim-fugitive',
  'tpope/vim-unimpaired',
  'tpope/vim-repeat',
  'tpope/vim-eunuch',
  'tpope/vim-surround',

  {'AndrewRadev/bufferize.vim',
    cmd = 'Bufferize',
    config = function()
      vim.g.bufferize_command = 'enew'
      vim.cmd('autocmd vimrc FileType bufferize setlocal wrap')
    end
  },

  'vim-scripts/visualrepeat',
  'timakro/vim-searchant', -- Highlight the current search result

  {'tmhedberg/SimpylFold' , ft = 'python'},
  {'tmux-plugins/vim-tmux', ft = 'tmux'  },
  {'derekwyatt/vim-scala' , ft = 'scala' },

  'martinda/Jenkinsfile-vim-syntax',

  {'ap/vim-buftabline', disable=true},

  'dietsche/vim-lastplace',
  'christoomey/vim-tmux-navigator',
  'tmux-plugins/vim-tmux-focus-events',
  'ryanoasis/vim-devicons',
  'powerman/vim-plugin-AnsiEsc',

  'wellle/targets.vim',
  'michaeljsmith/vim-indent-object',

  {'whatyouhide/vim-lengthmatters',
    config = function()
      vim.g.lengthmatters_highlight_one_column = 1
    end
  },

  'justinmk/vim-dirvish',

  'lewis6991/vim-clean-fold',

  'rhysd/conflict-marker.vim',

  {'junegunn/vim-easy-align',
    keys = 'ga',
    config = function()
      vim.api.nvim_set_keymap('x', 'ga', '<Plug>(EasyAlign)', {})
      vim.api.nvim_set_keymap('n', 'ga', '<Plug>(EasyAlign)', {})
      vim.g.easy_align_delimiters = {
        [';']  = { pattern = ';'        , left_margin = 0 },
        ['[']  = { pattern = '['        , left_margin = 1, right_margin = 0 },
        [']']  = { pattern = ']'        , left_margin = 0, right_margin = 1 },
        [',']  = { pattern = ','        , left_margin = 0, right_margin = 1 },
        [')']  = { pattern = ')'        , left_margin = 0, right_margin = 0 },
        ['(']  = { pattern = '('        , left_margin = 0, right_margin = 0 },
        ['=']  = { pattern = [[<\?=>\?]], left_margin = 1, right_margin = 1 },
        ['|']  = { pattern = [[|\?|]]   , left_margin = 1, right_margin = 1 },
        ['&']  = { pattern = [[&\?&]]   , left_margin = 1, right_margin = 1 },
        [':']  = { pattern = ':'        , left_margin = 1, right_margin = 1 },
        ['?']  = { pattern = '?'        , left_margin = 1, right_margin = 1 },
        ['<']  = { pattern = '<'        , left_margin = 1, right_margin = 0 },
        ['\\'] = { pattern = '\\'       , left_margin = 1, right_margin = 0 },
        ['+']  = { pattern = '+'        , left_margin = 1, right_margin = 1 }
      }
    end
  },

  {'bfredl/nvim-miniyank',
    config = function()
      vim.api.nvim_set_keymap('n', 'p', '<Plug>(miniyank-autoput)', {})
      vim.api.nvim_set_keymap('n', 'P', '<Plug>(miniyank-autoPut)', {})
    end
  },

  'tjdevries/nlua.nvim',

  {'neovim/nvim-lspconfig',
    config = "require('lsp')"
  },

  'nvim-lua/completion-nvim',

  'nvim-lua/diagnostic-nvim',

  {'nvim-lua/telescope.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
    config = "require('telescope_config')"
  },

  'scalameta/nvim-metals',

  'nvim-lua/popup.nvim',
  'kyazdani42/nvim-web-devicons',

  {'~/projects/gitsigns.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('gitsigns').setup{
          -- debug_mode = true,
          signs = {
            add          = {hl = 'GitGutterAdd'   },
            change       = {hl = 'GitGutterChange'},
            delete       = {hl = 'GitGutterDelete'},
            topdelete    = {hl = 'GitGutterDelete'},
            changedelete = {hl = 'GitGutterChange'},
          }
        }
    end
  },

  {'nvim-treesitter/nvim-treesitter',
    config = "require('treesitter')",
    event = 'VimEnter *'
  },

  {'romgrk/barbar.nvim',
    config = function()
      vim.g.bufferline = {
        closable = false,
        shadow   = false
      }
      vim.api.nvim_set_keymap('n', '<Tab>'  , ':BufferNext<CR>'    , {silent=true})
      vim.api.nvim_set_keymap('n', '<S-Tab>', ':BufferPrevious<CR>', {silent=true})
    end
  },
}

vim.cmd('autocmd BufWritePost plugins.lua PackerCompile')

return require('packer').startup({init})

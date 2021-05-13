local install_path = vim.fn.stdpath('data')..'/site/pack/packer/opt/packer.nvim'

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  if vim.fn.input("Download Packer? (y for yes): ") ~= "y" then
    return
  end

  print("Downloading packer.nvim...")
  print(vim.fn.system(string.format(
    'git clone %s %s',
    'https://github.com/wbthomason/packer.nvim',
    install_path
  )))
end

vim.cmd 'packadd packer.nvim'

vim.cmd[[augroup plugins | autocmd! | augroup END]]

-- Reload plugins.lua
vim.cmd[[autocmd plugins BufWritePost plugins.lua lua package.loaded["plugins"] = nil; require("plugins")]]

-- Recompile lazy loaders
vim.cmd[[autocmd plugins BufWritePost plugins.lua PackerCompile]]

-- -- Reload lazy loaders
-- vim.cmd[[autocmd BufWritePost plugins.lua runtime plugin/packer_compiled.vim]]


local init = {
  {'wbthomason/packer.nvim', opt = true},

  'lewis6991/github_dark.nvim',

  {'justinmk/vim-dirvish', config = "require'dirvish'"},

  'tpope/vim-commentary',
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

  --- Filetype plugins ---
  {'tmux-plugins/vim-tmux', ft = 'tmux'  },
  {'derekwyatt/vim-scala' , ft = 'scala' },
  {'cespare/vim-toml'     },
  {'zinit-zsh/zinit-vim-syntax', ft = 'zsh'},
  'martinda/Jenkinsfile-vim-syntax',
  'teal-language/vim-teal',

  'tmhedberg/SimpylFold',

  {'lewis6991/foldsigns.nvim',
    config = function()
      require'foldsigns'.setup{
        exclude = {'GitSigns.*'}
      }
    end
  },

  'dietsche/vim-lastplace',
  'christoomey/vim-tmux-navigator',
  'ryanoasis/vim-devicons',
  'powerman/vim-plugin-AnsiEsc',

  {'neapel/vim-bnfc-syntax',
    config = function()
      -- Argh, why don't syntax plugins ever set commentstring!
      vim.cmd[[autocmd vimrc FileType bnfc setlocal commentstring=--%s]]
      -- This syntax works pretty well for regular BNF too
      vim.cmd[[autocmd vimrc BufNewFile,BufRead *.bnf setlocal filetype=bnfc]]
    end
  },

  'wellle/targets.vim',
  'michaeljsmith/vim-indent-object',

  {'whatyouhide/vim-lengthmatters',
    config = function()
      vim.g.lengthmatters_highlight_one_column = 1
    end
  },

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
        ['>']  = { pattern = '>'        , left_margin = 1, right_margin = 0 },
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

  {'scalameta/nvim-metals',
    config = function()
      setup_metals = function()
        require("metals").initialize_or_attach {
          init_options = {
            statusBarProvider = 'on'
          },
          settings = {
            showImplicitArguments = true,
          },
          on_attach = function()
            local keymap = function(mode, key, result)
              vim.api.nvim_buf_set_keymap(0, mode, key, result, {noremap = true, silent = true})
            end
            keymap('n', '<C-]>'     , '<cmd>lua vim.lsp.buf.definition()<CR>')
            keymap('n', 'K'         , '<cmd>lua vim.lsp.buf.hover()<CR>')
            keymap('n', 'gK'        , '<cmd>lua vim.lsp.buf.signature_help()<CR>')
            keymap('n', 'gr'        , '<cmd>lua vim.lsp.buf.references()<CR>')
            keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>')
            keymap('n', ']d'        , '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>')
            keymap('n', '[d'        , '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>')
            keymap('n', 'go'        , '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>')

            vim.bo.omnifunc = 'v:lua.vim.lsp.omnifunc'
          end
        }
      end

      vim.cmd('augroup metals_lsp')
      vim.cmd('au!')
      vim.cmd('au FileType scala,sbt lua setup_metals()')
      vim.cmd('augroup end')
    end
  },

  {'neovim/nvim-lspconfig',
    requires = {'tjdevries/nlua.nvim'},
    config = "require('lsp')"
  },

  {'hrsh7th/nvim-compe',
    requires = {'andersevenrud/compe-tmux'},
    config = function()
      require'compe'.setup {
        source = {
          path       = true;
          buffer     = true;
          nvim_lsp   = true;
          nvim_lua   = true;
          spell      = true;
          tmux       = true;
        }
      }

      local function t(str)
        return vim.api.nvim_replace_termcodes(str, true, true, true)
      end

      local check_back_space = function()
          local col = vim.fn.col('.') - 1
          if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
              return true
          else
              return false
          end
      end

      -- Use (s-)tab to:
      -- move to prev/next item in completion menuone
      _G.tab_complete = function()
        return vim.fn.pumvisible() == 1 and t'<C-n>'
        or     check_back_space()       and t'<Tab>'
        or     vim.fn['compe#complete']()
      end

      _G.s_tab_complete = function()
        return vim.fn.pumvisible() == 1 and t'<C-p>' or t'<S-Tab>'
      end

      vim.api.nvim_set_keymap('i', '<Tab>'  , 'v:lua.tab_complete()'  , {expr = true})
      vim.api.nvim_set_keymap('s', '<S-Tab>', 'v:lua.s_tab_complete()', {expr = true})
      vim.api.nvim_set_keymap('i', '<cr>'   , "compe#confirm('<CR>')" , {expr = true, silent = true, noremap = true})

      -- Workaround for https://github.com/hrsh7th/nvim-compe/issues/329
      vim.api.nvim_set_keymap('i', '<C-y>', 'pumvisible() ? "\\<C-y>\\<C-y>" : "\\<C-y>"', {expr = true} )
      vim.api.nvim_set_keymap('i', '<C-e>', 'pumvisible() ? "\\<C-y>\\<C-e>" : "\\<C-e>"', {expr = true} )
    end
  },

  {'nvim-lua/telescope.nvim',
    requires = {
      'nvim-lua/popup.nvim',
      'nvim-lua/plenary.nvim'
    },
    config = "require('telescope_config')"
  },

  {'lewis6991/cleanfold.nvim', config = "require('cleanfold').setup()" },

  'whiteinge/diffconflicts',

  -- 'mhinz/vim-signify',
  -- 'airblade/vim-gitgutter',
  {'~/projects/gitsigns.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
    config = function()
      vim.api.nvim_set_keymap('n', 'm', ':Gitsigns dump_cache<cr>'    , {silent=true})
      vim.api.nvim_set_keymap('n', 'M', ':Gitsigns debug_messages<cr>', {silent=true})
      vim.cmd'hi link GitSignsCurrentLineBlame FloatBorder'
      require('gitsigns').setup{
        -- debug_mode = true,
        signs = {
          add          = {text= '┃', hl = 'GitGutterAdd'   },
          change       = {text= '┃', hl = 'GitGutterChange'},
          delete       = {text= '_', hl = 'GitGutterDelete'},
          topdelete    = {text= '‾', hl = 'GitGutterDelete'},
          changedelete = {text= '≃', hl = 'GitGutterChange'},
        }
      }
    end
  },

  {'~/projects/spellsitter.nvim',
    config = function()
      require('spellsitter').setup{}
    end
  },

  {'norcalli/nvim-colorizer.lua',
    config = function()
      require'colorizer'.setup()
    end
  },

  {'nvim-treesitter/nvim-treesitter',
    requires = {
      'romgrk/nvim-treesitter-context',
      'nvim-treesitter/playground',
    },
    run = ':TSUpdate',
    config = "require('treesitter')",
  },

  'euclidianAce/BetterLua.vim',

  {'romgrk/barbar.nvim',
    requires = { 'kyazdani42/nvim-web-devicons' },
    config = function()
      vim.g.bufferline = vim.tbl_extend('force', vim.g.bufferline or {}, {
        closable = false
      })
      vim.api.nvim_set_keymap('n', '<Tab>'  , ':BufferNext<CR>'    , {silent=true})
      vim.api.nvim_set_keymap('n', '<S-Tab>', ':BufferPrevious<CR>', {silent=true})
    end
  }
}

local packer = require('packer')

packer.startup{init}

return packer

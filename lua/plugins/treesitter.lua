-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  build = ":TSUpdate",
  lazy = false,
  config = function()
    local ensure_installed = {
      "bash",
      "c",
      "cpp",
      "c_sharp",
      "diff",
      "fish",
      "go",
      "html",
      "javascript",
      "json",
      "lua",
      "luadoc",
      "luap",
      "markdown",
      "markdown_inline",
      "odin",
      "python",
      "query",
      "regex",
      "rust",
      "toml",
      "tsx",
      "typescript",
      "vim",
      "vimdoc",
      "vue",
      "yaml",
    }

    local already_installed = require("nvim-treesitter").get_installed()
    local parsers_to_install = vim.iter(ensure_installed)
      :filter(function(parser)
        return not vim.tbl_contains(already_installed, parser)
      end)
      :totable()
    if #parsers_to_install > 0 then
      require("nvim-treesitter").install(parsers_to_install)
    end

    local function is_parser_installed(lang)
      local installed = require("nvim-treesitter").get_installed()
      return vim.tbl_contains(installed, lang)
    end

    local function start_treesitter(buf, lang)
      if not vim.treesitter.language.add(lang) then
        vim.notify(
          "Cannot load treesitter parser for language " .. lang,
          vim.log.levels.WARN
        )
        return
      end
      vim.treesitter.start(buf)
      vim.bo[buf].syntax = "ON"
      if vim.treesitter.query.get(lang, "indents") then
        vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end
    end

    vim.api.nvim_create_autocmd("FileType", {
      callback = function(ev)
        local lang = vim.treesitter.language.get_lang(ev.match)
        if not lang then
          return
        end
        local buf = ev.buf
        if is_parser_installed(lang) then
          start_treesitter(buf, lang)
        end
      end,
    })
  end,
}

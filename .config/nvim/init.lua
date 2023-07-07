require("jssantangelo")
local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
parser_config.snakemake = {
  install_info = {
    url = "https://github.com/osthomas/tree-sitter-snakemake",
    location = "tree-sitter-snakemake",
    files = {"src/parser.c", "src/scanner.cc"},
    branch = "main",
    requires_generate_from_grammar = false
  }
}

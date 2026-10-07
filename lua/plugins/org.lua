-- https://github.com/xheisenbugx/org.nvim

return {
  {
    "xheisenbugx/org.nvim",
    main = "org",
    lazy = false,
    opts = {
      org_directory = "~/org",
      agenda_files = { "~/org/**/*.org" },
      default_notes_file = "~/org/refile.org",
      mappings = {
        prefix = "<leader>O",
      },
      extensions = {
        present = true,
        roam = true,
      },
    },
  },
}

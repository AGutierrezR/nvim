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
      capture = {
        templates = {
          n = {
            description = "Note (to process)",
            template = "* %?\n  %u\n  %a",
            target = "~/org/refile.org",
            headline = "Inbox",
          },
          t = {
            description = "Tasks",
            template = "* TODO %?\n  %u\n  %a",
            target = "~/org/refile.org",
            headline = "Tasks",
          },
          r = {
            description = "Reference",
            template = "* %?\n  %u\n  %a\n",
            target = "~/org/refile.org",
            headline = "Inbox Reference",
          },
        },
      },
      extensions = {
        present = true,
        roam = {
          directory = "~/org/roam",
          capture_templates = {
            d = {
              description = "node",
              template = "%?",
              target = "%<%Y%m%d%H%M%S>-${slug}.org",
              head = "#+title: ${title}\n",
              unnarrowed = true,
            },
            m = {
              description = "MOC",
              template = "My map of ${title}. Start here.\n%?\n* \n* \n",
              target = "%<%Y%m%d%H%M%S>-moc-${slug}.org",
              head = "#+title: MOC ${title}\n#+filetags: moc\n",
              unnarrowed = true,
            },
            l = {
              description = "literature",
              template = "%?\n  %a",
              target = "%<%Y%m%d%H%M%S>-${slug}.org",
              head = "#+title: ${title}\n#+filetags: literature\n",
              unnarrowed = true,
            },
            r = {
              description = "reference",
              template = "%?\n  %a",
              target = "%<%Y%m%d%H%M%S>-${slug}.org",
              head = "#+title: ${title}\n#+filetags: reference\n",
              unnarrowed = true,
            },
          },
        },
      },
    },
  },
}

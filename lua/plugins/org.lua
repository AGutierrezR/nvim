-- https://github.com/xheisenbugx/org.nvim

local function open_refile()
  local dir = vim.fn.expand("~/org/")
  local path = dir .. "refile.org"

  -- Create directory if it does not exist
  vim.fn.mkdir(dir, "p")

  vim.cmd("edit " .. path)
end

return {
  {
    "xheisenbugx/org.nvim",
    main = "org",
    lazy = false,
    keys = {
      { "<leader>ww", function () open_refile() end, mode = "n", desc = "org: Open refile" },
    },
    opts = {
      org_directory = "~/org",
      agenda_files = { "~/org/**/*.org" },
      default_notes_file = "~/org/refile.org",
      mappings = {
        prefix = "<leader>w",
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

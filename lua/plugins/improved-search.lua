return {
  {
    "backdround/improved-search.nvim",
    keys = {
      { "!", function () require("improved-search").current_word() end, mode = "n" },
      { "g!", function () require("improved-search").current_word_strict() end, mode = "n" },
      { "!", function () require("improved-search").in_place() end, mode = "x" },
      { "g!", function () require("improved-search").in_place_strict() end, mode = "x" },
      { "*", function () require("improved-search").forward() end, mode = "x" },
      { "g*", function () require("improved-search").forward_strict() end, mode = "x" },
      { "#", function () require("improved-search").backward() end, mode = "x" },
      { "g#", function () require("improved-search").backward_strict() end, mode = "x" },
    },
  },
}

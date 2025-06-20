-- This file contains the configuration for integrating GitHub Copilot and Copilot Chat plugins in Neovim.

-- Define prompts for Copilot
-- This table contains various prompts that can be used to interact with Copilot.
local prompts = {
  Explain = "Please explain how the following code works.", -- Prompt to explain code
  Review = "Please review the following code and provide suggestions for improvement.", -- Prompt to review code
  Tests = "Please explain how the selected code works, then generate unit tests for it.", -- Prompt to generate unit tests
  Refactor = "Please refactor the following code to improve its clarity and readability.", -- Prompt to refactor code
  FixCode = "Please fix the following code to make it work as intended.", -- Prompt to fix code
  FixError = "Please explain the error in the following text and provide a solution.", -- Prompt to fix errors
  BetterNamings = "Please provide better names for thej following variables and functions.", -- Prompt to suggest better names
  Documentation = "Please provide documentation for the following code.", -- Prompt to generate documentation
  JsDocs = "Please provide JsDocs for the following code.", -- Prompt to generate JsDocs
  DocumentationForGithub = "Please provide documentation for the following code ready for GitHub using markdown.", -- Prompt to generate GitHub documentation
  CreateAPost = "Please provide documentation for the following code to post it in social media, like Linkedin, it has be deep, well explained and easy to understand. Also do it in a fun and engaging way.", -- Prompt to create a social media post
  Summarize = "Please summarize the following text.", -- Prompt to summarize text
  Spelling = "Please correct any grammar and spelling errors in the following text.", -- Prompt to correct spelling and grammar
  Wording = "Please improve the grammar and wording of the following text.", -- Prompt to improve wording
  Concise = "Please rewrite the following text to make it more concise.", -- Prompt to make text concise
}

return {
  "CopilotC-Nvim/CopilotChat.nvim",
  enabled = false,
  branch = "main",
  cmd = "CopilotChat",
  build = "make tiktoken",
  opts = function()
    return {
      -- auto_insert_mode = true,
      answer_header = "  Copilot ",
      window = {
        width = 0.4,
      },
      prompts = prompts,
      system_prompt = "Este GPT actua como un clon de un desarrollador frontend senior especializado en LitElement y Vanilla JavaScript, con una solida experiencia en diseno de arquitecturas escalables basadas en Clean Architecture y Hexagonal Architecture. Esta obsesionado con separar responsabilidades de forma clara y con mantener la logica de negocio desacoplada del framework.\n\nTiene un estilo tecnico pero practico, explica con claridad quirurgica y siempre aterriza los conceptos con ejemplos utiles y aplicables, especialmente pensados para desarrolladores con conocimientos intermedios a avanzados. Nada de teorias que no tocan el codigo: lo suyo es bajar a tierra con soluciones reales.\n\nSu tono de voz es profesional pero cercano, relajado, directo y con un toque de humor sarcastico cuando aplica. Evita formalismos innecesarios, y usa un lenguaje claro, tecnico si hace falta, pero nunca criptico.\n\nSus principales areas de conocimiento incluyen:\n\n- Desarrollo frontend con LitElement y componentes web con Vanilla JS.\n- Arquitectura de software: Clean Architecture, Hexagonal y Scream Architecture.\n- Buenas practicas con TypeScript y test unitarios.\n- Herramientas de productividad como Neovim, Tmux y flujos CLI-first.\n- Mentoria tecnica: explica temas complejos de forma accesible y memorable.\n- Contenido tecnico y charlas: sabe comunicar tanto a equipos como a comunidades.\n\nComo responde este GPT:\n\n1. Parte del problema o necesidad tecnica real del usuario.\n2. Plantea soluciones claras, estructuradas y con ejemplos si aplica.\n3. Anade herramientas o tecnicas utiles, sin divagar.\n\nCuando un concepto es complejo, lo traduce usando analogias arquitectonicas (si, de construccion real), haciendo que hasta un patron poco comun parezca logico. No repite lo obvio, no recita documentacion. Explica lo que necesitas saber, como si te lo estuviera contando en una sesion de pairing.",
      model = "claude-3.5-sonnet",
    }
  end,
  keys = {
    { "<c-s>", "<CR>", ft = "copilot-chat", desc = "Submit Prompt", remap = true },
    { "<leader>a", "", desc = "+ai", mode = { "n", "v" } },
  --   {
  --     "<leader>aa",
  --     function()
  --       return require("CopilotChat").toggle()
  --     end,
  --     desc = "Toggle (CopilotChat)",
  --     mode = { "n", "v" },
  --   },
  --   {
  --     "<leader>ax",
  --     function()
  --       return require("CopilotChat").reset()
  --     end,
  --     desc = "Clear (CopilotChat)",
  --     mode = { "n", "v" },
  --   },
  --   {
  --     "<leader>aq",
  --     function()
  --       vim.ui.input({
  --         prompt = "Quick Chat: ",
  --       }, function(input)
  --         if input ~= "" then
  --           require("CopilotChat").ask(input)
  --         end
  --       end)
  --     end,
  --     desc = "Quick Chat (CopilotChat)",
  --     mode = { "n", "v" },
  --   },
    {
      "<leader>ap",
      function()
        require("CopilotChat").select_prompt()
      end,
      desc = "Prompt Actions (CopilotChat)",
      mode = { "n", "v" },
    },
  },
  config = function(_, opts)
    local chat = require("CopilotChat")

    vim.api.nvim_create_autocmd("BufEnter", {
      pattern = "copilot-*",
      callback = function()
        vim.opt.completeopt = vim.opt.completeopt + "noinsert" + "noselect"
      end,
    })
    vim.api.nvim_create_autocmd("BufLeave", {
      pattern = "copilot-*",
      callback = function()
        vim.opt.completeopt = vim.opt.completeopt - "noinsert" - "noselect"
      end,
    })

    -- vim.api.nvim_create_autocmd("BufEnter", {
    --   pattern = "copilot-chat",
    --   callback = function()
    --     vim.opt.completeopt = vim.opt.completeopt + "noinsert" + "noselect"
    --     vim.opt_local.relativenumber = false
    --     vim.opt_local.number = false
    --   end,
    -- })

    chat.setup(opts)
  end,
}

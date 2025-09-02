return {
  "akinsho/toggleterm.nvim",
  version = "*",
  config = function()
    require("toggleterm").setup({
      open_mapping = [[<c-\>]],
      direction = "horizontal",
      size = 15,
      shade_terminals = true,
    })

    local Terminal = require("toggleterm.terminal").Terminal

    local maven_build = Terminal:new({ cmd = "mvn clean install", hidden = true, direction = "float" })
    local maven_run = Terminal:new({ cmd = "mvn exec:java", hidden = true, direction = "float" })
    local gradle_build = Terminal:new({ cmd = "./gradlew build", hidden = true, direction = "float" })
    local gradle_run = Terminal:new({ cmd = "./gradlew run", hidden = true, direction = "float" })
    local elixir_mix = Terminal:new({ cmd = "mix test", hidden = true, direction = "float" })

    function _MAVEN_BUILD_TOGGLE()
      maven_build:toggle()
    end

    function _MAVEN_RUN_TOGGLE()
      maven_run:toggle()
    end

    function _GRADLE_BUILD_TOGGLE()
      gradle_build:toggle()
    end

    function _GRADLE_RUN_TOGGLE()
      gradle_run:toggle()
    end

    function _ELIXIR_MIX_TOGGLE()
      elixir_mix:toggle()
    end

  end,
}


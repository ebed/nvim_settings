return {
  "luukvbaal/statuscol.nvim", 
  config = function()
    local builtin = require("statuscol.builtin")
    local cfg = {
    }
    require("statuscol").setup({
      -- segments = {
      --   text = { "%C" },       -- table of strings or functions returning a string
      --   click = "v:lua.ScFa",  -- %@ click function label, applies to each text element
      --   hl = "FoldColumn",     -- %# highlight group label, applies to each text element
      --   condition = { true },  -- table of booleans or functions returning a boolean
      --   sign = {               -- table of fields that configure a sign segment
      --     -- at least one of "name", "text", and "namespace" is required
      --     -- legacy signs are matched against the defined sign name e.g. "DapBreakpoint"
      --     -- extmark signs can be matched against either the namespace or the sign text itself
      --     name = { ".*" },     -- table of Lua patterns to match the legacy sign name against
      --     text = { ".*" },     -- table of Lua patterns to match the extmark sign text against
      --     namespace = { ".*" },-- table of Lua patterns to match the extmark sign namespace against
      --     -- below values list the default when omitted:
      --     maxwidth = 1,        -- maximum number of signs that will be displayed in this segment
      --     colwidth = 2,        -- number of display cells per sign in this segment
      --     auto = true,        -- boolean or string indicating what will be drawn when no signs
      --                          -- matching the pattern are currently placed in the buffer.
      --     wrap = false,        -- when true, signs in this segment will also be drawn on the
      --                          -- virtual or wrapped part of a line (when v:virtnum != 0).
      --     fillchar = " ",      -- character used to fill a segment with less signs than maxwidth
      --     fillcharhl = nil,    -- highlight group used for fillchar (SignColumn/CursorLineSign if omitted)
      --     foldclosed = false,  -- when true, show signs from lines in a closed fold on the first line
      --   },
              setopt = true,         -- Whether to set the 'statuscolumn' option, may be set to false for those who
                             -- want to use the click handlers in their own 'statuscolumn': _G.Sc[SFL]a().
                             -- Although I recommend just using the segments field below to build your
                             -- statuscolumn to benefit from the performance optimizations in this plugin.
      -- builtin.lnumfunc number string options
      thousands = ".",     -- or line number thousands separator string ("." / ",")
      relculright = false,   -- whether to right-align the cursor line number with 'relativenumber' set
      -- Builtin 'statuscolumn' options
      ft_ignore = nil,       -- Lua table with 'filetype' values for which 'statuscolumn' will be unset
      bt_ignore = nil,       -- Lua table with 'buftype' values for which 'statuscolumn' will be unset
      -- Default segments (fold -> sign -> line number + separator), explained below
      segments = {
        { text = { "%C" }, click = "v:lua.ScFa" },
        { text = { "%s" }, click = "v:lua.ScSa" },
        {
          text = { builtin.lnumfunc, " " },
          condition = { true, builtin.not_empty },
          click = "v:lua.ScLa",
        }
      },
      clickmod = "c",         -- modifier used for certain actions in the builtin clickhandlers:
                              -- "a" for Alt, "c" for Ctrl and "m" for Meta.
      clickhandlers = {       -- builtin click handlers, keys are pattern matched
        Lnum                    = builtin.lnum_click,
        FoldClose               = builtin.foldclose_click,
        FoldOpen                = builtin.foldopen_click,
        FoldOther               = builtin.foldother_click,
        DapBreakpointRejected   = builtin.toggle_breakpoint,
        DapBreakpoint           = builtin.toggle_breakpoint,
        DapBreakpointCondition  = builtin.toggle_breakpoint,
        ["diagnostic/signs"]    = builtin.diagnostic_click,
        gitsigns                = builtin.gitsigns_click,
      },

    })
  end,
}

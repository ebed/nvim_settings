return {
    'fei6409/log-highlight.nvim',
    config = function()
        require('log-highlight').setup {
            filename = {
                'messages',
            },

            -- The file path glob patterns, e.g. `.*%.lg`, `/var/log/.*`.
            -- Note: `%.` is to match a literal dot (`.`) in a pattern in Lua, but most
            -- of the time `.` and `%.` here make no observable difference.
            pattern = {
                '/var/log/.*',
                '*/log/.*',
                '*log.*',
                'messages%..*',
                '.*log[%p%d]*',
            },
        }
    end,
}

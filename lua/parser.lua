function COM_Compress(str)
    -- remove line comments (//)
    local pos = 0
    while pos ~= nil do
        pos = str:find('//', pos, true)
        if pos then
            local nextNewLine = str:find('\n', pos, true)
            if nextNewLine then
                local newStr = str:sub(1, pos - 1) .. str:sub(nextNewLine + 1)
                str = newStr
            end
        end
    end

    -- remove /* */ comments
    str = str:gsub('/%*.-%*/', '')

    -- str = JPUtil.px( str )
    str = JPUtil.trim6(str)
    str = JPUtil.trimWhitespace(str)

    -- record newline, whitespace?
    -- parse actual tokens
    --	if we have a pending newline, emit it (and it counts as whitespace)
    --	copy quoted strings unmolested
    return str
end

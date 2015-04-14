local html_escape_table = {
    ['<'] = '&lt;',
    ['>'] = '&gt;',
    ["'"] = '&#39;',
    ['"'] = '&quot;',
    ['&'] = '&amp;',
}

local function filter_html_escape( text )
    return text:gsub( '([<>\'"&])', html_escape_table )
end

local function filter_lower( text )
    return text:lower()
end

local function filter_upper( text )
    return text:upper()
end

--[[

--]]

return {
    html_escape = filter_html_escape,
}

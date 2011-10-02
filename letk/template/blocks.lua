local function block_if( template, chunk )
    local eval                 = loadstring( 'return ' .. chunk[ 1 ] )
    local tlist, end_chunk = template:parse{ 'else', 'elseif', 'end', 'endif' }

    local flist

    if end_chunk.block == 'else' then
        flist, end_chunk  = template:parse{ 'end', 'endif' }
    end

    if end_chunk.block == 'elseif' then
        flist, end_chunk = block_if( template, end_chunk )
    end

    return function()
        if template.context:eval( eval ) then
            return template:execute( tlist )
        else
            if type( flist ) == 'table' then
                return template:execute( flist )
            elseif type( flist ) == 'function' then
                return flist()
            end
            return ''
        end
    end
end

local function block_print( template, chunk )
    if not chunk[ 1 ] or chunk[ 1 ] == '' then
        return
    end

    local eval = loadstring( 'return ' .. chunk[ 1 ] )

    return function( )
        local res =  self.context:eval( eval )
        return res
    end
end

local function block_var( template, chunk )
    if not chunk.var or chunk.var == '' then
        return
    end

    local eval = loadstring( 'return ' .. chunk.var )

    return function( )
        local res =  self.context:eval( eval )
        return res
    end
end

local function block_for( template, chunk )
    --* blocks list *--
    local lists      = {}
    local delimiters = { 'first', 'last', 'empty', 'loop', 'endfor', 'end' }

    local list, end_chunk
    local last_end_chunk = 'loop'
    while true do
        list, end_chunk  = template:parse( delimiters )
        if not list or not end_chunk then
            print("ERRO: end for loop not find", chunk[1])
            return
        end
        lists[#lists +1] = {
            last_end_chunk,
            list,
        }

        last_end_chunk = end_chunk.block

        if end_chunk.block == 'end' or end_chunk.block == 'endfor' then
            break
        end
    end

    --* arguments and expression *--
    local mode
    local arglist
    local explist

    if chunk[1]:match('^%s*(%w+)%s*=%s*.-%s*$' ) then
        --numeric for
        mode = 'numeric'
        arglist, explist = chunk[1]:match('^%s*([^%s=]+)%s*=%s*(.-)%s*$' )
        if not arglist then print("ERRO: invalid for", chunk[1]) end
    else
         --generic for
        mode = 'generic'
        arglist, explist = chunk[1]:match( '^%s*(.-)%s+in%s+(.-)%s*$' )
        if not arglist then print("ERRO: invalid for", chunk[1]) end
        arglist = string.split( arglist, ',' )
        for i, arg in ipairs( arglist ) do
            arglist[ i ] = string.trim( arg )
        end
    end

    local eval = loadstring( 'return ' .. explist )

    return function( )
        local for_ctx, result = {}, {}
        self.context:push( for_ctx )

        local run             = false
        if mode == 'numeric' then
            local a,b,c = self.context:eval( eval )
            for i = a, b, c or 1 do
                run = true
                for_ctx[ arglist ] = i
                for _, lst in ipairs( lists ) do
                    if
                        lst[1] == 'loop' or
                        ( i == a               and lst[1] == 'first' ) or
                        ( i > ( b - (c or 1) ) and lst[1] == 'last'  )
                    then
                        result[#result +1] = template:execute( lst[2] )
                    end
                end
            end
        elseif mode == 'generic' then
            local iter, tbl, var  = self.context:eval( eval )
            while true do
                local values = { iter( tbl, var ) }
                var = values[ 1 ]
                if var == nil then
                    break
                end
                local islast = not iter( tbl, var )
                for i, arg in ipairs( arglist ) do
                    for_ctx[ arg ] = values[ i ]
                end

                for _, lst in ipairs( lists ) do
                    if
                        (lst[1] == 'loop') or
                        ( not run        and lst[1] == 'first' ) or
                        ( islast         and lst[1] == 'last'  )
                    then
                        result[#result +1] = template:execute( lst[2] )
                    end
                end
                run = true
            end
        end
        if not run then
            for _, lst in ipairs( lists ) do
                if lst[1] == 'empty' then
                    result[#result +1] = template:execute( lst[2] )
                end
            end
        end

        self.context:pop()

        return table.concat( result )
    end
end

return {
    [ 'if' ]     = block_if,
    [ 'elseif' ] = block_if,
    [ 'print' ]  = block_print,
    [ 'var' ]    = block_var,
    [ 'for' ]    = block_for,
}

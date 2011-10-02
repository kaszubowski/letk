local Context = {}
Context.__index = Context

setmetatable(Context, Object)


function Context.new()
    local self = {}
    setmetatable( self, Context )

    self.ctxs = {}
    self:push{
        table    = table,
        string   = string,
        math     = math,
        tonumber = tonumber,
        tostring = tostring,
        select   = select,
        pairs    = pairs,
        ipairs   = ipairs,
    }

    return self
end

function Context:push( t )
    if type( t ) == 'table' then
        self.ctxs[ #self.ctxs + 1 ] = t
    end
end

function Context:pop()
    if #self.ctxs > 0 then
        self.ctxs[ #self.ctxs ] = nil
    end
end

function Context:get( k )
    for i = #self.ctxs, 1, -1 do
        local v = self.ctxs[ i ][ k ]
        if v ~= nil then
            return v
        end
    end
end

function Context:get_env()
    local env = setmetatable( {}, {
        __index = function( _, k ) return self:get( k ) end,
        __newindex = error,
    } )
    return env
end

function Context:eval( f )
    local old_env = getfenv( f )
    local env     = self:get_env()
    setfenv( f, env )
    local result  = { f() }
    setfenv( f, old_env )
    return unpack( result )
end

return Context

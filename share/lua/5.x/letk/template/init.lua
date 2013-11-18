local Grammar = require 'letk.template.grammar'
local Tags    = require 'letk.template.tags'

local Template = {}
Template.__index = Template

function Template.new( name )
    self = {}

    setmetatable( self, Template )

    self.name            = name
    self.blocks          = {}
    self.errors          = {}
    self.path            = {}
    self.remove_new_line = false
    self._cache          = nil
    self._escape         = nil -- function that escape context vars
    self.autoescape      = false -- by default does not escape

    return self
end

function Template:sub_template( name )
    local new_template = Template.new( name )
    
    new_template.errors            = self.errors
    new_template._cache            = self._cache
    new_template.path              = table.clone( self.path )
    new_template.remove_new_line   = self.remove_new_line
    
    return new_template
end

function Template:__call( Context )
    if not Context then return false, 'ERRO: no Context' end

    if not self.chunks then
        local status = self:compile( Context )
        if not status then
            return false, table.concat( self.errors, '\n' )
        end
    end

    local list = self:parse()

    return self:execute( list )
end

function Template:addPath( pathList )
    pathList = type( pathList ) == 'table' and pathList or { pathList }
    table.append( self.path, pathList )
end

function Template:getTemplateFile( name )
    local file
    for _, path in ipairs( self.path ) do
        file = io.open( path .. name, 'r' )
        if file then
            return file
        end
    end
    file = io.open( name, 'r' )
    if file then
        return file
    end
end 

function Template:removeNewLine( value )
    new_template.remove_new_line = value
end

function Template:cache( cache )
    self._cache = cache
end

function Template:compile( Context )
    local f = self:getTemplateFile( self.name )
    if not f then self.errors[#self.errors + 1] = string.format('File "%s" not found',self.name) return false end

    self.context  = Context

    local s       = f:read("*a")

    self.chunks   = Grammar:match( s )
    self.chunk_id = 1
    
    return true
end

function Template:parse( fl )
    if type( fl ) == 'table' then
        for c,v in ipairs( fl ) do
            fl[v] = true
        end
    end

    local list = {}

    while true do
        local chunk = self.chunks[ self.chunk_id ]
        if not chunk then break end
        if type( chunk ) == 'string' then
            --~ chunk = chunk:gsub( '^\n', '' )
            --~ chunk = chunk:gsub('[ \t\r]*\n[ \t\r]*', '\n'):gsub('\n+', '\n'):gsub('^\n', '')
            if self.remove_new_line then
                chunk = chunk:gsub( '[\n\r]*', '' )
            end
            chunk = { tag='print', [1] = string.format( '%q', chunk ) }
            self.chunks[ self.chunk_id ] = chunk
        elseif chunk.var then
            chunk.tag='var'
        end

        self.chunk_id = self.chunk_id + 1

        if fl and fl[ chunk.tag ] then
            return list, chunk
        end

        if chunk.tag then
            local tag = Tags[ chunk.tag ]
            if not tag then
                print( "Erro, invalid tag:", chunk.tag, chunk[1] )
            else
                local fn = tag( self, chunk )
                if fn then
                    list[#list +1] = fn
                end
            end
        end
    end

    return list
end

function Template:execute( list )
    local result = {}
    for i, item in ipairs( list ) do
        local t = type( item )
        local val
        if t == 'string' then
            val = item
        elseif t == 'function' then
            val = item( self, self.context )
        else
            print('ERRO template execution')
        end
        result[ i ] = tostring( val or '' )
    end
    
    return table.concat( result, '' )
end

return Template

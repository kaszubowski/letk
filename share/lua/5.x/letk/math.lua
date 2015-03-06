local CHARS = {
    'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z',
    'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z',
    '0','1','2','3','4','5','6','7','8','9','_',
}
function math.random_string( lenght, chars )
    local t    = {}
    local c    = chars or CHARS
    local size = #c
    for i = 1, lenght do
        t[i] = c[ math.random(1,size) ]
    end
    return table.concat( t )
end

function math.div( a,b )
    return math.floor( a / b )
end

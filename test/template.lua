require 'letk'
Template = letk.Template
Context  = letk.Context

obj = Template.new( './test.c' )
ctx = Context.new()
ctx:push{
    variavel = "Ola, Tudo Bem?",
    num      = 12,
    cond1    = true,
    cond2    = false,
}
print( obj( ctx ) )

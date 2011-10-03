//Teste 1
[1]Primeira Linha: OK

//Teste 2
{% if true %}
[2] if true: OK
{% else %}
[2] if true: ERRO
{% end %}

//Teste 3
{% if false %}
[3] if false: ERRO
{% else %}
[3] if false: OK
{% end %}

//Teste 4
{% if 1==1 %}
[4] if 1==1: OK
{% elseif 2==2 %}
[4] if elseif a: ERRO
{% elseif 3==3 %}
[4] if elseif b: ERRO
{% else %}
[4] if else: ERRO
{% end %}

//Teste 5
{% if 1==2 %}
[5] if 1==1: ERRO
{% elseif 2==2 %}
[5] if elseif a: OK
{% elseif 3==3 %}
[5] if elseif b: ERRO
{% else %}
[5] if else: ERRO
{% end %}

//Teste 6
{% if false %}
[6] if 1==1: ERRO
{% elseif false %}
[6] if elseif a: ERRO
{% elseif 3==3 %}
[6] if elseif b: OK
{% else %}
[6] if else: ERRO
{% end %}

//Teste 7
{% if false %}
[7] if 1==1: ERRO
{% elseif false %}
[7] if elseif a: ERRO
{% elseif 3~=3 %}
[7] if elseif b: ERRO
{% else %}
[7] if else: OK
{% end %}

//Teste 8
{% if true %}
[8] if: OK
{% endif %}

//Teste 9
{% if false %}
[9] if: ERRO
{% endif %}
[9] if only this: OK

//Teste 10
[10] Minha Variável {{ variavel }}

//Teste 11
[11] Minha Variável {{ string.upper(variavel) }}

//Teste 12
[12] Minha Variável {{ num }} == 12

//Teste 13
[13] Minha Variável {{ num + 2 }} == 14

//Teste 14
{% for i=1,3,1 %}
    Val {{i}}
{% first %}
    This is the first {{ i }}
{% last %}
    This is the last {{ i }}
{% emply %}
    It is emply
{% loop %}
    Back to loop {{ i }}
{% end %}

//Teste 15
{% for c,v in ipairs{'a','b','c','d'} %}
    {{ c }} = {{ v }}
{% first %}
    This is the first {{ tostring(c) .. '-' .. v }}
{% last %}
    This is the last {{ v }}
{% empty %}
    It is Empty: ERRO
{% loop %}
    Back to loop {{ v }}
{% end %}

//Teste 16
{% for c,v in ipairs{} %}
    {{v}}
{% empty %}
    Empty
{% endfor %}

//Teste 17
{% for c,v in pairs{a = '111', b='222'} %}
    {{ c }} = {{ v }}
{% first %}
    This is the first {{ tostring(c) .. '-' .. v }}
{% last %}
    This is the last {{ v }}
{% empty %}
    It is Empty: ERRO
{% loop %}
    Back to loop {{ v }}
{% end %}

//Teste 18
{% for i=1,3 %}
    --{{i}}
    {% for j=4,6 %}
        {{i}},{{j}}
        {% for c,v in pairs{'a','b'} %}
            {{v}}
        {% end %}
    {% end %}
{% end %}

{% for i=1,10 %}
    {{i}}--{% cycle 'a','b',i as teste %},
    --{{teste}}--
{% end %}

//Teste 19
{% for c,v in ipairs{'a','a','b','b','c'} %}
    {% ifchanged v %}
        --> {{ v }}
    {% else %}
        repeat: {{ v }}
    {% end %}
{% end %}

//Teste 20
{% include 'extend.c' %}

//Teste 21
{% with x = 33, z=42 %}
    {% for i=0,10 %}
        {{x * i}}--{{z+i}}
    {% end %}
{% end %}

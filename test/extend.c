Var: {{ variavel }}

{% extends 'extend2.c' %}

{% block a %}
    Este é o bloco 'a' do extend.c
    {% if true %}
        SIM
    {% else %}
        NÃO
    {% end %}
{% endblock %}

{% block b %}
    Este é o bloco 'b' do extend.c
{% endblock %}

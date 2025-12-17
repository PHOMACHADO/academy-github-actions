*** Settings ***
Documentation     Keywords utilizadas na rota /user
Resource    ../../resources/user.resource

*** Test Cases ***
Cadastrar usuario
    Cadastrar novo usuario

Cadastrar usuario com campo confirmar senha vazio
    Cadastrar usuario com campo confirmar senha vazio

Cadastrar usuário com dados válidos
    Cadastrar usuário com dados válidos

Cadastrar usuário com nome completo contendo números
    Cadastrar usuário com nome completo contendo números

Cadastrar usuário com nome completo contendo apenas uma palavra
    Cadastrar usuário com nome completo contendo apenas uma palavra

Cadastrar usuário com nome completo contendo caracteres especiais
    Cadastrar usuário com nome completo contendo caracteres especiais

Cadastrar usuário com nome completo em branco
    Cadastrar usuário com nome completo em branco

Cadastrar usuário com nome completo maior que 100 caracteres
    Cadastrar usuário com nome completo maior que 100 caracteres

Cadastrar usuário com CPF contendo letras
    Cadastrar usuário com CPF contendo letras

Cadastrar usuário com CPF contendo mais de 11 dígitos
    Cadastrar usuário com CPF contendo mais de 11 dígitos

Cadastrar usuário com CPF já existente
    Cadastrar usuário com CPF já existente

Cadastrar usuário com senha maior que 12 caracteres
    Cadastrar usuário com senha maior que 12 caracteres

Cadastrar usuário com senha menor que 8 caracteres
    Cadastrar usuário com senha menor que 8 caracteres

Cadastrar usuário com senha sem letra minúscula
    Cadastrar usuário com senha sem letra minúscula

Cadastrar usuário com senha sem letra maiúscula
    Cadastrar usuário com senha sem letra maiúscula

Cadastrar usuário com senha sem caractere especial
    Cadastrar usuário com senha sem caractere especial

Cadastrar usuário com senha sem número
    Cadastrar usuário com senha sem número

Cadastrar usuário com senha em branco
    Cadastrar usuário com senha em branco

Cadastrar usuário com email já existente
    Cadastrar usuário com email já existente

Cadastrar usuário com email inválido
    Cadastrar usuário com email inválido

Cadastrar usuário com email em branco
    Cadastrar usuário com email em branco

Cadastrar usuário com confirmação de senha em branco
    Cadastrar usuário com confirmação de senha em branco

Cadastrar usuário com senha de confirmação diferente
    Cadastrar usuario com confirmacao de senha diferente
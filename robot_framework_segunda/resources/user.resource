*** Settings ***
Library    SeleniumLibrary
Library    Collections
Library    String
Library    RequestsLibrary
Library    FakerLibrary    locale=pt_BR
Resource    ../resources/generate_random_data.resource
Resource    ../config/dev.robot


*** Keywords ***
Criar Sessao
    ${headers}=    Create Dictionary   accept=application/json    Content-Type=application/json
    Create Session   alias=develop   url=${BASE_URL}    headers=${headers}

Realizar login
    ${body}=    Create Dictionary    mail=${USER_EMAIL}    password=${USER_PASSWORD}
    Criar Sessao
    ${bodyResponse}    POST On Session    alias=develop    url=/login    json=${body}    verify=${True}
    Log     ${bodyResponse.json()}
    Log    ${bodyResponse.json()['token']}
    Status Should Be    200    ${bodyResponse}
    RETURN    ${bodyResponse.json()['token']}

Gerar Usuario
    
    ${FIRST_NAME}    Gerar primeiro nome nao composto
    ${LAST_NAME}    Gerar ultimo nome nao composto
    ${RANDOM_PASSWORD}    Gerar Senha Aleatoria
    ${RANDOM_CPF}    Gerar CPF Unico

    Set Test Variable    ${FULLNAME}        ${FIRST_NAME} ${LAST_NAME}
    Set Test Variable    ${EMAIL}     ${FIRST_NAME.lower()}@qacoders.com
    Set Test Variable    ${PASSWORD}    ${RANDOM_PASSWORD}
    Set Test Variable    ${USER_CPF}    ${RANDOM_CPF}
    Set Test Variable    ${ACCESS_PROFILE}    ADMIN
    
Cadastrar novo usuario
    Gerar Usuario
    ${TOKEN}    Realizar login

    ${body}    Create Dictionary
    ...    fullName=${FULLNAME} 
    ...    mail=${EMAIL}
    ...    accessProfile=${ACCESS_PROFILE}
    ...    cpf=${USER_CPF}
    ...    password=${PASSWORD}
    ...    confirmPassword=${PASSWORD}
 
    ${response}    POST On Session    alias=develop    url=/user?token=${TOKEN}    json=${body}    verify=${True}
    Status Should Be    201    ${response}
    Log     ${response.json()}
    Set Suite Variable    ${USER_ID}    ${response.json()['user']['_id']}   


Cadastrar usuario com confirmacao de senha diferente
    Gerar Usuario
    ${TOKEN}    Realizar login

    ${body}    Create Dictionary
    ...    fullName=${FULLNAME} 
    ...    mail=${EMAIL}
    ...    accessProfile=${ACCESS_PROFILE}
    ...    cpf=${USER_CPF}
    ...    password=${PASSWORD}
    ...    confirmPassword=${PASSWORD}123
 
    ${response}    POST On Session    alias=develop    url=/user?token=${TOKEN}    json=${body}    expected_status=400    verify=${True}
    Status Should Be    400    ${response}
    Log     ${response.json()}
    Should Be Equal As Strings    ${response.json()['error'][0]}    As senhas não conferem.

Cadastrar usuario com campo confirmar senha vazio
    Gerar Usuario
    ${TOKEN}=    Realizar login

    ${body}=    Create Dictionary
    ...    fullName=${FULLNAME}
    ...    mail=${EMAIL}
    ...    accessProfile=${ACCESS_PROFILE}
    ...    cpf=${USER_CPF}
    ...    password=${PASSWORD}
    ...    confirmPassword=    # campo vazio propositalmente

    ${response}=    POST On Session    develop    url=/user?token=${TOKEN}    json=${body}    expected_status=400
    Log    ${response.json()}

    Should Be Equal As Strings    ${response.json()['error'][0]}    O campo de confirmação de senha é obrigatório.

Cadastrar usuário com dados válidos
    Gerar Usuario
    ${TOKEN}=    Realizar login

    ${body}=    Create Dictionary
    ...    fullName=${FULLNAME}
    ...    mail=${EMAIL}
    ...    accessProfile=${ACCESS_PROFILE}
    ...    cpf=${USER_CPF}
    ...    password=${PASSWORD}
    ...    confirmPassword=${PASSWORD}

    ${response}=    POST On Session    develop     url=/user?token=${TOKEN}    json=${body}    expected_status=201
    Log    ${response.json()}

    Should Be Equal As Strings    ${response.json()['msg']}    Registro realizado com sucesso 
    Set Suite Variable    ${USER_ID}    ${response.json()['user']['_id']}


Cadastrar usuário com nome completo em branco
    Gerar Usuario
    ${TOKEN}=    Realizar login

    # Nome completo vazio
    Set Test Variable    ${FULLNAME}    ${EMPTY}

    ${body}=    Create Dictionary
    ...    fullName=${FULLNAME}
    ...    mail=${EMAIL}
    ...    accessProfile=${ACCESS_PROFILE}
    ...    cpf=${USER_CPF}
    ...    password=${PASSWORD}
    ...    confirmPassword=${PASSWORD}

    ${response}=    POST On Session    develop    url=/user?token=${TOKEN}    json=${body}    expected_status=400
    Log    ${response.json()}

    Should Be Equal As Strings    ${response.json()['error'][0]}    O campo nome completo é obrigatório.


Cadastrar usuário com nome completo contendo números
    Gerar Usuario
    ${TOKEN}=    Realizar login

    # Sobrescrevendo o nome completo gerado com um nome inválido contendo números
    Set Test Variable    ${FULLNAME}    João123 Silva99

    ${body}=    Create Dictionary
    ...    fullName=${FULLNAME}
    ...    mail=${EMAIL}
    ...    accessProfile=${ACCESS_PROFILE}
    ...    cpf=${USER_CPF}
    ...    password=${PASSWORD}
    ...    confirmPassword=${PASSWORD}

    ${response}=    POST On Session    develop    url=/user?token=${TOKEN}    json=${body}    expected_status=400
    Log    ${response.json()}

    Should Be Equal As Strings    ${response.json()['error'][0]}    O campo nome completo não deve conter números

Cadastrar usuário com nome completo contendo caracteres especiais
    Gerar Usuario
    ${TOKEN}=    Realizar login

    # Nome inválido com caracteres especiais
    Set Test Variable    ${FULLNAME}    João@Silva#

    ${body}=    Create Dictionary
    ...    fullName=${FULLNAME}
    ...    mail=${EMAIL}
    ...    accessProfile=${ACCESS_PROFILE}
    ...    cpf=${USER_CPF}
    ...    password=${PASSWORD}
    ...    confirmPassword=${PASSWORD}

    ${response}=    POST On Session    develop    url=/user?token=${TOKEN}    json=${body}    expected_status=400
    Log    ${response.json()}

    Should Be Equal As Strings    ${response.json()['error'][0]}    Informe o nome e sobrenome com as iniciais em letra maiúscula e sem caracteres especiais.

Cadastrar usuário com nome completo maior que 100 caracteres
    Gerar Usuario
    ${TOKEN}=    Realizar login

    # Nome inválido com mais de 100 caracteres
    Set Test Variable    ${FULLNAME}    João da Silva Neto Pereira Almeida Costa Moreira Rodrigues Santos Oliveira Lima Barbosa Ferreira Martins

    ${body}=    Create Dictionary
    ...    fullName=${FULLNAME}
    ...    mail=${EMAIL}
    ...    accessProfile=${ACCESS_PROFILE}
    ...    cpf=${USER_CPF}
    ...    password=${PASSWORD}
    ...    confirmPassword=${PASSWORD}

    ${response}=    POST On Session    develop    url=/user?token=${TOKEN}    json=${body}    expected_status=400
    Log    ${response.json()}

    Should Be Equal As Strings    ${response.json()['error'][0]}    O nome completo deve ter no máximo 100 caracteres.

Cadastrar usuário com nome completo contendo apenas uma palavra
    Gerar Usuario
    ${TOKEN}=    Realizar login

    # Nome inválido contendo apenas uma palavra
    Set Test Variable    ${FULLNAME}    João

    ${body}=    Create Dictionary
    ...    fullName=${FULLNAME}
    ...    mail=${EMAIL}
    ...    accessProfile=${ACCESS_PROFILE}
    ...    cpf=${USER_CPF}
    ...    password=${PASSWORD}
    ...    confirmPassword=${PASSWORD}

    ${response}=    POST On Session    develop    url=/user?token=${TOKEN}    json=${body}    expected_status=400
    Log    ${response.json()}

    Should Be Equal As Strings    ${response.json()['error'][0]}    Informe o nome e sobrenome com as iniciais em letra maiúscula e sem caracteres especiais. 


Cadastrar usuário com CPF contendo letras
    Gerar Usuario
    ${TOKEN}=    Realizar login

    # CPF inválido contendo letras
    Set Test Variable    ${USER_CPF}    ABC12DEFG45

    ${body}=    Create Dictionary
    ...    fullName=${FULLNAME}
    ...    mail=${EMAIL}
    ...    accessProfile=${ACCESS_PROFILE}
    ...    cpf=${USER_CPF}
    ...    password=${PASSWORD}
    ...    confirmPassword=${PASSWORD}

    ${response}=    POST On Session    develop     url=/user?token=${TOKEN}    json=${body}    expected_status=400
    Log    ${response.json()}

    Should Be Equal As Strings    ${response.json()['error'][0]}    Campo CPF deve conter apenas números

Cadastrar usuário com CPF contendo mais de 11 dígitos
    Gerar Usuario
    ${TOKEN}=    Realizar login

    # CPF inválido com mais de 11 dígitos
    Set Test Variable    ${USER_CPF}    123456789012

    ${body}=    Create Dictionary
    ...    fullName=${FULLNAME}
    ...    mail=${EMAIL}
    ...    accessProfile=${ACCESS_PROFILE}
    ...    cpf=${USER_CPF}
    ...    password=${PASSWORD}
    ...    confirmPassword=${PASSWORD}

    ${response}=    POST On Session    develop    url=/user?token=${TOKEN}    json=${body}    expected_status=400
    Log    ${response.json()}

    Should Be Equal As Strings    ${response.json()['error'][0]}    Deve preencher o CPF com 11 dígitos


Cadastrar usuário com CPF já existente
    # Criando o primeiro usuário
    Cadastrar novo usuario
    ${TOKEN}=    Realizar login

    ${CPF_DUPLICADO}=    Set Variable    ${USER_CPF}

    # Gerando novo usuário para criar um segundo, mas garantindo novo email
    Gerar Usuario
    # Garantir email único com sufixo aleatório
    ${RANDOM}=    Generate Random String    5
    Set Test Variable    ${EMAIL}    novo_${RANDOM}@qacoders.com

    # Forçando CPF duplicado
    Set Test Variable    ${USER_CPF}    ${CPF_DUPLICADO}

    ${body}=    Create Dictionary
    ...    fullName=${FULLNAME}
    ...    mail=${EMAIL}
    ...    accessProfile=${ACCESS_PROFILE}
    ...    cpf=${USER_CPF}
    ...    password=${PASSWORD}
    ...    confirmPassword=${PASSWORD}

    ${response}=    POST On Session    develop    url=/user?token=${TOKEN}    json=${body}    expected_status=409
    Log    ${response.json()}

    Should Be Equal As Strings    ${response.json()['alert'][0]}    O cpf informado já existe em nossa base de dados.


Cadastrar usuário com senha maior que 12 caracteres
    Gerar Usuario
    ${TOKEN}=    Realizar login

    # Senha inválida com mais de 12 caracteres
    Set Test Variable    ${PASSWORD}    Abcdefghijklm@1

    ${body}=    Create Dictionary
    ...    fullName=${FULLNAME}
    ...    mail=${EMAIL}
    ...    accessProfile=${ACCESS_PROFILE}
    ...    cpf=${USER_CPF}
    ...    password=${PASSWORD}
    ...    confirmPassword=${PASSWORD}

    ${response}=    POST On Session    develop    url=/user?token=${TOKEN}    json=${body}    expected_status=400
    Log    ${response.json()}

    Should Be Equal As Strings    ${response.json()['error'][0]}    Senha precisa ter: uma letra maiúscula, uma letra minúscula, um número, um caractere especial(@#$%) e tamanho entre 8-12.

Cadastrar usuário com senha menor que 8 caracteres
    Gerar Usuario
    ${TOKEN}=    Realizar login

    # Senha inválida com menos de 8 caracteres
    Set Test Variable    ${PASSWORD}    Abc@12

    ${body}=    Create Dictionary
    ...    fullName=${FULLNAME}
    ...    mail=${EMAIL}
    ...    accessProfile=${ACCESS_PROFILE}
    ...    cpf=${USER_CPF}
    ...    password=${PASSWORD}
    ...    confirmPassword=${PASSWORD}

    ${response}=    POST On Session    develop    url=/user?token=${TOKEN}    json=${body}    expected_status=400
    Log    ${response.json()}

    Should Be Equal As Strings    ${response.json()['error'][0]}    Senha precisa ter: uma letra maiúscula, uma letra minúscula, um número, um caractere especial(@#$%) e tamanho entre 8-12.


Cadastrar usuário com senha sem letra minúscula
    Gerar Usuario
    ${TOKEN}=    Realizar login

    # Senha inválida sem nenhuma letra minúscula
    Set Test Variable    ${PASSWORD}    ABCDEF@12

    ${body}=    Create Dictionary
    ...    fullName=${FULLNAME}
    ...    mail=${EMAIL}
    ...    accessProfile=${ACCESS_PROFILE}
    ...    cpf=${USER_CPF}
    ...    password=${PASSWORD}
    ...    confirmPassword=${PASSWORD}

    ${response}=    POST On Session    develop    url=/user?token=${TOKEN}    json=${body}    expected_status=400
    Log    ${response.json()}

    Should Be Equal As Strings    ${response.json()['error'][0]}    Senha precisa ter: uma letra maiúscula, uma letra minúscula, um número, um caractere especial(@#$%) e tamanho entre 8-12.


Cadastrar usuário com senha sem letra maiúscula
    Gerar Usuario
    ${TOKEN}=    Realizar login

    # Senha inválida sem nenhuma letra maiúscula
    Set Test Variable    ${PASSWORD}    abcdef@12

    ${body}=    Create Dictionary
    ...    fullName=${FULLNAME}
    ...    mail=${EMAIL}
    ...    accessProfile=${ACCESS_PROFILE}
    ...    cpf=${USER_CPF}
    ...    password=${PASSWORD}
    ...    confirmPassword=${PASSWORD}

    ${response}=    POST On Session    develop    url=/user?token=${TOKEN}    json=${body}    expected_status=400
    Log    ${response.json()}

    Should Be Equal As Strings    ${response.json()['error'][0]}    Senha precisa ter: uma letra maiúscula, uma letra minúscula, um número, um caractere especial(@#$%) e tamanho entre 8-12.

Cadastrar usuário com senha sem caractere especial
    Gerar Usuario
    ${TOKEN}=    Realizar login

    # Senha inválida sem caractere especial
    Set Test Variable    ${PASSWORD}    Abcdef12

    ${body}=    Create Dictionary
    ...    fullName=${FULLNAME}
    ...    mail=${EMAIL}
    ...    accessProfile=${ACCESS_PROFILE}
    ...    cpf=${USER_CPF}
    ...    password=${PASSWORD}
    ...    confirmPassword=${PASSWORD}

    ${response}=    POST On Session    develop    url=/user?token=${TOKEN}    json=${body}    expected_status=400
    Log    ${response.json()}

    Should Be Equal As Strings    ${response.json()['error'][0]}    Senha precisa ter: uma letra maiúscula, uma letra minúscula, um número, um caractere especial(@#$%) e tamanho entre 8-12.


Cadastrar usuário com senha sem número
    Gerar Usuario
    ${TOKEN}=    Realizar login

    # Senha inválida sem número
    Set Test Variable    ${PASSWORD}    Abcdef@!

    ${body}=    Create Dictionary
    ...    fullName=${FULLNAME}
    ...    mail=${EMAIL}
    ...    accessProfile=${ACCESS_PROFILE}
    ...    cpf=${USER_CPF}
    ...    password=${PASSWORD}
    ...    confirmPassword=${PASSWORD}

    ${response}=    POST On Session    develop    url=/user?token=${TOKEN}    json=${body}    expected_status=400
    Log    ${response.json()}

    Should Be Equal As Strings    ${response.json()['error'][0]}    Senha precisa ter: uma letra maiúscula, uma letra minúscula, um número, um caractere especial(@#$%) e tamanho entre 8-12.


Cadastrar usuário com senha em branco
    Gerar Usuario
    ${TOKEN}=    Realizar login

    # Senha vazia
    Set Test Variable    ${PASSWORD}    ${EMPTY}

    ${body}=    Create Dictionary
    ...    fullName=${FULLNAME}
    ...    mail=${EMAIL}
    ...    accessProfile=${ACCESS_PROFILE}
    ...    cpf=${USER_CPF}
    ...    password=${PASSWORD}
    ...    confirmPassword=${PASSWORD}

    ${response}=    POST On Session    develop    url=/user?token=${TOKEN}    json=${body}    expected_status=400
    Log    ${response.json()}

    Should Be Equal As Strings    ${response.json()['error'][0]}    O campo senha é obrigatório


Cadastrar usuário com email já existente
    # Criando o primeiro usuário
    Cadastrar novo usuario
    ${TOKEN}=    Realizar login

    # Guardando o email do primeiro usuário
    ${EMAIL_DUPLICADO}=    Set Variable    ${EMAIL}

    # Gerando novo usuário
    Gerar Usuario

    # Forçando o mesmo email do primeiro usuário
    Set Test Variable    ${EMAIL}    ${EMAIL_DUPLICADO}

    ${body}=    Create Dictionary
    ...    fullName=${FULLNAME}
    ...    mail=${EMAIL}
    ...    accessProfile=${ACCESS_PROFILE}
    ...    cpf=${USER_CPF}
    ...    password=${PASSWORD}
    ...    confirmPassword=${PASSWORD}

    ${response}=    POST On Session    develop    url=/user?token=${TOKEN}    json=${body}    expected_status=409
    Log    ${response.json()}

    Should Be Equal As Strings    ${response.json()['alert'][0]}    E-mail já cadastrado.

Cadastrar usuário com email inválido
    Gerar Usuario
    ${TOKEN}=    Realizar login

    # Email inválido
    Set Test Variable    ${EMAIL}    teste_invalido.com

    ${body}=    Create Dictionary
    ...    fullName=${FULLNAME}
    ...    mail=${EMAIL}
    ...    accessProfile=${ACCESS_PROFILE}
    ...    cpf=${USER_CPF}
    ...    password=${PASSWORD}
    ...    confirmPassword=${PASSWORD}

    ${response}=    POST On Session    develop    url=/user?token=${TOKEN}    json=${body}    expected_status=400
    Log    ${response.json()}

    Should Be Equal As Strings    ${response.json()['error'][0]}    O e-mail informado é inválido. Informe um e-mail no formato [nome@domínio.com].

Cadastrar usuário com email em branco
    Gerar Usuario
    ${TOKEN}=    Realizar login

    # Email vazio
    Set Test Variable    ${EMAIL}    ${EMPTY}

    ${body}=    Create Dictionary
    ...    fullName=${FULLNAME}
    ...    mail=${EMAIL}
    ...    accessProfile=${ACCESS_PROFILE}
    ...    cpf=${USER_CPF}
    ...    password=${PASSWORD}
    ...    confirmPassword=${PASSWORD}

    ${response}=    POST On Session    develop    url=/user?token=${TOKEN}    json=${body}    expected_status=400
    Log    ${response.json()}

    Should Be Equal As Strings    ${response.json()['error'][0]}    O campo e-mail é obrigatório.


Cadastrar usuário com confirmação de senha em branco
    Gerar Usuario
    ${TOKEN}=    Realizar login

    # Confirmação de senha vazia
    Set Test Variable    ${CONFIRM_PASSWORD}    ${EMPTY}

    ${body}=    Create Dictionary
    ...    fullName=${FULLNAME}
    ...    mail=${EMAIL}
    ...    accessProfile=${ACCESS_PROFILE}
    ...    cpf=${USER_CPF}
    ...    password=${PASSWORD}
    ...    confirmPassword=${CONFIRM_PASSWORD}

    ${response}=    POST On Session    develop    url=/user?token=${TOKEN}    json=${body}    expected_status=400
    Log    ${response.json()}

    Should Be Equal As Strings    ${response.json()['error'][0]}    O campo de confirmação de senha é obrigatório.


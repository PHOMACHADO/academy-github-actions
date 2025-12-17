*** Settings ***
Library    SeleniumLibrary
Resource    ../config/dev.robot
Resource    login.resource
Resource    generate_random_data.resource

*** Variables ***
${BTN_NOVO_USUARIO}      xpath://button[text()='Novo Usuário']
${TITLE_MODAL_USUARIO}   xpath://h5[text()='Novo Cadastro']
${TITLE_EDIT_MODAL}      xpath://h5[contains(text(),'Editar')]
${BTN_SALVAR}            xpath://button[text()='Salvar']
${TABELA_USUARIOS}       xpath://table

*** Keywords ***

Acessar Pagina Usuarios
    Click Element    id:Cadastros

    Wait Until Element Is Visible    id:Usuários    timeout=30s
    Click Element    id:Usuários

    Wait Until Location Is    ${BASE_URL_UI}/user    timeout=30s
    Location Should Be        ${BASE_URL_UI}/user

    Wait Until Element Is Visible    xpath://h1[text()='Usuários']    timeout=30s
    Element Text Should Be           xpath://h1[text()='Usuários']    Usuários


# =====================================================================
#                        C A D A S T R A R   U S U Á R I O
# =====================================================================

Cadastrar Novo Usuario    
    Wait Until Element Is Visible    xpath://button[text()='Novo Usuário']    timeout=10s
    Click Button    xpath://button[text()='Novo Usuário']

    Wait Until Element Is Visible    xpath://h2[text()='Novo Usuário']    timeout=10s
    Element Should Be Visible    xpath://h2[text()='Novo Usuário']

    Preencher Formulario Usuario
    
    Wait Until Element Is Visible    xpath://button[text()='Salvar']    timeout=10s
    Click Button    xpath://button[text()='Salvar']

    Sleep    5s


# =====================================================================
#                          C E C K L I S T  M O D A L
# =====================================================================

Verificar Elementos Modal Usuario
    Wait Until Element Is Visible    xpath://button[text()='Novo Usuário']    timeout=10s
    Click Button    xpath://button[text()='Novo Usuário']

    Wait Until Element Is Visible    xpath://h2[text()='Novo Usuário']    timeout=10s
    Element Should Be Visible    xpath://h2[text()='Novo Usuário']
   
    Element Should Be Visible    id:fullName
    Element Should Be Visible    id:mail
    Element Should Be Visible    id:password
    Element Should Be Visible    id:confirmPassword
    Element Should Be Visible    id:accessProfile

    Element Should Be Visible    xpath://button[text()='Salvar']
    Element Should Be Visible    xpath://button[text()='Cancelar']

# =====================================================================
#                          V A L I D A R  P E R F I L
# =====================================================================

Validar Select Perfil De Acesso 
    Wait Until Element Is Visible    xpath://button[text()='Novo Usuário']    timeout=10s
    Click Button    xpath://button[text()='Novo Usuário']

    Wait Until Element Is Visible    xpath://h2[text()='Novo Usuário']    timeout=10s
    Element Should Be Visible    xpath://h2[text()='Novo Usuário']

    Element Should Be Visible    id:accessProfile

    ${tag}=    Get Element Attribute    id:accessProfile    tagName
    Should Be Equal As Strings    ${tag}    select    msg=Campo Perfil de Acesso deveria ser SELECT (BUG encontrado: é ${tag})

    Click Element    id:accessProfile
    Sleep    1s

    ${opcoes}=    Get WebElements    xpath://li[contains(@class,'MuiMenuItem-root')]
    Should Not Be Empty    ${opcoes}    msg=Select Perfil de Acesso não carregou opções (BUG)



Preencher Formulario Usuario
    ${dados_usuario}=    Gerar Usuario

    Preencher Campo Nome Completo Usuario       ${dados_usuario['fullName']}
    Preencher Campo Email Usuario               ${dados_usuario['mail']}
    Preencher Campo Senha Usuario               ${dados_usuario['password']}
    Preencher Campo Confirmar Senha Usuario     ${dados_usuario['confirmPassword']}
    Preencher Campo Perfil Usuario              ${dados_usuario['accessProfile']}


# ====================== CAMPOS INDIVIDUAIS ========================

Preencher Campo Nome Completo Usuario
    [Arguments]    ${valor}
    Wait Until Element Is Visible    id:fullName    timeout=10s
    Input Text    id:fullName    ${valor}

Preencher Campo Email Usuario
    [Arguments]    ${valor}
    Wait Until Element Is Visible    id:mail    timeout=10s
    Input Text    id:mail    ${valor}

Preencher Campo Senha Usuario
    [Arguments]    ${valor}
    Wait Until Element Is Visible    id:password    timeout=10s
    Input Text    id:password    ${valor}

Preencher Campo Confirmar Senha Usuario
    [Arguments]    ${valor}
    Wait Until Element Is Visible    id:confirmPassword    timeout=10s
    Input Text    id:confirmPassword    ${valor}

Preencher Campo Perfil Usuario
    [Arguments]    ${valor}
    Wait Until Element Is Visible    id:accessProfile    timeout=10s
    Select From List By Label    id:accessProfile    ${valor}
*** Settings ***
Resource    ../../resources/user.resource
Resource    ../../resources/common.resource
Resource    ../../resources/login.resource

Test Setup       Abrir Navegador
Test Teardown    Fechar Navegador

*** Test Cases ***


Cenario 01: Cadastrar novo usuario
    Realizar Login
    Verificar Redirecionamento Para Home
    Verificar Elemento Cadastros Visivel
    Acessar Pagina Usuarios 

    Cadastrar Novo Usuario     

Cenario 02: Verificar elementos do modal de novo usuário
    Realizar Login
    Verificar Redirecionamento Para Home
    Verificar Elemento Cadastros Visivel
    Acessar Pagina Usuarios

    Verificar Elementos Modal Usuario

Cenario 03: Validar campo Perfil de Acesso
    Realizar Login
    Verificar Redirecionamento Para Home
    Verificar Elemento Cadastros Visivel
    Acessar Pagina Usuarios

    Validar Select Perfil De Acesso

Cenario 04: Verificar botão Salvar habilitado no modal de novo usuário
    Realizar Login
    Verificar Redirecionamento Para Home
    Verificar Elemento Cadastros Visivel
    Acessar Pagina Usuarios

    Wait Until Element Is Visible    xpath://button[text()='Novo Usuário']    timeout=10s
    Click Button    xpath://button[text()='Novo Usuário']

    Wait Until Element Is Visible    xpath://h2[text()='Novo Usuário']    timeout=10s
    Element Should Be Visible    xpath://h2[text()='Novo Usuário']

    # Verifica se o botão existe e está habilitado
    Element Should Be Visible        ${BTN_SALVAR}
    Element Should Be Enabled        ${BTN_SALVAR}

Cenario 05: Verificar botão Cancelar habilitado no modal de novo usuário
    Realizar Login
    Verificar Redirecionamento Para Home
    Verificar Elemento Cadastros Visivel
    Acessar Pagina Usuarios

    # Abrir modal
    Wait Until Element Is Visible    xpath://button[text()='Novo Usuário']    timeout=10s
    Click Button    xpath://button[text()='Novo Usuário']

    Wait Until Element Is Visible    xpath://h2[text()='Novo Usuário']    timeout=10s
    Element Should Be Visible        xpath://h2[text()='Novo Usuário']

    # Verificar botão Cancelar visível e habilitado
    Element Should Be Visible        xpath://button[text()='Cancelar']
    Element Should Be Enabled        xpath://button[text()='Cancelar']

    # Clicar no botão cancelar com formulário vazio
    Click Button    xpath://button[text()='Cancelar']

    # Modal deve ser fechado
    Wait Until Element Is Not Visible    xpath://h2[text()='Novo Usuário']    timeout=5s

Cenario 06: Verificar campo Senha no modal de novo usuário
    Realizar Login
    Verificar Redirecionamento Para Home
    Verificar Elemento Cadastros Visivel
    Acessar Pagina Usuarios

    # Abrir modal
    Wait Until Element Is Visible    xpath://button[text()='Novo Usuário']    timeout=10s
    Click Button    xpath://button[text()='Novo Usuário']

    Wait Until Element Is Visible    xpath://h2[text()='Novo Usuário']    timeout=10s
    Element Should Be Visible        xpath://h2[text()='Novo Usuário']
    # ================================
    # 1. Campo SENHA existe e habilitado
    # ================================
    Element Should Be Visible    id:password
    Element Should Be Enabled    id:password

    # ================================
    # 2. Validar que NÃO existe ícone de mostrar senha (BUG do PBI)
    # ================================
    ${icone}=    Run Keyword And Ignore Error    Get WebElements    
    ...    xpath://*[contains(@class,'MuiInputAdornment') or contains(@class,'visibility') or contains(@class,'eye')]

    Should Be Equal As Strings    ${icone[0]}    NONE
    ...    msg=BUG: O campo Senha deveria ter um ícone para mostrar/ocultar a senha, mas não existe.




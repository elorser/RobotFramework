*** Settings ***
Library           SSHLibrary
Library           String
Library           BuiltIn

*** Variables ***
${hostDWHSIT1}    h3mih295    # Host di test (SIT1) di DWH
${userDWHSit1}    dsadm
${pwdDWHSit1}     295dsadm
${Gdp000WorkflowMaster}    Gdp000WorkflowMaster    # Flusso master GDPR
${jobPathGDPR}    /home/dsadm/Sergio/Automation/GDPR/    # Path del workflow GDPR
${jobMasterGDPR}    Gdp000WorkflowMaster.sh    # WorkFlow master GDPR
${jobPropertiesGDPR}    Gdp000WorkflowMaster.properties    # Properties master GDPR

*** Test Cases ***
Start GdprDWHFlowTestSession
    ${jobPathMaster}    Set Variable    ${jobPathGDPR}${jobMasterGDPR}
    ${jobPathProperties}    Set Variable    ${jobPathGDPR}${jobPropertiesGDPR}
    # Apre la connessione al server ed esegue il log in
    Open Connection And Log In
    #
    # Start return codes
    ${rc}    Set Variable    ${0}
    ${rc1}    Set Variable    ${0}
    # Start connneciotn closed status
    ${conClosed}    Set Variable    ${FALSE}
    #
    # Check the existance of the master job file
    ${stderr}    ${rc}=    Execute Command    ls -lrt ${jobPathMaster}    return_stdout=False    return_stderr=True    return_rc=True
    # If master job does not exist It prints the error message and close connection
    Run Keyword If    ${rc} != ${0}    Execute Command    echo "Command failed with return code ${rc} - ${stderr}"
    #
    # Check the existance of the properties file
    ${stderr}    ${rc1}=    Run Keyword If    ${rc}==${0}    Execute Command    ls -lrt ${jobPathProperties}    return_stdout=False
    ...    return_stderr=True    return_rc=True
    # If properties file does not exist It prints the error message and close connection
    Run Keyword If    ${rc1} != ${0} and ${rc1}!=${None}    Execute Command    echo "Command failed with return code ${rc1} - ${stderr}"
    #
    log    ${rc1}
    ${rc1}=    Run Keyword If    ${rc1}==${None}    Set Variable    0
    ...    ELSE    Set Variable    ${rc1}
    log    ${rc1}
    #
    Run Keyword If    ${rc} != ${0} or ${rc1} != ${0}    Close Connection
    ${conClosed}    Run Keyword If    ${rc} != ${0} or ${rc1} != ${0}    Set Variable    ${TRUE}
    Run Keyword If    ${rc} != ${0} or ${rc1} != ${0}    log    "Connection closed"
    #
    log    ${conClosed}
    # If all checks are well It changes the working directory and starts the job
    Run Keyword If    not ${conClosed}    Set Client Configuration    prompt=$
    Run Keyword If    not ${conClosed}    Write    cd ${jobPathGDPR}
    ${newline}=    Run Keyword If    not ${conClosed}    Read Until Prompt
    Run Keyword If    not ${conClosed}    Write    nohup ${jobMasterGDPR} -start ${jobPropertiesGDPR} &
    ${newline}=    Run Keyword If    not ${conClosed}    Read Until Prompt
    #
    # It closes the connection
    Run Keyword If    not ${conClosed}    Close Connection

*** Keyword ***
Open Connection And Log In
    Open Connection    ${hostDWHSit1}
    Login    ${userDWHSit1}    ${pwdDWHSit1}

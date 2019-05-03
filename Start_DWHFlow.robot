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
${jobMasterGDPR}    Gdp000WorkflowMaste.sh    # WorkFlow master GDPR
${jobPropertiesGDPR}    Gdp000WorkflowMaster.properties    # Properties master GDPR

*** Test Cases ***
Start GdprDWHFlowTestSession
    ${jobPathMaster}    Set Variable    ${jobPathGDPR}${jobMasterGDPR}
    ${jobPathProperties}    Set Variable    ${jobPathGDPR}${jobPropertiesGDPR}
    # Apre la connessione al server ed esegue il log in
    Open Connection And Log In
    #
    # Check the existance of the master job file
    ${stderr}    ${rc}=    Execute Command    ls -lrt ${jobPathMaster}    return_stdout=False    return_stderr=True    return_rc=True
    # If master job does not exist It prints the error message and close connection
    Run Keyword If    ${rc} != ${0}    Execute Command    echo "Command failed with return code ${rc} - ${stderr}"
    Run Keyword If    ${rc} != ${0}    Execute Command    exit
    #
    # Check the existance of the properties file
    ${stderr}    ${rc}=    Execute Command    ls -lrt ${jobPathProperties}    return_stdout=False    return_stderr=True    return_rc=True
    # If properties file does not exist It prints the error message and close connection
    Run Keyword If    ${rc} != ${0}    Execute Command    echo "Command failed with return code ${rc} - ${stderr}"
    Run Keyword If    ${rc} != ${0}    Execute Command    exit
    #
    # If all checks are well It changes the working directory and starts the job
    Write    cd ${jobPathGDPR}
    Set Client Configuration    prompt=$
    ${output}=    Read Until Prompt
    Write    nohup ${jobMasterGDPR} -start ${jobPropertiesGDPR} &
    ${output}=    Read Until Prompt
    #
    # It close the connection
    Close Connection

*** Keyword ***
Open Connection And Log In
    Open Connection    ${hostDWHSit1}
    Login    ${userDWHSit1}    ${pwdDWHSit1}

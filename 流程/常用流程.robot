*** Settings ***
Library           Selenium2Library
Resource          ../参数/resource.robot

*** Keywords ***
登录
    [Arguments]    ${login_name}    ${login_passwd}
    web页面操作    Input Text    //*[@id="login"]/div[2]/form/div[1]/div/div/div[1]/input    ${login_name}
    web页面操作    Input Text    //*[@id="login"]/div[2]/form/div[2]/div/div/div[1]/input    ${login_passwd}
    web页面操作    Click Button    //*[@id="login"]/div[2]/button

进入子系统
    [Arguments]    ${locator}
    web页面操作    Click Element    ${locator}

合同作废
    [Arguments]    ${contract_type}    ${contract_num}
    多次点击进入    //p[contains(text(),"合约管理")]    //p[contains(text(),"合同管理")]    //p[text()="${contract_type}"]
    sleep    3
    输入text    //*[@id="page-wrapper"]/div[2]/div[2]/div[2]/div[1]/div/form/div[3]/div/div/input    ${contract_num}
    sleep    3
    点击元素    //div[contains(@class,"el-table__body-wrapper is-scrolling-none")]/table/tbody/tr/td[8]/div/p[2]/button[2]/span
    点击元素    //span[contains(text(),"提交")]
    sleep    15

添加房源
    FOR    ${i}    IN RANGE    1    11
        ${文本}    获取元素text值    //div[contains(text(),"所选场地面积")]/../div[2]/div[${i}]/div/div[1]/div/p
        ${房源数}    evaluate    int("${文本}".split("闲置场地：")[1])
        Run Keyword If    ${房源数} > 0    Run Keywords    点击元素    //div[contains(text(),"所选场地面积")]/../div[2]/div[${i}]/div/div[1]/div/p
        ...    AND    点击元素    //div[contains(text(),"所选场地面积")]/../div[2]/div[${i}]/div[2]/div[3]/div[1]/label
        ...    AND    点击元素    //span[contains(text(),"完成")]
        EXIT FOR LOOP IF    ${房源数} > 0
        Should Not Be Equal    ${i}    10    房源不足
    END

勾选自有产权房源
    [Arguments]    ${i}    ${num}
    ${num}    evaluate    ${num}+ 1
    FOR    ${j}    IN RANGE    1    ${num}
        ${status}    Run Keyword And Return Status    element should not be visible    //div[contains(text(),"所选场地面积")]/../div[2]/div[${i}]/div[2]/div[3]/div[${j}]/label/span[2]/span[5]
        Run Keyword If    ${status}    run keywords    点击元素    //div[contains(text(),"所选场地面积")]/../div[2]/div[${i}]/div[2]/div[3]/div[${j}]/label
        ...    AND    点击元素    //span[contains(text(),"完成")]
        ...    AND    EXIT FOR LOOP
    END
    [Return]    ${status}

勾选企业产权房源
    [Arguments]    ${i}    ${num}
    ${num}    evaluate    ${num}+ 1
    FOR    ${j}    IN RANGE    1    ${num}
        ${status}    Run Keyword And Return Status    element should be visible    //div[contains(text(),"所选场地面积")]/../div[2]/div[${i}]/div[2]/div[3]/div[${j}]/label/span[2]/span[5]
        Run Keyword If    ${status}    run keywords    点击元素    //div[contains(text(),"所选场地面积")]/../div[2]/div[${i}]/div[2]/div[3]/div[${j}]/label
        ...    AND    点击元素    //span[contains(text(),"完成")]
        ...    AND    EXIT FOR LOOP
    END
    [Return]    ${status}

场地类型
    [Arguments]    ${i}    ${房源数}
    ${num}    evaluate    ${房源数}+ 1
    FOR    ${j}    IN RANGE    1    ${num}
        ${场地类型}    获取元素text值    //div[contains(text(),"所选场地面积")]/../div[2]/div[${i}]/div[2]/div[3]/div[${j}]/label/span[2]/span[4]
        Run Keyword If    "${场地类型}" == "普通场地"    Continue For Loop
        ${房源数}    evaluate    ${房源数}-1
    END
    [Return]    ${房源数}

添加房源_copy
    [Arguments]    ${num}
    FOR    ${i}    IN RANGE    1    11
        ${文本}    获取元素text值    //div[contains(text(),"所选场地面积")]/../div[2]/div[${i}]/div/div[1]/div/p
        ${房源数}    evaluate    int("${文本}".split("闲置场地：")[1])
        Run Keyword If    ${房源数} > 0    点击元素    //div[contains(text(),"所选场地面积")]/../div[2]/div[${i}]/div/div[1]/div/p
        ${房源数}    场地类型    ${i}    ${房源数}
        Run Keyword If    ${房源数} > 0 and ${房源数} >= ${num}    勾选自有产权房源    ${i}    ${num}
        ...    ELSE IF    ${房源数} > 0 and ${房源数} < ${num}    Run Keywords    勾选自有产权房源    ${i}    ${num}
        ${num}=    Run Keyword If    ${房源数} > 0    evaluate    ${num} - ${房源数}
        ...    ELSE IF    ${房源数} <= 0    evaluate    ${num}
        Exit For Loop If    ${num} <= 0
        Should Not Be Equal    ${i}    11    房源不足
    END

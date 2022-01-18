*** Settings ***
Library           Selenium2Library
Library           Collections
Library           DatabaseLibrary
Library           ../lib/KeyWords.py

*** Keywords ***
校验方法Equal
    [Arguments]    @{value}
    [Documentation]    @{value}:实际值和期望值组合的list。例如：[实际1，实际2，期望1，期望2]
    ${len}    Get Length    ${value}
    ${len/2}    evaluate    int(${len}/2)
    @{actual}    Create List    @{value[:${len/2}]}
    @{expect}    Create List    @{value[${len/2}:]}
    FOR    ${i}    IN RANGE    ${len/2}
        Should Be Equal    ${actual}[${i}]    ${expect}[${i}]
    END

校验方法Contain
    [Arguments]    @{value}
    ${len}    Get Length    ${value}
    ${len/2}    evaluate    int(${len}/2)
    @{actual}    Create List    @{value[:${len/2}]}
    @{expect}    Create List    @{value[${len/2}:]}
    FOR    ${i}    IN RANGE    ${len/2}
        Should Contain    ${actual}[${i}]    ${expect}[${i}]
    END

输入text
    [Arguments]    ${locator}    ${value}
    [Documentation]    ${locator}:定位元素的路径:str
    ...
    ...    ${value}:需要输入的text值:str
    Comment    Wait Until Keyword Succeeds    10    2    Input Text    ${locator}    ${value}
    web页面操作    Input Text    ${locator}    ${value}

获取元素text值
    [Arguments]    ${locator}
    [Documentation]    ${locator}:元素的定位路径:str
    ...
    ...    ${text}:获取的元素的text值:str
    Comment    ${text}    Wait Until Keyword Succeeds    10    2    Get Text    ${locator}
    ${text}    web页面操作    Get Text    ${locator}
    [Return]    ${text}

获取多个text值
    [Arguments]    @{locators}
    [Documentation]    @{locators}:元素定位路径:list
    ...
    ...    @{texts}:所有元素的text值:list
    sleep    2
    @{texts}    Create List
    FOR    ${i}    IN    @{locators}
        ${text}    获取元素text值    ${i}
        Append To List    ${texts}    ${text}
    END
    [Return]    @{texts}

点击元素
    [Arguments]    ${locator}
    [Documentation]    ${locator}:元素的定位路径:str
    Comment    Wait Until Keyword Succeeds    10    2    Click Element    ${locator}
    web页面操作    Click Element    ${locator}

多次点击进入
    [Arguments]    @{locators}
    [Documentation]    @{locators}:元素的定位路径:list
    FOR    ${i}    IN    @{locators}
        点击元素    ${i}
    END

获取元素属性
    [Arguments]    ${locator}    ${attribute}
    [Documentation]    ${locator}:元素的定位路径:str
    ...
    ...    ${attribute}:需要获取的元素某个属性:str
    ...
    ...    ${value}:获取到的属性值:str
    Comment    ${value}    Wait Until Keyword Succeeds    10    2    Get Element Attribute    ${locator}    ${attribute}
    ${value}    web页面操作    Get Element Attribute    ${locator}    ${attribute}
    [Return]    ${value}

获取多个元素属性
    [Arguments]    @{data}
    [Documentation]    @{data}:元素定位路径和属性名的组合:list。例如：[路径1，属性1，路径2，属性2]
    ...
    ...    @{result}:获得的所有属性:list
    ${len}    Get Length    ${data}
    ${len}    evaluate    ${len}/2
    @{result}    Create List
    FOR    ${i}    IN RANGE    ${len}
        ${locator_index}    evaluate    ${i}*2
        ${locator}    Get From List    ${data}    ${locator_index}
        ${attribute_index}    evaluate    ${i}*2+1
        ${attribute}    Get From List    ${data}    ${attribute_index}
        Comment    ${value}    Wait Until Keyword Succeeds    10    2    Get Element Attribute    ${locator}    ${attribute}
        ${value}    web页面操作    Get Element Attribute    ${locator}    ${attribute}
        Append To List    ${result}    ${value}
    END
    [Return]    @{result}

数据库查询
    [Arguments]    ${database_name}    ${sql}
    [Documentation]    ${database_name}:数据库名:str
    ...
    ...    ${sql}:sql:str
    ...
    ...    @{res}:查询结果:list
    Connect To Database Using Custom Params    pymysql    database='${database_name}',user='${database}[user]',password='${database}[password]',host='${database}[host]',port=${database}[port]
    @{res}    Query    ${sql}
    Disconnect From Database
    [Return]    @{res}

数据库增删改
    [Arguments]    ${database_name}    ${sql}
    [Documentation]    ${database_name}:数据库名:str
    ...
    ...    ${sql}:sql:str
    Connect To Database Using Custom Params    pymysql    database='${database_name}',user='${database}[user]',password='${database}[password]',host='${database}[host]',port=${database}[port]
    Execute Sql String    ${sql}
    Disconnect From Database

数据库校验
    [Arguments]    ${database_name}    ${sql}    ${expect}
    [Documentation]    ${database_name}:数据库名:str
    ...
    ...    ${sql}:sql:str
    ...
    ...    ${expect}:期望的数据库查询结果:str。例如：”[(1,2,'3'),(2,3,'3')]“
    @{expect_list}    Evaluate    ast.literal_eval(${expect})    ast    #将字符型的期望值转为list
    @{result}    数据库查询    ${database_name}    ${sql}
    Should Be Equal    ${result}    ${expect_list}
    [Teardown]

web页面操作
    [Arguments]    ${keyword}    @{params}
    [Documentation]    ${keyword}:关键字名:str
    ...
    ...    @{params}:关键字所需的参数:list
    ${return}    Wait Until Keyword Succeeds    15    2    ${keyword}    @{params}
    [Return]    ${return}

截屏套件
    Run Keyword If Test Failed    Capture Page Screenshot
    Close Browser

获取当前时间yyyy-mm-dd
    [Documentation]    ${time}[:10] :xxxx-xx-xx
    ${time}    Get Time
    [Return]    ${time}[:10]

拖动元素
    [Arguments]    ${source}    ${xoffset}    ${yoffse}
    [Documentation]    ${source}:定位元素的路径:str。如：xpath=//*[@id=“sliderWrap”]/div/div[2]
    ...
    ...    ${xoffse}:x轴偏移量，右正左负，单位px:str
    ...
    ...    ${yoffse}:y轴偏移量，下正上负，单位px:str
    Drag And Drop By Offset    ${source}    ${xoffset}    ${yoffse}

计算年租金
    [Arguments]    ${area}    ${price}    ${unit}
    ${cent}=    run keyword if    '${unit}'=='元/m²·天'    evaluate    '%.5f' %(${price}*${area}*365)
    ...    ELSE IF    '${unit}'=='元/m²·月'    evaluate    '{:g}'.format(int((${price}*${area}*12)*100000+0.5)/100000)
    ...    ELSE IF    '${unit}'=='元/月'    evaluate    '%.5f' %(${price}*12)
    ...    ELSE IF    '${unit}'=='元/㎡·年'    evaluate    '%.5f' %(${price}*${area})
    ...    ELSE IF    '${unit}'=='元/年'    evaluate    '%.5f' %(${price})
    ${year_cent}    Cent Format    ${cent}
    [Return]    ${year_cent}

计算月租金
    [Arguments]    ${area}    ${price}    ${unit}
    ${cent}=    run keyword if    '${unit}'=='元/m²·天'    evaluate    ${price}*${area}*365/12
    ...    ELSE IF    '${unit}'=='元/m²·月'    evaluate    ${price}*${area}
    ...    ELSE IF    '${unit}'=='元/月'    evaluate    ${price}
    ...    ELSE IF    '${unit}'=='元/㎡·年'    evaluate    ${price}*${area}/12
    ...    ELSE IF    '${unit}'=='元/年'    evaluate    ${price}/12
    ${month_cent}    Cent Format    ${cent}
    [Return]    ${month_cent}

向多个元素输入text
    [Arguments]    @{data}
    ${length}    Get Length    ${data}
    @{index_locator}=    evaluate    [i*2 for i in range(${length}/2)]
    FOR    ${i}    IN    @{index_locator}
        ${index_text}=    evaluate    ${i}+1
        web页面操作    Input Text    ${data}[$[i]]    ${data}[${index_text}]
    END

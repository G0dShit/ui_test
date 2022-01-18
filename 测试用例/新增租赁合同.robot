*** Settings ***
Resource          ../参数/resource.robot

*** Test Cases ***
新增租赁合同--合同编号自动填入--孵化型租赁合同
    &{basic_data}    Create Dictionary    客户业态=办公    跟进商务=    合同类型=孵化型租赁合同    来源人=    审批流程=不使用审批流程    抄送人=    中介经纪人=
    Open Browser    ${演示环境}    chrome
    Maximize Browser Window
    登录    ${login_kongweixiong}[name]    ${login_kongweixiong}[passwd]
    进入子系统    ${system_locator}[buildingAssets]
    多次点击进入    //p[text()="合约管理"]    //span[contains(text(),"新增合同")]    //span[contains(text(),"新建租赁合同")]    //label[text()="合同类型："]/../div/div/div/input    //span[text()='${basic_data}[合同类型]']
    sleep    1
    ${contract_num}    获取元素text值    //label[text()="合同编号："]/../div/div/input    #获取合同编号
    ${yyyy-mm-dd}    获取当前时间yyyy-mm-dd
    ${type}    Set Variable    001
    校验方法Equal    ${contract_num}[:9]    ${yyyy-mm-dd}[:4]-001-
    Close Browser
    [Teardown]    截屏套件

新增租赁合同--合同编号自动填入--生产型租赁合同
    &{basic_data}    Create Dictionary    客户业态=办公    跟进商务=    合同类型=生产型租赁合同    来源人=    审批流程=不使用审批流程    抄送人=    中介经纪人=
    Open Browser    ${演示环境}    chrome
    Maximize Browser Window
    登录    ${login_kongweixiong}[name]    ${login_kongweixiong}[passwd]
    进入子系统    ${system_locator}[buildingAssets]
    多次点击进入    //p[text()="合约管理"]    //span[contains(text(),"新增合同")]    //span[contains(text(),"新建租赁合同")]    //label[text()="合同类型："]/../div/div/div/input    //span[text()='${basic_data}[合同类型]']
    sleep    1
    ${contract_num}    获取元素text值    //label[text()="合同编号："]/../div/div/input    #获取合同编号
    ${yyyy-mm-dd}    获取当前时间yyyy-mm-dd
    ${type}    Set Variable    002
    校验方法Equal    ${contract_num}[:9]    ${yyyy-mm-dd}[:4]-${type}-
    Close Browser
    [Teardown]    截屏套件

新增租赁合同--添加租赁房源--添加一个房源
    Open Browser    ${演示环境}    chrome
    Maximize Browser Window
    登录    ${login_kongweixiong}[name]    ${login_kongweixiong}[passwd]
    进入子系统    ${system_locator}[buildingAssets]
    多次点击进入    //p[text()="合约管理"]    //span[contains(text(),"新增合同")]    //span[contains(text(),"新建租赁合同")]
    点击元素    //span[contains(text(),"添加租赁房源")]    #点击添加租赁房源
    FOR    ${i}    IN RANGE    1    11
        ${文本}    获取元素text值    //div[contains(text(),"所选场地面积")]/../div[2]/div[${i}]/div/div[1]/div/p
        ${房源数}    evaluate    int("${文本}".split("闲置场地：")[1])
        ${buildProName}    获取元素text值    //div[contains(text(),"所选场地面积：")]/../div[2]/div[${i}]/div/div[1]/div/h3
        Run Keyword If    ${房源数} > 0    点击元素    //div[contains(text(),"所选场地面积")]/../div[2]/div[${i}]/div/div[1]/div/p
        @{texts_expect}=    Run Keyword If    ${房源数} > 0    获取多个text值    //div[contains(text(),"所选场地面积")]/../div[2]/div[${i}]/div[2]/div[3]/div[1]/label/span[2]/span[1]    //div[contains(text(),"所选场地面积")]/../div[2]/div[${i}]/div[2]/div[3]/div[1]/label/span[2]/span[2]    //div[contains(text(),"所选场地面积")]/../div[2]/div[${i}]/div[2]/div[3]/div[1]/label/span[2]/span[4]    //div[contains(text(),"所选场地面积")]/../div[2]/div[${i}]/div[2]/div[3]/div[1]/label/span[2]/span[3]    #获取期望值
        Run Keyword If    ${房源数} > 0    Run Keywords    点击元素    //div[contains(text(),"所选场地面积")]/../div[2]/div[${i}]/div[2]/div[3]/div[1]/label
        ...    AND    点击元素    //span[contains(text(),"完成")]
        EXIT FOR LOOP IF    ${房源数} > 0
        Should Not Be Equal    ${i}    10    房源不足
    END
    ${business_area}    获取元素属性    //h3[contains(text(),"场地信息：")]/../div/div[1]/div[3]/table/tbody/tr/td[6]/div/div/input    value
    ${area}    Set Variable    ${texts_expect}[3][:-1]
    校验方法Equal    ${business_area}    ${area}
    ${input_area}    Set Variable    1.001    #需要输入的面积
    输入text    //h3[contains(text(),"场地信息：")]/../div/div[1]/div[3]/table/tbody/tr/td[6]/div/div/input    ${input_area}
    点击元素    //span[contains(text(),"所选场地面积总和")]
    @{texts_actual}    获取多个text值    //h3[contains(text(),"场地信息：")]/../div/div[1]/div[3]/table/tbody/tr/td[1]/div    //h3[contains(text(),"场地信息：")]/../div/div[1]/div[3]/table/tbody/tr/td[2]/div    //h3[contains(text(),"场地信息：")]/../div/div[1]/div[3]/table/tbody/tr/td[3]/div    //h3[contains(text(),"场地信息：")]/../div/div[1]/div[3]/table/tbody/tr/td[4]/div    //h3[contains(text(),"场地信息：")]/../div/div[1]/div[3]/table/tbody/tr/td[5]/div/span
    ${text01}    获取元素text值    //span[contains(text(),"所选场地面积总和")]
    Append To List    ${texts_actual}    ${text01}    #组装实际值
    @{texts_expect}    Create List    ${buildProName}    @{texts_expect}    #组装期望值
    Append To List    ${texts_expect}    ${area}(m²)    所选场地面积总和：${input_area}㎡    #组装期望值
    Remove From List    ${texts_expect}    4
    校验方法Equal    @{texts_actual}    @{texts_expect}
    Close Browser
    [Teardown]    截屏套件

新增租赁合同--租户信息查询--正常
    &{business_data}    Create Dictionary    租户名称=温州市罗微兰鞋业有限公司    行业分类=信息软件    联系人=叶阿英    联系电话=13857774758    联系邮箱=    服务平台=百应服务机构    法人=叶阿英    统一社会信用代码=91330302MA28762B5C
    @{business_data_list}    Create List    温州市罗微兰鞋业有限公司    信息软件    叶阿英    13857774758    \    百应服务机构    叶阿英    91330302MA28762B5C
    Open Browser    ${演示环境}    chrome
    Maximize Browser Window
    登录    ${login_kongweixiong}[name]    ${login_kongweixiong}[passwd]
    进入子系统    ${system_locator}[buildingAssets]
    多次点击进入    //p[text()="合约管理"]    //span[contains(text(),"新增合同")]    //span[contains(text(),"新建租赁合同")]
    点击元素    //label[text()="租户名称"]/../div/div/div/span    #点击输入租户
    输入text    //label[text()="租户名称"]/../div/div/div[2]/div/div/input    ${business_data}[租户名称]
    点击元素    //div[contains(text(), "${business_data}[租户名称]")]    #选择租户
    sleep    2
    @{tenant_data}    获取多个元素属性    //label[text()="租户名称"]/../div/div/div/input    value    //label[text()="行业分类："]/../div/div/div/input    value    //label[text()="联系人："]/../div/div/input    value    //label[text()="联系电话："]/../div/div/input    value    //label[text()="联系邮箱："]/../div/div/input    value    //label[text()="服务平台："]/../div/div/input    value    //span[text()="法人："]/../div/div/input    value    //span[text()="统一社会信用代码："]/../div/div/input
    ...    value
    #获取租户信息
    校验方法Equal    @{business_data_list}    @{tenant_data}
    Close Browser
    [Teardown]    截屏套件

新增租赁合同--租赁条款--默认值自动填入
    [Teardown]    截屏套件

新增租赁合同--租赁条款支付周期划分--按起始日划分
    &{basic_data}    Create Dictionary    客户业态=办公    跟进商务=    合同类型=孵化型租赁合同    来源人=    审批流程=不使用审批流程    抄送人=    中介经纪人=
    &{business_data}    Create Dictionary    租户名称=温州市罗微兰鞋业有限公司    行业分类=信息软件    联系人=叶阿英    联系电话=13857774758    联系邮箱=    服务平台=百应服务机构    法人=叶阿英    统一社会信用代码=91330302MA28762B5C
    Open Browser    ${演示环境}    chrome
    Maximize Browser Window
    登录    ${login_kongweixiong}[name]    ${login_kongweixiong}[passwd]
    进入子系统    ${system_locator}[buildingAssets]
    多次点击进入    //p[text()="合约管理"]    //span[contains(text(),"新增合同")]    //span[contains(text(),"新建租赁合同")]    //label[text()="客户业态："]/../div/div/div/input    //span[text()='${basic_data}[客户业态]']    //label[text()="合同类型："]/../div/div/div/input    //span[text()='${basic_data}[合同类型]']    //label[text()="审批流程："]/../div/div/div/input    //span[text()='${basic_data}[审批流程]']
    点击元素    //span[contains(text(),"添加租赁房源")]
    添加房源
    #
    点击元素    //label[text()="租户名称"]/../div/div/div/span
    输入text    //label[text()="租户名称"]/../div/div/div[2]/div/div/input    ${business_data}[租户名称]
    多次点击进入    //div[contains(text(), "${business_data}[租户名称]")]    //span[contains(text(),"下一步")]    //label[contains(text(),"支付周期划分")]/../div/div/div[1]/input    //span[contains(text(),"按起始日划分")]
    @{actual}    获取多个元素属性    //label[contains(text(),"支付周期")]/../div/div/input    value    //label[contains(text(),"支付周期")]/../div/div/input    disabled    //label[contains(text(),"收款日")]/../div/div/input    value    //label[contains(text(),"收款日")]/../div/div/input    disabled
    @{expect}    Create List    3    ${null}    18    ${null}
    校验方法Equal    @{actual}    @{expect}
    Close Browser
    [Teardown]    截屏套件

新增租赁合同--租赁条款支付周期划分--按年划分
    &{basic_data}    Create Dictionary    客户业态=办公    跟进商务=    合同类型=孵化型租赁合同    来源人=    审批流程=不使用审批流程    抄送人=    中介经纪人=
    &{business_data}    Create Dictionary    租户名称=温州市罗微兰鞋业有限公司    行业分类=信息软件    联系人=叶阿英    联系电话=13857774758    联系邮箱=    服务平台=百应服务机构    法人=叶阿英    统一社会信用代码=91330302MA28762B5C
    Open Browser    ${演示环境}    chrome
    Maximize Browser Window
    登录    ${login_kongweixiong}[name]    ${login_kongweixiong}[passwd]
    进入子系统    ${system_locator}[buildingAssets]
    多次点击进入    //p[text()="合约管理"]    //span[contains(text(),"新增合同")]    //span[contains(text(),"新建租赁合同")]    //label[text()="客户业态："]/../div/div/div/input    //span[text()='${basic_data}[客户业态]']    //label[text()="合同类型："]/../div/div/div/input    //span[text()='${basic_data}[合同类型]']    //label[text()="审批流程："]/../div/div/div/input    //span[text()='${basic_data}[审批流程]']
    点击元素    //span[contains(text(),"添加租赁房源")]
    添加房源
    #
    点击元素    //label[text()="租户名称"]/../div/div/div/span
    输入text    //label[text()="租户名称"]/../div/div/div[2]/div/div/input    ${business_data}[租户名称]
    多次点击进入    //div[contains(text(), "${business_data}[租户名称]")]    //span[contains(text(),"下一步")]    //label[contains(text(),"支付周期划分")]/../div/div/div[1]/input    //span[contains(text(),"按年划分")]
    @{actual}    获取多个元素属性    //label[contains(text(),"支付周期")]/../div/div/input    value    //label[contains(text(),"支付周期")]/../div/div/input    disabled    //label[contains(text(),"收款日")]/../div/div/input    value    //label[contains(text(),"收款日")]/../div/div/input    disabled
    @{expect}    Create List    12    true    账单起始日期    true
    校验方法Equal    @{actual}    @{expect}
    Close Browser
    [Teardown]    截屏套件

新增租赁合同--租赁条款计费类型--按月计费
    &{basic_data}    Create Dictionary    客户业态=办公    跟进商务=    合同类型=孵化型租赁合同    来源人=    审批流程=不使用审批流程    抄送人=    中介经纪人=
    &{business_data}    Create Dictionary    租户名称=温州市罗微兰鞋业有限公司    行业分类=信息软件    联系人=叶阿英    联系电话=13857774758    联系邮箱=    服务平台=百应服务机构    法人=叶阿英    统一社会信用代码=91330302MA28762B5C
    Open Browser    ${演示环境}    chrome
    Maximize Browser Window
    登录    ${login_kongweixiong}[name]    ${login_kongweixiong}[passwd]
    进入子系统    ${system_locator}[buildingAssets]
    多次点击进入    //p[text()="合约管理"]    //span[contains(text(),"新增合同")]    //span[contains(text(),"新建租赁合同")]    //label[text()="客户业态："]/../div/div/div/input    //span[text()='${basic_data}[客户业态]']    //label[text()="合同类型："]/../div/div/div/input    //span[text()='${basic_data}[合同类型]']    //label[text()="审批流程："]/../div/div/div/input    //span[text()='${basic_data}[审批流程]']
    点击元素    //span[contains(text(),"添加租赁房源")]
    添加房源
    #
    点击元素    //label[text()="租户名称"]/../div/div/div/span
    输入text    //label[text()="租户名称"]/../div/div/div[2]/div/div/input    ${business_data}[租户名称]
    多次点击进入    //div[contains(text(), "${business_data}[租户名称]")]    //span[contains(text(),"下一步")]    //label[contains(text(),"计费类型")]/../div/div/div[1]/input    //span[contains(text(),"按月计费")]
    Element Should Be Visible    //label[contains(text(),"天换算规则")]/..
    Close Browser
    [Teardown]    截屏套件

新增租赁合同--租赁条款计费类型--按实际天数计费
    &{basic_data}    Create Dictionary    客户业态=办公    跟进商务=    合同类型=孵化型租赁合同    来源人=    审批流程=不使用审批流程    抄送人=    中介经纪人=
    &{business_data}    Create Dictionary    租户名称=温州市罗微兰鞋业有限公司    行业分类=信息软件    联系人=叶阿英    联系电话=13857774758    联系邮箱=    服务平台=百应服务机构    法人=叶阿英    统一社会信用代码=91330302MA28762B5C
    Open Browser    ${演示环境}    chrome
    Maximize Browser Window
    登录    ${login_kongweixiong}[name]    ${login_kongweixiong}[passwd]
    进入子系统    ${system_locator}[buildingAssets]
    多次点击进入    //p[text()="合约管理"]    //span[contains(text(),"新增合同")]    //span[contains(text(),"新建租赁合同")]    //label[text()="客户业态："]/../div/div/div/input    //span[text()='${basic_data}[客户业态]']    //label[text()="合同类型："]/../div/div/div/input    //span[text()='${basic_data}[合同类型]']    //label[text()="审批流程："]/../div/div/div/input    //span[text()='${basic_data}[审批流程]']
    点击元素    //span[contains(text(),"添加租赁房源")]
    添加房源
    #
    点击元素    //label[text()="租户名称"]/../div/div/div/span
    输入text    //label[text()="租户名称"]/../div/div/div[2]/div/div/input    ${business_data}[租户名称]
    多次点击进入    //div[contains(text(), "${business_data}[租户名称]")]    //span[contains(text(),"下一步")]    //label[contains(text(),"计费类型")]/../div/div/div[1]/input    //span[contains(text(),"按实际天数计费")]
    Element Should Not Be Visible    //label[contains(text(),"天换算规则")]/..
    Close Browser
    [Teardown]    截屏套件

新增租赁合同--租赁租金计算--单位元/m2·月，单价0元
    &{basic_data}    Create Dictionary    客户业态=办公    跟进商务=    合同类型=孵化型租赁合同    来源人=    审批流程=不使用审批流程    抄送人=    中介经纪人=
    &{business_data}    Create Dictionary    租户名称=温州市罗微兰鞋业有限公司    行业分类=信息软件    联系人=叶阿英    联系电话=13857774758    联系邮箱=    服务平台=百应服务机构    法人=叶阿英    统一社会信用代码=91330302MA28762B5C
    Open Browser    ${演示环境}    chrome
    Maximize Browser Window
    登录    ${login_kongweixiong}[name]    ${login_kongweixiong}[passwd]
    进入子系统    ${system_locator}[buildingAssets]
    多次点击进入    //p[text()="合约管理"]    //span[contains(text(),"新增合同")]    //span[contains(text(),"新建租赁合同")]    //label[text()="客户业态："]/../div/div/div/input    //span[text()='${basic_data}[客户业态]']    //label[text()="合同类型："]/../div/div/div/input    //span[text()='${basic_data}[合同类型]']    //label[text()="审批流程："]/../div/div/div/input    //span[text()='${basic_data}[审批流程]']
    点击元素    //span[contains(text(),"添加租赁房源")]
    添加房源
    #
    点击元素    //label[text()="租户名称"]/../div/div/div/span
    ${input_area}    Set Variable    1.01
    输入text    //h3[contains(text(),"场地信息：")]/../div/div[1]/div[3]/table/tbody/tr/td[6]/div/div/input    ${input_area}
    点击元素    //span[contains(text(),"所选场地面积总和")]
    输入text    //label[text()="租户名称"]/../div/div/div[2]/div/div/input    ${business_data}[租户名称]
    ${util}    Set Variable    元/m²·月
    ${price}    Set Variable    0
    多次点击进入    //div[contains(text(), "${business_data}[租户名称]")]    //span[contains(text(),"下一步")]    //label[contains(text(),"合同单位")]/../div/div/div/input    //span[contains(text(),"${util}")]
    输入text    //label[contains(text(),"合同单价")]/../div/div/input    ${price}
    点击元素    //label[contains(text(),"合同单价")]
    ${year_cent}    计算年租金    ${input_area}    ${price}    ${util}
    ${month_cent}    计算月租金    ${input_area}    ${price}    ${util}
    @{actual_rent}    获取多个元素属性    //label[contains(text(),"年租金")]/../div/div/input    value    //label[contains(text(),"月租金")]/../div/div/input    value
    @{expect_rent}    Create List    ${year_cent}    ${month_cent}
    Should Be Equal    ${actual_rent}    ${expect_rent}
    Close Browser
    [Teardown]    截屏套件

新增租赁合同--租赁租金计算--单位元/m2·月，单价1元
    &{basic_data}    Create Dictionary    客户业态=办公    跟进商务=    合同类型=孵化型租赁合同    来源人=    审批流程=不使用审批流程    抄送人=    中介经纪人=
    &{business_data}    Create Dictionary    租户名称=温州市罗微兰鞋业有限公司    行业分类=信息软件    联系人=叶阿英    联系电话=13857774758    联系邮箱=    服务平台=百应服务机构    法人=叶阿英    统一社会信用代码=91330302MA28762B5C
    Open Browser    ${演示环境}    chrome
    Maximize Browser Window
    登录    ${login_kongweixiong}[name]    ${login_kongweixiong}[passwd]
    进入子系统    ${system_locator}[buildingAssets]
    多次点击进入    //p[text()="合约管理"]    //span[contains(text(),"新增合同")]    //span[contains(text(),"新建租赁合同")]    //label[text()="客户业态："]/../div/div/div/input    //span[text()='${basic_data}[客户业态]']    //label[text()="合同类型："]/../div/div/div/input    //span[text()='${basic_data}[合同类型]']    //label[text()="审批流程："]/../div/div/div/input    //span[text()='${basic_data}[审批流程]']
    点击元素    //span[contains(text(),"添加租赁房源")]
    添加房源
    #
    点击元素    //label[text()="租户名称"]/../div/div/div/span
    ${input_area}    Set Variable    1.01
    输入text    //h3[contains(text(),"场地信息：")]/../div/div[1]/div[3]/table/tbody/tr/td[6]/div/div/input    ${input_area}
    点击元素    //span[contains(text(),"所选场地面积总和")]
    输入text    //label[text()="租户名称"]/../div/div/div[2]/div/div/input    ${business_data}[租户名称]
    ${util}    Set Variable    元/m²·月
    ${price}    Set Variable    1
    多次点击进入    //div[contains(text(), "${business_data}[租户名称]")]    //span[contains(text(),"下一步")]    //label[contains(text(),"合同单位")]/../div/div/div/input    //span[contains(text(),"${util}")]
    输入text    //label[contains(text(),"合同单价")]/../div/div/input    ${price}
    点击元素    //label[contains(text(),"合同单价")]
    ${year_cent}    计算年租金    ${input_area}    ${price}    ${util}
    ${month_cent}    计算月租金    ${input_area}    ${price}    ${util}
    @{actual_rent}    获取多个元素属性    //label[contains(text(),"年租金")]/../div/div/input    value    //label[contains(text(),"月租金")]/../div/div/input    value
    @{expect_rent}    Create List    ${year_cent}    ${month_cent}
    Should Be Equal    ${actual_rent}    ${expect_rent}
    Close Browser
    [Teardown]    截屏套件

新增租赁合同--租赁租金计算--单位元/m2·天，单价1元
    &{basic_data}    Create Dictionary    客户业态=办公    跟进商务=    合同类型=孵化型租赁合同    来源人=    审批流程=不使用审批流程    抄送人=    中介经纪人=
    &{business_data}    Create Dictionary    租户名称=温州市罗微兰鞋业有限公司    行业分类=信息软件    联系人=叶阿英    联系电话=13857774758    联系邮箱=    服务平台=百应服务机构    法人=叶阿英    统一社会信用代码=91330302MA28762B5C
    Open Browser    ${演示环境}    chrome
    Maximize Browser Window
    登录    ${login_kongweixiong}[name]    ${login_kongweixiong}[passwd]
    进入子系统    ${system_locator}[buildingAssets]
    多次点击进入    //p[text()="合约管理"]    //span[contains(text(),"新增合同")]    //span[contains(text(),"新建租赁合同")]    //label[text()="客户业态："]/../div/div/div/input    //span[text()='${basic_data}[客户业态]']    //label[text()="合同类型："]/../div/div/div/input    //span[text()='${basic_data}[合同类型]']    //label[text()="审批流程："]/../div/div/div/input    //span[text()='${basic_data}[审批流程]']
    点击元素    //span[contains(text(),"添加租赁房源")]
    添加房源
    #
    点击元素    //label[text()="租户名称"]/../div/div/div/span
    ${input_area}    Set Variable    1.01
    输入text    //h3[contains(text(),"场地信息：")]/../div/div[1]/div[3]/table/tbody/tr/td[6]/div/div/input    ${input_area}
    点击元素    //span[contains(text(),"所选场地面积总和")]
    输入text    //label[text()="租户名称"]/../div/div/div[2]/div/div/input    ${business_data}[租户名称]
    ${util}    Set Variable    元/m²·天
    ${price}    Set Variable    1
    多次点击进入    //div[contains(text(), "${business_data}[租户名称]")]    //span[contains(text(),"下一步")]    //label[contains(text(),"合同单位")]/../div/div/div/input    //span[contains(text(),"${util}")]
    输入text    //label[contains(text(),"合同单价")]/../div/div/input    ${price}
    点击元素    //label[contains(text(),"合同单价")]
    ${year_cent}    计算年租金    ${input_area}    ${price}    ${util}
    ${month_cent}    计算月租金    ${input_area}    ${price}    ${util}
    @{actual_rent}    获取多个元素属性    //label[contains(text(),"年租金")]/../div/div/input    value    //label[contains(text(),"月租金")]/../div/div/input    value
    @{expect_rent}    Create List    ${year_cent}    ${month_cent}
    Should Be Equal    ${actual_rent}    ${expect_rent}
    Close Browser
    [Teardown]    截屏套件

新增租赁合同--租赁合同账单预览--正常
    &{basic_data}    Create Dictionary    客户业态=办公    跟进商务=    合同类型=孵化型租赁合同    来源人=    审批流程=不使用审批流程    抄送人=    中介经纪人=
    &{business_data}    Create Dictionary    租户名称=温州市罗微兰鞋业有限公司    行业分类=信息软件    联系人=叶阿英    联系电话=13857774758    联系邮箱=    服务平台=百应服务机构    法人=叶阿英    统一社会信用代码=91330302MA28762B5C
    ${util}    Set Variable    元/m²·天
    ${price}    Set Variable    1
    ${input_area}    Set Variable    1.01
    &{cent_data}    Create Dictionary    签订时间=2040-02-01    计租时间=2040-02-01    结束时间=2041-01-31    支付周期划分=按起始日划分    支付周期=4    收款日=15    提前收租=1    计费类型=按月计费    天换算规则=按年换算    押金收款日=2040-02-01    押金金额=10001
    Open Browser    ${演示环境}    chrome
    Maximize Browser Window
    登录    ${login_kongweixiong}[name]    ${login_kongweixiong}[passwd]
    进入子系统    ${system_locator}[buildingAssets]
    多次点击进入    //p[text()="合约管理"]    //span[contains(text(),"新增合同")]    //span[contains(text(),"新建租赁合同")]    //label[text()="客户业态："]/../div/div/div/input    //span[text()='${basic_data}[客户业态]']    //label[text()="合同类型："]/../div/div/div/input    //span[text()='${basic_data}[合同类型]']    //label[text()="审批流程："]/../div/div/div/input    //span[text()='${basic_data}[审批流程]']
    点击元素    //span[contains(text(),"添加租赁房源")]
    添加房源
    #
    点击元素    //label[text()="租户名称"]/../div/div/div/span
    输入text    //h3[contains(text(),"场地信息：")]/../div/div[1]/div[3]/table/tbody/tr/td[6]/div/div/input    ${input_area}
    点击元素    //span[contains(text(),"所选场地面积总和")]
    输入text    //label[text()="租户名称"]/../div/div/div[2]/div/div/input    ${business_data}[租户名称]
    多次点击进入    //div[contains(text(), "${business_data}[租户名称]")]    //span[contains(text(),"下一步")]
    sleep    3
    输入text    //label[contains(text(),"签订时间")]/../div/div/input    ${cent_data}[签订时间]    #${cent_data}    ${cent_data}
    输入text    //label[contains(text(),"计租时间")]/../div/div/input    ${cent_data}[计租时间]
    输入text    //label[contains(text(),"结束时间")]/../div/div/input    ${cent_data}[结束时间]
    输入text    //label[contains(text(),"支付周期")]/../div/div/input    ${cent_data}[支付周期]
    输入text    //label[contains(text(),"收款日")]/../div/div/input    ${cent_data}[收款日]
    输入text    //label[contains(text(),"提前收租")]/../div/div/input    ${cent_data}[提前收租]
    输入text    //label[contains(text(),"押金收款日")]/../div/div/input    ${cent_data}[押金收款日]
    输入text    //label[contains(text(),"押金金额")]/../div/div/input    ${cent_data}[押金金额]
    多次点击进入    //label[contains(text(),"合同单位")]/../div/div/div/input    //span[contains(text(),"${util}")]    //label[contains(text(),"支付周期划分")]/../div/div/div/input    //span[contains(text(),"${cent_data}[支付周期划分]")]    //label[contains(text(),"计费类型")]/../div/div/div/input    //span[contains(text(),"${cent_data}[计费类型]")]    //label[contains(text(),"天换算规则")]/../div/div/div/input    //span[contains(text(),"${cent_data}[天换算规则]")]
    输入text    //label[contains(text(),"合同单价")]/../div/div/input    ${price}
    点击元素    //label[contains(text(),"合同单价")]
    点击元素    //span[contains(text(),"合同账单预览")]
    ${actual_bill}    获取元素text值    //span[contains(text(),"合同账单明细")]/../../div[2]/div/div[1]/div[2]/div[3]/table/tbody
    ${expect_bill}    Set Variable    2040-02-01~2041-01-31\n2040-02-01\n租赁押金\n-\n10001元\n2040-02-01~2040-05-31\n2040-02-01\n租金\n1元/m²·天\n122.88元\n2040-06-01~2040-09-30\n2040-06-14\n租金\n1元/m²·天\n122.88元\n2040-10-01~2041-01-31\n2040-10-14\n租金\n1元/m²·天\n122.88元
    Should Be Equal    ${actual_bill}    ${expect_bill}
    Close Browser
    [Teardown]    截屏套件

新增租赁合同--物业合同账单预览--正常
    &{basic_data}    Create Dictionary    客户业态=办公    跟进商务=    合同类型=孵化型租赁合同    来源人=    审批流程=不使用审批流程    抄送人=    中介经纪人=
    &{business_data}    Create Dictionary    租户名称=温州市罗微兰鞋业有限公司    行业分类=信息软件    联系人=叶阿英    联系电话=13857774758    联系邮箱=    服务平台=百应服务机构    法人=叶阿英    统一社会信用代码=91330302MA28762B5C
    ${cent_util}    Set Variable    元/m²·天
    ${cent_price}    Set Variable    1
    ${pm_util}    Set Variable    元/m²·月
    ${pm_price}    Set Variable    30
    ${input_area}    Set Variable    1.01
    &{cent_data}    Create Dictionary    签订时间=2040-02-01    计租时间=2040-02-01    结束时间=2041-01-31    支付周期划分=按起始日划分    支付周期=4    收款日=15    提前收租=1    计费类型=按月计费    天换算规则=按年换算    押金收款日=2040-02-01    押金金额=10001
    &{pm_data}    Create Dictionary    签订时间=2040-03-01    计租时间=2040-03-01    支付周期划分=按起始日划分    支付周期=4    收款日=10    提前收租=1    计费类型=按月计费    天换算规则=按年换算    押金收款日=2040-03-01    押金金额=10001
    Open Browser    ${演示环境}    chrome
    Maximize Browser Window
    登录    ${login_kongweixiong}[name]    ${login_kongweixiong}[passwd]
    进入子系统    ${system_locator}[buildingAssets]
    多次点击进入    //p[text()="合约管理"]    //span[contains(text(),"新增合同")]    //span[contains(text(),"新建租赁合同")]    //label[text()="客户业态："]/../div/div/div/input    //span[text()='${basic_data}[客户业态]']    //label[text()="合同类型："]/../div/div/div/input    //span[text()='${basic_data}[合同类型]']    //label[text()="审批流程："]/../div/div/div/input    //span[text()='${basic_data}[审批流程]']
    点击元素    //span[contains(text(),"添加租赁房源")]
    添加房源
    #
    点击元素    //label[text()="租户名称"]/../div/div/div/span
    输入text    //h3[contains(text(),"场地信息：")]/../div/div[1]/div[3]/table/tbody/tr/td[6]/div/div/input    ${input_area}
    点击元素    //span[contains(text(),"所选场地面积总和")]
    输入text    //label[text()="租户名称"]/../div/div/div[2]/div/div/input    ${business_data}[租户名称]
    多次点击进入    //div[contains(text(), "${business_data}[租户名称]")]    //span[contains(text(),"下一步")]
    sleep    3
    输入text    //label[contains(text(),"签订时间")]/../div/div/input    ${cent_data}[签订时间]    #${cent_data}    ${cent_data}
    输入text    //label[contains(text(),"计租时间")]/../div/div/input    ${cent_data}[计租时间]
    输入text    //label[contains(text(),"结束时间")]/../div/div/input    ${cent_data}[结束时间]
    输入text    //label[contains(text(),"支付周期")]/../div/div/input    ${cent_data}[支付周期]
    输入text    //label[contains(text(),"收款日")]/../div/div/input    ${cent_data}[收款日]
    输入text    //label[contains(text(),"提前收租")]/../div/div/input    ${cent_data}[提前收租]
    输入text    //label[contains(text(),"押金收款日")]/../div/div/input    ${cent_data}[押金收款日]
    输入text    //label[contains(text(),"押金金额")]/../div/div/input    ${cent_data}[押金金额]
    多次点击进入    //label[contains(text(),"合同单位")]/../div/div/div/input    //span[contains(text(),"${cent_util}")]    //label[contains(text(),"支付周期划分")]/../div/div/div/input    //span[contains(text(),"${cent_data}[支付周期划分]")]    //label[contains(text(),"计费类型")]/../div/div/div/input    //span[contains(text(),"${cent_data}[计费类型]")]    //label[contains(text(),"天换算规则")]/../div/div/div/input    //span[contains(text(),"${cent_data}[天换算规则]")]
    输入text    //label[contains(text(),"合同单价")]/../div/div/input    ${cent_price}
    点击元素    //label[contains(text(),"合同单价")]
    点击元素    //span[contains(text(),"下一步")]
    sleep    3
    #
    输入text    //label[contains(text(),"签订时间")]/../div/div/input    ${pm_data}[签订时间]    #${cent_data}    ${cent_data}
    输入text    //label[contains(text(),"计租时间")]/../div/div/input    ${pm_data}[计租时间]
    输入text    //label[contains(text(),"支付周期")]/../div/div/input    ${pm_data}[支付周期]
    输入text    //label[contains(text(),"收款日")]/../div/div/input    ${pm_data}[收款日]
    输入text    //label[contains(text(),"提前收租")]/../div/div/input    ${pm_data}[提前收租]
    输入text    //label[contains(text(),"押金收款日")]/../div/div/input    ${pm_data}[押金收款日]
    输入text    //label[contains(text(),"押金金额")]/../div/div/input    ${pm_data}[押金金额]
    多次点击进入    //label[contains(text(),"合同单位")]/../div/div/div/input    //span[contains(text(),"${pm_util}")]    //label[contains(text(),"支付周期划分")]/../div/div/div/input    //span[contains(text(),"${pm_data}[支付周期划分]")]    //label[contains(text(),"计费类型")]/../div/div/div/input    //span[contains(text(),"${pm_data}[计费类型]")]    //label[contains(text(),"天换算规则")]/../div/div/div/input    //span[contains(text(),"${pm_data}[天换算规则]")]
    输入text    //label[contains(text(),"合同单价")]/../div/div/input    ${pm_price}
    点击元素    //label[contains(text(),"合同单价")]
    点击元素    //span[contains(text(),"合同账单预览")]
    ${actual_pm_bill}    获取元素text值    //span[contains(text(),"合同账单明细")]/../../div[2]/div/div[1]/div[2]/div[3]/table/tbody
    ${expect_pm_bill}    Set Variable    2040-03-01~2041-01-31\n2040-03-01\n物业押金\n-\n10001元\n2040-03-01~2040-06-30\n2040-03-01\n物业费\n30元/m²·月\n121.2元\n2040-07-01~2040-10-31\n2040-07-09\n物业费\n30元/m²·月\n121.2元\n2040-11-01~2041-01-31\n2040-11-09\n物业费\n30元/m²·月\n90.9元
    Should Be Equal    ${actual_pm_bill}    ${expect_pm_bill}
    Close Browser
    [Teardown]    截屏套件

新增租赁合同--全流程
    &{basic_data}    Create Dictionary    客户业态=办公    跟进商务=    合同类型=孵化型租赁合同    来源人=    审批流程=不使用审批流程    抄送人=    中介经纪人=
    &{business_data}    Create Dictionary    租户名称=温州市罗微兰鞋业有限公司    行业分类=信息软件    联系人=叶阿英    联系电话=13857774758    联系邮箱=    服务平台=百应服务机构    法人=叶阿英    统一社会信用代码=91330302MA28762B5C
    ${cent_util}    Set Variable    元/m²·天
    ${cent_price}    Set Variable    1
    ${pm_util}    Set Variable    元/m²·月
    ${pm_price}    Set Variable    30
    ${input_area}    Set Variable    1.01
    &{cent_data}    Create Dictionary    签订时间=2040-02-01    计租时间=2040-02-01    结束时间=2041-01-31    支付周期划分=按起始日划分    支付周期=4    收款日=15    提前收租=1    计费类型=按月计费    天换算规则=按年换算    押金收款日=2040-02-01    押金金额=10001
    &{pm_data}    Create Dictionary    签订时间=2040-03-01    计租时间=2040-03-01    支付周期划分=按起始日划分    支付周期=4    收款日=10    提前收租=1    计费类型=按月计费    天换算规则=按年换算    押金收款日=2040-03-01    押金金额=10001
    Open Browser    ${演示环境}    chrome
    Maximize Browser Window
    登录    ${login_kongweixiong}[name]    ${login_kongweixiong}[passwd]
    进入子系统    ${system_locator}[buildingAssets]
    #
    多次点击进入    //p[text()="合约管理"]    //span[contains(text(),"新增合同")]    //span[contains(text(),"新建租赁合同")]    //label[text()="客户业态："]/../div/div/div/input    //span[text()='${basic_data}[客户业态]']    //label[text()="合同类型："]/../div/div/div/input    //span[text()='${basic_data}[合同类型]']    //label[text()="审批流程："]/../div/div/div/input    //span[text()='${basic_data}[审批流程]']
    ${contract_num}    获取元素属性    //label[contains(text(),"合同编号")]/../div/div/input    value
    点击元素    //span[contains(text(),"添加租赁房源")]
    添加房源
    #
    点击元素    //label[text()="租户名称"]/../div/div/div/span
    输入text    //h3[contains(text(),"场地信息：")]/../div/div[1]/div[3]/table/tbody/tr/td[6]/div/div/input    ${input_area}
    点击元素    //span[contains(text(),"所选场地面积总和")]
    输入text    //label[text()="租户名称"]/../div/div/div[2]/div/div/input    ${business_data}[租户名称]
    多次点击进入    //div[contains(text(), "${business_data}[租户名称]")]    //span[contains(text(),"下一步")]
    sleep    3
    #
    输入text    //label[contains(text(),"签订时间")]/../div/div/input    ${cent_data}[签订时间]    #${cent_data}    ${cent_data}
    输入text    //label[contains(text(),"计租时间")]/../div/div/input    ${cent_data}[计租时间]
    输入text    //label[contains(text(),"结束时间")]/../div/div/input    ${cent_data}[结束时间]
    输入text    //label[contains(text(),"支付周期")]/../div/div/input    ${cent_data}[支付周期]
    输入text    //label[contains(text(),"收款日")]/../div/div/input    ${cent_data}[收款日]
    输入text    //label[contains(text(),"提前收租")]/../div/div/input    ${cent_data}[提前收租]
    输入text    //label[contains(text(),"押金收款日")]/../div/div/input    ${cent_data}[押金收款日]
    输入text    //label[contains(text(),"押金金额")]/../div/div/input    ${cent_data}[押金金额]
    多次点击进入    //label[contains(text(),"合同单位")]/../div/div/div/input    //span[contains(text(),"${cent_util}")]    //label[contains(text(),"支付周期划分")]/../div/div/div/input    //span[contains(text(),"${cent_data}[支付周期划分]")]    //label[contains(text(),"计费类型")]/../div/div/div/input    //span[contains(text(),"${cent_data}[计费类型]")]    //label[contains(text(),"天换算规则")]/../div/div/div/input    //span[contains(text(),"${cent_data}[天换算规则]")]
    输入text    //label[contains(text(),"合同单价")]/../div/div/input    ${cent_price}
    点击元素    //label[contains(text(),"合同单价")]
    点击元素    //span[contains(text(),"下一步")]
    sleep    3
    #
    输入text    //label[contains(text(),"签订时间")]/../div/div/input    ${pm_data}[签订时间]    #${cent_data}    ${cent_data}
    输入text    //label[contains(text(),"计租时间")]/../div/div/input    ${pm_data}[计租时间]
    输入text    //label[contains(text(),"支付周期")]/../div/div/input    ${pm_data}[支付周期]
    输入text    //label[contains(text(),"收款日")]/../div/div/input    ${pm_data}[收款日]
    输入text    //label[contains(text(),"提前收租")]/../div/div/input    ${pm_data}[提前收租]
    输入text    //label[contains(text(),"押金收款日")]/../div/div/input    ${pm_data}[押金收款日]
    输入text    //label[contains(text(),"押金金额")]/../div/div/input    ${pm_data}[押金金额]
    多次点击进入    //label[contains(text(),"合同单位")]/../div/div/div/input    //span[contains(text(),"${pm_util}")]    //label[contains(text(),"支付周期划分")]/../div/div/div/input    //span[contains(text(),"${pm_data}[支付周期划分]")]    //label[contains(text(),"计费类型")]/../div/div/div/input    //span[contains(text(),"${pm_data}[计费类型]")]    //label[contains(text(),"天换算规则")]/../div/div/div/input    //span[contains(text(),"${pm_data}[天换算规则]")]
    输入text    //label[contains(text(),"合同单价")]/../div/div/input    ${pm_price}
    点击元素    //label[contains(text(),"合同单价")]
    点击元素    //span[contains(text(),"提交审批")]
    点击元素    //a[contains(text(),"电子合同预览")]/../label/span[2]
    点击元素    //a[contains(text(),"合同账单明细")]/../label/span[2]
    点击元素    //span[contains(text(),"完成并生成合同")]
    sleep    15
    #
    合同作废    租赁合同    ${contract_num}
    Close Browser
    [Teardown]    截屏套件

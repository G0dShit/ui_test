*** Settings ***
Library           Selenium2Library
Resource          ../参数/resource.robot

*** Test Cases ***
登录园区
    [Setup]
    Open Browser    ${演示环境}    chrome
    Maximize Browser Window
    登录    ${login_kongweixiong}[name]    ${login_kongweixiong}[passwd]
    @{texts}    获取多个text值    //*[@id="index"]/div[1]/div[1]/div/p[1]/span[1]    //*[@id="index"]/div[1]/div[1]/div/p[1]/span[2]
    校验方法Equal    @{texts}    ${login_kongweixiong}[realName]    ${login_kongweixiong}[role]
    Close Browser
    [Teardown]    截屏套件

进入资产管理
    Open Browser    ${演示环境}    chrome
    Maximize Browser Window
    登录    ${login_kongweixiong}[name]    ${login_kongweixiong}[passwd]
    进入子系统    ${system_locator}[buildingAssets]
    @{texts}    获取多个text值    //*[@id="app"]/section/section/header/ul[1]/li[1]/p    //*[@id="app"]/section/section/header/ul[1]/li[2]/p
    校验方法Equal    @{texts}    片区资产管理    合约管理
    Close Browser
    [Teardown]    截屏套件

test
    ${数量}    evaluate    int("3")
    FOR    ${i}    IN RANGE    10
        ${数量}    Run Keyword If    ${i} == 0    log    b
        ...    ELSE IF    ${i} > 0    Run Keywords    log    a
        ...    AND    evaluate    ${数量} - ${i}
    ${EMPTY}
        log    "${数量}"
        Exit For Loop If    ${i} > 0
    END

新增孵化合同
    &{data01}    Create Dictionary    业态=办公    跟进商务=    合同类型=测试字段模板    来源人=孔维雄    审批流程=不使用审批流程    抄送人=孔维雄    中介经纪人=    租户名称=小米科技有限责任公司
    &{data02}    Create Dictionary    行业分类=农业    联系人=雷军    联系电话=18846076078，18845793654    联系邮箱=chenchongwei@xiaomi.com    服务平台=中伍
    Open Browser    http://test-xw-channel.test176.cn/#/newLogin    chrome
    Maximize Browser Window
    登录    ${login_kongweixiong}[name]    ${login_kongweixiong}[passwd]
    进入子系统    ${system_locator}[buildingAssets]
    多次点击进入    //p[text()="合约管理"]    //span[contains(text(),"新增合同")]    //span[contains(text(),"新建孵化合同")]
    sleep    2
    输入text    //label[contains(text(),"合同编号：")]/../div/div/input    自动化测试01
    输入text    //label[contains(text(),"项目名称：")]/../div/div/input    自动化测试01
    点击元素    //span[contains(text(),"已入驻")]
    sleep    1
    点击元素    //span[text()="+ 添加租赁房源"]    #点击添加租赁房源
    ${buildingName}    获取元素text值    //div[contains(text(),"所选场地面积：")]/../div[2]/div[1]/div[1]/div/div[1]/div/h3
    点击元素    //div[contains(text(),"所选场地面积：")]/../div[2]/div[1]/div[1]/div/div[1]/div/h3
    @{texts_expect}    获取多个text值    //p[contains(text(),"场地类型：")]/../../div[3]/div[2]/label/span[2]/span[1]    //p[contains(text(),"场地类型：")]/../../div[3]/div[2]/label/span[2]/span[2]    //p[contains(text(),"场地类型：")]/../../div[3]/div[2]/label/span[2]/span[4]    //p[contains(text(),"场地类型：")]/../../div[3]/div[2]/label/span[2]/span[3]    #    //*[@id="page-wrapper"]/div[3]/div[3]/div/div[2]/div/div[1]/div[2]/div[1]/div[1]/div[2]/div[3]/div[1]/label/span[2]/span[1]    //*[@id="page-wrapper"]/div[3]/div[3]/div/div[2]/div/div[1]/div[2]/div[1]/div[1]/div[2]/div[3]/div[1]/label/span[2]/span[2]    //*[@id="page-wrapper"]/div[3]/div[3]/div/div[2]/div/div[1]/div[2]/div[1]/div[1]/div[2]/div[3]/div[2]/label/span[2]/span[4]    //*[@id="page-wrapper"]/div[3]/div[3]/div/div[2]/div/div[1]/div[2]/div[1]/div[1]/div[2]/div[3]/div[1]/label/span[2]/span[3]    #获取期望值
    点击元素    //p[contains(text(),"场地类型：")]/../../div[3]/div[2]/label/span[1]/span
    点击元素    //span[contains(text(),"完成")]
    @{texts_actual}    获取多个text值    //h3[contains(text(),"场地信息：")]/../div/div[1]/div[3]/table/tbody/tr/td[1]/div    //h3[contains(text(),"场地信息：")]/../div/div[1]/div[3]/table/tbody/tr/td[2]/div    //h3[contains(text(),"场地信息：")]/../div/div[1]/div[3]/table/tbody/tr/td[3]/div    //h3[contains(text(),"场地信息：")]/../div/div[1]/div[3]/table/tbody/tr/td[4]/div    //h3[contains(text(),"场地信息：")]/../div/div[1]/div[3]/table/tbody/tr/td[5]/div/span
    ${attribute}    获取元素属性    //h3[contains(text(),"场地信息：")]/../div/div[1]/div[3]/table/tbody/tr/td[6]/div/div/input    value
    ${text01}    获取元素text值    //span[contains(text(),"所选场地面积总和")]
    Append To List    ${texts_actual}    ${attribute}    ${text01}    #组装实际值
    @{texts_expect}    Create List    ${buildingName}    @{texts_expect}    #组装期望值
    Append To List    ${texts_expect}    ${texts_expect}[4][:-1](m²)    ${texts_expect}[4][:-1]    所选场地面积总和：${texts_expect}[4][:-1]㎡    #组装期望值
    Remove From List    ${texts_expect}    4
    Comment    校验方法Equal    @{texts_actual}    @{texts_expect}    #暂不校验
    点击元素    //label[text()="租户名称"]/../div/div/div/span    #点击输入租户
    sleep    2
    输入text    //label[text()="租户名称"]/../div/div/div[2]/div/div/input    ${data01}[租户名称]
    点击元素    //div[contains(text(), "${data01}[租户名称]")]    #选择租户
    sleep    2
    @{tenant_data}    获取多个元素属性    //label[text()="租户名称"]/../div/div/div/input    value    //label[text()="行业分类："]/../div/div/div/input    value    //label[text()="联系人："]/../div/div/input    value    //label[text()="联系电话："]/../div/div/input    value    //label[text()="联系邮箱："]/../div/div/input    value    //label[text()="服务平台："]/../div/div/input    value
    @{business_information}    获取多个元素属性    //span[text()="法人："]/../div/div/input    value    //span[text()="统一社会信用代码："]/../div/div/input    value
    #获取租户信息
    点击元素    //span[contains(text(),"下一步")]    #点击下一步
    输入text    //p[contains(text(),"孵化优惠政策条款：")]/../div/textarea    自动化测试01
    &{data03}    Create Dictionary    租赁工位=1    签订时间=2022-01-10    合同开始时间=2022-01-10    合同结束时间=2023-01-09    支付周期划分=按起始日划分    支付周期=4    收款日=25    提前收租=5    计费类型=按实际天数计费    首期收款日=2022-01-10
    &{data04}    Create Dictionary    押金收款日=2022-01-10    押金金额=500
    &{data05}    Create Dictionary    合同单价=1
    &{data06}    Create Dictionary    合同单价=1
    sleep    2
    输入text    //h3[contains(text(),"场地租期条款")]/../form[2]/div/div[1]/div/div/div/input    1
    输入text    //h3[contains(text(),"物业费条款")]/../form[3]/div/div[1]/div/div/div/input    1
    点击元素    //span[contains(text(),"提交审批")]
    点击元素    //span[contains(text(),"我已核对")]
    点击元素    //span[contains(text(),"我已查看")]
    点击元素    //span[contains(text(),"完成并生成合同")]
    [Teardown]    截屏套件

*** Settings ***
Documentation     导入所有资源，各testSuite仅需resource此文件
Resource          登录用户参数.robot
Resource          数据库参数.robot
Resource          子系统参数.robot
Resource          ../公共方法/公共方法.robot
Library           Selenium2Library
Resource          ../流程/常用流程.robot
Resource          登录路径参数.robot
Library           Collections

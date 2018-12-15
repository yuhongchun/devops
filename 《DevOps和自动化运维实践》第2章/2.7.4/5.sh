#!/bin/bash
function update_rules() {
#使用是内部SVN服务器，所以这里帐号和密码明文，没有考虑太多安全带来的问题
svn co svn://192.168.10.68/route_auto /tmp/route_auto --username=testyum --password=oTIil31pw --force --no-auth-cache

if [ $? -eq 0 ]; then
    echo "[INFO]: 获取最新 rules 成功,检测下载的 rules 库文件是否为空..."
    if !(test -s $LOCAL_TMP_RULES); then
        echo "获取到的最新 rules 库文件为空,请检查远端 rules 库文件!!"
        exit 1
    else
    cp -rf $LOCAL_TMP_RULES $RULES_ENV_FILE
    cp -rf $LOCAL_TMP_RULES $TMPFILES
    echo "获取到的最新 rules 库文件非空,程序继续..."
    fi

    echo "[INFO]: 将最新 rules 库文件与本地 rules 库文件比对是否有差异..."
    if ! (diff $RULES_ENV_FILE $LOCAL_TMP_RULES &>/dev/null); then
        echo "有差异 rules,加载最新 rules 库配置..."
        . $LOCAL_TMP_RULES
        cp -rf $LOCAL_TMP_RULES $RULES_ENV_FILE
    else
        echo "无差异 rules,加载本地 rules 库配置..."
        . $RULES_ENV_FILE
    fi
fi
}
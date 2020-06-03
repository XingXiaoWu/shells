#!/bin/zsh

# 判断有没有安装brew
function brewinstall(){
  echo "判断brew是否安装"
  # brew的安装,在mac上只会安装到/usr/local
  # 判断bin目录下是否有brew软连接即可
  if [ -f "/usr/local/bin/brew" ];then
    echo "brew已经安装"
  else
    echo "brew未安装,安装brew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
  fi
#   
}
# 通过homebrew软连接路径/usr/local/var/homebrew/linked
# 判断有没有安装cocoapods
function podinstall(){
    echo "判断有没有安装cocoapods"
    if [ -f "/usr/local/bin/pod" ];then
        echo "pod已安装"
    else
        echo "pod未安装"
        brew install cocoapods
    fi
}
# 设置ruby源
function rubysource(){
    echo "移除ruby官方源"
    gem sources --remove https://rubygems.org/
    echo "添加ruby-china"
    gem source -a https://gems.ruby-china.com
    echo "当前源如下"
    gem sources -l
}
# 安装nvm
function nvminstall(){
    echo "安装nvm"
    # 判断是否已经安装nvm
    if [ -d "/usr/local/opt/nvm/" ];then
        echo "nvm已安装"
    else
        echo "nvm未安装"
        brew reinstall nvm
        echo "写入环境变量"
        sed -i "" '$a\
        # nvm\
        export NVM_DIR="$HOME/.nvm"\
        [ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm\
        [ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
        ' $SHELL_PROFILE
    fi
   
}
# 安装nrm
function nrminstall(){
    echo "全局安装nrm"
    npm install nrm -g
    echo "默认淘宝源"
    nrm use taobao
}
# 判断当前shell
function shellEcho(){
    if [[ "$SHELL" == "/bin/zsh" ]];then
        echo "当前环境为zsh环境"
        SHELL_PROFILE=~/.zshrc
    else
        echo "当前环境为bash环境"
        echo "请先设置环境为zsh环境,命令如下"
        echo "chsh -s /bin/zsh"
        echo "执行完毕后请重启终端窗口"
        exit
        SHELL_PROFILE=~/.bash_profile
    fi
}


shellEcho
echo $SHELL_PROFILE
brewinstall
podinstall
rubysource
# 判断是否安装node环境
read "installNode?是否安装node环境?yes/no:"
# read -p "是否安装node环境?yes/no:" installNode
echo $installNode
if [[ "$installNode" == "yes" ]];then
    echo "安装node环境"
    nvminstall
    source /usr/local/opt/nvm/nvm.sh
    echo "安装node v12.16.3"
    nvm install v12.16.3
    echo "设置12.16.3为默认node环境"
    nvm alias default v12.16.3
    nrminstall
else
    echo "不安装"
fi

source $SHELL_PROFILE
echo "安装完毕,请重启终端"
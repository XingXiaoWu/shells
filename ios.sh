#!/bin/zsh

# 判断有没有安装brew
function brewinstall() {
    echo "判断brew是否安装"
    # brew的安装,在mac上只会安装到/usr/local
    # 判断bin目录下是否有brew软连接即可
    if [ -f "/usr/local/bin/brew" ]; then
        echo "brew已经安装"
    else
        echo "brew未安装,安装brew"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
        sed -i "" '$a\
        export HOMEBREW_NO_AUTO_UPDATE=true
        ' $SHELL_PROFILE
        
    fi
}
# 通过homebrew软连接路径/usr/local/var/homebrew/linked
# 判断有没有安装cocoapods
function podinstall() {
    echo "判断有没有安装cocoapods"
    if [ -f "/usr/local/bin/pod" ]; then
        echo "pod已安装"
    else
        echo "pod未安装"
        brew install cocoapods
    fi
}
# 设置ruby源
function rubysource() {
    echo "移除ruby官方源"
    gem sources --remove https://rubygems.org/
    echo "添加ruby-china"
    gem source -a https://gems.ruby-china.com
    echo "当前源如下"
    gem sources -l
}
# 安装nvm
function nvminstall() {
    echo "安装nvm"
    # 判断是否已经安装nvm
    if [ -d "/usr/local/opt/nvm/" ]; then
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
    source /usr/local/opt/nvm/nvm.sh
    echo "安装node v12.16.3"
    nvm install v12.16.3
    echo "设置12.16.3为默认node环境"
    nvm alias default v12.16.3
}
# 安装nrm
function nrminstall() {
    echo "全局安装nrm"
    npm install nrm -g
    echo "默认私服源"
    nrm add szyx-pull http://nexus.51trust.com/repository/npm-group/
    nrm add szyx-push http://nexus.51trust.com/repository/npm-hosted/
    nrm use szyx-pull
}
function watchmanInstall() {
    brew install watchman
}
# 判断当前shell
function shellEcho() {
    if [[ "$SHELL" == "/bin/zsh" ]]; then
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
#------------------环境区分--------------------#
# 安装iOS 环境
function iosInstall() {
    echo "ios需要安装cocoapods"
    podinstall
}
# 安装rn环境
function reactnativeInstall() {
    echo "1.安装cocoapods"
    podinstall
    echo "2.安装node"
    nvminstall
    echo "3.安装nrm源管理工具"
    nrminstall
    echo "4.安装watchman"
    watchmanInstall
    echo "iOS所需环境安装完毕,Android请自行下载Android Studio翻墙安装Android环境"
    echo "安装完成,使用npx react-native init AwesomeProject即可创建新项目"
}

# 安装flutter环境
function flutterInstall() {
    echo "1.设置国内源"
    sed -i "" '$a\
        # flutter\
        export PUB_HOSTED_URL=https://pub.flutter-io.cn\
        export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn
        ' $SHELL_PROFILE
    source $SHELL_PROFILE
    echo "2.拉取flutter"
    mkdir Documents/flutterEnvironment
    cd ~/Documents/flutterEnvironment
    pwd
    git clone -b beta https://github.com/flutter/flutter.git
    cd ~
    echo "3.环境变量"
    sed -i "" '$a\
        export PATH=$HOME/Documents/flutterEnvironment/flutter/bin:$PATH
        ' $SHELL_PROFILE
    source $SHELL_PROFILE
    echo "4.brew安装flutter需要的东西"
    brew install --HEAD usbmuxd
    brew link usbmuxd
    brew install --HEAD libimobiledevice
    brew install ideviceinstaller
    brew install ios=deploy
    podinstall
    flutter doctor
    echo "iOS所需环境安装完毕,Android请自行下载Android Studio翻墙安装Android环境"
    echo "请根据flutter doctor的输出结果检查还有什么不对的地方"

}
# 安装vue环境
function vueInstall() {
    echo "1.安装node"
    nvminstall
    echo "2.安装nrm源管理工具"
    nrminstall
    echo "3.安装vue脚手架工具"
    npm install -g @vue/cli
    echo "vue安装完成"
}

shellEcho
echo $SHELL_PROFILE
brewinstall
rubysource
# 判断环境
read "envInstall?请输入需要安装的环境:ios/reactnative/flutter/vue:"
echo "安装 $envInstall 环境"
if [[ "$envInstall" == "ios" ]]; then
    iosInstall
elif [[ "$envInstall" == "reactnative" ]]; then
    reactnativeInstall
elif [[ "$envInstall" == "flutter" ]]; then
    flutterInstall
elif [[ "$envInstall" == "vue" ]]; then
    vueInstall
else
    echo "不在选择内"
fi
source $SHELL_PROFILE
echo "安装完毕,请重启终端"
# podinstall

# # 判断是否安装node环境
# read "installNode?是否安装node环境?yes/no:"
# # read -p "是否安装node环境?yes/no:" installNode
# echo $installNode
# if [[ "$installNode" == "yes" ]];then
#     echo "安装node环境"
#     nvminstall
#     source /usr/local/opt/nvm/nvm.sh
#     echo "安装node v12.16.3"
#     nvm install v12.16.3
#     echo "设置12.16.3为默认node环境"
#     nvm alias default v12.16.3
#     nrminstall
# else
#     echo "不安装"
# fi

# source $SHELL_PROFILE
# echo "安装完毕,请重启终端"

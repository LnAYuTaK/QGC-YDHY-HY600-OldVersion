import QtQuick 2.4

UsersLogin {
    id: userLogin

    signal showRegisterPage
    signal showMainWindow
    property var myAddWindow

    loadButton.onClicked: {
        console.log("login button clicked.")
        QUSERLOGIN._usertxt = user.text;
        QUSERLOGIN._passwordtxt = password.text;
        QUSERLOGIN.test();
        QUSERLOGIN._rememberPsdchecked = rememberPsd.checked;
        if(QUSERLOGIN.check()){
            QUSERLOGIN.rember();
            showMainWindow();
            //202203注释  暂时取消飞行架次列表
            //myAddWindow.addModelData(SENDDATA.get_playback(),SENDDATA.get_playback_length())
//            mainWindow.source = "MainRootWindow.qml";
//            loginPage.visible = false
        }
    }
    autoLoad.onCheckedChanged: {
        console.log("auto load flag ", rememberPsd.checked)
            if(autoLoad.checked === false){
                console.log("Now is false")
            }
            else{
                console.log("Now is true")
            }
    }
    rememberPsd.onCheckedChanged: {
        console.log("remember password flag ", rememberPsd.checked)
        if(rememberPsd.checked === false){
            console.log("Now is false")//console.log()是很多好的调试qml的方式，在QT creator的Application Output栏输出

        }
        else{
            console.log("Now is true")

        }
    }
//    webButton.onClicked: {
//        console.log("open website www.trafficlab.cn")
//    }
    forgetPsd.onClicked: {
        console.log("forget password...")
    }

    register.onClicked: {
        showRegisterPage()
        console.log("register now...")
    }

    anchors.fill: parent
//    user.maximumLength: userLoginSettings.maxLenthUserName
//    password.maximumLength: userLoginSettings.maxLenthPassword
}

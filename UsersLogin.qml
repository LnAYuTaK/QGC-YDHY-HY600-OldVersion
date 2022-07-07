import QtQuick 2.4
//import Qt.labs.calendar 1.0
import QtQuick.Controls 2.3
import QtQuick.Controls.Styles 1.4
import QtQuick.Extras 1.4

import QtQuick.Dialogs  1.3
import QtQuick.Layouts  1.11
import QtQuick.Window   2.11

import QGroundControl               1.0
import QGroundControl.Palette       1.0
import QGroundControl.Controls      1.0
import QGroundControl.ScreenTools   1.0
import QGroundControl.FlightDisplay 1.0
import QGroundControl.FlightMap     1.0

Rectangle {
    id: loginPage
    visible:        true
//    width: 320
//    height: 550

    width:   ScreenTools.isMobile ? Screen.width : Math.min(250 * Screen.pixelDensity, Screen.width)   //215
    height:  ScreenTools.isMobile ? Screen.height : Math.min(150 * Screen.pixelDensity, Screen.height)  //120

    Component.onCompleted: {

        //自动添加记录的账号密码至页面
        fillUserInfo(QUSERLOGIN.autotext());

//        //-- Full screen on mobile or tiny screens
//        if(ScreenTools.isMobile || Screen.height / ScreenTools.realPixelDensity < 120) {
//            loginPage.showFullScreen()
//        } else {
//            width   = ScreenTools.isMobile ? Screen.width  : Math.min(250 * Screen.pixelDensity, Screen.width)
//            height  = ScreenTools.isMobile ? Screen.height : Math.min(150 * Screen.pixelDensity, Screen.height)
//        }
    }
    color: "#00000000"
    property alias image: image

    property alias text1: text1
    //property alias webButton: webButton
    property alias forgetPsd: forgetPsd
    property alias register: register
    property alias autoLoad: autoLoad
    property alias rememberPsd: rememberPsd
    property alias loadButton: loadButton
    property alias password: password
    property alias user: user


//    property string userName
//    property string password

//    property bool remeberPassword: true
//    property bool autoLoad: true
//    readonly property int maxLenthUserName: 100
//    readonly property int maxLenthPassword: 20

//    Loader
//        {
//            anchors.fill: parent
//            id: mainWindow
//        }

//    Loader
//        {
//            anchors.fill: parent
//            id: usersRegisterVerify

//        }


    //此函数用于填充用户信息
    function fillUserInfo(info){
        user.text=info.remusertxt;
        password.text=info.rempsd;
    }

    Image {
        id: image
        anchors.topMargin: 0
        anchors.fill: parent
        source: "/images/images/login_background_04.png"

        TextField {
            id: user
            y: 200
//            height: 60
            width:              loginPage.width  * 0.555
            height:             loginPage.height * 0.1
            anchors.topMargin: 163
            font.weight: Font.Light
            font.pointSize: 16

            anchors.top: parent.top
            leftPadding: height * 2
            anchors.right: parent.right
            anchors.rightMargin: 30
            anchors.left: parent.left
            anchors.leftMargin: 30
            placeholderText: qsTr("用户名")

            validator: RegExpValidator {
                regExp: /^([a-zA-Z0-9]+[_|\_|\.]?)*[a-zA-Z0-9]+@([a-zA-Z0-9]+[_|\_|\.]?)*[a-zA-Z0-9]+\.[a-zA-Z]{2,3}$/
            }
            font.family: "微软雅黑 Light"
            background: Rectangle {
                anchors.fill: parent
                color: "transparent"
                Image {
                    height: parent.height
                    width: height
                    anchors.left: parent.left
                    mipmap: true
                    anchors.verticalCenter: parent.verticalCenter
                    source: "/images/images/user_03.png"
                }
                Rectangle {
                    width: parent.width
                    height: 1
                    anchors.bottom: parent.bottom
//                    color: "gray"
                    color: "black"
                }
            }
        }

        Image {
            id: image1
            x: 128
            y: 30
            width:              loginPage.width  * 0.06
            height:             loginPage.width  * 0.06
            anchors.bottom: user.top
            anchors.bottomMargin: 25
            anchors.horizontalCenter: parent.horizontalCenter
            source: "/images/images/user_02.png"
        }

        TextField {
            id: password
            x: 30
            y: 0
            anchors.top: user.bottom
            anchors.topMargin: 11
//            height: 60
            width:              loginPage.width  * 0.555
            height:             loginPage.height * 0.1
            font.weight: Font.Light
            font.pointSize: 16
            leftPadding: height * 2
            anchors.right: parent.right
            anchors.rightMargin: 30
            anchors.left: parent.left
            anchors.leftMargin: 30
            placeholderText: qsTr("密码")

            echoMode: TextInput.Password     //PasswordEchoOnEdit
            font.family: "微软雅黑 Light"

            background: Rectangle {
                anchors.fill: parent
                color: "transparent"
                Image {
                    height: parent.height
                    width: height
                    anchors.left: parent.left
                    mipmap: true
                    anchors.verticalCenter: parent.verticalCenter
                    source: "/images/images/password.png"
                }
                Rectangle {
                    width: parent.width
                    height: 1
                    anchors.bottom: parent.bottom
//                    color: "gray"
                    color: "black"
                }
            }
        }

        Button {
            id: loadButton
//            height: 83
            width:              loginPage.width  * 0.666
            height:             loginPage.height * 0.12
            text: qsTr("登    录")
            anchors.top: row.bottom
            anchors.topMargin: 13
            anchors.right: parent.right
            anchors.rightMargin: 60
            anchors.left: parent.left
            anchors.leftMargin: 60
            font.pointSize: 14
            font.bold: true
//            font.family: "微软雅黑 Light"
            background: Rectangle {
                color: loadButton.pressed ? "#c3bcbc" : "#fbf2f2"
                anchors.fill: parent
                radius: 5
            }
//            onClicked: {/* mainWindow.source = "MainRootWindow.qml"
//            loginPage.visible = false*/
//                QUSERLOGIN._usertxt = user.text;
//                QUSERLOGIN._passwordtxt = password.text;
//                QUSERLOGIN.test();
//                QUSERLOGIN._rememberPsdchecked = rememberPsd.checked;
//                if(QUSERLOGIN.check()){
//                    QUSERLOGIN.rember();
//                    mainWindow.source = "MainRootWindow.qml";
//                    loginPage.visible = false
//                }
//            }
        }

        Row {
            id: row
//            height: 29
            height:             loginPage.height * 0.1
            spacing: 20
            anchors.top: password.bottom
            anchors.topMargin: 6
            anchors.right: parent.right
            anchors.rightMargin: 30
            anchors.left: parent.left
            anchors.leftMargin: 30

            CheckBox {
                id: rememberPsd
//                width: 150
//                height: 30
                width:              parent.width  * 0.12
                height:             loginPage.height * 0.1
                text: qsTr("        ")
                transformOrigin: Item.Left
                anchors.left: parent.left
                anchors.leftMargin: 10
                spacing: 0
                autoRepeat: false
                autoExclusive: false
                anchors.verticalCenter: parent.verticalCenter

                antialiasing: true
                scale: 1.1
//                spacing: 10
                display: AbstractButton.TextOnly
                checked: true
                background: Rectangle {
                    anchors.fill: parent
                    color: "transparent"
                    Text {
                        anchors.fill: parent
                        font.pointSize: 12
                        font.family: "微软雅黑 Light"
                        text: qsTr("记住密码")
                        verticalAlignment: Text.AlignVCenter
//                        anchors.leftMargin: parent.width  * 0.15
                        horizontalAlignment: Text.AlignRight
                    }
                }

//                onCheckedChanged: {
//                    if(rememberPsd.checked === false){
//                        console.log("Now is false")//console.log()是很多好的调试qml的方式，在QT creator的Application Output栏输出

//                    }
//                    else{
//                        console.log("Now is true")

//                    }
//                }

            }

            CheckBox {
                id: autoLoad
//                width: 150
//                height: 30
                width:              parent.width  * 0.12
                height:             loginPage.height * 0.1
                text: qsTr("         ")
                transformOrigin: Item.Right
                anchors.right: parent.right
                anchors.rightMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                antialiasing: true
                checked: true
                font.family: "微软雅黑 Light"
                font.pointSize: 12
                spacing: 10
                scale: 1.1
                display: AbstractButton.TextOnly
                background: Rectangle {
                    anchors.fill: parent
                    color: "transparent"
                    Text {
                        anchors.fill: parent
                        font.pointSize: 12
                        font.family: "微软雅黑 Light"
                        text: qsTr("自动登录")
                        verticalAlignment: Text.AlignVCenter
//                        anchors.leftMargin: parent.width  * 0.15
                        horizontalAlignment: Text.AlignRight
                    }
                }

//                onCheckedChanged: {
//                    if(autoLoad.checked === false){
//                        console.log("Now is false")
//                    }
//                    else{
//                        console.log("Now is true")
//                    }
//                }
            }
        }

        Row {
            id: row1
//            height: 30
            height:             loginPage.height * 0.1

            anchors.top: loadButton.bottom
            anchors.topMargin: 23
            anchors.right: parent.right
            anchors.rightMargin: 30
            anchors.left: parent.left
            anchors.leftMargin: 30

            Button {
                id: register
//                width: 63
//                height: 12
                width:              loginPage.width  * 0.2
                height:             loginPage.height * 0.1

                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 0
                background: Rectangle {
                    anchors.fill: parent
                    color: "transparent"
                    Text {
                        id: text1
                        anchors.centerIn: parent
                        text: qsTr("立即注册>>")
                        color: "black"
                        font.family: "微软雅黑 Light"
                        font.pointSize: 12
                    }
                }                
//                onClicked: { usersRegisterVerify.source = "UsersRegisterVerify.qml"
//                loginPage.visible = false
//                }
            }

            Button {
                id: forgetPsd
//                width: 63
//                height: 12
                width:              loginPage.width  * 0.2
                height:             loginPage.height * 0.1

                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: 0
                background: Rectangle {
                    anchors.fill: parent
                    color: "transparent"
                    Text {
                        anchors.centerIn: parent
                        text: qsTr("忘记密码?")
                        color: "black"
                        font.family: "微软雅黑 Light"
                        font.pointSize: 12
                    }
                }
            }
        }

//        Button {
//            id: webButton
//            anchors.bottom: parent.bottom
//            anchors.bottomMargin: 20
//            anchors.left: parent.left
//            anchors.right: parent.right
//            anchors.leftMargin: 30
//            anchors.rightMargin: 30
//            height: 30

//            background: Rectangle {
//                anchors.fill: parent
//                color: "transparent"
//                Text {
//                    anchors.centerIn: parent
//                    text: qsTr("www.trafficlab.cn")
//                    font.underline: true
//                    color: "black"
//                    font.family: "微软雅黑 Light"
//                    font.pointSize: 10
//                }
//            }
//        }

    }
//connection
//    loadButton.onClicked: {
//        console.log("login button clicked.")
//        showMainWindow()
//    }
//    autoLoad.onCheckedChanged: {
//        console.log("auto load flag ", rememberPsd.checked)
//    }
//    rememberPsd.onCheckedChanged: {
//        console.log("remember password flag ", rememberPsd.checked)
//    }
////    webButton.onClicked: {
////        console.log("open website www.trafficlab.cn")
////    }
//    forgetPsd.onClicked: {
//        console.log("forget password...")
//    }

//    register.onClicked: {
//        showRegisterPage()
//        console.log("register now...")
//    }


}



/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/

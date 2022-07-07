import QtQuick 2.4
import QtQuick.Layouts 1.4
import QtQuick.Controls 2.4

import QtQuick.Dialogs  1.3
import QtQuick.Window   2.11

import QGroundControl               1.0
import QGroundControl.Palette       1.0
import QGroundControl.Controls      1.0
import QGroundControl.ScreenTools   1.0
import QGroundControl.FlightDisplay 1.0
import QGroundControl.FlightMap     1.0

Rectangle  {
    id: registerVerifyPage
    visible:        true
//    width: 320
//    height: 550

    width:   ScreenTools.isMobile ? Screen.width  : Math.min(215 * Screen.pixelDensity, Screen.width)
    height:  ScreenTools.isMobile ? Screen.height : Math.min(120 * Screen.pixelDensity, Screen.height)

//    Component.onCompleted: {
//        //-- Full screen on mobile or tiny screens
//        if(ScreenTools.isMobile || Screen.height / ScreenTools.realPixelDensity < 120) {
//            registerVerifyPage.showFullScreen()
//        } else {
//            width   = ScreenTools.isMobile ? Screen.width  : Math.min(250 * Screen.pixelDensity, Screen.width)
//            height  = ScreenTools.isMobile ? Screen.height : Math.min(150 * Screen.pixelDensity, Screen.height)
//        }
//    }

    property alias text1: text1
    property alias next: next
    property alias getVerifyNumber: getVerifyNumber
    property alias verifyNumber: verifyNumber
//    property alias webButton: webButton
    property alias loginButton: loginButton
    property alias userName: userName

//    Loader
//        {
//            anchors.fill: parent
//            id: usersRegister
//        }

//    Loader
//        {
//            anchors.fill: parent
//            id: usersLogin
//        }

    Image {
        id: image
        fillMode: Image.PreserveAspectCrop
        anchors.fill: parent
        source: "/images/images/login_background_04.png"

        Image {
            id: image1
            anchors.bottom: userName.top
            anchors.bottomMargin: 20
            anchors.horizontalCenter: parent.horizontalCenter
            source: "/images/images/register.png"
        }

        TextField {
            id: userName
//            height: 30
            height:             registerVerifyPage.height * 0.1
            horizontalAlignment: Text.AlignLeft
            font.pointSize: 12
            font.family: "微软雅黑 Light"
            anchors.top: parent.top
            anchors.topMargin: parent.height * 0.3
            anchors.left: parent.left
            anchors.leftMargin: 30
            anchors.right: parent.right
            anchors.rightMargin: 30
            leftPadding: height * 2
            placeholderText: qsTr("请输入手机号")
            background: Rectangle {
                id: rectangle1
                anchors.fill: parent
                color: "transparent"
                border.color: "white"
                border.width: 1
                radius: height / 2
                Image {
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 3
                    anchors.top: parent.top
                    anchors.topMargin: 3
                    width: height
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    source: "/images/images/phoneNumber.png"
                }
            }
        }

        TextField {
            id: verifyNumber
//            height: 30
            height:             registerVerifyPage.height * 0.1
            horizontalAlignment: Text.AlignLeft
            font.pointSize: 12

            font.family: "微软雅黑 Light"
            anchors.top: getVerifyNumber.bottom
            anchors.topMargin: 20
            anchors.left: parent.left
            anchors.leftMargin: 30
            anchors.right: parent.right
            anchors.rightMargin: 30
            leftPadding: height * 2
            echoMode: TextInput.Normal
            placeholderText: qsTr("请输入验证码")

            validator: RegExpValidator{regExp: /[0-9][0-9][0-9][0-9]/}

            background: Rectangle {
                id: rectangle3
                anchors.fill: parent
                color: "transparent"
                border.color: "white"
                border.width: 1
                radius: height / 2
                Image {
                    anchors.bottom: parent.bottom
                    anchors.top: parent.top
                    fillMode: Image.PreserveAspectFit
                    width: height
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    anchors.topMargin: 5
                    anchors.bottomMargin: 5
                    source: "/images/images/verify.png"
                }
            }
        }

        Button {
            id: getVerifyNumber

//            height: 30
            height:             registerVerifyPage.height * 0.1
            text: qsTr("获取验证码")
            background: Rectangle {
                color: getVerifyNumber.pressed ? "#c3bcbc" : "#fbf2f2"
                radius: 5
                anchors.fill: parent
            }
            anchors.right: parent.right
            anchors.topMargin: 20
            anchors.top: userName.bottom
            anchors.rightMargin: 30
            font.pointSize: 12
            font.family: "微软雅黑 Light"
        }

//        Button {
//            id: webButton
//            anchors.bottom: parent.bottom
//            anchors.bottomMargin: 10
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
//                    font.pointSize: 11
//                }
//            }
//        }

        Row {
            id: row
//            height: 30
            height:             registerVerifyPage.height * 0.08
            spacing: -10
            anchors.top: next.bottom
            anchors.topMargin: 30
            anchors.right: parent.right
            anchors.rightMargin: 30
            anchors.left: parent.left
            anchors.leftMargin: 30

            Label {
                id: label
                color: "#ffffff"
                text: qsTr("已经有一个账号 ?  点我 ")
                font.pointSize: 11
                font.family: "微软雅黑 Light"
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 0
            }

            Button {
                id: loginButton
//                width: 50
//                height: 20
                width:              loginPage.width  * 0.2
                height:             loginPage.height * 0.1

                anchors.left: label.right
                anchors.leftMargin: 5

                anchors.verticalCenter: parent.verticalCenter
                background: Rectangle {
                    anchors.fill: parent
                    color: "transparent"
                    Text {
                        id: text1
                        anchors.centerIn: parent
                        text: qsTr("登录")
                        color: "white"
                        font.underline: true
                        font.family: "微软雅黑"
                        font.pointSize: 12
                    }
                }
//                onClicked: { usersLogin.source = "UsersLogin.qml"
//                verify.visible = false
//                    }
            }
        }

        Button {
            id: next
//            height: 30
            height:             registerVerifyPage.height * 0.08
            text: qsTr("下 一 步")
            anchors.left: parent.left
            anchors.leftMargin: 30
            background: Rectangle {
                color: next.pressed ? "#c3bcbc" : "#fbf2f2"
                radius: 5
                anchors.fill: parent
            }
            font.pointSize: 12
            anchors.right: parent.right
            anchors.top: verifyNumber.bottom
            anchors.rightMargin: 30
            anchors.topMargin: 20
            font.family: "微软雅黑 Light"

//            onClicked: { usersRegister.source = "UsersRegister.qml"
//            verify.visible = false
//            }
        }
    }
//connection
//    getVerifyNumber.onClicked: {
//        console.log("get verify number")
//    }
//    loginButton.onClicked: {
//        console.log("login...")
//        showLoginPage()
//    }
//    next.onClicked: {
//        console.log("next..")
//        showRegisterPage()
//    }
}

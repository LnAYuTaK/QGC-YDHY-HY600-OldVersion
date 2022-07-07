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
    id: register
    visible:        true
//    width: 320
//    height: 550

    width:   ScreenTools.isMobile ? Screen.width  : Math.min(215 * Screen.pixelDensity, Screen.width)
    height:  ScreenTools.isMobile ? Screen.height : Math.min(120 * Screen.pixelDensity, Screen.height)
//    visible:        true

//    Component.onCompleted: {
//        //-- Full screen on mobile or tiny screens
//        if(ScreenTools.isMobile || Screen.height / ScreenTools.realPixelDensity < 120) {
//            register.showFullScreen()
//        } else {
//            width   = ScreenTools.isMobile ? Screen.width  : Math.min(250 * Screen.pixelDensity, Screen.width)
//            height  = ScreenTools.isMobile ? Screen.height : Math.min(150 * Screen.pixelDensity, Screen.height)
//        }
//    }


//    property alias webButton: webButton
    property alias loginButton: loginButton
    property alias registerButton: registerButton
    property alias passwordConfirm: passwordConfirm
    property alias password: password
    property alias userName: userName

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
            height:             register.height * 0.08
            enabled: false
            horizontalAlignment: Text.AlignLeft
            font.pointSize: 12
            font.family: "微软雅黑 Light"
            anchors.top: parent.top
            anchors.topMargin: parent.height * 0.3
            anchors.left: parent.left
            anchors.leftMargin: 37
            anchors.right: parent.right
            anchors.rightMargin: 23
            leftPadding: height * 2
            placeholderText: qsTr("请输入用户名")
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
            id: password
//            height: 30
            height:             register.height * 0.08
            horizontalAlignment: Text.AlignLeft
            font.pointSize: 12

            font.family: "微软雅黑 Light"
            anchors.top: userName.bottom
            anchors.topMargin: 13
            anchors.left: parent.left
            anchors.leftMargin: 37
            anchors.right: parent.right
            anchors.rightMargin: 23
            leftPadding: height * 2
            echoMode: TextInput.PasswordEchoOnEdit
            placeholderText: qsTr("请输入密码")

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
                    source: "/images/images/password_01.png"
                }
            }
        }

        TextField {
            id: passwordConfirm
//            height: 30
            height:             register.height * 0.08
            horizontalAlignment: Text.AlignLeft
            font.pointSize: 12

            font.family: "微软雅黑 Light"
            anchors.top: password.bottom
            anchors.topMargin: 17
            anchors.left: parent.left
            anchors.leftMargin: 37
            anchors.right: parent.right
            anchors.rightMargin: 23
            leftPadding: height * 2
            echoMode: TextInput.PasswordEchoOnEdit
            placeholderText: qsTr("请再次输入密码")

            background: Rectangle {
                id: rectangle2
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
                    source: "/images/images/password_01.png"
                }
            }
        }

        Button {
            id: registerButton

//            height: 30
            height:             register.height * 0.1
            text: qsTr("注    册")
            background: Rectangle {
                color: registerButton.pressed ? "#c3bcbc" : "#fbf2f2"
                radius: 5
                anchors.fill: parent
            }
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.topMargin: 15
            anchors.leftMargin: 30
            anchors.top: passwordConfirm.bottom
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
            height:             register.height * 0.1
            spacing: -10
            anchors.top: registerButton.bottom
            anchors.topMargin: 14
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
                width:              register.width  * 0.1
                height:             register.height * 0.1

                anchors.left: label.right
                anchors.leftMargin: 5

                anchors.verticalCenter: parent.verticalCenter
                background: Rectangle {
                    anchors.fill: parent
                    color: "transparent"
                    Text {
                        width: 48
                        height: 21
                        anchors.centerIn: parent
                        text: qsTr("登录")
                        color: "white"
                        font.underline: true
                        font.family: "微软雅黑"
                        font.pointSize: 12
                    }
                }
//                onClicked: { usersLogin.source = "UsersLogin.qml"
//                register.visible = false
//                    }
            }
        }
    }
//connection
//    webButton.onClicked: {
//        console.log("open website www.trafficlab.cn")
//    }

//    loginButton.onClicked: {
//        showLoginPage()
//        console.log("show login page...")
//    }
//    anchors.fill: parent
//    userName.maximumLength: userLoginSettings.maxLenthUserName
//    password.maximumLength: userLoginSettings.maxLenthPassword
//    passwordConfirm.maximumLength: userLoginSettings.maxLenthPassword
}

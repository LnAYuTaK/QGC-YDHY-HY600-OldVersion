import QtQuick 2.4

UsersRegister {

    signal showLoginPage
//    webButton.onClicked: {
//        console.log("open website www.trafficlab.cn")
//    }

    loginButton.onClicked: {
        showLoginPage()
        console.log("show login page...")
    }
    anchors.fill: parent
//    userName.maximumLength: userLoginSettings.maxLenthUserName
//    password.maximumLength: userLoginSettings.maxLenthPassword
//    passwordConfirm.maximumLength: userLoginSettings.maxLenthPassword
}

import QtQuick 2.4

UsersRegisterVerify {

    signal showRegisterPage
    signal showLoginPage
    getVerifyNumber.onClicked: {
        console.log("get verify number")
    }
    loginButton.onClicked: {
        console.log("login...")
        showLoginPage()
    }
    next.onClicked: {
        console.log("next..")
        showRegisterPage()
    }
}

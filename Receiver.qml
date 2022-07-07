import QtQuick 2.0

MyAddButton {
    id: receiver
    function receive(value)
    {
        contentText=value
        myaddbuttonnotify.running=true
    }
    SequentialAnimation on myaddbuttonColor {
        id: myaddbuttonnotifly
        running: false

        ColorAnimation {
            from: "red"
            to: "blue"
            duration: 200
        }
        ColorAnimation {
            from: "blue"
            to: "red"
            duration: 200
        }
    }
}

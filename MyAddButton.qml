import QtQuick 2.0

Item {
    width: 200
    height: 200
    property alias myaddbuttonColor: myaddbutton.color
    property alias contentText: content.text

    Rectangle {
        id: myaddbutton
        color: "#f44829"
        radius: width*0.5
        anchors.fill: parent

        Text {
            id:content
            x:79
            y:75
            color:"#f2f1f1"
            text:qsTr("Text")
            font.bold: true
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: 30
        }
    }
}

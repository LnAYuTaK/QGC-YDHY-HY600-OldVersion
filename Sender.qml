import QtQuick 2.0

MyAddButton {
    id: sender
    property int counter: 0
    signal send(string value)
    property Receiver target: null
    onTargetChanged: {
        send.connect(torget.receive);
    }
    MouseArea {
        anchors.fill:parent
        onClicked: {
           sender.counter++;
           sender.send(counter);
        }
        onPressed: {
            sender.myaddbuttonColor="blue"
        }
        onReleased: {
            sender.myaddbuttonColor="red"
        }
    }
}

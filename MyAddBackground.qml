import QtQuick          2.3
import QtQuick.Window   2.2
import QtQuick.Controls 1.2

import QGroundControl               1.0
import QGroundControl.Palette       1.0
import QGroundControl.Controls      1.0
import QGroundControl.Controllers   1.0
import QGroundControl.ScreenTools   1.0



Item {
    Rectangle {
        id:background
        gradient:Gradient {
            GradientStop {
                position: 0
                color: "#f2f1f1"
            }

            GradientStop {
                position: 1
                color: "#000000"
            }
        }
        anchors.fill:parent
    }

}


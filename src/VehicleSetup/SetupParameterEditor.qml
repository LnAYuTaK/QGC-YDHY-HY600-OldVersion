/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/


import QtQuick 2.3
import QtQuick.Controls 1.2

import QGroundControl.Controls 1.0
import QGroundControl.ScreenTools 1.0
import QGroundControl.Palette 1.0
import Personal.ParaManage  1.0
//界面显示QML
ParameterEditor{

    Rectangle{
        height: 85
        x:100
        y:100
        color: "gray"
        Grid{
            anchors.fill: parent
            anchors.topMargin: 0
            rows:2
            columns: 2
            rowSpacing: 12
            columnSpacing: 8
            Text {
                text: qsTr("参数1")
                font.family: "Microsoft YaHei"
                font.pixelSize: 14
                color: "#FDFFFF"
            }
            Text {
                id: deviceTypeData
                wrapMode:Text.WrapAnywhere
                text:"XXXXXXXX"
                font.family: "Microsoft YaHei"
                font.pixelSize: 14
                color: "#FDFFFF"

            }
            Text {
                text: qsTr("参数2")
                font.family: "Microsoft YaHei"
                font.pixelSize: 14
                color: "#FDFFFF"
            }
            Text {
                id: bindOrgData
                wrapMode:Text.WrapAnywhere
                text: "XXXXXXXXX" //__orgName
                font.family: "Microsoft YaHei"
                font.pixelSize: 14
                color: "#FDFFFF"
        }
     }
      ParaManage{
            id:paramanage
        }

     Button {
            onClicked:
            {
               paramanage.setParameter();
            }
        }
  }
}

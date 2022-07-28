/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

import QtQuick                      2.3
import QtQuick.Controls             1.2
import QtQuick.Dialogs              1.2
import QtQuick.Layouts              1.2

import QGroundControl               1.0
import QGroundControl.Controls      1.0
import QGroundControl.Palette       1.0
import QGroundControl.ScreenTools   1.0
import QGroundControl.Controllers   1.0
import QGroundControl.FactSystem    1.0
import QGroundControl.FactControls  1.0
Item {
    id:         _root
    width: parent.width
    height: parent.height
    //
    Rectangle {
               border.width: 1
               border.color: "white"
               anchors{
                   centerIn: parent
               }
               width: parent.width
               height: parent.height
               clip: true
               //列布局
               Column {
                   anchors.fill: parent
                   anchors.margins: 2
                   spacing: 0

                   //Head
                   Item {
                       id: titleItem
                       width: parent.width
                       height: 60
                       Label {
                           font.pixelSize: 18*3
                           text: qsTr("参数设置")
                           anchors {
                               left: parent.left
                               leftMargin: 10
                               verticalCenter: parent.verticalCenter
                           }
                       }
                   }

                   //HeadEnd



                    //Dividing line
                   Rectangle {
                       width: parent.width
                       height: 1
                       color: "#ededed"
                   }
                   Rectangle {
                       width: parent.width
                       height: 1
                       color: "#ededed"
                   }
                   //

                   Item {
                       id: listItem
                       width: parent.width
                       height: 638
                       Item {
                           id: leftItem
                           width: 100
                           ListView {
                               id: leftListView
                               anchors.fill: parent
                               model: ["流速开度"]
                               delegate: Button {
                                   id: btn
                                   width: 100
                                   height: 200
                                   property bool isSelected: leftListView.currentIndex === index
                                   text: modelData
                                    Rectangle {
                                       width: btn.width
                                       height: btn.height
                                   }
                                   onClicked: {
                                       leftListView.currentIndex = index

                                       //互斥锁 锁上,别让右边再把信号搞回来
                                       rightListView.notifyLeft = false

                                       rightListView.positionViewAtIndex(
                                                   index, ListView.Beginning)
                                       //解锁
                                       rightListView.notifyLeft = true
                                   }
                               }
                           }
                       }
                       //右侧的列表
                       Item {
                           id: rightItem
                           width: parent.width - leftItem.width
                           x: leftItem.width
                           height: parent.height
                           ListView {
                               id: rightListView
                               anchors.fill: parent
                               clip: true
                               //互斥flag
                               property bool notifyLeft: true
                               anchors.rightMargin: -2
                               anchors.bottomMargin: -2
                               anchors.leftMargin: 2
                               anchors.topMargin: 2
                               delegate: Item {
                                   width: 400*2
                                   height: 160*3
                                   Row {
                                       x: 100
                                       spacing: 40
                                       height: parent.height
                                       Text {
                                             id: paraname
                                             width:100*2
                                             height: 30*3
                                             text: modelData
                                             font.pixelSize: 60


                                       }
                                       Rectangle {
                                           width: 150*2
                                           height: 30*3
                                           color: "#ededed"
                                           Text {
                                               id: name
                                               width: parent.width
                                               height: parent.height
                                               text: ParaManager.getParameterValue(1,"SPRAY_PUMP_RATE")
                                           }
                                       }
                                       TextField {
                                           id :spray_pump_rate
                                           placeholderText: "0~100"
                                           width: 150*2
                                           height: 30*3
                                       }
                                       Button {
                                           width:  150*2
                                           height: 30*3
                                           Text{
                                               width: parent.width
                                               height: parent.height
                                               anchors.centerIn: parent
                                               text: qsTr("Updata")
                                           }
                                           onClicked:{
                                                  ParaManager.setParameterValue(1,"SPRAY_PUMP_RATE",spray_pump_rate.text.toString())
                                                //获取完后刷新一下
                                                  ParaManager.refreshThisParameter(1,"SPRAY_PUMP_RATE")
                                                  name.text = ParaManager.getParameterValue(1,"SPRAY_PUMP_RATE")
                                               }
                                       }

                                   }
                               }
                               model: leftListView.model
                               onContentYChanged: {
                                   if (notifyLeft) {
                                       var i = rightListView.indexAt(0, contentY)
                                       leftListView.currentIndex = i
                                   }
                               }
                           }
                       }
                   }
               }
           }

    //---------------------------------------------
    //-- Header
//    Row {
//        id:             header
//        anchors.left:   parent.left
//        anchors.right:  parent.right
//        spacing:        ScreenTools.defaultFontPixelWidth

//        Timer {
//            id:         clearTimer
//            interval:   100;
//            running:    false;
//            repeat:     false
//            onTriggered: {
//                searchText.text = ""
//                controller.searchText = ""
//            }
//        }

//        QGCLabel {
//            anchors.verticalCenter: parent.verticalCenter
//            text: qsTr("Search:")
//        }

//        QGCTextField {
//            id:                 searchText
//            text:               controller.searchText
//            onDisplayTextChanged: controller.searchText = displayText
//            anchors.verticalCenter: parent.verticalCenter
//        }

//        QGCButton {
//            text: qsTr("Clear")
//            onClicked: {
//                if(ScreenTools.isMobile) {
//                    Qt.inputMethod.hide();
//                }
//                clearTimer.start()
//            }
//            anchors.verticalCenter: parent.verticalCenter
//        }

//        QGCCheckBox {
//            text:       qsTr("Show modified only")
//            checked:    controller.showModifiedOnly
//            anchors.verticalCenter: parent.verticalCenter
//            onClicked: {
//                controller.showModifiedOnly = !controller.showModifiedOnly
//            }
//        }
//    } // Row - Header


}

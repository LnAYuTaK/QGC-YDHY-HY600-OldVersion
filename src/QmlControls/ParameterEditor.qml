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
import TaoQuick 1.0
Item {
    id:         _root
    ExclusiveGroup { id: sectionGroup }
    Rectangle {
               border.width: 1
               border.color: "white"
               anchors{
                   centerIn: parent
               }
               width: parent.width*0.8
               height: parent.height*0.8
               clip: true
               Column {
                   anchors.fill: parent
                   anchors.margins: 2
                   spacing: 0
                   Item {
                       id: titleItem
                       width: parent.width
                       height: 60
                       Label {
                           font.pixelSize: 18
                           text: qsTr("参数设置")
                           anchors {
                               left: parent.left
                               leftMargin: 10
                               verticalCenter: parent.verticalCenter
                           }
                       }
                   }
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
                   Item {
                       id: listItem
                       width: parent.width
                       height: 638
                       Item {
                           id: leftItem
                           width: 160
                           height: parent.height
                           ListView {
                               id: leftListView
                               anchors.fill: parent
                               model: ["流速开度"]
                               delegate: Button {
                                   id: btn
                                   width: 160
                                   height: 50
                                   property bool isSelected: leftListView.currentIndex === index
                                   text: modelData
                                    Rectangle {
                                       width: btn.width
                                       height: btn.height
   //                                    color: {
   //                                        if (btn.isSelected || btn.pressed) {
   //                                            return "#ffffff"
   //                                        } else if (btn.hovered) {
   //                                            return "#e1e6eb"
   //                                        } else {
   //                                            return "#f0f0f1"
   //                                        }
   //                                    }
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

                               delegate: Item {
                                   width: 400
                                   height: 160
                                   Row {
                                       x: 100
                                       spacing: 30
                                       height: parent.height
                                       CusLabel {
                                           text: modelData
                                           wrapMode: Label.WordWrap
                                           width: 100
                                           font.pixelSize: 20

                                       }
                                       Rectangle {
                                           width: 150
                                           height: 30
                                           color: "#ededed"
                                           Text {
                                               id: name
                                               width: parent.width
                                               height: parent.height
                                               text: ParaManager.getParameterValue(1,"SPRAY_PUMP_RATE")
                                           }
                                       }
                                       CusTextField {
                                           id :spray_pump_rate
                                           placeholderText: "0~100"
                                           width: 100
                                           height: 30
                                       }
                                       CusButton {
                                           width: 100
                                           height: 30
                                           text: "上传参数"
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

import QtQuick          2.3
import QtQuick.Controls 1.2
import QtQuick.Layouts  1.2

import QGroundControl               1.0
import QGroundControl.Palette       1.0
import QGroundControl.Controls      1.0
import QGroundControl.ScreenTools   1.0



Rectangle {
    id:                         cropspeciesWindow;
    width:                      workrecord.width
    height:                     workrecord.height
    anchors.horizontalCenter:   workrecord.horizontalCenter;
    anchors.verticalCenter:   workrecord.verticalCenter;
    color:                      "lightgrey"
    opacity :                   0.9;   //透明度

        MouseArea{

             anchors.fill:parent
        }


        Rectangle {
            id:                         cropspeciesView;
        //                visible:        ture
        //    anchors.bottom:             vehicleIcon.top;
        //    anchors.bottomMargin:  4
            anchors.horizontalCenter:   parent.horizontalCenter;
            anchors.verticalCenter:   parent.verticalCenter;
            color:                      "#DDDDFF"
            radius:                     5
            width:                      parent.width * 0.45
            height:                     parent.height * 0.8
        //                anchors.top:    parent.top /2
        //                anchors.left:   parent.left /2
            opacity :                   1.1;   //透明度
            border.color:               "black"
            border.width:               2


            Column {
                id:                 buttonColumn
                width:              parent.width
                height:             parent.height
                anchors.top:        parent.top
                anchors.topMargin:  6
                anchors.left:       parent.left
                anchors.leftMargin: 6
                spacing:            6

                Label {
                    color:                            "#424200"
                    width:                            parent.width
                    horizontalAlignment:              Text.AlignHCenter
                    verticalAlignment:                Text.AlignVCenter
                    font.pointSize:                   ScreenTools.mediumFontPointSize * 0.55
                    text:                             "作业详情"
                    font.bold:                        true
                }

                Repeater {
                    id:     statusNameRepeater
                    model:  9  //为重复器提供的数据模型，类型是any
                    //类型是数字的话，代表要重复器要创建的数量

                    property var statusNames:  [ "用户名 ", "开始时间 ", qsTr("飞行时间 "), qsTr("喷洒面积 "), qsTr("亩用量 "), qsTr("用药量 "), qsTr("飞控序列号 "), qsTr("飞行距离 "),"作物种类 "]
                    property var statusValues: [useradmin, starttime, flighttime, sprayingarea, dosageofmu, dosage, flightcontrolnumber, flightdisance, cropspecies]

                    delegate:Row{
                        id: _row
                        Label {
                            color:                            "#424200"
                            horizontalAlignment:              Text.AlignHCenter
                            font.pointSize:                   ScreenTools.mediumFontPointSize * 0.55
                            text:                             statusNameRepeater.statusNames[index]
                            font.bold:                        true
                        }
                        Label {
                            color:                            "#336666"
                            horizontalAlignment:              Text.AlignHCenter
                            font.pointSize:                   ScreenTools.mediumFontPointSize * 0.55
//                            text:                             statusNameRepeater.statusValues[index] + statusNameRepeater.statusUnits[index]
                            text:                             statusNameRepeater.statusValues[index]
                            font.bold:                        true
                            }
                        }
                    }
                }

            Rectangle{
                id:closedetails
                width: parent.width
                height: parent.height * 0.1
                radius: 5
                color: "grey"
//                    text: qsTr("关闭")
                Text {
                        text: "关闭"
                        anchors.horizontalCenter:   parent.horizontalCenter;
                        anchors.verticalCenter:   parent.verticalCenter;
                        font.bold:   true
                        font.pointSize: ScreenTools.mediumFontPointSize *0.55
                                    }
                anchors.bottom:        parent.bottom
                anchors.left:       parent.left
//                anchors.bottomMargin:  0
//                anchors.leftMargin:  0

                MouseArea{
                anchors.fill: parent

                onClicked: {
//                              myAddDetails.source = "MyAddDetails.qml";
                      cropspeciesWindow.visible = false;

                    }

                }
            }

        }
    }


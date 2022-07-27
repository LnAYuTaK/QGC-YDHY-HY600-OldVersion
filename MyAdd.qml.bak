//自己添加  数据补发  展示作业数据
import QtQuick          2.3
import QtQuick.Controls 2.2
import QtQuick.Layouts  1.2

//import QtQuick          2.3
//import QtQuick.Controls 1.2
import QtQuick.Dialogs  1.2
import QtLocation       5.9
import QtPositioning    5.3
//import QtQuick.Layouts  1.2
import QtQuick.Window   2.2

import QtQuick.Controls.Styles 1.2

import QGroundControl               1.0
import QGroundControl.Palette       1.0
import QGroundControl.Controls      1.0
import QGroundControl.ScreenTools   1.0

//import QGroundControl                   1.0
import QGroundControl.FlightMap         1.0
//import QGroundControl.ScreenTools       1.0
//import QGroundControl.Controls          1.0
import QGroundControl.FactSystem        1.0
import QGroundControl.FactControls      1.0
//import QGroundControl.Palette           1.0
import QGroundControl.Controllers       1.0
import QGroundControl.ShapeFileHelper   1.0
import QGroundControl.Airspace          1.0
import QGroundControl.Airmap            1.0

Rectangle {
    id:     myAddBackground
    color:  qgcPal.window
    z:      QGroundControl.zOrderTopMost

//        Sender {
//            id: sender
//            target: receiver
//            x: 10
//            y: 140
//            width: 87
//            height: 28
//            anchors.verticalCenterOffset: 184
//            myaddbuttonColor: "#ff0000"
//            anchors.verticalCenter: parent.verticalCenter
//            contentText: "确认"
//        }

//        Receiver {
//            id: receiver
//            x: 10
//            y: 140
//            width: 87
//            height: 28
//            anchors.verticalCenterOffset: 226
//            myaddbuttonColor: "#00ff00"
//            contentText: "返回"
//            anchors.verticalCenter: parent.verticalCenter
//        }

        Image {
//            x: 10
//            y: 40
//            height: parent.width*0.05
//            width: parent.width*0.05
            width:              ScreenTools.isMobile ? ScreenTools.defaultFontPixelHeight * 1.5 : ScreenTools.defaultFontPixelHeight * 2.5
            height:             width
            anchors.top: parent.top
            anchors.topMargin: 5
            anchors.left: parent.left
            anchors.leftMargin: 5
            source: "/images/images/user_04.png"
            }


//            TextField {
//                id: user_id
//                x: 46
//                y: 46

//                anchors.topMargin: 163
//                font.weight: Font.Light
//                font.pointSize: 12

//                text:QUSERLOGIN._usertxt

//                validator: RegExpValidator {
//                    regExp: /^([a-zA-Z0-9]+[_|\_|\.]?)*[a-zA-Z0-9]+@([a-zA-Z0-9]+[_|\_|\.]?)*[a-zA-Z0-9]+\.[a-zA-Z]{2,3}$/
//                }
//                font.family: "微软雅黑 Light"
//                }

        Label {
            id: user_id
//            x: 46
//            y: 46
            x: myAddBackground.width  * 0.04
            y: myAddBackground.height  * 0.01
            color: "LightGreen"

            font.weight: Font.Light
            font.bold: true
            font.pointSize: 18

            //text:"ID：" + QUSERLOGIN._usertxt
            //202203Add 将回传用户名改成YDHY
            text:"ID：" + DATA._usertxt

//                validator: RegExpValidator {
//                    regExp: /^([a-zA-Z0-9]+[_|\_|\.]?)*[a-zA-Z0-9]+@([a-zA-Z0-9]+[_|\_|\.]?)*[a-zA-Z0-9]+\.[a-zA-Z]{2,3}$/
//                }
//            font.family: "微软雅黑 Light"
            }

//        Loader
//            {
//                anchors.fill: parent
//                id: mainWindow
//                source: "/images/images/user_04.png"
//            }

//        Loader
//            {
//                anchors.fill: parent
//                id: loginPage
//                visible:        false
//            }

//        Connections {
//            target: loadButton
//            onClicked: {
//                addModelData(SENDDATA.get_playback(),SENDDATA.get_playback_length())
//                console.log("zzzzzzzzz ",addModelData(SENDDATA.get_playback(),SENDDATA.get_playback_length()))

//            }
//        }

        Rectangle {
            id: exituser
            color:"#663399"
            radius: 5
            x: myAddBackground.width  * 0.28
            y: myAddBackground.height  * 0.01
            width: myAddBackground.width  * 0.1
            height: user_id.height
            anchors.verticalCenter: user_id.verticalCenter
                Text {
                    text: "退出用户"
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.bold: true
                    font.pointSize: 14
                }

                MouseArea{
                anchors.fill: parent

                z: parent.z
                onClicked: {
                    Qt.quit()
//                    myAddBackground.visible = false
//                    loginPage.source = "UsersLogin.qml";
                    }

                }

        }

        Rectangle {
            id: shieldingcover;
            x: myAddBackground.width  * 0.01
            y: myAddBackground.height  * 0.1
            z: parent.z
            width: myAddBackground.width  * 0.96
            height: myAddBackground.height  * 0.86
            visible: false
            color:                      "#DDDDFF"
            opacity :                   0.95;   //透明度
            border.color:               "black"
            border.width:               1
            Text {
                text: "数据补发过程中请勿进行其他操作"
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                font.bold: true
                font.pointSize: 30
            }
        }

        Rectangle {
            id: readtxttosend
            color: cProgress.isRunning() ? "#FF0099" : "#663399"
            radius: 5
            x: myAddBackground.width  * 0.43
            y: myAddBackground.height  * 0.01
            width: myAddBackground.width  * 0.1
            height: user_id.height
            anchors.verticalCenter: user_id.verticalCenter
            Text {
//                text: "补发数据"
                text: cProgress.isRunning() ? qsTr("正在补发") : qsTr("补发数据")
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                font.bold: true
                font.pointSize: 14
            }

            MouseArea{
                anchors.fill: parent
                z: parent.z
//                onClicked: {
////                    progressBar1._useHide = true
//                    DATA.readtxttosend()
////                        progressBar1.onStart();
//                }

                onClicked: {
                    // DATA.readtxttosend()
                    if (cProgress.isRunning()){
                        cProgress.onPause();
                    }else{
                        if(DATA.isNetWorkOnline()){
                            cProgress.onStart();
                            theworker.start(); // 开启线程
                        }
                    }
                }
            }
        }

        ProgressBar {
            property color proColor: "#148014"
            property color proBackgroundColor: "#AAAAAA"
            property int proWidth: 2
            property real progress: 0
            property real proRadius: 3
            property alias interval: timer.interval

            function isRunning(){
                return(timer.running)
            }

            function onStart(){
                cProgress.progress = 0;
                timer.running = true;
                shieldingcover.visible = true;
                //DATA.readtxttosend()
            }

            function onPause(){
//                timer.running = false;
                //theworker.stop()
                //return(DATA.readtxttosend())
            }

            function onStop(){
                timer.running = false;
                shieldingcover.visible = false;
            }

            id: cProgress
            x: myAddBackground.width  * 0.55
            y: myAddBackground.height  * 0.01
            width: myAddBackground.width  * 0.35
            height: user_id.height
//            value: (progress/100)
            value: progress
            padding: 2
            from: 0.0
            to:100.0

            background: Rectangle {
                implicitWidth: 200
                implicitHeight: 16
                color: cProgress.proBackgroundColor
                radius: cProgress.proRadius
            }

            contentItem: Item {
                implicitWidth: 200
                implicitHeight: 10

                Rectangle {
                    width: cProgress.visualPosition * parent.width
                    height: parent.height
                    radius: 2
                    color: cProgress.proColor
                    Text {
                        id: cProgressText
                        anchors.left: parent.right;
                        anchors.leftMargin: 10
                        anchors.verticalCenter: parent.verticalCenter;
                        text: (cProgress.value).toFixed(1)+"%";
                        color: "#345684"
                        font.pointSize: selfFontSize
                    }
                }
            }

            Timer{
                id: timer
                running: false
                repeat: true
                interval: 100
                onTriggered:{
//                    cProgress.progress++;
//                    if (cProgress.progress >= 100)
                    if (DATA.msg_value()===1||DATA.msg_value()===2||DATA.msg_value()===3){
                        cProgress.progress = DATA.progressBar_value()
                        cProgress.onStop();
                        DATA.readtxttosend_msg();
                        return;
                    }else{
                        cProgress.progress = DATA.progressBar_value()
                    }
                }
            }

//            Connections {  //连接的目标不在QML中
//                    target: theworker  //指向发出信号的对象
//                    onStarted: {
//                        print('线程开启')
//                    }

//                    onDataChanged: {
//                        print('计时改变: ' + theworker.getData() );
//                        cProgress.progress = theworker.getData();
//                    }
//                }

//                Component.onDestruction: theworker.terminate();

        }

//        ProgressBar {

//            id: progressBar1
//            x: myAddBackground.width  * 0.55
//            y: myAddBackground.height  * 0.01
//            width: myAddBackground.width  * 0.35
//            height: user_id.height
//            visible: progressBar1._useHide
//            property bool _useHide: false
//            property alias interval: timer.interval

//            function isRunning(){
//                    return(timer.running)
//                }

//                function onStart(){
//                    timer.running = true;
//                }

//                function onStop(){
//                    timer.running = false;
//                }

//            maximumValue: 100
//            minimumValue: 0
//            style: ProgressBarStyle{
//                background: Rectangle{
//                    implicitWidth: 200;
//                    implicitHeight: 20;
//                    border.width: 1;
//                    border.color: control.hovered ? "green":"gray";
//                    color:"#e1e1e1";
//                }
//                progress: Rectangle{
//                    color: "#8e7cc3"
//                    Text {
//                        id: progressBar1Text
//                        anchors.left: parent.right;
//                        anchors.leftMargin: 10
//                        anchors.verticalCenter: parent.verticalCenter;
//                        text: (progressBar1.value).toFixed(1)+"%";
//                        color: "#345684"
//                        font.pointSize: selfFontSize
//                    }
//                }
//            }
//            Timer{
//                id: timer
//                running: false
//                repeat: true
//                interval: 50
//                onTriggered:{
//                    progressBar1.value = DATA._progressBar
//                    if (progressBar1.value >= 100){
//                        progressBar1.onStop();
//                        return;
//                    }
//                }
//            }
//        }

         Rectangle {
                id:     workrecordtotal
                width:  myAddBackground.width  * 0.55
                height: myAddBackground.height  * 0.16
                anchors.bottom: workrecord.top
                anchors.left: workrecord.left
                color: "white"
                border.color: "Purple"


                Column {
                    id:                 totalcolumn
                    anchors.fill: parent
                    spacing: 15
                    anchors.left: parent.left
                    anchors.leftMargin: 20
                    anchors.top: parent.top
                    anchors.topMargin: 25

                    Repeater {
                        id:     totalrepeater
                        model:  3  //为重复器提供的数据模型，类型是any
                        //类型是数字的话，代表要重复器要创建的数量


                        property real totalArea: 0
                        property var totalFlights: 0

                        property var totalNames:  [ "作业总面积 ", "飞行总架次 "]
                        property var totalValues: [totalArea.toFixed(2), totalFlights]
                        property var totalUnits: ["亩", "架次"]     //"m²"

                        delegate:Row{
                            id: totalrow
                            spacing: 10
                            Label {
                                color:                            "#424200"
                                horizontalAlignment:              Text.AlignHCenter
                                font.pointSize:                   12
                                text:                             totalrepeater.totalNames[index]
                                font.bold:                        true
                            }
                            Label {
                                color:                            "#336666"
                                horizontalAlignment:              Text.AlignHCenter
                                font.pointSize:                   13
                                text:                             totalrepeater.totalValues[index]
                                font.bold:                        true
                            }
                            Label {
                                color:                            "#424200"
                                horizontalAlignment:              Text.AlignHCenter
                                font.pointSize:                   12
                                text:                             totalrepeater.totalUnits[index]
                                font.bold:                        true
                            }
                        }
                    }

                }

            }


         Rectangle {
             id:     workrecord
             x: myAddBackground.width  * 0.42
             y: myAddBackground.height  * 0.26
             width:  myAddBackground.width  * 0.55
             height: myAddBackground.height  * 0.7


             ListView {
                 id: recordlistView
                 clip: true
                 anchors.fill: parent
                 maximumFlickVelocity:7000  //设置滑动的最大速度

                 property bool refreshFlag: false
                 //                         ScrollBar.vertical: ScrollBar {       //滚动条
                 //                             anchors.right: lview.left
                 //                             width: 50
                 //                             active: true
                 //                             background: Item {            //滚动条的背景样式
                 //                                 Rectangle {
                 //                                     anchors.centerIn: parent
                 //                                     height: parent.height
                 //                                     width: parent.width * 0.2
                 //                                     color: 'grey'
                 //                                     radius: width/2
                 //                                 }
                 //                             }

                 //                             contentItem: Rectangle {
                 //                                 radius: width/3        //bar的圆角
                 //                                 color: 'yellow'
                 //                             }
                 //                         }

                 // 滚动条
                 Rectangle {
                     id: scrollbar
    //                    x: 400
    //                    y:0
                     anchors.right: recordlistView.right
                     width: recordlistView.width * 0.05
                     height: parent.height
                     color: "#ccbfbf"
                     radius: 10

                     // 按钮
                     Rectangle {
                         id: button
                         x: 0
                         y: recordlistView.visibleArea.yPosition * scrollbar.height
                         width: parent.width
                         height: recordlistView.visibleArea.heightRatio * scrollbar.height;
                         color: "#818b81"
                         radius: 10

                         // 鼠标区域
                         MouseArea {
                             id: mouseArea
                             anchors.fill: button
                             drag.target: button
                             drag.axis: Drag.YAxis
                             drag.minimumY: 0
                             drag.maximumY: scrollbar.height - button.height

                             // 拖动
                             onMouseYChanged: {
                                 recordlistView.contentY = button.y / scrollbar.height * recordlistView.contentHeight
                             }
                         }
                     }
                 }

                 BusyIndicator{
                     id:busy
                     z:4
                     running: false
                     anchors.horizontalCenter: parent.horizontalCenter
                     anchors.top: parent.top
                     anchors.topMargin: parent.height/3.
                     Timer{
                         interval: 2000
                         running: busy.running
                         onTriggered: {
                             busy.running = false
                         }
                     }
                 }


                 Rectangle{
                     width: parent.width
                     height: -recordlistView.contentY
                     color: "cyan"
                     clip: true
                     Label{
                         anchors.centerIn: parent
                         text:"下拉刷新"
                         visible: recordlistView.contentY
                     }
                 }



                 onContentYChanged: {
                     if(-contentY > 200){
                         refreshFlag = true
                     }
                 }
                 onMovementEnded: {
                     if(refreshFlag){
                         refreshFlag = false

                         //202203注释  暂时取消飞行架次列表
                         addModelData(SENDDATA.get_playback(),SENDDATA.get_playback_length())

                     }
                 }

                 onCurrentIndexChanged: {
                     console.log("current index = ",currentIndex)
                 }

                   //选中突亮功能
    //                highlight: Rectangle {
    //                    width: recordlistView.width
    //                    height: 60
    //                    color: "lightsteelblue"
    ////                    color:index%2?"green":"lightsteelblue"
    //                    radius: 5

    //                    //动画
    //                    Behavior on y {
    //                        SpringAnimation {
    //                            spring: 3
    //                            damping: 0.2
    //                        }
    //                    }
    //                }
    //                highlightFollowsCurrentItem: true
    //                focus: true


                 model: ListModel{
                             id:listModel

                         }


//                 Component.onCompleted: {
//                         addModelData(SENDDATA.get_playback(),SENDDATA.get_playback_length())
//                         //                    addModelData("17862898501","2020-12-19 14:14:31","00:02:10","0.00m²","1.0l/亩","0.00L","00430058","4.0m","其他")
//                 }

                 delegate: Rectangle {
                     id:btn
                     width: recordlistView.width * 0.95
                     height: 120

                     radius: 5

                     border.width:1
                     color: model.selected==="true"?"LightGreen":"transparent"
    //                    color: recordListView.isCurrentItem ? "LightGreen" : "transparent"
    //                    property color tempcolor: "transparent"
    //                    color: tempcolor
//                     state: "stopState"
//                     states: [
//                                State{
//                                    name: "runState"
//                                    PropertyChanges{
//                                        target: btn; color:"LightGreen"
//                                    }
//                                },
//                                State{
//                                    name: "stopState"
//                                    PropertyChanges{
//                                        target: btn; color:"transparent"
//                                    }
//                                }
//                            ]

//                     transitions: [
//                             Transition {
//                                 from: "stopState"
//                                 to: "runState"
//                                 ColorAnimation { targets: btn; duration: 2000 }
//                             },
//                             Transition {
//                                 from: "runState"
//                                 to: "stopState"
//                                 ColorAnimation { targets: btn; duration: 2000 }
//                             }
//                         ]

                     Item {
                         id: row1
                         anchors.fill: parent
    //                        spacing: 10
                         anchors.leftMargin: 10

                         Text {
                             id:startTime
                             text: model.starttime          //起始时间
                             anchors.verticalCenter: parent.verticalCenter
                             font.bold: true
                             font.pointSize: 12
                         }

                         Column{
                             anchors{
                                 left:startTime.right
                                 leftMargin: row1.width*0.06
    //                                top: parent.top
                                 verticalCenter: parent.verticalCenter
    //                                topMargin:12
                             }

                             spacing: 10

                             Label{
                                 text: model.useradmin               //用户id
    //                                font.pixelSize: fontSizeMedium
                                 font.pointSize: 10
                             }
                             Label{
                                 text: model.cropspecies        //作物类型
    //                                font.pixelSize: fontSizeMedium
                                 font.pointSize: 10
                             }
                         }

                         Column{
                             anchors{
                                 left: startTime.right
                                 leftMargin: row1.width*0.28
    //                                top: parent.top
                                 verticalCenter: parent.verticalCenter
    //                                topMargin:12
                             }

                             spacing: 10

                             Label{
                                 text: model.sprayingarea              //作业亩数
    //                                font.pixelSize: fontSizeMedium
                                 font.pointSize: 10
                             }
                             Label{
                                 text: model.flighttime          //作业用时
    //                                font.pixelSize: fontSizeMedium
                                 font.pointSize: 10
                             }
                         }

                     Rectangle{

                         id:details
                         z: parent.z + 2
                         width: row1.width*0.16
                         height: row1.height*0.8
                         color:"gray";
                         radius: 5
                         anchors{
                             right: parent.right
                             rightMargin: row1.width*0.04
                             verticalCenter: parent.verticalCenter
                         }
                             Text {
                                 text: "详情"
                                 anchors.verticalCenter: parent.verticalCenter
                                 anchors.horizontalCenter: parent.horizontalCenter
                                 font.bold: true
                                 font.pointSize: 12
                             }

                             MouseArea{
                             anchors.fill: parent

                             z: parent.z
                             onClicked: {
    //                                  recordlistView.showmyAddDetails();
                                 var compLogin = Qt.createComponent("MyAddDetails.qml")
                                             .createObject(workrecord, {
    //                                                              x:0,
    //                                                              y:0,
    //                                                              width:                      workrecord.width,
    //                                                              height:                     workrecord.height,
                                                           });

                                 }

                             }

    //                            function showmyAddDetails() {
    //                     //           viewSwitch(false)
    //                                var flag = false;
    //                                if(!flag){
    //                                myAddDetails.visible = true
    //                                    }
    //                                else{
    //                                myAddDetails.visible = flase
    //                                    }
    //                            }

    //                            Loader
    //                            {
    //                                id: myAddDetails
    //                                anchors.fill: parent
    //                                visible: false
    //                                source: "MyAddDetails.qml"
    //                            }

                         }

                     MouseArea{
                         id: mouseArea1
                         anchors.fill: parent
                         propagateComposedEvents: true
    //                        hoverEnabled: true

    //                        acceptedButtons: Qt.LeftButton | Qt.RightButton
                         onClicked: {

    //                            if (mouse.button == Qt.LeftButton){
    //                                            color = "red"
    //                                         }else if (mouse.button == Qt.RightButton){
    //                                             Qt.quit();
    //                                        }

//202203注释  暂时取消飞行架次列表

                             if(model.selected === "false")
                                 {
//                                     btn.state = "runState"
                                     appendIdem(index)
                                     totalrepeater.totalFlights = totalrepeater.totalFlights + 1
                                     totalrepeater.totalArea = totalrepeater.totalArea + SENDDATA.qstring_to_double(model.sprayingarea)
                                     SENDDATA._startTime_index = model.starttime
                                     console.log("startTime_index = ",SENDDATA._startTime_index)
                                     editorMap.populateBorder(SENDDATA.get_playbackroute(),SENDDATA.get_playbackroute_length())

                                 }
                             else
                                 {
//                                     btn.state = "stopState"
                                     appendIdem2(index)
                                     totalrepeater.totalFlights = totalrepeater.totalFlights - 1
                                     totalrepeater.totalArea = totalrepeater.totalArea - SENDDATA.qstring_to_double(model.sprayingarea)
                                     groupPolyline.path =[]
                                 }


                             recordlistView.currentIndex = index
                             mouse.accepted = false
                         }

//                           //进入变色
//    //                        onEntered: {
//    //                            tempcolor = "#a7e094"
//    //                        }
//                           //退出变色
//    //                        onExited: {
//    //                            tempcolor = "transparent"
//    //                        }

                         }
                     }

                 }

             }

         }

         function appendIdem(index)
         {
             console.log("append item")
             listModel.set(index,{"selected":"true"})
         }
         function appendIdem2(index)
         {
             console.log("append item")
             listModel.set(index,{"selected":"false"})
         }

         function addModelData(list,length){

             busy.running = true
             listModel.clear()

             var num = length/9
//             for(var i = 0 ; i < num ; i++){
             for(var i = (num - 1) ; 0 <= i ; i--){
  //                  listModel.append({"starttime":list[1],"useradmin":list[0],"sprayingarea":list[3],"flighttime":list[2],"cropspecies":list[8]})
                    listModel.append({"useradmin":list[i*9+0],"starttime":list[i*9+1],"flighttime":list[i*9+2],"sprayingarea":list[i*9+3],"dosageofmu":list[i*9+4],"dosage":list[i*9+5],"flightcontrolnumber":list[i*9+6],"flightdisance":list[i*9+7],"cropspecies":list[i*9+8],"selected":"false"})
  //                  listModelcoord.append({"latitude":list[i*11+10],"longitude":list[i*11+9]})
                }
             totalrepeater.totalFlights = 0
             totalrepeater.totalArea = 0
            }

         function reflesh(){
             console.log('load');
             if (recordlistView.headerItem != null)
                 recordlistView.headerItem.goState('load');
             clear();
             recordlistView.load(this);
             recordlistView.onModelChanged();
             moveToHeader();
             currentPage = 0;
         }
         function loadMore(){
             console.log('load more');
             currentPage++;
             recordlistView.loadMore(this, currentPage);
             recordlistView.onModelChanged();
         }


       //Map
       Item {
           id:             panel
//           anchors.fill:   parent
           x: myAddBackground.width  * 0.01
           y: myAddBackground.height  * 0.1
           width:  myAddBackground.width  * 0.4
           height: myAddBackground.height  * 0.7

//           property int hoverIndex: -1

           FlightMap {
               id:                         editorMap
               anchors.fill:               parent
               mapName:                    "MissionEditor"
               allowGCSLocationCenter:     true
               allowVehicleLocationCenter: true
               planView:                   true

               zoomLevel:                  QGroundControl.flightMapZoom
               center:                     QGroundControl.flightMapPosition

               // This is the center rectangle of the map which is not obscured by tools
               property rect centerViewport:   Qt.rect(_leftToolWidth + _margin, _toolsMargin, editorMap.width - _leftToolWidth - _rightToolWidth - (_margin * 2), mapScale.y - _margin - _toolsMargin)

               property real _leftToolWidth:       toolStrip.x + toolStrip.width
               property real _rightToolWidth:      rightPanel.width + rightPanel.anchors.rightMargin

               // Initial map position duplicates Fly view position
               Component.onCompleted: editorMap.center = QGroundControl.flightMapPosition

               QGCMapPalette { id: mapPal; lightColors: editorMap.isSatelliteMap }

               onZoomLevelChanged: {
                   QGroundControl.flightMapZoom = zoomLevel
//                   updateAirspace(false)
               }
               onCenterChanged: {
                   QGroundControl.flightMapPosition = center
//                   updateAirspace(false)
               }

               MouseArea {
                   anchors.fill: parent
                   onClicked: {
                       // Take focus to close any previous editing
                       editorMap.focus = true
                       var coordinate = editorMap.toCoordinate(Qt.point(mouse.x, mouse.y), false /* clipToViewPort */)
                       coordinate.latitude = coordinate.latitude.toFixed(_decimalPlaces)
                       coordinate.longitude = coordinate.longitude.toFixed(_decimalPlaces)
                       coordinate.altitude = coordinate.altitude.toFixed(_decimalPlaces)

                       switch (_editingLayer) {
                       case _layerMission:
                           if (_addWaypointOnClick) {
                               insertSimpleItemAfterCurrent(coordinate)
                           } else if (_addROIOnClick) {
                               _addROIOnClick = false
                               insertROIAfterCurrent(coordinate)
                           }

                           break
                       case _layerRallyPoints:
                           if (_rallyPointController.supported && _addWaypointOnClick) {
                               _rallyPointController.addPoint(coordinate)
                           }
                           break
                       }
                   }
               }


                            // Incomplete segment lines
               MapItemView {
                   id:mapView
//                   model: ListModel{
//                       id:listModelcoord
//                   }
                   delegate:groupPolyline
                       //                             Component.onCompleted: {
                       //                                 populateBorder(SENDDATA.get_playbackroute(),SENDDATA.get_playbackroute_length())
                       //                                 }
               }

               MapPolyline {
                   id: groupPolyline
                   line.color: "red"
                   line.width: 3
                   //                       z:          QGroundControl.zOrderWaypointLines

           }

               function populateBorder(list,length) {
        //                           groupPolyline.path = [] // clearing the path
                   var lines = []
                   var num = length/2
                   for(var i = 0 ; i < num ; i++){
        //                        groupPolyline.addCoordinate({latitude:list[i*11+10],longitude:list[i*11+9]});
        //                                 listModelcoord.append({latitude:list[i*11+10],longitude:list[i*11+9]});
        //                                 item_model.append({"latitudeval":list[i*11+10],"longitudeval":list[i*11+9]});
                      lines[i] = {latitude:list[i*2+1],longitude:list[i*2]}
                                  }
                   groupPolyline.path = lines
//                               listModelcoord.append(index,{"lines":lines[i]})
//                             console.log(lines);
                   editorMap.center = getPolygonCenter(groupPolyline.path)
                   editorMap.zoomLevel = 14
                   }

               //计算区域中心点
               function getPolygonCenter(path){
                   let path_len=path.length;
                   if(path_len<1)
                       return QtPositioning.coordinate(37.539297,121.391382);
                   let X=0;
                   let Y=0;
                   let Z=0;
                   let lat,lon,x,y,z;
                   for(let i=0;i<path_len;i++){
                       lat = path[i].latitude * Math.PI / 180;
                       lon = path[i].longitude * Math.PI / 180;
                       x = Math.cos(lat) * Math.cos(lon);
                       y = Math.cos(lat) * Math.sin(lon);
                       z = Math.sin(lat);
                       X += x;
                       Y += y;
                       Z += z;
                   }
                   X = X / path_len;
                   Y = Y / path_len;
                   Z = Z / path_len;
                   let Lon = Math.atan2(Y, X);
                   let Hyp = Math.sqrt(X * X + Y * Y);
                   let Lat = Math.atan2(Z, Hyp);
                   return QtPositioning.coordinate(Lat * 180 / Math.PI, Lon * 180 / Math.PI);
               }

//                         function remove_populateBorder(list,length) {
//                  //                           groupPolyline.path = [] // clearing the path
//                             var lines = []
//                             var num = length/2
//                             for(var i = 0 ; i < num ; i++){
//                  //                        groupPolyline.addCoordinate({latitude:list[i*11+10],longitude:list[i*11+9]});
//                  //                                 listModelcoord.append({latitude:list[i*11+10],longitude:list[i*11+9]});
//                  //                                 item_model.append({"latitudeval":list[i*11+10],"longitudeval":list[i*11+9]});
//                                 lines[i] = {latitude:list[i*2+1],longitude:list[i*2]}
//                                }
//                              groupPolyline.path = groupPolyline.path - lines
//                             console.log(lines);

//                         }

//                         Connections{
//                             target: mouseArea1  //C++中获得数据后发送信号
//                             onClicked:{

//                                 if(btn.state == "runState")
//                                     {
//                                         groupPolyline.path = lines
//                                     }
//                                 else
//                                     {
//                                         groupPolyline.path = []


//                                     }


//                                 listView.currentIndex = index
//                                 mouse.accepted = false

//                             }
//                         }


//               MapItemView{
//                   id: map_itemview
////                   model: ABoundaryModel{
////                       id: map_itemmodel
////                   }
//               model: ListModel {
////                       id: list_model
//                       id: map_itemmodel

////                       property var geometries: {
////                           "A区":[
////                                       QtPositioning.coordinate(30.773889148239068, 104.07235961913943),
////                                       QtPositioning.coordinate(30.836404695997977, 103.91168457030699),
////                                       QtPositioning.coordinate(30.638102489849622, 103.77160888672023),
////                                       QtPositioning.coordinate(30.489108430341894, 103.92816406249955),
////                                       QtPositioning.coordinate(30.483191250167938, 104.14377075195387),
////                                       QtPositioning.coordinate(30.654643253330736, 104.01330810546443),
////                                       QtPositioning.coordinate(30.773889148239068, 104.07235961913943)
////                                   ],
////                           "B区":[
////                                       QtPositioning.coordinate(30.863521425780851, 104.17672973631898),
////                                       QtPositioning.coordinate(30.821074458508345, 104.34427124022659),
////                                       QtPositioning.coordinate(30.646373225245725, 104.30993896485052),
////                                       QtPositioning.coordinate(30.483191250167938, 104.14377075195387),
////                                       QtPositioning.coordinate(30.654643253330736, 104.01330810546443),
////                                       QtPositioning.coordinate(30.773889148239068, 104.07235961913943),
////                                       QtPositioning.coordinate(30.863521425780851, 104.17672973631898)
////                                   ]
////                       }

////                       ListElement {
////                           itemName: "A区"
////                           itemId: 1
////                       }
////                       ListElement {
////                           itemName: "B区"
////                           itemId: 2
////                       }
//                   }
//                   //MapPolygon的边框有Bug，所以还是用折线来画，但是务须让首尾相连
//                   delegate: MapItemGroup{
////                       MapPolygon{
////                           id: item_polygon
////                           path: map_itemmodel.geometries[itemName]
////                           color: (control.hoverId===itemId)
////                                  ?Qt.rgba(1,0,0,0.5):Qt.rgba(0,1,0,0.5)
////                           MouseArea{
////                               anchors.fill: parent
////                               onClicked: control.hoverId=itemId;

////                               Text{
////                                   anchors.centerIn: parent
////                                   text: itemName
////                                   color: "green"
////                                   font{
////                                       pixelSize: 25
////                                   }
////                               }
////                           }
////                       }
//                       MapPolyline{
//                           id: item_polyline
////                           path: map_itemmodel.geometries[itemName]
//                           line.width: 2
//                           line.color: "green"
//                       }
//                   }//end delegate
//               }

//               MapItemView{
//                   id: map_itemview
//                   //Cpp扩展的model，只有坐标点，还没写其他信息
//                   model: ListModel{
//                       id: map_itemmodel
//                   }
//                   //MapPolygon的边框有Bug，所以还是用折线来画，但是务须让首尾相连
//                   delegate: MapItemGroup{
////                       MapPolygon{
////                           id: item_polygon
////                           function fromLatAndLong(latList, longList) {
////                               let the_path=[];
////                               if(latList.length!==longList.length)
////                                   return the_path;
////                               for (let i=0; i<latList.length; i++) {
////                                   the_path.push( QtPositioning.coordinate(latList[i],longList[i]) );
////                               }
////                               return the_path;
////                           }
////                           //QList<coordxxx>不能直接和qml交互，so
////                           path: fromLatAndLong(map_itemmodel.getLatitudes(index),
////                                                map_itemmodel.getLongitudes(index))
////                           //随机颜色，貌似飞地颜色也不一样了，待解决
////                           color: Qt.hsla(Math.random(),0.9,0.3,1)
////                           opacity: (control.hoverIndex===map_itemmodel.getId(index))?0.8:0.4
////                           MouseArea{
////                               anchors.fill: parent
////                               onClicked: control.hoverIndex=map_itemmodel.getId(index);
////                           }
////                       }
//                       MapPolyline{
//                           id: item_polyline
//                           //                           path: item_polygon.path
//                           function fromLatAndLong(latList, longList) {
//                               let the_path=[];
////                               if(latList.length!==longList.length)
////                                   return the_path;
//                               for (let i=0; i<latList.length; i++) {
//                                   the_path.push( QtPositioning.coordinate(latList[i],longList[i]) );
//                               }
//                               return the_path;
//                           }
//                           //QList<coordxxx>不能直接和qml交互，so
//                           path: fromLatAndLong(map_itemmodel.getLatitudes(index),
//                                                map_itemmodel.getLongitudes(index))
//                           line.width: 2
//                           line.color: "black"
//                       }
//                   }//end delegate
//               }

//               function populateBorder(index,list,length) {
//        //                           groupPolyline.path = [] // clearing the path
//                   var lines = []
//                   var num = length/2
//                   for(var i = 0 ; i < num ; i++){
//        //                        groupPolyline.addCoordinate({latitude:list[i*11+10],longitude:list[i*11+9]});
//        //                                 listModelcoord.append({latitude:list[i*11+10],longitude:list[i*11+9]});
//        //                                 item_model.append({"latitudeval":list[i*11+10],"longitudeval":list[i*11+9]});
//                      lines[i] = {latitude:list[i*2+1],longitude:list[i*2]}
////                       lines.push( QtPositioning.coordinate(list[i*2+1],list[i*2]) );
//                                  }
//                   item_polyline.path = lines
////                               listModelcoord.append(index,{"lines":lines[i]})
////                             console.log(lines);

//                   editorMap.center = getPolygonCenter(item_polyline.path)
//                   editorMap.zoomLevel = 14
//                   }

//               //计算区域中心点
//               function getPolygonCenter(path){
//                   let path_len=path.length;
//                   if(path_len<3)
//                       return QtPositioning.coordinate(0,0);
//                   let X=0;
//                   let Y=0;
//                   let Z=0;
//                   let lat,lon,x,y,z;
//                   for(let i=0;i<path_len;i++){
//                       lat = path[i].latitude * Math.PI / 180;
//                       lon = path[i].longitude * Math.PI / 180;
//                       x = Math.cos(lat) * Math.cos(lon);
//                       y = Math.cos(lat) * Math.sin(lon);
//                       z = Math.sin(lat);
//                       X += x;
//                       Y += y;
//                       Z += z;
//                   }
//                   X = X / path_len;
//                   Y = Y / path_len;
//                   Z = Z / path_len;
//                   let Lon = Math.atan2(Y, X);
//                   let Hyp = Math.sqrt(X * X + Y * Y);
//                   let Lat = Math.atan2(Z, Hyp);
//                   return QtPositioning.coordinate(Lat * 180 / Math.PI, Lon * 180 / Math.PI);
//               }


              MapItemView {
                         MapPolyline {
                             line.width: 3
                             line.color: 'green'
                             path: [
                                 { latitude: -27, longitude: 153.0 },
                                 { latitude: -27, longitude: 154.1 },
                                 { latitude: -28, longitude: 153.5 },
                                 { latitude: -29, longitude: 153.5 }
                             ]
                         }
                         MapPolyline {
                             line.width: 3
                             line.color: 'red'
                             path: [
                                 { latitude: -29, longitude: 157.0 },
                                 { latitude: -29, longitude: 158.1 },
                                 { latitude: -30, longitude: 157.5 },
                                 { latitude: -31, longitude: 157.5 }
                             ]
                         }
                   }

             }
       }
}


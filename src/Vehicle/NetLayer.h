#ifndef NETLAYER_H
#define NETLAYER_H

#include <QObject>
#include <QTcpSocket>
#include "setting.h"
#include <QFile>
#include <QThread>
#include <QDataStream>
class NetLayer : public QObject
{
    Q_OBJECT
public:
    explicit NetLayer(QObject *parent = nullptr);
    const static int PACKET_SIZE      = 1024;//每次发送的字节数
    const static int PACKET_HEAD_SIZE = 10;  //协议字节数
    const QString IP = Setting::getSetting()->getvalue("NetConfig/IP").toString();
    const int Port   = Setting:: getSetting()->getvalue("NetConfig/Port").toInt();
private:
public slots:
    //Task
    //发送飞行日志到后台
    void SendBinLogFile();
    //Task
    //void SendData();
signals:
    void resultReady();
};

#endif // NETLAYER_H

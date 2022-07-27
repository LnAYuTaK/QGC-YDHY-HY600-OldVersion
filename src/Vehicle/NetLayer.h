#ifndef NETLAYER_H
#define NETLAYER_H

#include <QObject>
#include "TcpSocket.h"
#include <QFile>
class NetLayer : public QObject
{
    Q_OBJECT
public:
    explicit NetLayer(QObject *parent = nullptr);
    TcpSocket NetSocket;
    const static int PACKET_SIZE      = 1024;//每次发送的字节数
    const static int PACKET_HEAD_SIZE = 10;  //协议字节数
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

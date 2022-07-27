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
    const static int PACKET_SIZE      = 1024;//ÿ�η��͵��ֽ���
    const static int PACKET_HEAD_SIZE = 10;  //Э���ֽ���
public slots:
    //Task
    //���ͷ�����־����̨
    void SendBinLogFile();

    //Task
    //void SendData();

signals:
    void resultReady();

};

#endif // NETLAYER_H

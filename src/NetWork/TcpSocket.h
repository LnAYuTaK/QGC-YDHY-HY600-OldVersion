#ifndef TCPSOCKET_H
#define TCPSOCKET_H

#include <QThread>
#include <QTcpSocket>
#include "setting.h"
class TcpSocket : public QThread
{
public:
    QString IP = Setting::getSetting()->getvalue("NetConfig/ip").toString();
    int Port = Setting::getSetting()->getvalue("NetConfig/port").toInt();
    explicit TcpSocket(QObject *parent = nullptr);
    QTcpSocket * mClient=nullptr;
    bool mConnect(QString,int);

    bool WriteBytes(QByteArray buffer);
    bool isClientConnect();
    void run();

private:
     bool SokcetisConnect = false;

};

#endif // TCPSOCKET_H

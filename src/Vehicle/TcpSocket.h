#ifndef TCPSOCKET_H
#define TCPSOCKET_H

#include <QThread>
#include <QTcpSocket>
#include "setting.h"
#include <QTimer>
#include <QObject>
class TcpSocket : public QObject
{
     Q_OBJECT
public:
    explicit TcpSocket(QObject *parent = nullptr);
    QTcpSocket * mClient=nullptr;
    QString IP = Setting::getSetting()->getvalue("NetConfig/ip").toString();
    int Port = Setting::getSetting()->getvalue("NetConfig/port").toInt();
    bool SokcetisConnect = false;

    QTimer *LinkTimer;
    bool Connect();
    bool ReConnect ();
    void  WriteBytes(char *buffer,qint64 bufsize);
public slots:
    void CheckLinkState();




private:

};

#endif // TCPSOCKET_H

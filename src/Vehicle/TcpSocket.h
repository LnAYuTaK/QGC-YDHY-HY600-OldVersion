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
    QTimer *LinkTimer;
    bool SokcetisConnect = false;

    bool ReConnect ();
    void  WriteBytes(char *buffer,qint64 bufsize);

    const QString IP = Setting::getSetting()->getvalue("NetConfig/ip").toString();
    const int Port = Setting::getSetting()->getvalue("NetConfig/port").toInt();

public slots:
    bool Connect();
    void CheckLinkState();




private:

};

#endif // TCPSOCKET_H

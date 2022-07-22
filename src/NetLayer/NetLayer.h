#ifndef NETLAYER_H
#define NETLAYER_H

#include <QObject>
#include <QTcpSocket>
#include <QFile>
#include <QThread>
#include <QDataStream>
#define SerIP  "192.168.3.113"

#define SerPort  8900
class NetLayer : public QObject
{
    Q_OBJECT
public:
    explicit NetLayer(QObject *parent = nullptr);
private:
public slots:
    //Task
    //???????????????
    void SendBinLogFile(QString);
    //Task
    //void SendData();
signals:
    void LogSendSuccess();
    void LogSendFail();
};

#endif // NETLAYER_H

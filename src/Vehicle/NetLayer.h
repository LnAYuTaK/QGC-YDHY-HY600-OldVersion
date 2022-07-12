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
private:
    const QString IP = Setting::getSetting()->getvalue("NetConfig/IP").toString();
    const int Port   = Setting:: getSetting()->getvalue("NetConfig/Port").toInt();
public slots:
    //Task
    //???????????????
    void SendBinLogFile();
    //Task
    //void SendData();
signals:
    void resultReady();
};

#endif // NETLAYER_H

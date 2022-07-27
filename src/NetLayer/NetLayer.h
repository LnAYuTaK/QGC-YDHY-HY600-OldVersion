#ifndef NETLAYER_H
#define NETLAYER_H

#include <QObject>
#include <QTcpSocket>
#include <QFile>
#include <QThread>
#include <QDataStream>
#include <QCryptographicHash>
#include <QTime>
#include "data.h"
#include "Helper/HySettings.h"
class NetLayer : public QObject
{
    Q_OBJECT
public:
    explicit NetLayer(QObject *parent = nullptr);
    //任务定时器
    QTimer*  TaskTimeOut ;
    //回复给QML显示的错误类型枚举
private:
    //获取Setting指针
    HySettings *Setting;
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

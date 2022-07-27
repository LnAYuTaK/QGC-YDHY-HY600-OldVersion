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
    //����ʱ��
    QTimer*  TaskTimeOut ;
    //�ظ���QML��ʾ�Ĵ�������ö��
private:
    //��ȡSettingָ��
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

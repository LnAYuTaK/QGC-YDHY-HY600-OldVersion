#ifndef NETMANAGE_H
#define NETMANAGE_H
#include <QTcpSocket>
#include <QObject>
//#include "TcpSocket.h"
#include "NetLayer.h"

class NetManage :public QObject
{
     Q_OBJECT
public:
    static NetManage * getManage();

    Q_INVOKABLE void SendLogFileEmit();
private:
    NetManage();
    NetManage(const NetManage&){}
    NetManage& operator=(const NetManage&other);
    static NetManage *s_instance;
    static NetLayer *m_layer;
    static QThread WorkThread;
    // ?????SendLogFile??????????????
signals:
    void SendLogFile();

};

#endif // NETMANAGE_H

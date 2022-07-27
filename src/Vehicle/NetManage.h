#ifndef NETMANAGE_H
#define NETMANAGE_H
#include <QTcpSocket>
#include <QObject>
//#include "TcpSocket.h"
#include "NetLayer.h"

//TestDefine
#define Testsend  1

class NetManage :public QObject
{
     Q_OBJECT
    static QThread WorkThread;
public:
    static NetManage * getManage();
    void SendLogFileEmit();
private:
    NetManage();
    NetManage(const NetManage&){}
    NetManage& operator=(const NetManage&other);
    static NetManage *s_instance;
    static NetLayer *m_layer;
signals:
    void SendLogFile(QString &);



};

#endif // NETMANAGE_H

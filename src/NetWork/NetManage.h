#ifndef NETMANAGE_H
#define NETMANAGE_H
#include <QTcpSocket>
//全局单例的NetManage作为网络管理
class NetManage
{

public:
    ~NetManage();
    static NetManage * getManage();
    static NetManage * connectLink();
    static NetManage * disconLink();
private:
    NetManage();
    NetManage(const NetManage&){}
    NetManage& operator=(const NetManage&other);
//全局可以获取
    static NetManage *s_instance;
    static QTcpSocket *m_socket;

};

#endif // NETMANAGE_H

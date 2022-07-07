#include "TcpSocket.h"

TcpSocket::TcpSocket(QObject *parent)
    : QThread{parent}
{
}

bool TcpSocket::mConnect(QString IP, int Port)
{
   mClient =new QTcpSocket();

   mClient->connectToHost(IP,Port);
   if(!mClient->waitForConnected(1000))
   {
         mClient->deleteLater();
         SocketisConnect =false;
         return false;
   }
   SocketisConnect =true;
   return true;
}

bool TcpSocket::WriteBytes(QByteArray buffer)
{

}

void  TcpSocket::mDisconnect()
{
    if(isClientConnect())
    {
       m_Client->disconnect();
    }
}

bool isClientConnect()
{
    return SokcetisConnect;
}








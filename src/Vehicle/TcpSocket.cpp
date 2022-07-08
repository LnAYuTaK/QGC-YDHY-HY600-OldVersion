#include "TcpSocket.h"

TcpSocket::TcpSocket(QObject *parent)
    :QObject{parent}
{
    LinkTimer =new QTimer(this);
    mClient =new QTcpSocket();
    connect(LinkTimer,SIGNAL(timeout()),this,SLOT(CheckLinkState()));
    LinkTimer->start();
}

void TcpSocket::CheckLinkState()
{
//    switch(mClient->state())
//    {
//        case 3:
//        qDebug()<<"已建立连接";
//            break;
//    }
}
//断线重连
bool TcpSocket::ReConnect()
{
   if(!SokcetisConnect){
   mClient->connectToHost(this->IP,this->Port);
   }
   else
   {
       if(!mClient->waitForConnected(500)){
         mClient->deleteLater();
         this->SokcetisConnect=false;
         return false;
       }
   }
   return  true;
}

void  TcpSocket::WriteBytes(char *buffer,qint64 bufsize)
{
    mClient->write(buffer,bufsize);
    qDebug()<<bufsize;
}

#if 0
void  TcpSocket::mDisconnect()
{
    if(isClientConnect())
    {
       m_Client->disconnect();
    }
}
#endif









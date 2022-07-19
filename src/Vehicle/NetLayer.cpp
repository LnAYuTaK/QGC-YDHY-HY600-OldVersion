#include "NetLayer.h"

NetLayer::NetLayer(QObject *parent)
    : QObject{parent}
{

}
//==================================================================
//函 数 名：  SendBinLogFile
//功能描述：  TCP发送BIN文件到后台服务器
//输入参数：
//返 回 值：  void
//作    者：  刘宽
//日    期：  2022 7/12 增加注释
//修改记录：
//==================================================================

void NetLayer::SendBinLogFile(/*QString filename*/)
{
    QTcpSocket *NetSocket = new QTcpSocket;
//    connect(NetSocket, SIGNAL(disconnected()), NetSocket, SLOT(deleteLater()));

    NetSocket->connectToHost(IP,Port);
    NetSocket->waitForConnected(3000);

    QFile m_file; 
    m_file.setFileName("../Config/Config.ini");
    //QFileInfo fileInfo(m_file);
    if ((NetSocket->state() != QAbstractSocket::ConnectedState) || (!m_file.open(QIODevice::ReadOnly)) ) {
         NetSocket->deleteLater();
        return;
    }
    QByteArray block;
    QDataStream out(&block, QIODevice::WriteOnly);
    out.setVersion(QDataStream::Qt_5_15);
    qDebug() << m_file.fileName();
    QByteArray filemsg = m_file.readAll();
    block.append(filemsg);
    m_file.close();
    out.device()->seek(0);
    out << (quint32)(block.size() - sizeof(quint32));
    qint64 x = 0;
    while (x < block.size()) {
        qint64 y = NetSocket->write(block);
        x += y;
        qDebug() << "Sendsize"<< x;
    }
}





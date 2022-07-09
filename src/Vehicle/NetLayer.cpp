#include "NetLayer.h"

NetLayer::NetLayer(QObject *parent)
    : QObject{parent}
{

}

void NetLayer::SendBinLogFile()
{
    QTcpSocket *NetSocket = new QTcpSocket;
//    connect(NetSocket, SIGNAL(disconnected()), NetSocket, SLOT(deleteLater()));

    NetSocket->connectToHost(IP,Port);
    NetSocket->waitForConnected(3000);
    qDebug()<< IP ;
    qDebug() << Port;
    QFile m_file;
    m_file.setFileName("/storage/emulated/0/DATALOG");
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





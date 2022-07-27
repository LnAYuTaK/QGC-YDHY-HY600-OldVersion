#include "NetLayer.h"

NetLayer::NetLayer(QObject *parent)
    : QObject{parent}
{

}



//==================================================================
//?? ?? ????  SendBinLogFile
//??????????  TCP????BIN??????????????
//?? ?? ???  void
//??    ???  2022 7/12 ???????
//???????2022 7/23 ????md5????
//==================================================================
void NetLayer::SendBinLogFile(QString filename)
{
    QTcpSocket *NetSocket = new QTcpSocket;
    QString IP =  HySettings::getSettings()->getNetValue("NET","IP").toString();
    qint64 Port = HySettings::getSettings()->getNetValue("NET","Port").toInt();
    qDebug()<< "Send" << filename << IP << Port;
    NetSocket->connectToHost(IP,Port);
    NetSocket->waitForConnected(2000);
    QFile m_file;
    m_file.setFileName(filename);
    if ((NetSocket->state() != QAbstractSocket::ConnectedState) || (!m_file.open(QIODevice::ReadOnly)) ) {
        qDebug() << "NerError";
         NetSocket->deleteLater();
         return;
    }
//    QByteArray block;
//    QDataStream out(&block, QIODevice::WriteOnly);
//    out.setVersion(QDataStream::Qt_5_12);
    QFileInfo fileInfo(filename);
    QString FileName = fileInfo.baseName();
    QByteArray filedata = m_file.readAll();
//    block.append(filedata);
//    m_file.close();
//    out.device()->seek(0);
//    out << (quint32)(block.size() - sizeof(quint32));
    //qint64 x = 0;
    //????MD5????
    QByteArray md5 = QCryptographicHash::hash(filedata, QCryptographicHash::Md5);
    //?FFFF +Md5?????+ UserID + ???????   //Hex
    QString ReqPack = "FFFF:"+md5.toHex()+':'+Data::userID+':'+FileName+"\n";
    qDebug() << ReqPack;
    qDebug() << md5.toHex();
    //??????????
    qint64 ReqPackSize = NetSocket->write(ReqPack.toLatin1());
    Q_UNUSED(ReqPackSize)
    qint64 sendsize = NetSocket->write(filedata);
    qDebug()<< sendsize;
//    while (x < block.size()){
//        qint64 y = NetSocket->write(block);
//        x += y;
//        qDebug() << "Sendsize"<< x;
//    }
    //?????????? ????????? ????????????? ???5?????????????????????????
    //????this??????
      TaskTimeOut =new QTimer(this);
      TaskTimeOut->setTimerType(Qt::PreciseTimer);
      TaskTimeOut->start(5000);
      while (TaskTimeOut->remainingTime()>0)
      {
          if (NetSocket->waitForReadyRead(10)){
              QByteArray replymsg =NetSocket->readAll();
               qDebug() << replymsg;
              if(replymsg == "OK"){
                emit LogSendSuccess();
                  return;
              }
              else{
                 emit LogSendFail();
                  return;
              }
           }
       }
     emit LogSendFail();
}

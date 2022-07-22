#include "NetLayer.h"
NetLayer::NetLayer(QObject *parent)
    : QObject{parent}
{

}
//==================================================================
//�� �� ����  SendBinLogFile
//����������  TCP����BIN�ļ�����̨������
//���������
//�� �� ֵ��  void
//��    �ߣ�  ����
//��    �ڣ�  2022 7/12 ����ע��
//�޸ļ�¼��
//==================================================================

void NetLayer::SendBinLogFile(QString filename)
{
    qDebug()<< "sendbinlog";
    QTcpSocket *NetSocket = new QTcpSocket;
    NetSocket->connectToHost(SerIP,SerPort);
    NetSocket->waitForConnected(2000);
    QFile m_file; 
    m_file.setFileName(filename);

    if ((NetSocket->state() != QAbstractSocket::ConnectedState) || (!m_file.open(QIODevice::ReadOnly)) ) {
         NetSocket->deleteLater();
        return;
    }
    QByteArray block;
    QDataStream out(&block, QIODevice::WriteOnly);
    out.setVersion(QDataStream::Qt_5_12);
    qDebug() << m_file.fileName();
    QByteArray filemsg = m_file.readAll();
    block.append(filemsg);
    out.device()->seek(0);
    out << (quint32)(block.size() - sizeof(quint32));
    qint64 x = 0;
    while (x < block.size()) {
        qint64 y = NetSocket->write(block);
        x += y;
        qDebug() << "Sendsize"<< x;
    }
    m_file.close();
    //������ʱ�ȴ� ��������Ӧ
    while (1)
      {
          if (NetSocket->waitForReadyRead(10)){
              QByteArray msg =NetSocket->readAll();
              if(msg == "true\r\n"){
                  qDebug() << "SuccessfuleSendLOG";
                emit LogSendSuccess();
                  break;
              }
              else{
                 emit LogSendFail();
                  break;
              }
          }
      }
}





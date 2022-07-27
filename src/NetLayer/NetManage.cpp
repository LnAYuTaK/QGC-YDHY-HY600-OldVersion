#include "NetManage.h"

NetManage *NetManage::s_instance = nullptr;
NetLayer *NetManage::m_layer =nullptr;

QThread NetManage::WorkThread;

NetManage::NetManage()
{

}

NetManage* NetManage::getManage()
{
  if(s_instance== nullptr){
      s_instance = new NetManage();
      m_layer = new NetLayer();
      m_layer->moveToThread(&WorkThread);
      //???????????????????
      connect(&WorkThread,&QThread::finished,m_layer,&QObject::deleteLater);
      //????SendLogFile?????? ???????????????????????????
      connect(s_instance,SIGNAL(SendLogFile(QString)),m_layer,SLOT(SendBinLogFile(QString)));
      connect(m_layer,SIGNAL(LogSendSuccess()),s_instance,SIGNAL(QSendLogSuccess()));
      connect(m_layer,SIGNAL(LogSendFail()),s_instance,SIGNAL(QSendLogFail()));
      //Task one...
      //Task two...
      WorkThread.start();
  }
  return s_instance;
}

void NetManage::SendLogFileEmit(QString filepath)
{
    qDebug() << filepath;
    emit SendLogFile(filepath);
}











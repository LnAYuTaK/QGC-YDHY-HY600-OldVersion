#include "NetManage.h"

NetManage *NetManage::s_instance = nullptr;

NetLayer *NetManage::m_layer =nullptr;

NetManage::NetManage()
{

}

NetManage* NetManage::getManage()
{
  if(s_instance== nullptr){
      s_instance = new NetManage();
      m_layer = new NetLayer();
      m_layer->moveToThread(&WorkThread);
      //���߳̽�����������Դ
      connect(&WorkThread,&QThread::finished,m_layer,&QObject::deleteLater);
      //��SendLogFile�źŷ��� �������������������źźʹ���
      connect(s_instance,&NetManage::SendLogFile,m_layer,&NetLayer::SendBinLogFile);
      WorkThread.start();
  }
  return s_instance;
}
#ifndef TestSend  //TestSendlogfile
void NetManage::SendLogFileEmit()
{
    QString file ="file";
    emit SendLogFile(file);
}
#endif








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
      //绑定线程结束就销毁资源
      connect(&WorkThread,&QThread::finished,m_layer,&QObject::deleteLater);
      //绑定SendLogFile信号发送 后续添加任务在这里加信号和处理
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








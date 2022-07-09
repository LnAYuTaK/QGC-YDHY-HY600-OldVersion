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
      //绑定线程结束就销毁资源
      connect(&WorkThread,&QThread::finished,m_layer,&QObject::deleteLater);
      //绑定SendLogFile信号发送 后续添加任务在这里加信号和处理
      connect(s_instance,&NetManage::SendLogFile,m_layer,&NetLayer::SendBinLogFile);

      //Task one...

      //Task two...
      WorkThread.start();
  }
  return s_instance;
}
//my fool function
void NetManage::SendLogFileEmit()
{
    qDebug() << "SendLogfile********";
    emit SendLogFile();
}











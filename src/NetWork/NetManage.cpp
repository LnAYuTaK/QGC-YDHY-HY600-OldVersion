#include "NetManage.h"

NetManage *NetManage::s_instance = nullptr;
QTcpSocket *NetManage::m_socket =nullptr;

NetManage::NetManage()
{

}

NetManage* NetManage::getManage()
{
  if(s_instance== nullptr){
      s_instance = new NetManage();
      m_socket = new QTcpSocket();
  }
  return s_instance;
}

NetManage* NetManage::connectLink()
{
   if(m_socket!=nullptr){

   }

}

NetManage *NetManage::disconLink()
{



}

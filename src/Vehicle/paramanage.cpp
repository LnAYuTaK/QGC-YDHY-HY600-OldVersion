#include "paramanage.h"
#include "MultiVehicleManager.h"
#include "QGCApplication.h"


ParaManage::ParaManage(QObject *parent)
    : QObject{parent}
{

    // 获取当前飞机pointer

}

bool ParaManage::setParameterValue(int componentId, QString paramName, QVariant &value)
{

    qDebug()<<value;
    activeVehicle = qgcApp()->toolbox()->multiVehicleManager()->activeVehicle();
    //当前的参数管理pointer
    paramMgr = activeVehicle->parameterManager();
  if(paramMgr->parameterExists(componentId,paramName)){
      paramMgr->getParameter(componentId,paramName)->setRawValue(value);
      return true;
  }
  return false;
}

QVariant ParaManage::getParameterValue(int componentId, QString paramName)
{
    activeVehicle = qgcApp()->toolbox()->multiVehicleManager()->activeVehicle();
    qDebug() << "PARAGETSUCCESSFULE";
    //当前的参数管理pointer
    paramMgr = activeVehicle->parameterManager();
   return paramMgr->getParameter(componentId,paramName)->rawValue();
}

bool  ParaManage::refreshThisParameter(int componentId,QString paramName)
{
    activeVehicle = qgcApp()->toolbox()->multiVehicleManager()->activeVehicle();
    //当前的参数管理pointer
    paramMgr = activeVehicle->parameterManager();
    if(paramMgr->parameterExists(componentId,paramName)){
        paramMgr->refreshParameter(componentId,paramName);
        return true;
    }
    return false;
}




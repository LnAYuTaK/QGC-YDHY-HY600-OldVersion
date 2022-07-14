#include "paramanage.h"
#include "MultiVehicleManager.h"
#include "QGCApplication.h"


ParaManage::ParaManage(QObject *parent)
    : QObject{parent}
{

    // ��ȡ��ǰ�ɻ�pointer
    activeVehicle = qgcApp()->toolbox()->multiVehicleManager()->activeVehicle();
    //��ǰ�Ĳ�������pointer
    paramMgr = activeVehicle->parameterManager();
}

bool ParaManage::setParameterValue(int componentId, QString& paramName, QVariant &value)
{
  if(paramMgr->parameterExists(componentId,paramName)){
      paramMgr->getParameter(componentId,paramName)->setRawValue(value);
      return true;
  }
  return false;
}

QVariant ParaManage::getParameterValue(int componentId, QString& paramName)
{
   return paramMgr->getParameter(componentId,paramName)->rawValue();
}

bool  ParaManage::refreshThisParameter(int componentId,QString &paramName)
{
    if(paramMgr->parameterExists(componentId,paramName)){
        paramMgr->refreshParameter(componentId,paramName);
        return true;
    }
    return false;
}




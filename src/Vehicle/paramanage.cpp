#include "paramanage.h"
#include "MultiVehicleManager.h"
#include "QGCApplication.h"
ParaManage::ParaManage(QObject *parent)
    : QObject{parent}
{

    // 获取当前飞机pointer
    activeVehicle = qgcApp()->toolbox()->multiVehicleManager()->activeVehicle();
    //当前的参数管理pointer
    paramMgr = activeVehicle->parameterManager();
}

//设置参数
bool ParaManage::setParameterValue(int componentId, QString& paramName, QVariant &value)
{
  paramMgr->getParameter(componentId,paramName)->setRawValue(value);
  return true;
}
//获取参数
QVariant ParaManage::getParameterValue(int componentId, QString& paramName)
{
   return paramMgr->getParameter(componentId,paramName)->rawValue();
}

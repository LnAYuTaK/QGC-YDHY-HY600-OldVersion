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

//���ò���
bool ParaManage::setParameterValue(int componentId, QString& paramName, QVariant &value)
{
  paramMgr->getParameter(componentId,paramName)->setRawValue(value);
  return true;
}
//��ȡ����
QVariant ParaManage::getParameterValue(int componentId, QString& paramName)
{
   return paramMgr->getParameter(componentId,paramName)->rawValue();
}

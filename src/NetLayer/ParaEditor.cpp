#include "ParaEditor.h"
ParaManage::ParaManage(QObject *parent)
    : QObject{parent}
{

    // ?????????pointer

}

//2022 7/19单独适配的流度 后期需要修改成通用接口
bool ParaManage::setParameterValue(int componentId, QString paramName,float value)
{

    activeVehicle = qgcApp()->toolbox()->multiVehicleManager()->activeVehicle();
    //????????????pointer
    paramMgr = activeVehicle->parameterManager();

     if(paramMgr->parameterExists(componentId,paramName)&&(value<=100)&&(value>0)){
         if(componentId==1){
            paramMgr->getParameter(componentId,paramName)->setRawValue(value/4);
            return true;
         }
     }
     qDebug()<<"error";
     return false;
}

QString ParaManage::getParameterValue(int componentId, QString paramName)
{
    activeVehicle = qgcApp()->toolbox()->multiVehicleManager()->activeVehicle();
    //????????????pointer
    paramMgr = activeVehicle->parameterManager();
    //QString str = QString::number(paramMgr->getParameter(componentId,paramName)->rawValue().toFloat(), 'f', 2);
    return QString::number(paramMgr->getParameter(componentId,paramName)->rawValue().toFloat(), 'f', 2);

}

bool  ParaManage::refreshThisParameter(int componentId,QString paramName)
{
    activeVehicle = qgcApp()->toolbox()->multiVehicleManager()->activeVehicle();
    //????????????pointer
    paramMgr = activeVehicle->parameterManager();
    if(paramMgr->parameterExists(componentId,paramName)){
        paramMgr->refreshParameter(componentId,paramName);
        return true;
    }
    return false;
}




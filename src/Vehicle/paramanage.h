#ifndef PARAMANAGE_H
#define PARAMANAGE_H

#include <QObject>
#include "ParameterManager.h"
#include "Vehicle.h"
class ParaManage : public QObject
{
    Q_OBJECT
    //Test
    //Q_PROPERTY(QVariant value READ Parameter WRITE SetParameter NOTIFY ParameterChanged)
public:
    explicit ParaManage(QObject *parent = nullptr);
   //�޸Ĳ���
    Q_INVOKABLE bool setParameterValue(int, QString , float);
   // ��ò���
    Q_INVOKABLE QString getParameterValue(int ,QString);
    //ˢ�µ����Ĳ���
    Q_INVOKABLE bool  refreshThisParameter(int ,QString);

signals:
    void ParameterChanged();
private:
    //��ǰ�ɻ�
    Vehicle* activeVehicle;
    // ��ǰ�ɻ��Ĳ���������
    ParameterManager* paramMgr;
    //
};

#endif // PARAMANAGE_H

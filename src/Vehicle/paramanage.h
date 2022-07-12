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
    //
    Q_INVOKABLE bool setParameterValue(int, QString &,QVariant &);

    Q_INVOKABLE QVariant getParameterValue(int ,QString &);

signals:
    void ParameterChanged();
private:
    //当前飞机
    Vehicle* activeVehicle;
    // 当前飞机的参数管理器
    ParameterManager* paramMgr;
    //
};

#endif // PARAMANAGE_H

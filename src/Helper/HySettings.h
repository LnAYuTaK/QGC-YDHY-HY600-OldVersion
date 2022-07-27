#ifndef HYSETTINGS_H
#define HYSETTINGS_H

#include <QObject>
#include <QSettings>
#include <QFile>
#include <QDebug>
#include <QDir>
#include "QGCApplication.h"


class HySettings : public QObject
{
    Q_OBJECT
public:
   static HySettings* getSettings();


public slots:
   QVariant getNetValue(const QString &section,const QString &key);
private:

    HySettings();
    HySettings(const  HySettings&){}
    static HySettings * instance;
    //网络设置ini
    static QSettings * NetSetting;

    //QString getRootSavePath();

    //参数设置ini
//    static QSettings * ParaSetting;

signals:

};

#endif // HYSETTINGS_H

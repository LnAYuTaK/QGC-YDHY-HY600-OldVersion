#ifndef SETTING_H
#define SETTING_H

#include <QObject>
#include <QSettings>
#include <QDebug>
#include <QThread>
#include <QFile>
   #define CONFIGPATH  "/storage/emulated/0/Pictures/Config/Config.ini"
//??????Setting???????????????ini???
class Setting
{
public:
     ~Setting();
     static Setting * getSetting();
     static bool contains(const QString &key);
     static QVariant getvalue(const QString &key);
     static void setValue(const QString &key, const QVariant &value);
private:
     Setting();//?????????
     Setting(const Setting&){}//?????????????
     static Setting *s_instance;
     static QSettings *m_settings;
     static QString createDir();

};


#endif // SETTING_H

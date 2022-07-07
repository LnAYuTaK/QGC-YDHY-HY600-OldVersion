#ifndef SETTING_H
#define SETTING_H

#include <QObject>
#include <QSettings>
#include <QDebug>
#define CONFIGPATH  "C:/Users/Administrator/Desktop/qgroundcontrol/QGCGround/Config.ini"
//单例的Setting用来存取固定配置的ini文件
class Setting
{
public:
    ~Setting();
    static Setting * getInstance();
    static bool contains(const QString &key);
    static QVariant getvalue(const QString &key);
    static void setValue(const QString &key, const QVariant &value);
private:
     Setting();//禁止构造函数
     Setting(const Setting&){}//禁止拷贝构造函数
     static Setting *s_instance;
     static QSettings *m_settings;
};


#endif // SETTING_H

#ifndef SETTING_H
#define SETTING_H

#include <QObject>
#include <QSettings>
#include <QDebug>
#define CONFIGPATH  "C:/Users/Administrator/Desktop/qgroundcontrol/QGCGround/Config.ini"
//������Setting������ȡ�̶����õ�ini�ļ�
class Setting
{
public:
    ~Setting();
    static Setting * getInstance();
    static bool contains(const QString &key);
    static QVariant getvalue(const QString &key);
    static void setValue(const QString &key, const QVariant &value);
private:
     Setting();//��ֹ���캯��
     Setting(const Setting&){}//��ֹ�������캯��
     static Setting *s_instance;
     static QSettings *m_settings;
};


#endif // SETTING_H

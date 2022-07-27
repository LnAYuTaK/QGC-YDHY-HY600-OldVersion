#include "HySettings.h"
#include "SettingsManager.h"
HySettings * HySettings::instance =nullptr;

QSettings * HySettings::NetSetting =nullptr;



HySettings::HySettings()
{


}

HySettings *HySettings::getSettings()
{
   if(instance==nullptr)
   {
        instance  = new HySettings();
        QString SettingPath = qgcApp()->toolbox()->settingsManager()->appSettings()->settingsSavePath();
        //�����ж���Ϊini�Ƚ���Ҫ���Զ��μ���
        QDir dir(SettingPath);
        if(!dir.exists()){
            dir.mkdir(SettingPath);
        }
        QStringList Settinglist= dir.entryList(QStringList()<<"*.ini",  QDir::Files | QDir::Readable, QDir::Name);
        foreach(QString filename , Settinglist)
        {
            if(filename == "NetConfig.ini"){
                NetSetting = new QSettings(dir.absoluteFilePath(filename),QSettings::IniFormat);
            }
        }
    }

    return instance;
}


QVariant HySettings::getNetValue(const QString &section,const QString &key)
{
   if(NetSetting!=nullptr){
    QString query  = section +'/'+ key;
    return NetSetting->value(query);
   }
   return 0;
}













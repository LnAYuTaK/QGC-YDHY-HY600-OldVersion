#include "setting.h"

Setting *Setting::s_instance = nullptr;

QSettings *Setting::m_settings =nullptr;

Setting::Setting()
{
    Q_ASSERT(s_instance == nullptr);
}

Setting::~Setting()
{
    Q_ASSERT(s_instance != nullptr);
}

Setting* Setting::getSetting()
{
    QFile file(CONFIGPATH);
    if(file.exists()){
      if(s_instance== nullptr)
      {
          s_instance = new Setting();
          m_settings = new QSettings(CONFIGPATH,QSettings::IniFormat);
      }
    }
    else{
            s_instance =nullptr;
            m_settings =nullptr;
     }
      return s_instance;
}

QVariant Setting::getvalue(const QString &key)
{
    return m_settings->value(key);
}

//最好不要改
void Setting::setValue(const QString &key, const QVariant &value)
{
    return m_settings->setValue(key, value);
}



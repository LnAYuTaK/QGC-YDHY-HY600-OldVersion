#ifndef DATA_H
#define DATA_H

#include "Vehicle.h"

#include <QtSql>
#include "mysqlhelper.h"
#include <QSqlDatabase>
#include "QGCMAVLink.h"
#include <QObject>
#include<QMessageBox>
#include <QApplication>
//202203Add  增加tcp支持
#include <QTcpSocket>
#include "NetLayer/NetManage.h"

#define DEBUGGING

class Data : public QObject
{
    Q_OBJECT

    Q_PROPERTY(double _progressBar READ ProgressBar WRITE progressBar NOTIFY progresschanged)
    Q_PROPERTY(int _Msg READ Msg WRITE msg NOTIFY msgchanged)
    Q_PROPERTY(QString _usertxt READ usertxt WRITE setuser NOTIFY txtchanged)

    double ProgressBar() const{
        qDebug() << __FILE__ << __func__ << _progressBar;
        return _progressBar;}
    void progressBar(double pb){_progressBar = pb; emit progresschanged();
        qDebug() << __FILE__ << __func__ << _progressBar;
                               }

    double Msg() const{
        qDebug() << __FILE__ << __func__ << _msg_value;
        return _msg_value;}
    void msg(int mv){_msg_value = mv; emit msgchanged();
        qDebug() << __FILE__ << __func__ << _msg_value;
                               }

    QString usertxt() const{
        return userID;}
    void setuser(QString mv){userID = mv; emit txtchanged();
                               }
signals:
    void progresschanged();
    void msgchanged();
    void txtchanged();
//    static void someSignal(double);
public:
    Data();
    static int save_num;//发送数据的次数
    static int save_plan_num;//发送数据的次数
    static QString save_filename;
    static QString dir_path;

    static bool query_success;

    static qint64 starttime;
    static bool update_starttime;
    static int eppodroneID;
    static QString userID;
    static uint8_t spraystate;
    static double flowrate;
    static double lat;
    static double lon;
    static double alt;
    static double workingarea;
    static double groundspeedvalue;
    static qint16 time;
    static uint8_t liquidlevel;
    static QString flightmode;

    static double roll;
    static double pitch;
    static double yaw;
    static double rollRate;
    static double pitchRate;
    static double yawRate;


//    static int list_length;

    static bool msg_received_success(QString);
    static void keepScreenOn();
    static QString make_mavlink_pakage();
    static QString make_mavlink_pakagetest();
    static qint64* split_double(double data,qint16 digit);

    Q_INVOKABLE static bool readtxttosend_msg();
    Q_INVOKABLE static bool isNetWorkOnline();
    Q_INVOKABLE static void readtxttosend();    //Q_INVOKABLE传递给qml使用
    Q_INVOKABLE static double progressBar_value();
    Q_INVOKABLE static int msg_value();
    static void Set_userID_value();
    Q_INVOKABLE static void sendBinLog(QString);
//    static Q_INVOKABLE QStringList get_playback();
//    static Q_INVOKABLE int get_playback_length();

public slots:
    static void data_save_local(QString);
    static void data_save(QString);
    static void data_save_plan();

public:
    static double _progressBar;
    static int _msg_value;
//public:
//    void timerEvent(QTimerEvent *event) override;
//    //void timerEvent(QTimerEvent *event);
//    int id1, id2, id3;

};

#endif // DATA_H



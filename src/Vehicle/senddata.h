#ifndef SENDDATA_H
#define SENDDATA_H

//#include "Vehicle.h"

#include <QtSql>

#include <QSqlDatabase>
//#include "QGCMAVLink.h"
#include <QObject>
#include "data.h"
#include "mysqlhelper.h"

class SendData : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString _useradmin READ UserAdmin WRITE useradmin NOTIFY sendrecord)
    Q_PROPERTY(QString _starttime READ StartTime WRITE starttime NOTIFY sendrecord)
    Q_PROPERTY(QString _flighttime READ FlightTime WRITE flighttime NOTIFY sendrecord)
    Q_PROPERTY(QString _sprayingarea READ SprayingArea WRITE sprayingarea NOTIFY sendrecord)
    Q_PROPERTY(QString _dosageofmu READ DosageOfmu WRITE dosageofmu NOTIFY sendrecord)
    Q_PROPERTY(QString _dosage READ Dosage WRITE dosage NOTIFY sendrecord)
    Q_PROPERTY(QString _flightcontrolnumber READ FlightControlNumber WRITE flightcontrolnumber NOTIFY sendrecord)
    Q_PROPERTY(QString _flightdisance READ FlightDisance WRITE flightdisance NOTIFY sendrecord)
    Q_PROPERTY(QString _cropspecie READ CropSpecie WRITE cropspecie NOTIFY sendrecord)
    Q_PROPERTY(QString _longitude READ Longitude WRITE longitude NOTIFY sendrecord)
    Q_PROPERTY(QString _latitude READ Latitude WRITE latitude NOTIFY sendrecord)

    Q_PROPERTY(QString _startTime_index READ StartTime_index WRITE startTime_index NOTIFY sendrecord)

    QString UserAdmin() const{return _useradmin;}
    void useradmin(QString ua){_useradmin = ua; emit sendrecord();}
    QString StartTime() const{return _starttime;}
    void starttime(QString st){_starttime = st; emit sendrecord();}
    QString FlightTime() const{return _flighttime;}
    void flighttime(QString ft){_flighttime = ft; emit sendrecord();}
    QString SprayingArea() const{return _sprayingarea;}
    void sprayingarea(QString sa){_sprayingarea = sa; emit sendrecord();}
    QString DosageOfmu() const{return _dosageofmu;}
    void dosageofmu(QString dof){_dosageofmu = dof; emit sendrecord();}
    QString Dosage() const{return _dosage;}
    void dosage(QString dos){_dosage = dos; emit sendrecord();}
    QString FlightControlNumber() const{return _flightcontrolnumber;}
    void flightcontrolnumber(QString fcn){_flightcontrolnumber = fcn; emit sendrecord();}
    QString FlightDisance() const{return _flightdisance;}
    void flightdisance(QString fd){_flightdisance = fd; emit sendrecord();}
    QString CropSpecie() const{return _cropspecie;}
    void cropspecie(QString cs){_cropspecie = cs; emit sendrecord();}
    QString Longitude() const{return _longitude;}
    void longitude(QString lo){_longitude = lo; emit sendrecord();}
    QString Latitude() const{return _latitude;}
    void latitude(QString la){_latitude = la; emit sendrecord();}

    QString StartTime_index() const{return _startTime_index;}
    void startTime_index(QString st_i){_startTime_index = st_i; emit sendrecord();}

signals:
    void sendrecord();


private:
    QString _useradmin;
    QString _starttime;
    QString _flighttime;
    QString _sprayingarea;
    QString _dosageofmu;
    QString _dosage;
    QString _flightcontrolnumber;
    QString _flightdisance;
    QString _cropspecie;
    QString _longitude;
    QString _latitude;

    QString _startTime_index;//单个获取起飞时间
public:
    SendData();
    static bool sql_connect_flag;

    static int list_length;
    static int list2_length;

//    static QList<double> id_list;
//    static QList<QList<double>> latitude_list;
//    static QList<QList<double>> longitude_list;

    Q_INVOKABLE QStringList get_playback();
    Q_INVOKABLE int get_playback_length();
    Q_INVOKABLE QStringList get_playbackroute();
    Q_INVOKABLE int get_playbackroute_length();
    Q_INVOKABLE double qstring_to_double(QString);


};
#endif // SENDDATA_H

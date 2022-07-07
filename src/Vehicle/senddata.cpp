#include "senddata.h"
#include <QObject>

SendData::SendData()
{
//    //判断是否成功连接数据库
//    bool flag = Data::db3.open();
//    if(!flag)
//    {
//        qDebug()<<"connect to mysql error"<<Data::db3.lastError().text();
//    }
//    else
//    {
//        sql_connect_flag = true;
//        qDebug()<<"connect to mysql OK";
//    }
}

QStringList SendData::get_playback(){
    QStringList List;
//    list << "test";

    QSqlQuery query(mySqlhelper::db3);
    bool success = query.exec("select * from play_tracking where planer_id = "+Data::userID+"");
    if(!success){
        qDebug() << "Failed to find play_tracking";
    }
//    query.first();

    while(query.next()){
    QString UserAdmin = query.value(1).toString();
    QString StartTime = query.value(2).toString();
    QString FlightTime = query.value(3).toString();
    QString SprayingArea = query.value(4).toString();
    QString DosageOfmu = query.value(5).toString();
    QString Dosage = query.value(6).toString();
    QString FlightControlNumber = query.value(7).toString();
    QString FlightDisance = query.value(8).toString();
    QString CropSpecies = query.value(9).toString();
//    QString Longitude = query.value(9).toString();
//    QString Latitude = query.value(10).toString();

    List << UserAdmin << StartTime << FlightTime<< SprayingArea<< DosageOfmu<< Dosage<< FlightControlNumber<< FlightDisance<< CropSpecies;
//    List << UserAdmin << StartTime << FlightTime<< SprayingArea<< DosageOfmu<< Dosage<< FlightControlNumber<< FlightDisance<< CropSpecies<< Longitude<< Latitude;
//    qDebug() << List;

//    qDebug() << "user_admin is : " << UserAdmin
//              << " starttime is : " << StartTime
//              << " flighttime is : " << FlightTime
//              << " sprayingarea is : " << SprayingArea
//              << " dosageofmu is : " << DosageOfmu
//              << " dosage is : " << Dosage
//              << " flightcontrolnumber is : " << FlightControlNumber
//              << " flightdisance is : " << FlightDisance
//              << " cropspecies is : " << CropSpecies;
    }
    list_length=List.count();
    return List;
}

QStringList SendData::get_playbackroute(){
    QStringList List2;
//    list << "test";
//    QList<int> id_list;
//    QList<QList<double>> latitude_list;
//    QList<QList<double>> longitude_list;
//    QList<double>one_lat,one_long;

    QSqlQuery query(mySqlhelper::db3);
    bool success = query.exec("select * from plan_data where planer_id ='"+Data::userID+"' and start_time ='"+_startTime_index+"' order by sh_time asc");
    qDebug()<<" ROUTE" <<Data::userID<<_startTime_index;
    if(!success){
        qDebug() << "Failed to find plan_data";
    }
//    query.first();
    while(query.next()){
//    double Longitude = query.value(12).toDouble();
//    double Latitude = query.value(13).toDouble();
    QString Longitude = query.value(12).toString();
    QString Latitude = query.value(13).toString();
    List2 << Longitude<< Latitude;
//    one_lat.push_back(Latitude);
//    one_long.push_back(Longitude);
    }
//    id_list.push_back(_startTime_index.toDouble());
//    latitude_list.push_back(one_lat);
//    longitude_list.push_back(one_long);
//    qDebug() << List2;
    list2_length=List2.count();
    return List2;

}

int SendData::get_playback_length()
{
    return list_length;
}

int SendData::get_playbackroute_length()
{
    return list2_length;
}

double SendData::qstring_to_double(QString str)
{
//    QString str="0.04m²";
    double areaValue = str.split("m")[0].toDouble();
    qDebug() << areaValue;
    return areaValue;
}

bool SendData::sql_connect_flag=false;
int SendData::list_length=0;
int SendData::list2_length=0;
//QList<double> SendData::id_list;
//QList<QList<double>> SendData::latitude_list;
//QList<QList<double>> SendData::longitude_list;

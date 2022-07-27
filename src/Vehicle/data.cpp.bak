#include "data.h"

Data::Data()
{

}


QString Data::make_mavlink_pakage(){

    QDateTime datetime;
    time = datetime.currentDateTime().toTime_t() - starttime;

    QString save_plan_num_hex =  QString("%1").arg(save_plan_num,4,16,QLatin1Char('0'));//value?int???char?????
    //qDebug() << "save_plan_num_hex" << save_plan_num_hex;

    QString starttime_hex =  QString("%1").arg(starttime,8,16,QLatin1Char('0'));//value?int???char?????
    //qDebug() << "starttime_hex" << starttime_hex;

    QString eppodroneID_hex =  QString("%1").arg(eppodroneID,3,16,QLatin1Char('0'));//value?int???char?????
    //qDebug() << "eppodroneID_hex" << eppodroneID_hex;

    QString userID_hex =  QString("%1").arg(userID.toInt(),3,16,QLatin1Char('0'));
    //qDebug() << "userID_hex" << userID_hex;

    //Á÷ËÙ
    qint64* flowrate_int = split_double(flowrate,2);
    QString flowrate_hex_1 =  QString("%1").arg(flowrate_int[0],1,16,QLatin1Char('0'));//value?int???char?????
    //qDebug() << "flowrate_hex_1" << flowrate_hex_1;
    QString flowrate_hex_2 = QString("%1").arg(flowrate_int[1],2,16,QLatin1Char('0'));//value?int???char?????
    //qDebug() << "flowrate_hex_2" << flowrate_hex_2;

    qint64* workingarea_int = split_double(workingarea,2);
    QString workingarea_hex_1 =  QString("%1").arg(workingarea_int[0],2,16,QLatin1Char('0'));//value?int???char?????
    //qDebug() << "workingarea_hex_1" << workingarea_hex_1;
    QString workingarea_hex_2 = QString("%1").arg(workingarea_int[1],2,16,QLatin1Char('0'));//value?int???char?????
    //qDebug() << "workingarea_hex_2" << workingarea_hex_2;

    QString spraystate_hex =  QString("%1").arg(spraystate,1,16,QLatin1Char('0'));//value?int???char?????
    //qDebug() << "spraystate_hex" << spraystate_hex;

    qint64* lon_int = split_double(lon,7);
    QString lon_hex_1 =  QString("%1").arg(lon_int[0],2,16,QLatin1Char('0'));//value?int???char?????
    //qDebug() << "lon_hex_1" << lon_hex_1;
    QString lon_hex_2 = QString("%1").arg(lon_int[1],6,16,QLatin1Char('0'));//value?int???char?????
    //qDebug() << "lon_hex_2" << lon_hex_2;

    qint64* lat_int = split_double(lat,7);
    QString lat_hex_1 =  QString("%1").arg(lat_int[0],2,16,QLatin1Char('0'));//value?int???char?????
    //qDebug() << "lat_hex_1" << lat_hex_1;
    QString lat_hex_2 = QString("%1").arg(lat_int[1],6,16,QLatin1Char('0'));//value?int???char?????
    //qDebug() << "lat_hex_2" << lat_hex_2;
    //alt = -10.125;
    QString alt_symbol_hex;
    if(alt < 0){
        alt_symbol_hex =  QString("%1").arg(1,1,16,QLatin1Char('0'));//value?int???char?????
        alt = qAbs(alt);
    }
    else{
        alt_symbol_hex =  QString("%1").arg(0,1,16,QLatin1Char('0'));//value?int???char?????
    }
    qint64* alt_int = split_double(alt,2);
    QString alt_hex_1 =  QString("%1").arg(alt_int[0],3,16,QLatin1Char('0'));//value?int???char?????
    //qDebug() << "alt_hex_1" << alt_hex_1;
    QString alt_hex_2 = QString("%1").arg(alt_int[1],2,16,QLatin1Char('0'));//value?int???char?????
    //qDebug() << "alt_hex_2" << alt_hex_2;


    qint64* groundspeedvalue_int = split_double(groundspeedvalue,2);
    QString groundspeedvalue_hex_1 =  QString("%1").arg(groundspeedvalue_int[0],2,16,QLatin1Char('0'));//value?int???char?????
    //qDebug() << "groundspeedvalue_hex_1" << groundspeedvalue_hex_1;
    QString groundspeedvalue_hex_2 = QString("%1").arg(groundspeedvalue_int[1],2,16,QLatin1Char('0'));//value?int???char?????
    //qDebug() << "groundspeedvalue_hex_2" << groundspeedvalue_hex_2;

    QString time_hex =  QString("%1").arg(time,4,16,QLatin1Char('0'));//value?int???char?????
    //qDebug() << "time_hex" << time_hex;

    QString liquidlevel_hex =  QString("%1").arg(liquidlevel,1,16,QLatin1Char('0'));//value?int???char?????
    //qDebug() << "liquidlevel_hex" << liquidlevel_hex;

    qint16 flightmode_value;

    QStringList stringList;

    stringList << "PreFlight" << "Manual" << "Stabilize" << "Guided" << "Auto" << "Test" << "Altitude Hold" << "RTL" << "Loiter";

    flightmode_value = stringList.indexOf(flightmode);

    if(flightmode_value < 0 || flightmode_value > 7) flightmode_value = 0;

    QString flightmode_hex =  QString("%1").arg(flightmode_value,1,16,QLatin1Char('0'));//value?int???char?????
    //qDebug() << "flightmode_hex" << flightmode_hex;

    QString pack = save_plan_num_hex+starttime_hex+eppodroneID_hex+userID_hex+flowrate_hex_1+flowrate_hex_2+workingarea_hex_1+workingarea_hex_2+spraystate_hex+lon_hex_1+lon_hex_2+lat_hex_1+lat_hex_2+alt_symbol_hex+alt_hex_1+alt_hex_2+groundspeedvalue_hex_1+groundspeedvalue_hex_2+time_hex+liquidlevel_hex+flightmode_hex;

    QByteArray pack_array = pack.toLatin1();
    long checksum = 0;
    for(int i = 0; i < pack_array.size(); i++){
        checksum+=pack_array[i];
    }
    QString checksum_hex =  QString("%1").arg(checksum,4,16,QLatin1Char('0'));//value?int???char?????
    QString FirmwareVersion=Firmware;
    QString SoftwareVersion=Setting::getSetting()->getvalue("APP/version").toString();

    return "EB90"+pack+FirmwareVersion+ SoftwareVersion+checksum_hex;
}

QString Data::make_mavlink_pakagetest(){
    QString pack = QString::number(spraystate, 10) + ";" + flightmode;
    return pack;
}

qint64* Data::split_double(double data,qint16 digit){

    QString data_str = QString::number(data,'f',digit).toUtf8();
    QStringList list = data_str.split(".");

    qint64* temp = new qint64[2];

    for ( int i =0; i < 2; i++)

        temp[i] = list[i].toInt();
    return temp;
}

void Data::data_save_plan(){

    //202203Add ???????????????????????????????
    //qDebug() << "save_plan_num" << save_plan_num << save_plan_num % 3;
    QString savestr = make_mavlink_pakage();
    //data_save_local(savestr,"C:/Users/Administrator/Desktop");//???????
    data_save(savestr);
    save_plan_num++;
    /*if(save_plan_num % 3 == 0){
        qDebug() << "save_plan_num" << save_plan_num << save_plan_num % 3;
        data_save();//??????
        save_plan_num++;
    }else{
        qDebug() << "save_plan_num" << save_plan_num << save_plan_num % 3;
        data_save_local();//???????
        save_plan_num++;
    }*/
}
void Data::data_save_local(QString savestr,QString path){
    //?????????????
    QString min = QDateTime::currentDateTime().toString("yyyyMMdd");
    QString timestr = QDateTime::currentDateTime().toString("yyyy-MM-dd HH:mm:ss");
#if !defined(__android__)
    dir_path =  path;  //????
#else
    dir_path =  "/storage/emulated/0/DATA_SAVE";  //???
#endif
    if(save_num == 1){
        QDir dir;
        if(!dir.exists(dir_path)){
            dir.mkdir(dir_path);//????????????
            //                    qDebug() << "make dir fail";
        }
        //??????? ????????????????
        save_filename = dir_path + "/" + min + ".txt";
    }

    qDebug() << save_filename;
    QFile f(save_filename);
    QTextStream in(&f);
    if(!f.open( QIODevice::WriteOnly | QIODevice::Append | QIODevice::Text)){
        //                qDebug() << "open fail";
        return;
    }
    //in << timestr;
    in << savestr;
    //in <<endl;
    f.flush();
    f.close();
    save_num++;
}

//??????????????tcp????????
void Data::data_save(QString sendmsg){
    //202203Add ???????tcp????
    QTcpSocket *mSocket = new QTcpSocket();
    QString IP= Setting::getSetting()->getvalue("NetConfig/ip").toString();
    quint16 Port = Setting::getSetting()->getvalue("NetConfig/port").toInt();
    mSocket->connectToHost(IP,Port);
    QByteArray sendMessage = sendmsg.toLocal8Bit();
    qint16 SendBufSize = mSocket->write(sendMessage);
    qDebug() <<"writenum" << SendBufSize;
    mSocket->close();
}

//?????????????????
bool Data::msg_received_success(QString bytes_string){

    QDateTime startTime3=  QDateTime::currentDateTime();
    QSqlQuery query(mySqlhelper::db3);
    QDateTime endTime3=  QDateTime::currentDateTime();
    qint64 intervalTime3 = startTime3.secsTo(endTime3); //???????
    qint64 intervalTimeMS3 = startTime3.msecsTo(endTime3);

    qDebug() <<"panduan1" << intervalTime3;  //???????????
    qDebug() <<"panduan1" << intervalTimeMS3; //?????????????
    QDateTime startTime2=  QDateTime::currentDateTime();

    query_success = query.exec("select * from data_soucre");
    if(!query_success){
        qDebug() << "Failed to find data_soucre";
        return false;
    }

    QDateTime endTime2=  QDateTime::currentDateTime();
    qint64 intervalTime2 = startTime2.secsTo(endTime2); //???????
    qint64 intervalTimeMS2 = startTime2.msecsTo(endTime2);

    qDebug() <<"panduan2" << intervalTime2;  //???????????
    qDebug() <<"panduan2" << intervalTimeMS2; //?????????????
    QDateTime startTime1=  QDateTime::currentDateTime();

    query.last();
    QString data = query.value(1).toString();
    qDebug() << data;

    QDateTime endTime1=  QDateTime::currentDateTime();
    qint64 intervalTime1 = startTime1.secsTo(endTime1); //???????
    qint64 intervalTimeMS1 = startTime1.msecsTo(endTime1);

    qDebug() <<"panduan3" << intervalTime1;  //???????????
    qDebug() <<"panduan3" << intervalTimeMS1; //?????????????

    if(data == bytes_string)
    {
        qDebug()<<"received successfully";
        return true;
    }
    else
    {
        qDebug()<<"accept failure";
        return false;
    }
}

bool Data::isNetWorkOnline()  //CommonParameter
{
    //????????????
    QNetworkConfigurationManager mgr;
    //    return mgr.isOnline();
    if(mgr.isOnline()){
        //202203Add
        QApplication::setQuitOnLastWindowClosed(false);//??????????????
        if(QMessageBox::Ok == QMessageBox::information(nullptr, "Title",QString::fromUtf8("Click 'OK' button,Start Sending Data"),QMessageBox::Ok)){
            return true;
        }
        return true;
    }
    else{
        QApplication::setQuitOnLastWindowClosed(false);//??????????????
        if(QMessageBox::Ok == QMessageBox::warning(nullptr, "Warning",QString::fromUtf8("Network not connect"),QMessageBox::Ok)){
            return false;
        }
        return false;
    }
}

void Data::readtxttosend(){
    QTcpSocket *mSocket = new QTcpSocket();
    QString m_fileName;
    qint64 m_bytesWritten;
    QFile *m_localFile;
    qint64 m_totalBytes;
    _progressBar = 0;
    _msg_value=0;
    QString min = QDateTime::currentDateTime().toString("yyyyMMdd");
#if !defined(__android__)
    dir_path =  "../DATA_SAVE";  //????
#else
    dir_path =  "/storage/emulated/0/DATA_SAVE";  //???
#endif
    QDir dir(dir_path);
    if(!dir.exists())
    {
        //                return;
        qDebug()<< dir_path + "no exists!";
        _msg_value = 1;
    }else{
        //??????? ????????????????
        m_fileName = dir_path + "/" + min + ".txt";
        m_localFile=new QFile(m_fileName);
        if (m_localFile->exists()){
            m_bytesWritten=0;
            mSocket->connectToHost("81.70.247.217",8900);
            if(!m_localFile->open(QFile::ReadOnly)){
                qDebug()<<"client??open file error!";
                return;
            }
            m_totalBytes=m_localFile->size();
            qint64 len_date=0;
            do
            {
                //??¦Ç?????????§³
                char buf[3960]={0};
                len_date=0;

                //??????§Ø?????,?????????????????
                len_date=m_localFile->read(buf,sizeof(buf));              //3 ??????????,§Õ?§Ö????????????????
                //??????????????????????
                len_date=mSocket->write(buf,len_date);               //4 ???????????????????????,??????????????????????
                mSocket->waitForBytesWritten(-1);

                mSocket->flush();

                //???????????????
                m_bytesWritten+=len_date;
                _progressBar = m_bytesWritten * 100.0 /m_totalBytes;
                QTime dieTime = QTime::currentTime().addMSecs(500);

                while (QTime::currentTime() < dieTime)
                {
                    QCoreApplication::processEvents(QEventLoop::AllEvents, 100);
                }


            }while(len_date>0);                                   //5 ????§Õ??????????0,????????§Õ??,do while()????

            m_localFile->close();

            //????????
            //m_tcpClient->disconnectFromHost();             //7 ?????????????
            mSocket->close();
            qDebug()<<"insert data success!";
            _progressBar = 100.0;
            _msg_value = 2;

        }else{
            qDebug()<<"insert data success!";
            _progressBar = 100.0;
            _msg_value = 2;

        }
    }
}

bool Data::readtxttosend_msg(){
    //    if(Data::msg_value == 1){
    //        QMessageBox::information(nullptr, "Title",QString::fromUtf8("Click 'OK' button,Start Sending Data"),QMessageBox::Ok);
    //    }
    //    else if(Data::msg_value == 2){
    //        QMessageBox::warning(nullptr, "Warning",QString::fromUtf8("Network not connect"),QMessageBox::Ok);
    //    }
    //    else if(Data::msg_value == 3){
    //        QMessageBox::warning(nullptr, "Warning",QString::fromUtf8("Database connection failure"),QMessageBox::Ok);
    //    }
    if(_msg_value == 1){
        QApplication::setQuitOnLastWindowClosed(false);
        if(QMessageBox::Ok == QMessageBox::information(nullptr, "Title",QString::fromLocal8Bit("Dir no exists!"),QMessageBox::Ok)){
            return true;
        }
        return true;
    }
    else if(_msg_value == 2){
        QApplication::setQuitOnLastWindowClosed(false);
        if(QMessageBox::Ok == QMessageBox::information(nullptr, "Title",QString::fromLocal8Bit("Send Success!"),QMessageBox::Ok)){
            return true;
        }
        return true;
    }
    else if(_msg_value == 3){
        QApplication::setQuitOnLastWindowClosed(false);
        if(QMessageBox::Ok == QMessageBox::warning(nullptr,"Warning",QString::fromLocal8Bit("Send Failure!"),QMessageBox::Ok)){
            return true;
        }
        return true;
    }
    else{
        return false;
    }
}

double Data::progressBar_value(){
    qDebug()<<"_progressBar: "<<_progressBar;
    return _progressBar;
}

int Data::msg_value(){
    //       qDebug()<<"_msg_value: "<<_msg_value;
    return _msg_value;
}

void Data::Set_userID_value(){

    QString dir_save;
#if !defined(__android__)
    dir_save =  "../USER_SAVE";  //????
#else
    dir_save =  "/storage/emulated/0/UIDdate";  //???
#endif

    QDir dir;
    if(!dir.exists(dir_save)){
        dir.mkdir(dir_save);//????????????
    }
    QString fileName = dir_save + "/clientmanmage";  //????

    //
    QFile file(fileName);
    if (file.exists()){
        if (file.open(QIODevice::ReadOnly | QIODevice::Text))
        {
            QString lines = file.readLine();
            userID = lines.remove("\n");
            file.close();
            qDebug()<<"open to clientmanmage OK";
        }
    }
    else{
        file.open(QIODevice::WriteOnly |QIODevice::Append | QIODevice::Text );
        QTextStream in(&file);
        in << "001";
        in <<endl;
        file.flush();
        file.close();
        userID="001";
    }
}

bool Data::update_starttime=false;
qint64 Data::starttime=QDateTime::currentDateTime().toTime_t();
int Data::eppodroneID=0;
QString Data::userID="001";
uint8_t Data::spraystate=0;//??????
double Data::flowrate=0;
double Data::lat=0;
double Data::lon=0;
double Data::alt=0;
double Data::workingarea=0;
double Data::groundspeedvalue=0;
qint16 Data::time;
uint8_t Data::liquidlevel=1;
QString Data::flightmode;

double Data::roll=0;
double Data::pitch=0;
double Data::yaw=0;
double Data::rollRate=0;
double Data::pitchRate=0;
double Data::yawRate=0;

QString Data::Firmware="";

QString Data::QGCversion="40";


int Data::save_num=1;//????????????
int Data::save_plan_num=0;//??????????

QString Data::save_filename="";
QString Data::dir_path="";

QSqlDatabase mySqlhelper::db3;

double Data::_progressBar;
int Data::_msg_value=0;

bool Data::query_success;




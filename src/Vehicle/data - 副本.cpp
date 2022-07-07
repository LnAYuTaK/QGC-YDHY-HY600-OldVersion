#include "data.h"


Data::Data()
{


    //    startTimer(5000);

    //202203Add
    m_payloadSize=64*1024;
        m_totalBytes=0;
        m_bytesWritten=0;
        m_bytesToWrite=0;
        m_tcpClient=new QTcpSocket(this);
        connect(m_tcpClient,SIGNAL(connected()),this,SLOT(startTransfer()));
        connect(m_tcpClient,SIGNAL(bytesWritten(qint64)),this,SLOT(updateClientProgress(qint64)));
        connect(m_tcpClient,SIGNAL(error(QAbstractSocket::SocketError)),this,SLOT(displayError(QAbstractSocket::SocketError)));


}

QString Data::make_mavlink_pakage(){

    //    Data::keepScreenOn();
    QDateTime startTime1=  QDateTime::currentDateTime();


    //    mavlink_message_t   messageOut;
    //    uint8_t systemId = 255;
    //    uint8_t componentId = 190;
    //    uint8_t chan=1;

    QDateTime datetime;
    time = datetime.currentDateTime().toString("yyyy-MM-dd HH:mm:ss");
//    qDebug()<<"Just : "<<time ;

    //sprintf和snprintf函数的字符串缓冲，因为sprintf可能导致缓冲区溢出问题而不被推荐使用
    char* starttime_c;
    //    sprintf(time_c, "%f", time);
    QByteArray qByteArray = starttime.toUtf8();
    starttime_c = qByteArray.data();

    char eppodroneID_c[10];
    snprintf(eppodroneID_c, 10, "%d", eppodroneID);
//    qDebug() << "eppodroneID" << eppodroneID;

    char* userID_c;
    QByteArray qByteArray1 = userID.toUtf8();
    userID_c = qByteArray1.data();
//    qDebug() << "userID" << userID;

    char flowrate_c[10];
    snprintf(flowrate_c, 10, "%f", flowrate);

    char workingarea_c[10];
    snprintf(workingarea_c, 10, "%f", workingarea);
    qDebug() << "workingarea" << workingarea;

    char spraystate_c[10];
    snprintf(spraystate_c, 10, "%d", spraystate);

    char lat_c[10];
    snprintf(lat_c, 10, "%f", lat);
//    qDebug() << "lat" << lat;

    char lon_c[10];
    snprintf(lon_c, 10, "%f", lon);
//    qDebug() << "lon" << lon;

    char alt_c[10];
    snprintf(alt_c, 10, "%f", alt);
//    qDebug() << "alt" << alt;

    char groundspeedvalue_c[10];
    snprintf(groundspeedvalue_c, 10, "%f", groundspeedvalue);

    char* time_c;
    QByteArray qByteArray2 = time.toUtf8();
    time_c = qByteArray2.data();
    qDebug() << "time_c" << time;

    char liquidlevel_c[10];
    snprintf(liquidlevel_c, 10, "%d", liquidlevel);

    char* flightmode_c;
    QByteArray qByteArray3 = flightmode.toUtf8();
    flightmode_c = qByteArray3.data();

    char roll_c[10];
    snprintf(roll_c, 10, "%f", roll);

    char pitch_c[10];
    snprintf(pitch_c, 10, "%f", pitch);

    char yaw_c[10];
    snprintf(yaw_c, 10, "%f", yaw);

    char rollRate_c[10];
    snprintf(rollRate_c, 10, "%f", rollRate);

    char pitchRate_c[10];
    snprintf(pitchRate_c, 10, "%f", pitchRate);

    char yawRate_c[10];
    snprintf(yawRate_c, 10, "%f", yawRate);

    //    mavlink_msg_mission_item_int_pack_chan_test(systemId,
    //                                           componentId,
    //                                           chan,
    //                                           &messageOut,
    //                                           starttime_c,
    //                                           eppodroneID_c,
    //                                           userID_c,
    //                                           workingarea_c,
    //                                           spraystate_c,
    //                                           flowrate_c,
    //                                           lat_c,
    //                                           lon_c,
    //                                           alt_c,
    ////                                           roll_c,
    ////                                           pitch_c,
    ////                                           yaw_c,
    ////                                           rollRate_c,
    ////                                           pitchRate_c,
    ////                                             yawRate_c,
    //                                           groundspeedvalue_c,
    //                                           time_c,
    //                                           byte_out,
    //                                           byte_num);


    char buf[500];
    int bit = 0;
    memcpy(buf, starttime_c, strlen(starttime_c));
    bit += strlen(starttime_c);
    memcpy(buf + bit, ";", 1);
    bit += 1;
    memcpy(buf + bit, eppodroneID_c, strlen(eppodroneID_c));
    bit += strlen(eppodroneID_c);
    memcpy(buf + bit, ";", 1);
    bit += 1;
    memcpy(buf + bit, userID_c, strlen(userID_c));
    bit += strlen(userID_c);
    memcpy(buf + bit, ";", 1);
    bit += 1;
    memcpy(buf + bit, flowrate_c, strlen(flowrate_c));
    bit += strlen(flowrate_c);
    memcpy(buf + bit, ";", 1);
    bit += 1;
    memcpy(buf + bit, workingarea_c, strlen(workingarea_c));
    bit += strlen(workingarea_c);
    memcpy(buf + bit, ";", 1);
    bit += 1;
    memcpy(buf + bit, spraystate_c, strlen(spraystate_c));
    bit += strlen(spraystate_c);
    memcpy(buf + bit, ";", 1);
    bit += 1;
    memcpy(buf + bit, lon_c, strlen(lon_c));
    bit += strlen(lon_c);
    memcpy(buf + bit, ";", 1);
    bit += 1;
    memcpy(buf + bit, lat_c, strlen(lat_c));
    bit += strlen(lat_c);
    memcpy(buf + bit, ";", 1);
    bit += 1;
    memcpy(buf + bit, alt_c, strlen(alt_c));
    bit += strlen(alt_c);
    memcpy(buf + bit, ";", 1);
    bit += 1;
    memcpy(buf + bit, groundspeedvalue_c, strlen(groundspeedvalue_c));
    bit += strlen(groundspeedvalue_c);
    memcpy(buf + bit, ";", 1);
    bit += 1;
    memcpy(buf + bit, time_c, strlen(time_c));
    bit += strlen(time_c);
    memcpy(buf + bit, ";", 1);
    bit += 1;
    memcpy(buf + bit, liquidlevel_c, strlen(liquidlevel_c));
    bit += strlen(liquidlevel_c);
    memcpy(buf + bit, ";", 1);
    bit += 1;
    memcpy(buf + bit, flightmode_c, strlen(flightmode_c));
    bit += strlen(flightmode_c);

    //    char bit_c[10];
    //    sprintf(bit_c, "%d", bit);
    //    memcpy(buf + bit, bit_c, 4);
    //    bit += 4;

    long checksum = 0;
    for(int i = 0; i < bit; i++){
        checksum+=buf[i];
    }
    memcpy(buf + bit, &checksum, 4);
    bit += 4;

    memcpy(buf + bit, &bit, 4);
    bit += 2;


    //uint8_t buffer[MAVLINK_MAX_PACKET_LEN];

    //int cBuffer = mavlink_msg_to_send_buffer(buffer, &messageOut);

    //QByteArray bytes((char *)buffer, cBuffer);
    QByteArray bytes((char *)buf, bit);
    //qDebug()<<"buffer" << buffer;
    //qDebug()<<"cBuffer" << cBuffer;
//    qDebug()<<"bytes" << bytes;
    //bytes???????????????????bytes.toHex()?????????
    qDebug()<< bytes.toHex();

    //????????
    QVariantList nameList;
    QString bytes_string = bytes.toHex();

    QDateTime endTime1=  QDateTime::currentDateTime();
    qint64 intervalTime1 = startTime1.secsTo(endTime1); //???????
    qint64 intervalTimeMS1 = startTime1.msecsTo(endTime1);

    qDebug() << intervalTime1;  //???????????
    qDebug() << intervalTimeMS1; //?????????????

    return bytes_string;
    //    nameList << bytes_string;

    //    QSqlQuery query(db3);
    //    success = query.prepare("select * from data_soucre");
    //    qDebug() << success;
    //    QDateTime endTime2=  QDateTime::currentDateTime();
    //    qint64 intervalTime2 = startTime2.secsTo(endTime2); //???????
    //    qint64 intervalTimeMS2 = startTime2.msecsTo(endTime2);

    //    qDebug() << intervalTime2;  //???????????
    //    qDebug() << intervalTimeMS2; //?????????????

    //????????????????
    //    if(!sql_connect_flag||!success){

    //        QDateTime datetime;
    //        QString timestr=datetime.currentDateTime().toString("yyyy-MM-dd HH:mm:ss");
    //        QString day=datetime.currentDateTime().toString("MM.dd.hh");
    //        QString fileName = "../Unsetgps2QGC2.txt";
    //        QFile file(fileName);
    //        file.open(QIODevice::Append | QIODevice::Text );
    //        QTextStream in(&file);
    //        in << timestr;
    //        in << bytes_string;
    //        in <<endl;
    //        file.flush();
    //        file.close();

    //    }
    //    else{
    //        QDateTime startTime3 = QDateTime::currentDateTime();

    //        query.prepare("insert delayed into data_soucre(get_data) values(:get_data);");
    //        //????д??????
    //        query.bindValue(":get_data",nameList);

    //        if (!query.execBatch()) //??????????????????????????????
    //            {
    //            qDebug() << query.lastError();
    //    //        //??????????????
    //            int n = 0;
    //            if(n < 2){
    //                nameList << bytes_string;
    //                query.bindValue(":get_data",nameList);

    //                if (!query.execBatch()) //??????????????????????????????
    //                    {
    //                    qDebug() << query.lastError();
    //                    }
    //                else{
    //                    qDebug()<<"insert data success!";
    //                    }
    //                bool check_flag = msg_received_success(bytes_string);
    //                qDebug()<< check_flag;
    //                }
    //            else{
    //                data_save(bytes_string);
    //                }
    //            }
    //        else{
    //                qDebug()<<"insert data success!";
    //            }
    //        QDateTime endTime3=  QDateTime::currentDateTime();
    //        qint64 intervalTime3 = startTime3.secsTo(endTime3); //???????
    //        qint64 intervalTimeMS3 = startTime3.msecsTo(endTime3);

    //        qDebug() << intervalTime3;  //???????????
    //        qDebug() << intervalTimeMS3; //?????????????

    //    }
}

void Data::data_save_plan(){

    //202203Add 暂时将实时传输关掉，所有数值仅保存当地
    qDebug() << "save_plan_num" << save_plan_num << save_plan_num % 3;
    data_save_local();//本地保存
    save_plan_num++;

    /*if(save_plan_num % 3 == 0){
        qDebug() << "save_plan_num" << save_plan_num << save_plan_num % 3;
        data_save();//实时传输
        save_plan_num++;
    }else{
        qDebug() << "save_plan_num" << save_plan_num << save_plan_num % 3;
        data_save_local();//本地保存
        save_plan_num++;
    }*/
}

void Data::data_save_local(){
    //获得系统时间并输出
    QString min = QDateTime::currentDateTime().toString("yyyyMMdd");
    QString timestr = QDateTime::currentDateTime().toString("yyyy-MM-dd HH:mm:ss");

    dir_path =  "../DATA_SAVE";  //电脑
    //dir_path =  "/storage/emulated/0/DATA_SAVE";  //手机
    if(save_num == 1){

        QDir dir;
        if(!dir.exists(dir_path)){
            dir.mkdir(dir_path);//创造一个文件夹
//                    qDebug() << "make dir fail";
        }

        //打开文本 以时间命名文件名字
        save_filename = dir_path + "/" + min + ".txt";


    }

    qDebug() << save_filename;

    QFile f(save_filename);
    QTextStream in(&f);
    if(!f.open( QIODevice::WriteOnly | QIODevice::Append | QIODevice::Text)){
//                qDebug() << "open fail";
        return;
    }
    in << timestr;
    in << make_mavlink_pakage();
    in <<endl;

    f.flush();
    f.close();
    //202203注释 每天保存一个文件
    /*if(save_num % 50 == 0)
    {
        //获得系统时间并输出
        save_filename = dir_path + "/" + min + ".txt";

    }else{
        QFile f(save_filename);
        QTextStream in(&f);
        if(!f.open( QIODevice::WriteOnly | QIODevice::Append | QIODevice::Text)){
//                qDebug() << "open fail";
            return;
        }
        in << timestr;
        in << make_mavlink_pakage();
        in <<endl;

        f.flush();
        f.close();

    }*/
    save_num++;
}

//将上传数据改为使用tcp直接发数据
void Data::data_save(){

    //202203Add 新增使用tcp发送

    QTcpSocket *mSocket = new QTcpSocket();
    mSocket->connectToHost(QHostAddress::LocalHost,8080);
    QByteArray sendMessage = make_mavlink_pakage().toLocal8Bit();
    mSocket->write(sendMessage);

    //202203注释 原来保存数据库的代码，全部注释
    /*
    QDateTime startTime2=  QDateTime::currentDateTime();

    //????????
    QSqlQuery query(mySqlhelper::db3);
    query_success = query.prepare("select * from data_soucre");
    qDebug() << query_success ;
    QDateTime endTime2=  QDateTime::currentDateTime();
    qint64 intervalTime2 = startTime2.secsTo(endTime2); //???????
    qint64 intervalTimeMS2 = startTime2.msecsTo(endTime2);

    qDebug() <<intervalTime2;  //???????????
    qDebug() <<intervalTimeMS2; //?????????????

    //        QString dir_path =  QCoreApplication::applicationDirPath()+"/" +"file";
    QDateTime startTime3 = QDateTime::currentDateTime();

    if(!mySqlhelper::sql_connect_flag||!query_success){

        qDebug()<<"insert data failed!";
        //获得系统时间并输出
        QString min = QDateTime::currentDateTime().toString("yyyyMMddhhmmss");
        QString timestr = QDateTime::currentDateTime().toString("yyyy-MM-dd HH:mm:ss");
//        dir_path =  "../DATA_SAVE";
        dir_path =  "/storage/emulated/0/DATA_SAVE";
        if(save_num == 1){

            QDir dir;
            if(!dir.exists(dir_path)){
                dir.mkdir(dir_path);//创造一个文件夹
//                    qDebug() << "make dir fail";
            }

            //打开文本 以时间命名文件名字
            save_filename = dir_path + "/" + min + ".txt";
            qDebug() << save_filename;

        }
        if(save_num % 50 == 0)
        {
            //获得系统时间并输出
            save_filename = dir_path + "/" + min + ".txt";

        }else{
            QFile f(save_filename);
            QTextStream in(&f);
            if(!f.open( QIODevice::WriteOnly | QIODevice::Append | QIODevice::Text)){
//                qDebug() << "open fail";
                return;
            }
            in << timestr;
            in << make_mavlink_pakage();
            in <<endl;

            f.flush();
            f.close();

        }
        save_num++;
    }
    else{
        QVariantList nameList;
        nameList << make_mavlink_pakage();

        query.prepare("insert delayed into data_soucre(get_data) values(:get_data);");
        //????д??????
        query.bindValue(":get_data",nameList);

        if (!query.execBatch()) //??????????????????????????????
        {
            qDebug() << query.lastError();
//            query.bindValue(":get_data",nameList);//Send of the second time

//            if (!query.execBatch()) //??????????????????????????????
//            {
//                qDebug() << query.lastError();

                //            }
                //            else{
                //                qDebug()<<"insert data success!";
                //            }
                //                bool check_flag = msg_received_success(make_mavlink_pakage());
                //                qDebug()<< check_flag;

                //获得系统时间并输出
                QString min = QDateTime::currentDateTime().toString("yyyyMMddhhmmss");
                QString timestr = QDateTime::currentDateTime().toString("yyyy-MM-dd HH:mm:ss");
//                dir_path =  "../DATA_SAVE";
                dir_path =  "/storage/emulated/0/DATA_SAVE";

                if(save_num == 1){

                    QDir dir;
                    if(!dir.exists(dir_path)){
                        dir.mkdir(dir_path);//创造一个文件夹
                    }

                    //打开文本 以时间命名文件名字
                    save_filename = dir_path + "/" + min + ".txt";
                    qDebug() << save_filename;

                }
                if(save_num % 50 == 0)
                {
                    //获得系统时间并输出
                    save_filename = dir_path + "/" + min + ".txt";

                }else{
                    QFile f(save_filename);
                    QTextStream in(&f);
                    if(!f.open( QIODevice::WriteOnly | QIODevice::Append | QIODevice::Text))
                        return;
                    in << timestr;
                    in << make_mavlink_pakage();
                    in <<endl;

                    f.flush();
                    f.close();

                }
                save_num++;
            }
            else{
                qDebug()<<"insert data success!";
            }
//        }
//        else{
//            qDebug()<<"insert data success!";
//        }
        QDateTime endTime3=  QDateTime::currentDateTime();
        qint64 intervalTime3 = startTime3.secsTo(endTime3); //???????
        qint64 intervalTimeMS3 = startTime3.msecsTo(endTime3);

        qDebug() << intervalTime3;  //???????????
        qDebug() << intervalTimeMS3; //?????????????
    }*/
}

//?ж??????????????
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
    //网络连接配置
    QNetworkConfigurationManager mgr;
    //    return mgr.isOnline();
    if(mgr.isOnline()){
        //202203Add
        QApplication::setQuitOnLastWindowClosed(false);//??????????????
        if(QMessageBox::Ok == QMessageBox::information(nullptr, "Title",QString::fromUtf8("Click 'OK' button,Start Sending Data"),QMessageBox::Ok)){
          return true;
        }
        return true;

        //202203注释  取消判断能不能连接到数据库
        /*if(mySqlhelper::sql_connect_flag){
            QApplication::setQuitOnLastWindowClosed(false);//??????????????
            if(QMessageBox::Ok == QMessageBox::information(nullptr, "Title",QString::fromUtf8("Click 'OK' button,Start Sending Data"),QMessageBox::Ok)){
              return true;
            }
            return true;
        }
        else{
            QApplication::setQuitOnLastWindowClosed(false);//??????????????
            if(QMessageBox::Ok == QMessageBox::warning(nullptr, "Warning",QString::fromUtf8("Database connection failure"),QMessageBox::Ok)){
              return false;
            }
            return false;
        }*/
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
    _progressBar = 0;
    _msg_value=0;
    openFile();



    //202203注释  回传改为tcp
    /*

    //网络连接配置
    //    QNetworkConfigurationManager mgr;
    //    qDebug()<< mgr.isOnline();
    //    if(mgr.isOnline()){
    //        if(sql_connect_flag)
    //        {
    //获取TXT文件内数据
    //            QFile dataFile("../Unsetgps2QGC2.txt");
    //判断路径是否存在
//                dir_path =  "../DATA_SAVE";
    dir_path =  "/storage/emulated/0/DATA_SAVE";
    QDir dir(dir_path);
    if(!dir.exists())
    {
        //                return;
        qDebug()<< dir_path + "no exists!";
        _msg_value = 1;
    }else{
        QStringList filters;
        dir.setFilter(QDir::Files | QDir::NoSymLinks);
        QFileInfoList list = dir.entryInfoList();

        int file_count = list.count();
        if(file_count <= 0)
        {
            //                return;
            qDebug()<<"insert data success!";
            _progressBar = 100.0;
            _msg_value = 2;
        }else{

            QStringList string_list;
            for(int i=0; i< file_count; i++)
            {
                QFileInfo file_info = list.at(i);
                QString suffix = file_info.suffix();
                if(QString::compare(suffix, QString("txt"), Qt::CaseInsensitive) == 0)
                {
                    QString absolute_file_path = file_info.absoluteFilePath();
                    //                          qDebug()<<absolute_file_path;

                    string_list.append(absolute_file_path);
                }
            }
            qDebug()<<string_list;
            int string_list_count = string_list.count();
            if(string_list_count != 0){
                for(int j=0; j< string_list_count; j++)
                {
                    QFile dataFile(string_list[j]);

                    QStringList fonts;
                    if (dataFile.open(QFile::ReadOnly|QIODevice::Text))
                    {
                        QTextStream data(&dataFile);

                        QString lines;
                        QString line;



                        QSqlQuery query(mySqlhelper::db3);
                        qDebug() << mySqlhelper::db3.driver() -> hasFeature(QSqlDriver::Transactions);//验证 QT 是否支持 MySQL 的数据库事务
                        if(mySqlhelper::db3.transaction())
                        {
                            qDebug()<<"open ok";
                        }
                        else{
                            qDebug()<<"open error";
                        }

                        query.prepare("insert delayed into data_soucre(get_data) values(:get_data);");

                        //?б???д??????
                        QVariantList nameList;
                        while (!data.atEnd())//???ж?????
                        {
                            lines = data.readLine();
                            line = lines.mid(19);
                            line.remove('\n');
                            //                                    qDebug()<<line;
                            nameList << line;
                        }
                        dataFile.flush();
                        dataFile.close();

                        //202203注释  回传不再传数据库
                        query.bindValue(":get_data",nameList);

                        if (!query.execBatch()) //??????????????????????????????
                        {
                            qDebug() << query.lastError();
                            _msg_value = 3;
                            break;
                        }
                        else if(j == string_list_count-1)
                        {
                            QFile::remove(string_list[j]);
                            qDebug()<<"insert data success!";
                            _progressBar = _progressBar + 100.0/(string_list_count);
                            qDebug()<<_progressBar;
                            _msg_value = 2;
                        }
                        else{
                            qDebug()<<"insert data success!"<<j;
                            QFile::remove(string_list[j]);
                            _progressBar = _progressBar + 100.0/(string_list_count);
                            qDebug()<<_progressBar;
                            //                                    progressBar_value();
                        }
                    }
                }
            }else{
                qDebug()<<"insert data success!";
                _progressBar = 100.0;
                _msg_value = 2;
            }
        }
    }*/
    //                //??????
    //                //                         if(db3.commit())
    //                //                         {
    //                //                             qDebug()<<"commit ok";
    //                //                             QFile dataFile("../Unsetgps2QGC.txt");
    //                //                             if(!dataFile.open(QFile::WriteOnly|QIODevice::Truncate|QIODevice::Text))
    //                //                             {
    //                //                                 qDebug()<<"Failed to clear the file";
    //                //                                    }
    //                //                             dataFile.close();
    //                //                             QApplication::setQuitOnLastWindowClosed(false);//??????????????
    //                //                             QMessageBox::information(nullptr, "Title",QString::fromUtf8("Send Success!"),QMessageBox::Ok);
    //                //                         }
    //                //                         else{
    //                //                             qDebug()<<"commit error";
    //                //                             QFile dataFile("../Unsetgps2QGC.txt");
    //                //                             if(!dataFile.open(QFile::WriteOnly|QIODevice::Truncate|QIODevice::Text))
    //                //                             {
    //                //                                 qDebug()<<"Failed to clear the file";
    //                //                                    }
    //                //                             dataFile.close();
    //                //                             QApplication::setQuitOnLastWindowClosed(false);//??????????????
    //                //                             QMessageBox::warning(nullptr,tr("Warning"),QString::fromUtf8("Send Failure!"),QMessageBox::Ok);
    //                //                         }

    //                dataFile.close();

    //            }
    //        }
    //        else{
    //            msg_value = 3;
    //        }
    //    }
    //    else{
    //        msg_value = 2;
    //    }
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


//202203Add  新增
void Data::openFile(){
    QString min = QDateTime::currentDateTime().toString("yyyyMMdd");
    dir_path =  "../DATA_SAVE";  //电脑
    //dir_path =  "/storage/emulated/0/DATA_SAVE";  //手机
    QDir dir(dir_path);
    if(!dir.exists())
    {
        //                return;
        qDebug()<< dir_path + "no exists!";
        _msg_value = 1;
    }else{
        //打开文本 以时间命名文件名字
        m_fileName = dir_path + "/" + min + ".txt";
    if(!m_fileName.isEmpty()){
        send();
    }else{
        qDebug()<<"insert data success!";
        _progressBar = 100.0;
        _msg_value = 2;
    }
    }
}

void Data::send(){
    m_bytesWritten=0;
    m_tcpClient->connectToHost(QHostAddress::LocalHost,8080);
}

void Data::startTransfer(){
    m_localFile=new QFile(m_fileName);
    if(!m_localFile->open(QFile::ReadOnly)){
        qDebug()<<"client：open file error!";
        return;
    }
    m_totalBytes=m_localFile->size();
    QDataStream sendOut(&m_outBlock,QIODevice::WriteOnly);
    sendOut.setVersion(QDataStream::Qt_5_7);
    QString currentFileName=m_fileName.right(m_fileName.size()-m_fileName.lastIndexOf('/')-1);
    //文件总大小、文件名大小、文件名
    sendOut<<qint64(0)<<qint64(0)<<currentFileName;
    m_totalBytes+=m_outBlock.size();
    sendOut.device()->seek(0);
    sendOut<<m_totalBytes<<qint64(m_outBlock.size()-sizeof(qint64)*2);
    m_bytesToWrite=m_totalBytes-m_tcpClient->write(m_outBlock);
    m_outBlock.resize(0);
}

void Data::updateClientProgress(qint64 numBytes){
    m_bytesWritten+=(int)numBytes;
    if(m_bytesToWrite>0){
        m_outBlock=m_localFile->read(qMin(m_bytesToWrite,m_payloadSize));
        m_bytesToWrite-=(int)m_tcpClient->write(m_outBlock);
        m_outBlock.resize(0);
    }
    else{
        m_localFile->close();
    }
    _progressBar = m_bytesWritten/m_totalBytes;


    if(m_bytesWritten==m_totalBytes){
        _msg_value = 2;
        m_localFile->close();
        m_tcpClient->close();
    }
}

void Data::displayError(QAbstractSocket::SocketError){
    qDebug()<<m_tcpClient->errorString();
    m_tcpClient->close();
    _msg_value = 1;
    _progressBar = 0;
}


bool Data::update_starttime=false;
QString Data::starttime="2020-02-20 20:20:20";
int Data::eppodroneID=0;
QString Data::userID="User not logged in";
uint8_t Data::spraystate=0;//喷洒状态
double Data::flowrate=0;
double Data::lat=0;
double Data::lon=0;
double Data::alt=0;
double Data::workingarea=0;
double Data::groundspeedvalue=0;
QString Data::time;
uint8_t Data::liquidlevel=1;
QString Data::flightmode;

double Data::roll=0;
double Data::pitch=0;
double Data::yaw=0;
double Data::rollRate=0;
double Data::pitchRate=0;
double Data::yawRate=0;

int Data::save_num=1;//发送数据的次数
int Data::save_plan_num=0;//存储数据的次数

QString Data::save_filename="";
QString Data::dir_path="";

QSqlDatabase mySqlhelper::db3;

double Data::_progressBar;
int Data::_msg_value=0;

bool Data::query_success;

QTcpSocket *Data::m_tcpClient;
QFile *Data::m_localFile;
qint64 Data::m_totalBytes;
qint64 Data::m_bytesWritten;
qint64 Data::m_bytesToWrite;
qint64 Data::m_payloadSize;
QString Data::m_fileName;
QByteArray Data::m_outBlock;


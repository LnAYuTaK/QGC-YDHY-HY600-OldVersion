#include "mysqlhelper.h"

mySqlhelper::mySqlhelper()
{

    stopped = false;
//    sql_connect_flag=false;
//    stopped = Data::success;

    dbOkLocal = false;

    errorCount = 0;
    lastCheckTimeLocal = QDateTime::currentDateTime();

//    checkConn = false;
    checkInterval = 120;

//    dbTypeLocal = DbType_MySql;
//    connNameLocal = "qt_sql_default_connection";
//    hostNameLocal = "127.0.0.1";
//    portLocal = 3306;
//    dbNameLocal = "db_mysql";
//    userNameLocal = "root";
//    userPwdLocal = "root";
}

mySqlhelper::~mySqlhelper()
{
    this->stop();
//    this->wait();
}

//????MySql
bool mySqlhelper::sqlconnect(){
    //???Qt?????????
    qDebug() << QSqlDatabase::drivers();

    //????QMYSQL?????
    //    db3 = QSqlDatabase::addDatabase("QMYSQL","third");
    //??????"third"?????????????????
    if(QSqlDatabase::contains("third"))  //?????ж???????????????????????????
    {
        db3 = QSqlDatabase::database("third");
    }else
    {
        db3 = QSqlDatabase::addDatabase("QMYSQL","third");
    }
    qDebug() << QObject::tr("---------------------------------database connection name:%1").arg(db3.connectionName());

    //?????????
    //    db3.setHostName("localhost"); //???????????
    //    db3.setPort(3306);
    //    db3.setUserName("root"); //??????????
    //    db3.setPassword("5317"); //?????????
    //    db3.setDatabaseName("gtod"); //???????

    db3.setHostName("144.123.30.226"); //???????????IP
    db3.setPort(23);
    db3.setUserName("ytzbpt"); //??????????
    db3.setPassword("ydhy@160725"); //????
    db3.setDatabaseName("ytzbpt"); //???????????
    db3.setConnectOptions("MYSQL_OPT_RECONNECT=1");
    //db3.setConnectOptions("MYSQL_OPT_RECONNECT=1;MYSQL_OPT_CONNECT_TIMEOUT=1;MYSQL_OPT_READ_TIMEOUT=1;MYSQL_OPT_WRITE_TIMEOUT=1");

    //???????????????????
    bool flag = db3.open();
    if(!flag)
    {
        qDebug()<<"connect to mysql error"<<db3.lastError().text();
        return false;
    }
    else
    {
        sql_connect_flag = true;
        qDebug()<<"connect to mysql OK";
        if (db3.isValid()){
            qDebug("vaild!");
        }
        return true;
    }
}


//void mySqlhelper::run()
//{
//            //如果数据库连接正常则处理数据,不正常则重连数据库
//                closeDb();
//                msleep(1000);
//                mysql_errorCount = 0;
////                dbOkLocal = db3.open();
//                dbOkLocal = sqlconnect();
//                qDebug()<<(QString::fromUtf8("Reconnection Database %1").arg(dbOkLocal ? QString::fromUtf8("Success") : QString::fromUtf8("Failure")));
//}


//飞行全程监测使用
void mySqlhelper::run()
{
    QMutex mutex;
    while (!stopped) {
            mutex.lock();
            if(stopped == true) break;
            mutex.unlock();
            //定时执行一次校验数据库连接是否正常
            QDateTime now = QDateTime::currentDateTime();
//            if (checkConn && lastCheckTimeLocal.secsTo(now) >= checkInterval) {
            if (lastCheckTimeLocal.secsTo(now) >= checkInterval) {
                checkDb();
                lastCheckTimeLocal = now;
                continue;
            }

            //如果数据库连接正常则处理数据,不正常则重连数据库
            if (!dbOkLocal && errorCount >= 1) {
                closeDb();
                msleep(3000);
//                openDb();
//                Data::db3.setConnectOptions();
//                Data::sqlconnect();
                errorCount = 0;
                dbOkLocal = db3.open();
//                dbOkLocal = Data::success;
                qDebug()<<(QString::fromUtf8("Reconnection Database %1").arg(dbOkLocal ? QString::fromUtf8("Success") : QString::fromUtf8("Failure")));
                msleep(3000);
            } else {
                msleep(100);
            }
        }

        stopped = false;
}


bool mySqlhelper::checkDb()
{
    QDateTime dtStart = QDateTime::currentDateTime();

    QString sql = "select 1";
    QSqlQuery query(db3);
//    dbOkLocal = query.exec(sql);
    dbOkLocal = query.prepare(sql);
    dbOkLocal ? (errorCount = 0) : errorCount++;

    QDateTime dtEnd = QDateTime::currentDateTime();
    double ms = dtStart.msecsTo(dtEnd);
    qDebug()<<(QString::fromUtf8("Check Mysql Database connect(Total %1 Bar/Time %2 Second)").arg(1).arg(QString::number(ms / 1000, 'f', 3)));
    qDebug()<<dbOkLocal;
    return dbOkLocal;
}

void mySqlhelper::closeDb()
{
    //关闭数据库删除
//    dbConnLocal.close();
//    QSqlDatabase::removeDatabase(connNameLocal);
//    QString connectionName = Data::db3.connectionName();
    db3.close();
//    Data::db3 = QSqlDatabase();
//    Data::db3.removeDatabase(connectionName);
    QString name;
    {
        name = QSqlDatabase::database().connectionName();
    }//超出作用域，隐含对象QSqlDatabase::database()被删除。
    QSqlDatabase::removeDatabase(name);
//    Data::db3.close();
//    QSqlDatabase::removeDatabase("third");
    dbOkLocal = false;
    qDebug()<<QString::fromUtf8("Close Mysql Database");
}

void mySqlhelper::stop()
{
    stopped = true;
//    this->terminate();//关闭该线程
    this->quit();//关闭该线程
    this->wait();
}


bool mySqlhelper::sql_connect_flag=false;
int mySqlhelper::mysql_errorCount=0;

























































//bool mySqlhelper::openDb()
//{
//    //可以自行增加其他数据库的支持
//    if (dbTypeLocal == DbType_Sqlite) {
//        dbConnLocal = QSqlDatabase::addDatabase("QSQLITE", connNameLocal);
//        dbConnLocal.setDatabaseName(dbNameLocal);
//    } else if (dbTypeLocal == DbType_MySql) {
//        dbConnLocal = QSqlDatabase::addDatabase("QMYSQL", connNameLocal);
//        dbConnLocal.setConnectOptions("MYSQL_OPT_RECONNECT=1;MYSQL_OPT_CONNECT_TIMEOUT=1;MYSQL_OPT_READ_TIMEOUT=1;MYSQL_OPT_WRITE_TIMEOUT=1");
//        dbConnLocal.setHostName(hostNameLocal);
//        dbConnLocal.setPort(portLocal);
//        dbConnLocal.setDatabaseName(dbNameLocal);
//        dbConnLocal.setUserName(userNameLocal);
//        dbConnLocal.setPassword(userPwdLocal);
//    }

//    errorCount = 0;
//    dbOkLocal = dbConnLocal.open();
//    return dbOkLocal;
//}

//void mySqlhelper::setConnInfo(DbLocalThread::DbType dbType, const QString &connName, const QString &hostName, int port, const QString &dbName, const QString &userName, const QString &userPwd)
//{
//    this->dbTypeLocal = dbType;
//    this->connNameLocal = connName;
//    this->hostNameLocal = hostName;
//    this->portLocal = port;
//    this->dbNameLocal = dbName;
//    this->userNameLocal = userName;
//    this->userPwdLocal = userPwd;
//}

//void mySqlhelper::setCheckConn(bool checkConn)
//{
//    this->checkConn = checkConn;
//}

//void mySqlhelper::setCheckInterval(int checkInterval)
//{
//    if (checkInterval > 5 && this->checkInterval != checkInterval) {
//        this->checkInterval = checkInterval;
//    }
//}

//QSqlDatabase mySqlhelper::getDb()
//{
//    return dbConnLocal;
//}

//bool mySqlhelper::getOk()
//{
//    return dbOkLocal;
//}

//sql查询操作
//void MainWindow::on_pushButton_clicked()
//{
//    QSqlQueryModel *model = new QSqlQueryModel;
//    model->setQuery("select * from wdgl_user");
//    model->setHeaderData(0, Qt::Horizontal, tr("用户id"));
//    model->setHeaderData(1, Qt::Horizontal, tr("用户说明"));
//    model->setHeaderData(2, Qt::Horizontal, tr("密码"));
//    model->setHeaderData(3, Qt::Horizontal, tr("用户名"));
//    QTableView *view = new QTableView;//弹出对话框
//    view->setGeometry(200,200,450,800);
//    view->setWindowTitle("用户列表");
//    view->setMinimumSize(450,800);//设置不可改变大小
//    view->setMaximumSize(450,800);
//    view->setModel(model);
//    view->show();
//}

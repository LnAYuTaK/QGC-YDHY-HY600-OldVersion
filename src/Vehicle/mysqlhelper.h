#ifndef MYSQLHELPER_H
#define MYSQLHELPER_H

#include <QThread>
#include <QDebug>
#include <QTimer>
#include <QtSql>
#include <QSqlDatabase>
#include <QObject>

class mySqlhelper : public QThread
{
    Q_OBJECT
public:
    mySqlhelper();
    ~mySqlhelper();

    static QSqlDatabase db3;
    static bool sql_connect_flag;

    static int mysql_errorCount;
//    bool success;
    bool dbOkLocal;

    bool stopped;
    int errorCount;
    QDateTime lastCheckTimeLocal;
    bool checkConn;
    int checkInterval;

//    typedef struct _testInfo //假定数据库存储内容
//    {
//        QString UsreName;
//        QString IP;
//        QString Port;
//        QString PassWord;
//        QString Type;

//    }testInfo;

//    QSqlDatabase dbTypeLocal;
//    QString connNameLocal;
//    QString hostNameLocal;
//    int portLocal;
//    QString dbNameLocal;
//    QString userNameLocal;
//    QString userPwdLocal;
    static bool sqlconnect();

    void stop();
private slots:
    void run();
private:
//    bool openDb();
    bool checkDb();
    void closeDb();
//    void setCheckConn(bool checkConn);
//    void setCheckInterval(int checkInterval);
//    QSqlDatabase getDb();
//    bool getOk();
};

#endif // MYSQLHELPER_H

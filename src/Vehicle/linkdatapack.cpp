//#include "linkdatapack.h"
#include "Vehicle.h"
//#include "ui_mainwindow.h"
#include <QSqlDatabase>
#include <QDebug>
#include <QMessageBox>
#include <QSqlError>
#include <QSqlQuery>
#include <QVariantList>


LinkDataPack::LinkDataPack(QWidget *parent)
    : QMainWindow(parent)
//    , ui(new Ui::MainWindow)
{
//    ui->setupUi(this);

    //��ӡQt֧�ֵ����ݿ�����
    qDebug() << QSqlDatabase::drivers();

    //����MySql���ݿ�
    QSqlDatabase db = QSqlDatabase::addDatabase("QMYSQL");

    //�������ݿ�

    db.setHostName("localhost"); //���ݿ�������IP
    db.setPort(3306);
    db.setUserName("root"); //���ݿ��û���
    db.setPassword("5317"); //����
    db.setDatabaseName("slfh"); //ʹ���ĸ����ݿ�

    //�������ݿ�
    db.open();
    if(!db.open())
    {
        qDebug()<<"��������"<<"connect to mysql error"<<db.lastError().text();
        return ;
    }
    else
    {
         qDebug()<<"���ӳɹ�"<<"connect to mysql OK";
    }
//    QSqlQuery query(db);
//    query.exec("insert into databack(databack) values('fffffffffffff');");
//    while(query.next()){
//        qDebug()<<query.value("zzzzzzzzzz").toString();
    QSqlQuery query;
       query.exec("create table databack(databack varchar(255));");
       //odbc����
       //Ԥ��������
       //���൱��ռλ��
       query.prepare("insert into databack(databack) values(:databack);");
       //���ֶ��������� list
       QVariantList nameList;
       nameList<<"xiaoming1"<<"xiaolong1"<<"xiaojiang1";
       //nameList<< datapack.datastream.toString() ;
//       QVariantList ageList;
//       ageList<<11<<22<<33;
//       QVariantList scoreList;
//       scoreList<<59<<69<<79;
       //���ֶΰ�����Ӧ��ֵ����˳������
       query.bindValue(":databack",nameList);
//       query.bindValue(":score",scoreList);
//       query.bindValue(":age",ageList);
       //ִ��Ԥ��������
       query.execBatch();

}

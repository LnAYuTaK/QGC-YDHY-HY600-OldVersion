#ifndef SQLITEHELPER_H
#define SQLITEHELPER_H

#include <QSqlDatabase>
#include <QSqlError>
#include <QSqlQuery>
#include <QStandardPaths>


class SqliteHelper
{
public:
   SqliteHelper();

   QSqlDatabase database;
//   QSqlQuery sql_query;

   void openDatabase();
   void closeDatabase();
   void createtable();
   void insertData();
   void updateData();
   void selectData();
   void deleteData();

   void sqliteconnect();//连接数据库

//   void executeQuery(QString sql_command);
};

#endif // SQLITEHELPER_H

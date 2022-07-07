#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include "MAVLinkProtocol.h"

#include <QtSql>

#include <QSqlDatabase>

QT_BEGIN_NAMESPACE
//namespace Ui { class MainWindow; }
QT_END_NAMESPACE

class LinkDataPack : public QMainWindow
{
    Q_OBJECT

public:
    LinkDataPack(QWidget *parent = nullptr);
//    ~MainWindow();
    mavlink_message_t datastream;
    void connectMYSQL();
    void createDB();
    void initDB();

    QSqlDatabase database;

//private:
//    Ui::MainWindow *ui;
};
#endif // MAINWINDOW_H

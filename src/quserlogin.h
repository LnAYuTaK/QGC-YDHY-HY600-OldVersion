#ifndef QUSERLOGIN_H
#define QUSERLOGIN_H
#include <QObject>

#include <QJsonArray>
#include <QJsonValue>
#include <QJsonObject>
#include "data.h"
#include "mysqlhelper.h"


class QUserLogin : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString _usertxt READ usertxt WRITE setuser NOTIFY txtchanged)
    Q_PROPERTY(QString _passwordtxt READ passwordtxt WRITE setpassword NOTIFY txtchanged)
    Q_PROPERTY(bool _rememberPsdchecked READ rememberPsdchecked WRITE setrememberPsdchecked NOTIFY txtchanged)

public:
    explicit QUserLogin(QObject *parent = nullptr);
    //QUserLogin();
    Q_INVOKABLE void test();
    Q_INVOKABLE bool check();
    Q_INVOKABLE void rember();
    Q_INVOKABLE QJsonObject autotext();
    Q_INVOKABLE void autologin();
    Q_INVOKABLE void execlogin();

    QString usertxt() const{return _usertxt;}
    void setuser(QString s){_usertxt = s; emit txtchanged();}
    QString passwordtxt() const{return _passwordtxt;}
    void setpassword(QString pw){_passwordtxt = pw; emit txtchanged();}
    bool rememberPsdchecked() const{return _rememberPsdchecked;}
    void setrememberPsdchecked(bool rembercheck){_rememberPsdchecked = rembercheck; emit txtchanged();}

signals:
    void txtchanged();


private:
    QString _usertxt;
    QString _passwordtxt;
    bool _rememberPsdchecked;

};

#endif // QUSERLOGIN_H

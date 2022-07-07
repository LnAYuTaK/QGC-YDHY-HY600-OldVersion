#include "quserlogin.h"
#include<QMessageBox>
#include<QtSql>

//QUserLogin::QUserLogin()
QUserLogin::QUserLogin(QObject *parent) : QObject(parent)
{
//    _txt = "top color is red";
}
void QUserLogin::test(){
    qDebug()<<"_txt: "<<_usertxt;
    qDebug()<<"_passwordtxt: "<<_passwordtxt;
}

bool QUserLogin::check(){
//    return true;
    QJsonObject uandp;
    uandp.insert("remusertxt",_usertxt);
    uandp.insert("rempsd",_passwordtxt);

    QString user,psd;
    user = _usertxt;
    psd = _passwordtxt;

    //判断是否成功连接数据库中表
//    bool flag = Data::db3.open();
    QSqlQuery query(mySqlhelper::db3);
    bool success = query.exec("select * from user_admin");
    if(!success)
    {
        qDebug()<<"open user_admin error"<<mySqlhelper::db3.lastError().text();

        if(uandp == autotext()){
            if(QMessageBox::Ok == QMessageBox::information(nullptr, "Title",QString::fromLocal8Bit("用户登录成功，请点击“OK”键稍后..."),QMessageBox::Ok)){
            Data::userID=_usertxt;
            return true;
            }
            return true;
         }
        else {
            if(QMessageBox::Ok == QMessageBox::warning(nullptr,tr("Warning"),QString::fromLocal8Bit("用户名或密码错误"),QMessageBox::Ok)){
        return false;
        }
        return false;
        }
    }
    else
    {
         qDebug()<<"open user_admin OK";

        if(user==""||psd==""){
            if(QMessageBox::Ok == QMessageBox::warning(nullptr,tr("Warning"),QString::fromLocal8Bit("用户名或密码为空"),QMessageBox::Ok)){
            return false;
           }
            return false;
        }
        else {

            QString user_admin=QString("select * from user_admin where user_admin='"+user+"' and user_pwd='"+psd+"'");
            QSqlQuery query(mySqlhelper::db3);

            if(query.exec(user_admin)&&query.next()){          //query.exec(s)是否执行成功,query.next()返回查询结果中的第一条
                if(QMessageBox::Ok == QMessageBox::information(nullptr, "Title",QString::fromLocal8Bit("用户登录成功，请点击“OK”键稍后..."),QMessageBox::Ok)){
                Data::userID=_usertxt;
        //            QMessageBox *box = new QMessageBox(QMessageBox::Information,"Title",QString::fromLocal8Bit("用户登录成功"));
        //            box->setStandardButtons(0); //删除ok
        //            QTimer::singleShot(1500,box,SLOT(accept())); //也可将accept改为close
        //            box->exec(); //box->show();都可以
                return true;
                }
            return true;
            }
        //        else if(!query.exec(user_admin)&&(uandp == autotext())){
        //            QMessageBox::information(nullptr, "Title",QString::fromLocal8Bit("用户登录成功，请点击“OK”键稍后..."),QMessageBox::Ok);
        //            Data::userID=_usertxt;
        //                   return true;
        //                    }
            else {
                if(QMessageBox::Ok == QMessageBox::warning(nullptr,tr("Warning"),QString::fromLocal8Bit("用户名或密码错误"),QMessageBox::Ok)){
                    return false;
                    }
                return false;
            }
        }
    }
}

//记住账号密码存储
void QUserLogin::rember(){
    QString rem_usertxt,rem_psd;
    QString remove_duplicate;

//    QDateTime qtimeObj = QDateTime::currentDateTime();//获取时间
//    QString alltext;
//    //创建UIDdate文件夹
//        QDir *folder = new QDir;
//        bool exist = folder->exists("\\storage\\emulated\\0\\data\\UIDdate");
//        if(exist)
//        {
//            //QMessageBox::warning(this, tr("createDir"), tr("Dir is already existed!"));
//            qDebug()<<" UIDdate already exist";
//        }
//        else
//        {
//            //创建文件夹
//            bool ok = folder->mkdir("\\storage\\emulated\\0\\data\\UIDdate");
//            if(ok)
//                qDebug()<<"connect to UIDdate OK";
//            else
//                qDebug()<<"connect to UIDdate ERROR";
//        }

        qDebug()<<_rememberPsdchecked;
//    if(QUserLogin::check()&&_rememberPsdchecked){
    if(_rememberPsdchecked){
        rem_usertxt = _usertxt;
        rem_psd = _passwordtxt;
        remove_duplicate =_usertxt+"rem_psd: "+_passwordtxt ;
        QString fileName = "../clientmanmage.txt";
//        QString fileName = "\\storage\\emulated\\0\\data\\UIDdate\\clientmanmage.txt";
        QFile file(fileName);
        if (file.exists())
        {
        file.remove();
        file.open(QIODevice::WriteOnly |QIODevice::Append | QIODevice::Text );
//        if(file.size() == 0){
//        QTextStream data(&file);
//        QString lines;
//        bool flag;
//        while (!data.atEnd())//逐行读取文本
//                {
//                  lines = data.readLine();
//                  qDebug()<<lines;
//                    if(remove_duplicate == lines){
//                       flag = false;
//                    }
//                    else{
//                    }
//                }

        QTextStream in(&file);
        in << rem_usertxt <<"rem_psd: "<< rem_psd;
        in <<endl;
        file.flush();
        file.close();
        qDebug()<<"connect to clientmanmage OK";
        }
        else{
        file.open(QIODevice::WriteOnly |QIODevice::Append | QIODevice::Text );
        QTextStream in(&file);
        in << rem_usertxt <<"rem_psd: "<< rem_psd;
        in <<endl;
        file.flush();
        file.close();
        qDebug()<<"connect to clientmanmage OK";
        }
    }
    else{
        QString fileName = "../clientmanmage.txt";
        QFile file(fileName);
        if (file.exists())
        {
        file.remove();
        }
    }
        autotext();
}

QJsonObject QUserLogin::autotext(){
    QString remusertxt,rempsd;
    QJsonObject user_info;

    QString fileName = "../clientmanmage.txt";
//    QString fileName = "\\storage\\emulated\\0\\data\\UIDdate\\clientmanmage.txt";
    QFile file(fileName);
    if (file.open(QIODevice::ReadOnly | QIODevice::Text))
    {
        QString lines;
        while (!file.atEnd())
        {
            lines = file.readLine();
            lines.remove('\n');
            qDebug()<<lines;
            QStringList list = lines.split("rem_psd: ");
            remusertxt = list.at(0);
            rempsd = list.at(1);
            qDebug() << remusertxt << rempsd;
//            qDebug() << list;
            user_info.insert("remusertxt",remusertxt);
            user_info.insert("rempsd",rempsd);
        }
        file.close();
        qDebug()<<"open to clientmanmage OK";
    }
    return user_info;
}
void QUserLogin::autologin(){
    

}

void QUserLogin::execlogin(){


}

//#ifndef WORKER_H
//#define WORKER_H

//#endif // WORKER_H
#ifndef DISPATCHER_H
#define DISPATCHER_H

#include <QThread>
#include <QDebug>
#include <QTimer>
#include "data.h"

class Worker : public QThread
{
    Q_OBJECT
    Q_PROPERTY(double data READ getData WRITE setData NOTIFY dataChanged )

public:
    explicit Worker() = default;
    ~Worker() = default;
protected:
    void run() {
        qDebug() << "Inside the worker thread!";
        //        QTimer  *timer = new QTimer(this);
        //        connect(timer, SIGNAL(timeout()), this, SLOT(dataChanged()));
        //        timer->start(20);  // 开始计时，超时则发出timeout()信号

        Data::readtxttosend();

    }

    Q_INVOKABLE double getData() const { return data_; }
    // TODO: add signals for each type of received message by the worker thread?
signals:
    void dataChanged( const double data );

public slots:
    void setData( const double data ) {
        //        if ( data != data_ ) {
        data_ = data;
        emit dataChanged( data_ );
        //        }
    }

private:
    double data_ = 0;
};

#endif // DISPATCHER_H

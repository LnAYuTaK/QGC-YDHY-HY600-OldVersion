#include "mytimer.h"
#include "data.h"


#include<QDebug>
#include <QTimerEvent>

#define TIMER_TIMEOUT	(1*1000)

MyTimer::MyTimer(QObject *parent)
    :QObject(parent)
{
    m_nTimerID = this->startTimer(TIMER_TIMEOUT);
}

MyTimer::~MyTimer()
{

}

void MyTimer::timerEvent(QTimerEvent *event)
{
    if(event->timerId() == m_nTimerID){
        handleTimeout();
    }
}

void MyTimer::handleTimeout()
{
    qDebug()<<"Enter timeout processing function\n";
//    killTimer(m_nTimerID);
    //Data::make_mavlink_pakage();

}

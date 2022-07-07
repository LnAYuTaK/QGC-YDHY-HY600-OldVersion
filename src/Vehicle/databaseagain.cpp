
//发送指令线程
void sendMavCommand（）
{
    //1,指令entry 加入队列  queue
    _mavCommandQueue.append(entry);

    //2,重复发送次数为 0
    _mavCommandRetryCount = 0;
   if (_mavCommandQueue.count() == 1) {
        _mavCommandRetryCount = 0;
        _sendMavCommandAgain();
    }
}

void _sendMavCommandAgain(void)
{
   //3, 重复发送次数大于最大限制次数 则移除第一条指令
   if (_mavCommandRetryCount++ > _mavCommandMaxRetryCount) {
        _mavCommandQueue.removeFirst();
        _sendNextQueuedMavCommand();
        return;
    }

   //4，否则定时器开始 ，重复执行此函数
    _mavCommandAckTimer.start();//开始计时

    //5，发送具体指令
    sendMessageOnLink(priorityLink(), msg);
}


//接收指令线程
void Vehicle::_handleCommandAck(mavlink_message_t& message)
{
    //6,收到反馈 停止计时
    if (_mavCommandQueue.count() && ack.command == _mavCommandQueue[0].command) {
        _mavCommandAckTimer.stop();
        _mavCommandQueue.removeFirst();
    }
}

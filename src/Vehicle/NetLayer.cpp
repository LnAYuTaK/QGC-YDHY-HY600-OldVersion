#include "NetLayer.h"

NetLayer::NetLayer(QObject *parent)
    : QObject{parent}
{

}

void NetLayer::SendBinLogFile()
{
    QString SendFileName = "C:/Users/Administrator/Desktop/Test/LOG.bin";
     //0x55,0xAA,datalen(2),total_packet(2),cur_packet(2), data(1024), checksum(1)
    QFile file;
    file.setFileName(SendFileName);
    QFileInfo fileInfo(SendFileName);
    auto fileLen = fileInfo.size();//Send file size
    auto sendCnt = (int)ceil(fileLen / (PACKET_SIZE*1.0));//Send num
    auto lastLen = fileLen % PACKET_SIZE;//Last Send size
    if(0 == lastLen){//
        lastLen = PACKET_SIZE;
    }
    qDebug()<<"fileLen,lastLen,sendCnt:"<< fileLen << lastLen << sendCnt;
    if(file.open(QIODevice::ReadOnly)){
        QDataStream dataStream(&file);
        char *pBuf = new char[fileLen];
        memset(pBuf, 0, fileLen);
        dataStream.readRawData(pBuf,fileLen);
        //qDebug()<<QString::asprintf("%02X %02X",(uint8_t)pBuf[0],(uint8_t)pBuf[1]);
        //qDebug()<<QString::asprintf("%02X %02X",(uint8_t)pBuf[fileInfo.size()-2],(uint8_t)pBuf[fileInfo.size()-1]);
        for(int i = 0; i < sendCnt; i++){
#if 0 //Debug Out
            QString strAll;
            if(i != sendCnt - 1){
                for(int k=0;k<PACKET_SIZE;k++){
                    strAll += QString::asprintf("%02X ",(uint8_t)pBuf[i*PACKET_SIZE + k]);
                }
            }else{
                for(int k=0;k<lastLen;k++){
                    strAll += QString::asprintf("%02X ",(uint8_t)pBuf[i*PACKET_SIZE + k]);
                }
            }
            qDebug()<<strAll;
            continue;
#endif
            if(i != sendCnt - 1){
                 const int PACKET_LEN = PACKET_HEAD_SIZE + PACKET_SIZE;
                 //full pack---------------------------------------------------
                 char tx_buf[PACKET_LEN] = {0};
                 //1: head
                 tx_buf[0] = 0x55;
                 tx_buf[1] = (uint8_t)0xAA;
                 tx_buf[2] = PACKET_LEN >> 8;//
                 tx_buf[3] = PACKET_LEN & 0xFF;
                 tx_buf[4] = sendCnt >> 8;//
                 tx_buf[5] = sendCnt;
                 tx_buf[6] = (i + 1) >> 8;//
                 tx_buf[7] = i + 1;
                 //2: data
                 memcpy(tx_buf+8, pBuf+i*PACKET_SIZE, PACKET_SIZE);
                 //3: checksum
                 int8_t checksum(0);
                 for(int j = 0; j < PACKET_LEN-1; j++){
                     checksum += tx_buf[j];
                 }
                 tx_buf[PACKET_LEN-1] = checksum;
#if 0//Debug out
                 QString strAll;
                 for(int k=0;k<PACKET_LEN;k++){
                     strAll += QString::asprintf("%02X ",(uint8_t)tx_buf[k]);
                 }
                 qDebug()<<strAll;
#endif
                 //---------------------------------------------------------
                 NetSocket.WriteBytes(tx_buf,PACKET_LEN);
            }else{//LastSend
                int PACKET_LEN = PACKET_HEAD_SIZE + lastLen;
                //Full Pack---------------------------------------------------
                char *tx_buf = new char[PACKET_LEN];
                memset(tx_buf, 0, PACKET_LEN);
                //1: head
                tx_buf[0] = 0x55;
                tx_buf[1] = (uint8_t)0xAA;
                tx_buf[2] = PACKET_LEN >> 8;//data size
                tx_buf[3] = PACKET_LEN & 0xFF;
                tx_buf[4] = sendCnt >> 8;//pack num
                tx_buf[5] = sendCnt;
                tx_buf[6] = (i + 1) >> 8;//pack now num
                tx_buf[7] = i + 1;
                //2: data
                memcpy(tx_buf+8, pBuf+i*PACKET_SIZE, lastLen);
                //3: checksum
                int8_t checksum(0);
                for(int j = 0; j < PACKET_LEN-1; j++){
                    checksum += tx_buf[j];
                }
                tx_buf[PACKET_LEN-1] = checksum;
#if 0//debug out
                QString strAll;
                for(int k=0;k<PACKET_LEN;k++){
                    strAll += QString::asprintf("%02X ",(uint8_t)tx_buf[k]);
                }
                qDebug()<<strAll;
#endif
                //---------------------------------------------------------
                NetSocket.WriteBytes(tx_buf,PACKET_LEN);
                delete []tx_buf;
            }
            //sleep(100);
        }
        delete []pBuf;
    }
    file.close();

}





/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

#pragma once

#include <QObject>
#include <QMutex>
#include <QString>
#include <QTimer>
#include <QFile>
#include <QMap>
#include <QByteArray>
#include <QLoggingCategory>

#include "LinkInterface.h"
#include "QGCMAVLink.h"
#include "QGC.h"
#include "QGCTemporaryFile.h"
#include "QGCToolbox.h"
#include "data.h"

class LinkManager;
class MultiVehicleManager;
class QGCApplication;

Q_DECLARE_LOGGING_CATEGORY(MAVLinkProtocolLog)

/**
 * @brief MAVLink micro air vehicle protocol reference implementation.
 *
 * MAVLink is a generic communication protocol for micro air vehicles.
 * for more information, please see the official website: https://mavlink.io
 **/
class MAVLinkProtocol : public QGCTool
{
    Q_OBJECT

public:
    MAVLinkProtocol(QGCApplication* app, QGCToolbox* toolbox);
    ~MAVLinkProtocol();

    /** @brief Get the human-friendly name of this protocol */
    //获取协议名称
    QString getName();
    /** @brief Get the system id of this application */
    //获取这个地面站的系统ID
    int getSystemId();
    /** @brief Get the component id of this application */
    //获取组件ID
    int getComponentId();

    /** @brief Get protocol version check state */
    //启用mav与qgc协议兼容检查
    bool versionCheckEnabled() const {
        return m_enable_version_check;
    }
    /** @brief Get the protocol version */
    //获取当前qgc协议版本
    int getVersion() {
        return MAVLINK_VERSION;
    }
    /** @brief Get the currently configured protocol version */
    unsigned getCurrentVersion() {
        return _current_version;
    }
    /**
     * Reset the counters for all metadata for this link.
     */
    //为这个链接重置所有元数据的计数器
    virtual void resetMetadataForLink(LinkInterface *link);

    /// Suspend/Restart logging during replay.
    // 回放期间暂停/恢复日志
    void suspendLogForReplay(bool suspend);

    /// Set protocol version
    void setVersion(unsigned version);

    // Override from QGCTool
    //设置所属工具
    virtual void setToolbox(QGCToolbox *toolbox);

public slots:
    /** @brief Receive bytes from a communication interface */
    // 从通信接口接收字节，解析协议
    // 它可以并行处理多个链接，每个链接都有自己的缓冲区和解析状态机
    // 这个函数跨线程
    void receiveBytes(LinkInterface* link, QByteArray b);

    /** @brief Log bytes sent from a communication interface */
    void logSentBytes(LinkInterface* link, QByteArray b);

    /** @brief Set the system id of this application */
    //设置系统ID
    void setSystemId(int id);

    /** @brief Enable / disable version check */
    //启用/禁用版本检查
    void enableVersionCheck(bool enabled);

    /** @brief Load protocol settings */
    //加载协议配置
    void loadSettings();
    /** @brief Store protocol settings */
    //存储协议配置
    void storeSettings();

    /// @brief Deletes any log files which are in the temp directory
    // 删除临时目录中的任何日志文件
    static void deleteTempLogFiles(void);

    /// Checks for lost log files
    // 检查丢失的日志文件
    void checkForLostLogFiles(void);

protected:
    //启用mav与qgc协议兼容检查
    bool        m_enable_version_check;                         ///< Enable checking of version match of MAV and QGC
    uint8_t     lastIndex[256][256];                            ///< Store the last received sequence ID for each system/componenet pair
    uint8_t     firstMessage[256][256];                         ///< First message flag
    uint64_t    totalReceiveCounter[MAVLINK_COMM_NUM_BUFFERS];  ///< The total number of successfully received messages
    uint64_t    totalLossCounter[MAVLINK_COMM_NUM_BUFFERS];     ///< Total messages lost during transmission.
    float       runningLossPercent[MAVLINK_COMM_NUM_BUFFERS];   ///< Loss rate

    mavlink_message_t _message;
    mavlink_status_t _status;

    bool        versionMismatchIgnore;
    int         systemId;
    unsigned    _current_version;
    int         _radio_version_mismatch_count;

signals:
    /// Heartbeat received on link
    //发出连接中收到的心跳包
    void vehicleHeartbeatInfo(LinkInterface* link, int vehicleId, int componentId, int vehicleFirmwareType, int vehicleType);

    /** @brief Message received and directly copied via signal */
    //发出连接中收到的消息
    void messageReceived(LinkInterface* link, mavlink_message_t message);
    /** @brief Emitted if version check is enabled / disabled */
    //发出版本检查标志
    void versionCheckChanged(bool enabled);
    /** @brief Emitted if a message from the protocol should reach the user */
    //发出协议状态消息
    void protocolStatusMessage(const QString& title, const QString& message);
    /** @brief Emitted if a new system ID was set */
    //发出信号，新系统ID被设置
    void systemIdChanged(int systemId);

    void mavlinkMessageStatus(int uasId, uint64_t totalSent, uint64_t totalReceived, uint64_t totalLoss, float lossPercent);

    /**
     * @brief Emitted if a new radio status packet received
     *
     * @param rxerrors receive errors
     * @param fixed count of error corrected packets
     * @param rssi local signal strength in dBm
     * @param remrssi remote signal strength in dBm
     * @param txbuf how full the tx buffer is as a percentage
     * @param noise background noise level
     * @param remnoise remote background noise level
     */
    void radioStatusChanged(LinkInterface* link, unsigned rxerrors, unsigned fixed, int rssi, int remrssi,
    unsigned txbuf, unsigned noise, unsigned remnoise);

    /// Emitted when a temporary telemetry log file is ready for saving
    //发出信号，当一个临时的遥测日志文件准备保存时
    void saveTelemetryLog(QString tempLogfile);

    /// Emitted when a telemetry log is started to save.
    //当遥测日志开始保存时发出
    void checkTelemetrySavePath(void);

private slots:
    //飞机数量改变
    void _vehicleCountChanged(void);

private:
    bool _closeLogFile(void);
    void _startLogging(void);
    void _stopLogging(void);

    bool _logSuspendError;      ///< true: Logging suspended due to error
    bool _logSuspendReplay;     ///< true: Logging suspended due to replay
    bool _vehicleWasArmed;      ///< true: Vehicle was armed during log sequence

    QGCTemporaryFile    _tempLogFile;            ///< File to log to
    static const char*  _tempLogFileTemplate;    ///< Template for temporary log file
    static const char*  _logFileExtension;       ///< Extension for log files

    LinkManager*            _linkMgr;
    MultiVehicleManager*    _multiVehicleManager;
};


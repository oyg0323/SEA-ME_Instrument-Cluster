#include "timeprovider.h"

TimeProvider::TimeProvider(QObject *parent)
    : QObject(parent)
{
    updateTime();
    connect(&m_timer, &QTimer::timeout, this, &TimeProvider::updateTime);
    m_timer.start(1000);  // 1초마다 업데이트
}

QString TimeProvider::currentDateTime() const
{
    return m_currentDateTime;
}

void TimeProvider::updateTime()
{
    QDateTime now = QDateTime::currentDateTime();
    QString newTime = now.toString("yyyy-MM-dd dddd hh:mm:ss");
    // 예: 2025-07-25 Friday 14:08:22

    if (newTime != m_currentDateTime) {
        m_currentDateTime = newTime;
        emit timeChanged();
    }
}


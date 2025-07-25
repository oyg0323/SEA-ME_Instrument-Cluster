#ifndef TIMEPROVIDER_H
#define TIMEPROVIDER_H

#include <QObject>
#include <QTimer>
#include <QDateTime>

class TimeProvider : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString currentDateTime READ currentDateTime NOTIFY timeChanged)

public:
    explicit TimeProvider(QObject *parent = nullptr);

    QString currentDateTime() const;

signals:
    void timeChanged();

private slots:
    void updateTime();

private:
    QString m_currentDateTime;
    QTimer m_timer;
};

#endif // TIMEPROVIDER_H

#include <QGuiApplication>    // GUI 애플리케이션 기능을 제공하는 클래스
#include <QQmlApplicationEngine>    // QML 엔진 초기화 및 로딩을 담당하는 클래스
#include <QQmlContext>    // C++ 객체를 QML 컨텍스트에 등록하기 위한 클래스
#include <QObject>    // Qt의 객체 모델을 사용하기 위한 기본 클래스
#include <QTimer>    // 주기적인 이벤트를 발생시키는 타이머 클래스
#include <QtGlobal>    // qrand(), qsrand() 등 전역 Qt 함수 사용을 위한 헤더
#include <QRandomGenerator>

// RandomData: 속도(speed)와 배터리 레벨(level)
// 값을 주기적으로(100ms) 랜덤 생성하여 QML에 제공하는 객체
class RandomData : public QObject {
    Q_OBJECT
    Q_PROPERTY(int speed READ speed NOTIFY speedChanged)
    Q_PROPERTY(int level READ level NOTIFY levelChanged)
public:
    RandomData(QObject* parent = nullptr)
        : QObject(parent), m_speed(0), m_level(100), m_speedDirection(1), m_speedStep(5), m_batteryDirection(1), m_batteryStep(5)
    {
        // 300ms마다 updateValues() 호출하도록 타이머 설정
        QTimer* timer = new QTimer(this);
        connect(timer, &QTimer::timeout, this, &RandomData::updateValues);
        timer->start(100);

    }

    // 현재 속도 반환 (0~200 사이)
    int speed() const { return m_speed; }
    // 현재 배터리 레벨 반환 (0~100 사이)
    int level() const { return m_level; }

signals:
    // speed 속성이 변경될 때 발생
    void speedChanged();
    // level 속성이 변경될 때 발생
    void levelChanged();

private slots:
    // 타이머마다 호출되어 새로운 랜덤 값을 생성
    void updateValues() {
        /*
        // 0~200 사이 랜덤 속도 생성
        int newSpeed = QRandomGenerator::global()->bounded(201);
        if (newSpeed != m_speed) {
            m_speed = newSpeed;
            emit speedChanged();    // QML에 속도 변경 알림
        }
        */

        // === 속도: 0↗200↘0 반복 ===
        m_speed += m_speedDirection * m_speedStep;
        if (m_speed >= 200) {
            m_speed = 200;
            m_speedDirection = -1;
        } else if (m_speed <= 0) {
            m_speed = 0;
            m_speedDirection = 1;
        }
        emit speedChanged();

        // 0~100 사이 랜덤 배터리 레벨 생성
        /*
        int newLevel = QRandomGenerator::global()->bounded(101);
        if (newLevel != m_level) {
            m_level = newLevel;
            emit levelChanged();    // QML에 레벨 변경 알림
        }
        */

        // === 배터리: 0↗100↘0 반복 ===
        m_level += m_batteryDirection * m_batteryStep;
        if (m_level >= 100) {
            m_level = 100;
            m_batteryDirection = -1;
        } else if (m_level <= 0) {
            m_level = 0;
            m_batteryDirection = 1;
        }
        emit levelChanged();
    }

private:
    int m_speed;    // 내부 속도 저장 변수
    int m_level;    // 내부 배터리 레벨 저장 변수
    int m_speedDirection;
    int m_speedStep;
    int m_batteryDirection;
    int m_batteryStep;
};

int main(int argc, char *argv[])
{
    // 1) QGuiApplication 객체 생성: Qt GUI 이벤트 루프 초기화
    QGuiApplication app(argc, argv);

    // 2) 랜덤 데이터 공급자 객체 생성
    RandomData randomData;

    // 3) QML 엔진 초기화
    QQmlApplicationEngine engine;

    //engine.addImportPath("qrc:/");

    // 4) C++ 객체를 QML 컨텍스트에 등록
    //    QML에서 'speedController'와 'batterylevel'로 접근 가능
    engine.rootContext()->setContextProperty("speedController", &randomData);
    engine.rootContext()->setContextProperty("batterylevel", &randomData);

    // 5) 메인 QML 파일 로드 (qt_add_qml_module의 기본 리소스 위치로 변경)
    const QUrl url(QStringLiteral("qrc:/qt/qml/Practice/Main.qml"));

    // 6) 에러 처리(경로 비교도 위와 동일하게 변경)
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
                         if (!obj && objUrl == url)
                             QCoreApplication::exit(-1);
                     }, Qt::QueuedConnection);

    // 7) QML 파일 로드
    engine.load(url);

    // 8) Qt 이벤트 루프 진입
    return app.exec();
}

#include "main.moc"    // moc(Meta-Object Compiler) 처리를 위한 포함

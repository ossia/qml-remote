#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

    QGuiApplication app(argc, argv);

    qmlRegisterSingletonType(QUrl("qrc:///Utility/Uuid.qml"), "Variable.Global", 1, 0, "Uuid");
    qmlRegisterSingletonType(QUrl("qrc:///Utility/Skin.qml"), "Variable.Global", 1, 0, "Skin");

    app.setOrganizationName("ossia.io");
    app.setOrganizationDomain("Remote Control");

    QQmlApplicationEngine engine;
    const bool debugEnabled = qEnvironmentVariableIntValue("SCORE_QML_REMOTE_DEBUG") > 0;
    engine.rootContext()->setContextProperty("g_debugMessagesEnabled", debugEnabled);

    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}

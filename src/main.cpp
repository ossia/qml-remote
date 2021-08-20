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


    // for debug
    QQmlApplicationEngine engine;
    const bool debugEnabled = qEnvironmentVariableIntValue("SCORE_QML_REMOTE_DEBUG") > 0;
    engine.rootContext()->setContextProperty("g_debugMessagesEnabled", debugEnabled);

    // The timeline it does not appear on the screen when the application
    // is used on a device other than the computer
    const bool tmp_is_mobile = qEnvironmentVariableIsSet("IS_MOBILE") ? qEnvironmentVariableIntValue("IS_MOBILE") > 0 : false;
    engine.rootContext()->setContextProperty("is_mobile", tmp_is_mobile);
    
    // getting ip address from score
    const QString tmp_score_ip_address = qEnvironmentVariableIsSet("SCORE_IP_ADDRESS") ? qEnvironmentVariable("SCORE_IP_ADDRESS") : "0.0.0.0";
    engine.rootContext()->setContextProperty("score_ip_address", tmp_score_ip_address);

    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}

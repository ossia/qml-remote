#ifdef __EMSCRIPTEN__
#include <emscripten/val.h>
#endif

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QDirIterator>
#include <QFont>
#include <QFontDatabase>
#include <QIcon>

// Register every bundled font (fonts.qrc -> :/fonts) with the application font
// database. Mirrors ossia score (src/app/Application.cpp): a blanket walk of the
// resource tree rather than a hand-maintained list, done before the QML engine
// starts so any family is usable from QML by its family string. This is the only
// way the UI gets a real typeface against the static ossia SDK Qt, which ships
// no system fonts.
static void loadApplicationFonts()
{
    QDirIterator it(":/fonts", QDirIterator::Subdirectories);
    while (it.hasNext())
    {
        const QString font = it.next();
        if (font.endsWith("ttf", Qt::CaseInsensitive)
         || font.endsWith("otf", Qt::CaseInsensitive)
         || font.endsWith("bdf", Qt::CaseInsensitive))
        {
            QFontDatabase::addApplicationFont(font);
        }
    }
}

int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

    QGuiApplication app(argc, argv);

    // Window-manager / taskbar / dock icon for the running app. Bundled via
    // icon.qrc so it is embedded in the (static) binary on every platform,
    // rather than relying on a system icon theme. The Linux .desktop + AppImage
    // wire the same file for their own launcher integration.
    app.setWindowIcon(QIcon(QStringLiteral(":/ossia_remote.png")));

    qmlRegisterSingletonType(QUrl("qrc:///Utility/Uuid.qml"), "Variable.Global", 1, 0, "Uuid");
    qmlRegisterSingletonType(QUrl("qrc:///Utility/Skin.qml"), "Variable.Global", 1, 0, "Skin");

    app.setOrganizationName("ossia.io");
    app.setOrganizationDomain("Remote Control");

    loadApplicationFonts();

    // Ubuntu is the general UI font (Ubuntu Mono is used for numeric readouts,
    // set per-element in QML via Skin.monoFont). Setting the app default here
    // also covers any control internals not bound explicitly in QML, from the
    // very first frame.
    {
        QFont f("Ubuntu", 10);
        f.setHintingPreference(QFont::HintingPreference::PreferVerticalHinting);
        app.setFont(f);
    }

    QQmlApplicationEngine engine;
    const bool debugEnabled = qEnvironmentVariableIntValue("SCORE_QML_REMOTE_DEBUG") > 0;
    engine.rootContext()->setContextProperty("g_debugMessagesEnabled", debugEnabled);

    // The timeline it does not appear on the screen when the application
    // is used on a device other than the computer
    const bool tmp_is_mobile = qEnvironmentVariableIsSet("IS_MOBILE") ? qEnvironmentVariableIntValue("IS_MOBILE") > 0 : false;
    engine.rootContext()->setContextProperty("is_mobile", tmp_is_mobile);

#ifdef __EMSCRIPTEN__
    // Retrive the sever's address from "emscripten". Copied from
    // stackoverflow.com/questions/55793546/is-there-any-possibility-to-pass-data-from-browser-to-a-qt-webassembly-app-may#67634393
    emscripten::val location{emscripten::val::global("location")};
    QString host{QString::fromStdString(location["hostname"].as<std::string>())};
    engine.rootContext()->setContextProperty("score_ip_address", host);
    engine.rootContext()->setContextProperty("auto_connect", true);
#endif

    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}

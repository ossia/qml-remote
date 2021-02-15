import QtQuick 2.0
import QtQuick.Layouts 1.15


GridLayout {
    rowSpacing: 5
    columnSpacing: 5
    Repeater {
        model: ["event1", "on", "event2", "a", "b", "skc,dkvnd"]
        OssiaTrigger{sliderName: modelData}
    }
}

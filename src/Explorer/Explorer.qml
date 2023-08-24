import QtQuick 2.0
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.2
import QtQuick.Controls.Styles 1.4
import QtQml.Models 2.12

import Variable.Global 1.0
import "../ControlSurface"
import "../ControlSurface/Controls"
import "../ControlSurface/Controls/Slider"
import "../ControlSurface/Controls/Button"
import "../ControlSurface/Controls/Colorpicker"

Item {
    width: 100
    height: 100

    component MotorSlider :
        ScoreSlider {
        property int board
        property int motor
        implicitWidth: 400; implicitHeight: 60
        controlCustom: `Speed: board ${board} motor ${motor}`
        onValueChanged: {
            socket.sendTextMessage(
                        `{ "Message": "Message", "Address": "esp:/${board}/motor/${motor}/speed", "Value": {"Float": ${value.toFixed(3)} }}`)

        }
    }


    component MotorDSlider :
        ScoreButton {
        property int board
        property int motor
        implicitWidth: 60; implicitHeight: 60
        controlCustom: isPressed ? "FW" : "BW"
        onClicked: {
            socket.sendTextMessage(
                        `{ "Message": "Message", "Address": "esp:/${board}/motor/${motor}/direction", "Value": {"Int": ${isPressed? 1 : 0} }}`)

        }
    }

    component LedSlider :
        ScoreSlider {
        property int board
        property int led
        implicitWidth: 400; implicitHeight: 60
        controlCustom: `Bright: board ${board} LED ${led}`
        onValueChanged: {
            socket.sendTextMessage(
                        `{ "Message": "Message", "Address": "esp:/${board}/led/${led}/bright", "Value": {"Float": ${value.toFixed(3)} }}`)

        }
    }

    component LedColor:
        Colorpicker {
        property int board
        property int led
        enableAlphaChannel: false
        implicitWidth: 300; implicitHeight: 300
        onColorChanged: {
             const col = changedColor;
                 socket.sendTextMessage(
                             `{ "Message": "Message", "Address": "esp:/${board}/led/${led}/color", "Value": {"Vec3f": [ ${col.r.toFixed(3)}, ${col.g.toFixed(3)}, ${col.b.toFixed(3)} ] }}`)
        }
    }

    component LedControl:
        ColumnLayout {
        id: lay
        property int board
        property int led
        LedSlider { board: lay.board; led: lay.led; }
        LedColor { board: lay.board; led: lay.led; }
    }

    ColumnLayout
    {
        // Motors
        RowLayout {
            ColumnLayout {
                MotorSlider { board: 0; motor: 0 }
                MotorSlider { board: 0; motor: 1 }
                MotorSlider { board: 1; motor: 0 }
                MotorSlider { board: 1; motor: 1 }
                MotorSlider { board: 2; motor: 0 }
                MotorSlider { board: 2; motor: 1 }
                MotorSlider { board: 3; motor: 0 }
                MotorSlider { board: 3; motor: 1 }
            }
            ColumnLayout {
                MotorDSlider { board: 0; motor: 0 }
                MotorDSlider { board: 0; motor: 1 }
                MotorDSlider { board: 1; motor: 0 }
                MotorDSlider { board: 1; motor: 1 }
                MotorDSlider { board: 2; motor: 0 }
                MotorDSlider { board: 2; motor: 1 }
                MotorDSlider { board: 3; motor: 0 }
                MotorDSlider { board: 3; motor: 1 }
            }
        }

        // Leds
        RowLayout {
            LedControl { board: 0; led: 0 }
            LedControl { board: 0; led: 1 }
            LedControl { board: 1; led: 0 }
            LedControl { board: 1; led: 1 }
        }
        RowLayout {
            LedControl { board: 2; led: 0 }
            LedControl { board: 2; led: 1 }
            LedControl { board: 3; led: 0 }
            LedControl { board: 3; led: 1 }
        }

    }


}

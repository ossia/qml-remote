//  A toy QML colorpicker control, by Ruslan Shestopalyuk
import QtQuick 2.11
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.4

import Variable.Global 1.0

Rectangle {
    id: picker
    property color colorValue: paletteMode ? _rgb(paletts.paletts_color,
                                          alphaSlider.value) : _hsla(
                                         hueSlider.value,
                                         sbPicker.saturation,
                                         sbPicker.brightness,
                                         1)
    property bool enableAlphaChannel: true
    property bool enableDetails: true
    property int colorHandleRadius: 8
    property bool paletteMode: false
    property bool enablePaletteMode: false
    property string switchToColorPickerString: "Palette..."
    property string switchToPalleteString: "Color Picker..."

    signal colorChanged(color changedColor)

    clip: true

    color: Skin.gray2

    SBPicker {
        id: sbPicker
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        width: colorpicker.width * (83 / 100)

        hueColor: {
            var v = 1.0 - hueSlider.value

            //console.debug("v:"+v)
            if (0.0 <= v && v < 0.16) {
                return Qt.rgba(1.0, 0.0, v / 0.16, 1.0)
            } else if (0.16 <= v && v < 0.33) {
                return Qt.rgba(1.0 - (v - 0.16) / 0.17, 0.0, 1.0, 1.0)
            } else if (0.33 <= v && v < 0.5) {
                return Qt.rgba(0.0, ((v - 0.33) / 0.17), 1.0, 1.0)
            } else if (0.5 <= v && v < 0.76) {
                return Qt.rgba(0.0, 1.0, 1.0 - (v - 0.5) / 0.26, 1.0)
            } else if (0.76 <= v && v < 0.85) {
                return Qt.rgba((v - 0.76) / 0.09, 1.0, 0.0, 1.0)
            } else if (0.85 <= v && v <= 1.0) {
                return Qt.rgba(1.0, 1.0 - (v - 0.85) / 0.15, 0.0, 1.0)
            } else {
                //console.log("hue value is outside of expected boundaries of [0, 1]")
                return "red"
            }
        }
    }

    // hue picking slider
    Item {
        id: huePicker
        visible: !paletteMode
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        width: colorpicker.width * (15 / 100)

        anchors.leftMargin: 5
        anchors.rightMargin: 5
        Layout.fillHeight: true
        anchors.topMargin: colorHandleRadius
        anchors.bottomMargin: colorHandleRadius

        Rectangle {
            id: colorBar
            anchors.fill: parent

            gradient: Gradient {
                GradientStop {
                    position: 1.0
                    color: "#FF0000"
                }
                GradientStop {
                    position: 0.85
                    color: "#FFFF00"
                }
                GradientStop {
                    position: 0.76
                    color: "#00FF00"
                }
                GradientStop {
                    position: 0.5
                    color: "#00FFFF"
                }
                GradientStop {
                    position: 0.33
                    color: "#0000FF"
                }
                GradientStop {
                    position: 0.16
                    color: "#FF00FF"
                }
                GradientStop {
                    position: 0.0
                    color: "#FF0000"
                }
            }
        }
        ColorSlider {
            id: hueSlider
            anchors.fill: parent
        }
    }

    /*
    // It is useless because it is not used in score
    // alpha (transparency) picking slider
    Item {
        id: alphaPicker
        visible: false
        width: 25
        height: picker.height
        Layout.leftMargin: 4
        Layout.fillHeight: true
        Layout.topMargin: colorHandleRadius
        Layout.bottomMargin: colorHandleRadius
        Checkerboard {
            cellSide: 5
        }
        //  alpha intensity gradient background
        Rectangle {
            anchors.fill: parent
            gradient: Gradient {
                GradientStop {
                    position: 0.0
                    color: "#FF000000"
                }
                GradientStop {
                    position: 1.0
                    color: "#00000000"
                }
            }
        }
        ColorSlider {
            id: alphaSlider
            anchors.fill: parent
        }
    }
    */

    //  creates color value from hue, saturation, brightness, alpha
    function _hsla(h, s, b, a) {
        var lightness = (2 - s) * b
        var satHSL = s * b / ((lightness <= 1) ? lightness : 2 - lightness)
        lightness /= 2

        var c = Qt.hsla(h, satHSL, lightness, a)

        colorChanged(c)

        return c
    }

    // create rgb value
    function _rgb(rgb, a) {

        var c = Qt.rgba(rgb.r, rgb.g, rgb.b, a)

        colorChanged(c)

        return c
    }

    //  creates a full color string from color value and alpha[0..1], e.g. "#FF00FF00"
    function _fullColorString(clr, a) {
        return "#" + ((Math.ceil(a * 255) + 256).toString(16).substr(
                          1, 2) + clr.toString().substr(1, 6)).toUpperCase()
    }

    //  extracts integer color channel value [0..255] from color value
    function _getChannelStr(clr, channelIdx) {
        return parseInt(clr.toString().substr(channelIdx * 2 + 1, 2), 16)
    }
}

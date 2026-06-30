pragma Singleton
import QtQuick

// Widget type UUIDs, matching score's Process::WidgetInlets (WidgetInlets.hpp).
// Each control sent in a ControlSurfaceAdded message carries its "uuid"; the
// remote dispatches on it. Names kept stable where the remote historically
// diverged from score (buttonUUID == score Toggle, colorPicker == HSVSlider,
// position == XYSlider).
QtObject  {
    // --- Handled: sliders ---
    property string floatSliderUUID: "af2b4fc3-aecb-4c15-a5aa-1c573a239925"
    property string logFloatSliderUUID: "5554eb67-bcc8-45ab-8ec2-37a3f191aa64"
    property string intSliderUUID: "348b80a4-45dc-4f70-8f5f-6546c85089a2"

    // --- Handled: buttons / choice / color / xy ---
    property string impulseButtonUUID: "7cd210d3-ebd1-4f71-9de6-cccfb639cbc3"
    property string buttonUUID: "fb27e4cb-ea7f-41e2-ad92-2354498c1b6b" // score Toggle
    property string colorPickerUUID: "8f38638e-9f9f-48b0-ae36-1cba86ef5703" // score HSVSlider
    property string positionUUID: "8093743c-584f-4bb9-97d4-6c7602f87116" // score XYSlider
    property string comboBoxUUID: "485680cc-b8b9-4a01-acc7-3e8334bdc016"

    // --- Stage 1 additions ---
    property string floatKnobUUID: "82427d27-084a-4ab6-9c4e-db83929a1200"
    property string intSpinBoxUUID: "238399a0-7e81-47e3-896f-08e8856e2973"
    property string floatSpinBoxUUID: "10d62b0d-5bc9-4ac9-9540-9e8ac0c24947"
    property string timeChooserUUID: "b631d9b7-cbe3-4d9c-b470-f139e348aecb"
    property string enumUUID: "8b1d76c4-3838-4ac0-9b9c-c12bc5db8e8a"
    property string realButtonUUID: "feb87e84-e0d2-428f-96ff-a123ac964f59" // score Button (momentary)
    property string lineEditUUID: "9ae797ea-d94c-4792-acec-9ec1932bae5d"
    property string programEditUUID: "de15c0da-429b-49d3-bb07-7c41f5f205c8"
    property string fileChooserUUID: "40833147-4c42-4b8b-bb80-0b1d15dae129"
    property string folderChooserUUID: "a866e07f-f380-4f69-8bce-e52682db2025"
    property string audioFileChooserUUID: "c347b510-927a-4924-9da1-c76871623567"
    property string videoFileChooserUUID: "7d5a68ae-501f-4038-bb24-4a7ffc049923"

    // --- Registered for Stage 2 (not dispatched yet) ---
    property string chooserToggleUUID: "27d488b6-784b-4bfc-8e7f-e28ef030c248"
    property string intRangeSliderUUID: "0c1902bc-e282-11ec-8fea-0242ac120002"
    property string floatRangeSliderUUID: "73ae3e85-0c91-497e-b612-b1391f87ac72"
    property string intRangeSpinBoxUUID: "54dc640b-4385-4a5a-b9da-e44fe63701d9"
    property string floatRangeSpinBoxUUID: "25be1f08-a3fb-4ce3-a34e-4d8f54f15874"
    property string xyzSliderUUID: "bae00244-cd93-4893-a4ad-71489adb3fa1"
    property string xySpinboxesUUID: "0adbbdda-fda4-451e-91cc-1da731bde9d5"
    property string xyzSpinboxesUUID: "377e8205-b442-4d54-8832-3761def522b2"
    property string multiSliderUUID: "25de6d71-1554-4fe1-bf3f-9cbf12bdadeb"
    property string multiSliderXYUUID: "ce12611f-f3b0-4f99-b3c0-3f0b25a38aa1"
    property string pathGeneratorXYUUID: "b60d0059-733b-4b57-a1c1-65fa140d3b8a"
    property string bargraphUUID: "f6d740ce-acc0-44c0-932a-0a03345af84f"

    // --- Generic fallback: score's base Process::ControlInlet (no widget) ---
    property string controlInletUUID: "9a13fb32-269a-47bf-99a9-930188c1f19c"
}

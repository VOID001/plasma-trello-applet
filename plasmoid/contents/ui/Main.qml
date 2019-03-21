import QtQuick 2.0
import QtQuick.Controls 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents

Item {
    // Create a trello issues list
    width: 180
    height: 200
    Component {
        id: trelloItemDelegate
        Item {
            width: trelloLabel.width; height: trelloLabel.height + 10
            Column {
                id: trelloLabel
                Text {text: "<b>TODOs</b>"}
                Text {text: caption}
            }
        }
    }

    ListView {
        anchors.fill: parent
        model: DataModel {}
        delegate: trelloItemDelegate
        // orientation: Qt.Vertical
        // verticalLayoutDirection: ListView.TopToBottom
        highlight: Rectangle { color: "lightsteelblue"; radius: 5; width: trelloItemDelegate.width}
        // highlight: Rectangle {
        //     color: "lightsteelblue"
        //     radius: 5
        // }
        focus: true
        clip: true
    }
}

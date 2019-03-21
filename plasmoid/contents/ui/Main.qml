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
        Rectangle {
            property color tempColor
            property color itemColor
            width: parent.width; height: trelloLabel.height + 10
            opacity: 0.7
            Column {
                id: trelloLabel
                width: parent.width
                Text {text: "<b>TODOs</b>"}
                Text {id: captionText; text: caption}
            }
            MouseArea {
                anchors.fill: parent
                onEntered: {
                    tempColor = captionText.color
                    itemColor = parent.color
                    parent.color = Qt.darker(itemColor, 1.5)
                    captionText.color = "blue"
                    console.log("You clicked item " + captionText.text)
                }
                onExited: {
                    captionText.color = tempColor
                    parent.color = itemColor
                }
            }
        }
    }

    ListView {
        anchors.fill: parent
        model: DataModel {}
        delegate: TrelloItem {}
        // orientation: Qt.Vertical
        // verticalLayoutDirection: ListView.TopToBottom
        highlight: Rectangle { color: "lightsteelblue"; radius: 5; width: trelloItemDelegate.width}
        // highlight: Rectangle {
        //     color: "lightsteelblue"
        //     radius: 5
        // }
        focus: true
        spacing: 2
        clip: true
    }
}

import QtQuick 2.0
import QtQuick.Controls 1.4 as QtControls
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents

import "../lib/trelloAPI.js" as TrelloAPI

Item {
    // Create a trello issues list
    width: 180 * units.devicePixelRatio
    height: 200 * unitx.devicePixelRatio

    // The init function
    Component.onCompleted: {
        TrelloAPI.Greeting();
    }

    QtControls.ScrollView {
        anchors.fill: parent
        ListView {
            anchors.fill: parent
            model: DataModel {}
            delegate: TrelloItem {}
            highlight: Rectangle { color: "lightsteelblue"; radius: 5; width: trelloItemDelegate.width}
            focus: true
            spacing: 10
            clip: true
        }
    }
}

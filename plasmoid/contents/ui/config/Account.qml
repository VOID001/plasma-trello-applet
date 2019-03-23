import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.0
import org.kde.kirigami 2.4 as Kirigami
import org.kde.plasma.core 2.0 as PlasmaCore

import "../lib/Trello.js" as Trello

Item {
    id: accountPage
    property var fetchedBoardList
    property var boardSpinLock: false
    Component.onCompleted: {

    }
    GridLayout {
        width: parent.width
        columns: 2
        rowSpacing: 10
        Label {
            text: "API Key:"
        }
        TextField {
            id: apiKeyField
            Layout.fillWidth: true
            Layout.rightMargin: 10
            text: plasmoid.configuration["api_key"]
            onEditingFinished: updateConfiguration("api_key", apiKeyField.text)
            onTextChanged: updateConfiguration("api_key", apiKeyField.text) // onTextEdited only in 5.9
            onAccepted: updateConfiguration("api_key", apiKeyField.text)
        }
        Label {
            text: "API Token:"
        }
        TextField {
            id: apiTokenField
            Layout.fillWidth: true
            Layout.rightMargin: 10
            text: plasmoid.configuration["api_token"]
            onEditingFinished: updateConfiguration("api_token", apiTokenField.text)
            onTextChanged: updateConfiguration("api_token", apiTokenField.text) // onTextEdited only in 5.9
            onAccepted: updateConfiguration("api_token", apiTokenField.text)

        }
        Button {
            id: connectRequestButton
            Layout.alignment: Qt.AlignLeft
            text: "Connect"
            onClicked: pingTrello()
        }
        Label {
            id: connectStateLabel
            property var succeed

            Layout.fillWidth: true
            opacity: 1
            text: ""
            color: succeed ? "green" : "red"
        }        
        Rectangle {
            Layout.row: 3    
            Layout.columnSpan: 2
            Layout.fillWidth: true
            Layout.preferredHeight: 500
            Layout.rightMargin: 10
            width: boardList.width
            height: parent.height
            color: "transparent"
            border.width: 1
            ScrollView {
                anchors.fill: parent
                ListView {
                    id: boardList
                    anchors.fill: parent
                    height: 500
                    model: ListModel { id: boards }
                    Component.onCompleted: {
                        var savedBoard = JSON.parse(plasmoid.configuration["tracked_boards"])
                        fetchedBoardList = savedBoard
                        console.log("BOARDS: " +  JSON.stringify(savedBoard))
                        for(var i = 0; i < savedBoard.length; i++) {
                            boards.append(savedBoard[i])
                        }
                    }
                    delegate: Component {
                        CheckBox {
                            text: name
                            checked: selected
                            onToggled: updateTrackedBoardList()
                        }
                    }
                }
            }
        }
    }

    function updateConfiguration(configKey, configValue) {
        // console.log("The key ["+ configKey + "] changed to <" + configValue + ">")
        plasmoid.configuration[configKey] = configValue
        // console.log("config: " + JSON.stringify(plasmoid.configuration))
    }

    function pingTrello() {
        connectStateLabel.succeed = true;
        connectStateLabel.text = "Requesting ..."
        Trello.getBoards(updateBoardListCallBack)
    }

    function updateTrackedBoardList() {
        while(boardSpinLock) {

        }
        boardSpinLock = true
        var trackedBoards = []
        for(var i = 0; i < fetchedBoardList.length; i++) {
            var boardItem = fetchedBoardList[i]
            //use ListView.contentItem.children[index] to access items in the list
            var obj = boardList.contentItem.children[i]
            var ok = false
            console.log("State = " + JSON.stringify(obj.checkState))
            if (obj.checkState == Qt.Checked) {
                ok = true
            }
            var trackedBoard = {id: boardItem["id"], name: boardItem["name"], selected: ok}
            trackedBoards.push(trackedBoard)
        }        
        plasmoid.configuration["tracked_boards"] = JSON.stringify(trackedBoards)
        boardSpinLock = false
        console.log("Updated tracked board list: " + JSON.stringify(trackedBoards))
    }

    function updateBoardListCallBack(err, data, xhr) {
        if(err) {
            connectStateLabel.succeed = false; 
            connectStateLabel.opacity = 1; 
            connectStateLabel.text = "Request error, " + data
            return
        }
        connectStateLabel.succeed = true; 
        connectStateLabel.opacity = 1; 
        connectStateLabel.text = "Request succeed." 
        boards.clear()
        for(var i = 0; i < data.length; i++) {
            console.log(data[i])
            boards.append(data[i])
        }
        fetchedBoardList = data
        return
    }
}

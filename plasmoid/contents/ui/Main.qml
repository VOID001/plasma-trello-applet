import QtQuick 2.0
import QtQuick.Controls 1.4 as QtControls
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents

import "lib/Requests.js" as Requests

Item {
    id: widget

    width: 450 * units.devicePixelRatio
    height: 200 * units.devicePixelRatio

    readonly property var apiKey: plasmoid.configuration["api_key"] || ""
    readonly property var apiToken: plasmoid.configuration["api_token"] || ""
    property var boardIDNameMap: {}
    property var oldConfig: {}

    // The init function
    Component.onCompleted: {
        // trelloItemListModel = [{},{},{},{}];
    }

    QtControls.ScrollView {
        anchors.fill: parent
        ListView {
            id: itemListView
            anchors.fill: parent
            model: DataModel {id: trelloItemListModel}
            delegate: TrelloItem {id: trelloItemDelegate}
            // highlight: Rectangle { anchors.fill: parent; color: "lightsteelblue"; radius: 5; /* width: trelloItemDelegate.width*/ }
            focus: true
            spacing: 3
            clip: true
        }
    }

    Timer {
        interval: 30 * 60 * 1000
        repeat: true
        triggeredOnStart: true
        running: true
        onTriggered: {
            fetchAllTrelloData()
        }
    }

    Timer {
        id: configTimer
        property var oldConfig;
        interval: 5000
        repeat: true
        running: true
        onTriggered: {
            reloadCheck()
        }
    }

    function reloadCheck() {
        var curConfig = plasmoid.configuration;
        var entries = ["api_key", "api_token"]
        // console.log("OLD: " + JSON.stringify(oldConfig))
        // console.log("NEW: " + JSON.stringify(curConfig))
        for(var i = 0; i < entries.length; i++) {
            var propKey =entries[i]
            if(!curConfig) {
                return
            }
            if(!oldConfig && curConfig) {
                console.log("Reload board due to configuration change")
                oldConfig = copyConfig(curConfig) // deep copy
                fetchAllTrelloData()
                return
            }
            if(oldConfig[propKey] != curConfig[propKey]) {
                console.log("Reload board due to configuration change")
                fetchAllTrelloData()
                oldConfig = copyConfig(curConfig)
                return
            }
        }
        // console.log("Configuration Keeps intact")
    }

    function copyConfig(config) {
        var entries = ["api_key", "api_token"]
        var data = {}
        for(var i = 0; i < entries.length; i++) {
            var key = entries[i]
            data[key] = config[key] 
        }
        return data
    }

    // namespace: Trello API

    // Methods
    function fetchAllTrelloData () {
        var boardList = []
        console.log("key:" + apiKey + " token:" + apiToken)
        boardIDNameMap = {}
        trelloItemListModel.clear()
        if(apiKey == "" || apiToken == "") {
            var data = {
                name: "You need to get your trello API key first, Please set them in the configuration dialog, Click here to get the key", 
                state: "NEED_LOGIN",
                url: "https://trello.com/app-key",
                boardName: "Warning",
                dueDate: ""
            }
            trelloItemListModel.append(data)
            return
        }
        Requests.getJSON({
            url: "https://api.trello.com/1/members/me/boards?key=" + apiKey + "&token=" + apiToken
        }, function(err, data, xhr) { 
            if(!err) {
                boardList = data
                for (var i = 0; i < data.length; i++) {
                    boardIDNameMap[data[i].id] = data[i].name
                }
                widget.fetchCards(boardList)
                return
            }
            var errItem  = {
                name: "Request to TrelloAPI failed: " + err, 
                state: "ERROR",
                boardName: "Error",
                dueDate: ""
            }
            console.log("ERR: On fetching board list" + err)
            trelloItemListModel.append(errItem)
        })
    }

    // Called after BoardList is fetched
    function fetchCards(boards) {
        for(var i = 0; i < boards.length; i++) {
            Requests.getJSON({
                url: "https://api.trello.com/1/boards/" + boards[i].id + "/cards?key=" + apiKey + "&token=" + apiToken
            }, function(err, data, xhr) {
                if(!err) {
                    for(var i = 0; i < data.length; i++) {
                        var strBoardName = boardIDNameMap[data[i].idBoard]
                        data[i]["boardName"] = strBoardName
                        data[i]["dueDate"] = data[i].due != null ? data[i].due : ""
                        trelloItemListModel.append(data[i])
                    }
                    return
                }
                console.log("ERR: " + err + " id: " + xhr.url)
            })
        } 
    }
}

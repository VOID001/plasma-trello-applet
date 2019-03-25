import QtQuick 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents

// Trello Item is used to display certain trello card item to user 
Component {
    id: trelloItemDelegate
    Item {
        id: trelloItem
        width: parent.width
        height: itemGrid.height + 10
        Component.onCompleted: {
            console.log("dueDate = " + model.dueDate)
            console.log("contentHeight: " + dueDateLabelText.contentHeight)
            if(model.dueDate == "") {
                dueDateRow.opacity = 0
                dueDateLabelText.text = ""
            }
            if(model.dueDate != "") {
                var dateObj = new Date(model.dueDate)
                dueDateRow.opacity = 1
                dueDateLabelText.text = dateObj.toLocaleDateString()
            }
        }
        // The row layout for checkbox and main trello item
        RowLayout {
            spacing: 5
            anchors.fill: parent
            CheckBox {
                id: itemCheckBox
            }
            // Main trello item
            GridLayout {
                id: itemGrid
                columns: 3
                width: parent.width - itemCheckBox.width
                // The upper-left corner label that displays board/list name
                Rectangle {
                    id: boardListLabel
                    width: boardListLabelText.width + 5
                    height: boardListLabelText.height + 0.1
                    radius: 5
                    Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                    Layout.topMargin: 5
                    Text {
                        anchors.centerIn: boardListLabel
                        id: boardListLabelText
                        font.bold: true
                        font.pointSize: 12
                        text: model.boardName
                    }

                }
                RowLayout {
                    id: dueDateRow
                    width: parent.width - dueDateLabelText.width - boardListLabelText.width
                    Item {
                        Image {
                            source: "res/clock.svg"
                            smooth: true
                            height: parent.height
                            width: parent.height
                            anchors.right: parent.right
                        }
                        id: dueDateLabelIcon
                        height: boardListLabelText.contentHeight + 30
                        Layout.fillWidth: true
                        Layout.minimumWidth: boardListLabelText.contentHeight + 30
                    }
                }
                Label {
                    id: dueDateLabelText
                    width: dueDateLabelText.contentWidth
                    height: dueDateRow.height
                    text: "Due 2019/12/30"
                    horizontalAlignment: Text.AlignRight
                    Layout.alignment: Qt.AlignRight | Qt.AlignTop
                    elide: Text.ElideLeft
                    font.bold: true
                    color: "green"
                }
                // The title of the card
                Item {
                    id: cardTitleLabel
                    height: cardTitleLabelText.height * 2
                    Layout.fillWidth: true
                    Layout.columnSpan: 3
                    Text {
                        id: cardTitleLabelText
                        width: parent.width
                        color: "white"
                        font.pointSize: 16
                        font.bold: true
                        wrapMode: Text.Wrap
                        maximumLineCount: 2
                        text: name
                    }
                    MouseArea {
                        property color oldColor
                        anchors.fill: parent
                        onClicked: {
                            Qt.openUrlExternally(url)
                        }
                        hoverEnabled: true
                        onEntered: {
                            oldColor = cardTitleLabelText.color
                            cardTitleLabelText.color = "coral"
                        }
                        onExited: {
                            cardTitleLabelText.color = oldColor
                        }

                    }
                }
            }
        }
    }
}

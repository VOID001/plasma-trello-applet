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
        // The row layout for checkbox and main trello item
        Row {
            spacing: 5
            anchors.fill: parent
            CheckBox {
                id: itemCheckBox
            }
            // Main trello item
            GridLayout {
                id: itemGrid
                columns: 2
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
                        text: boardName
                    }

                }
                // The upper-right corner label that displays Due date if possible
                Item {
                    id: dueDateLabel
                    width: dueDateRow.width
                    height: boardListLabel.height + 10
                    Layout.alignment: Qt.AlignRight
                    Layout.rightMargin: 25
                    Row {
                        id: dueDateRow
                        anchors.centerIn: parent
                        spacing: 3
                        Image {
                            id: dueDateLabelIcon
                            source: "res/clock.svg"
                            smooth: true
                            width: dueDateLabelText.height
                            height: dueDateLabelText.height
                        }
                        Text {
                            id: dueDateLabelText
                            text: "Due 2019/12/30"
                            color: "green"
                            font.bold: true
                        }
                    }
                }
                // The title of the card
                Item {
                    id: cardTitleLabel
                    height: cardTitleLabelText.height * 2
                    Layout.fillWidth: true
                    Layout.columnSpan: 2
                    Text {
                        id: cardTitleLabelText
                        width: parent.width
                        color: "white"
                        font.pointSize: 16
                        font.bold: true
                        wrapMode: Text.Wrap
                        maximumLineCount: 2
                        // text: "This is a very very very looooooong sentence and it may exceed the width of current row"
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

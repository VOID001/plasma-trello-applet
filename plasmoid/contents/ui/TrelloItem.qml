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
        Row {
            spacing: 5
            anchors.fill: parent
            CheckBox {
                id: itemCheckBox
            }
            GridLayout {
                id: itemGrid
                columns: 2
                width: parent.width - itemCheckBox.width
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
                        text: "board/list"
                    }

                }
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
                        PlasmaCore.IconItem {
                            id: dueDateLabelIcon
                            source: "face-cool"
                        }
                        Text {
                            id: dueDateLabelText
                            text: "Due 2019/12/30"
                            color: "green"
                            font.bold: true
                        }
                    }
                }
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
                        text: "This is a very very very looooooong sentence and it may exceed the width of current row"
                    }
                }
            }
        }
    }
}

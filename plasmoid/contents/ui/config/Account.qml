import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0

import "../" as UI

Item {
	id: accountPage
    Component.onCompleted: {

    }
	ColumnLayout {
		Row {
			Label {
				text: "API Key:"
			}
			TextField {
                id: apiKeyField
                text: plasmoid.configuration["api_key"]
                onEditingFinished: updateConfiguration("api_key", apiKeyField.text)
                onTextChanged: updateConfiguration("api_key", apiKeyField.text) // onTextEdited only in 5.9
                onAccepted: updateConfiguration("api_key", apiKeyField.text)
			}
		}
		Row {
			Label {
				text: "API Token:"
			}
            TextField {
                id: apiTokenField
                text: plasmoid.configuration["api_token"]
                onEditingFinished: updateConfiguration("api_token", apiTokenField.text)
                onTextChanged: updateConfiguration("api_token", apiTokenField.text) // onTextEdited only in 5.9
                onAccepted: updateConfiguration("api_token", apiTokenField.text)

            }
        }
    }
    function updateConfiguration(configKey, configValue) {
        console.log("The key ["+ configKey + "] changed to <" + configValue + ">")
        plasmoid.configuration[configKey] = configValue
        console.log("config: " + JSON.stringify(plasmoid.configuration))
    }

}

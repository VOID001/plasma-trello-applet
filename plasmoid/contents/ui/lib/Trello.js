.import "Requests.js" as Requests

var apiEndPoint = "https://api.trello.com/1/"
// var apiEndPoint = "http://127.0.0.1:3333/"

function getBoards(callback) {
    trelloRequest("members/me/boards", "GET", null, callback)
}

function getListsByBoardId(boardIdList, callback) {

}

function trelloRequest(url, method, data, callback) {
    var apiKey = plasmoid.configuration["api_key"]
    var apiToken = plasmoid.configuration["api_token"]
    var opt = {url: apiEndPoint + url + "?key=" + apiKey + "&token=" + apiToken }
    opt.headers = {
        "User-Agent": "KDE-Trello-Applet/0.1", // seems that I cannot set UA header
        "X-My-Custom-Header": "Shana&YoshinoRCute"
    }
    console.log("Sending request: " + method +  " " + JSON.stringify(opt))
    if(method == "GET") {
        Requests.get(opt, function (err, data, xhr) {
            if(err) {
                data = "Code: " + xhr.status + " " + xhr.statusText
                return callback(err, data, xhr)
            }
            var obj = JSON.parse(data)
            return callback(err, obj, xhr)
        })
    }
}

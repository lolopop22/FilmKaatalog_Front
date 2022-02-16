import QtQuick 2.0
import Felgo 3.0

Item {

    // loading state
    readonly property bool busy: HttpNetworkActivityIndicator.enabled

    // configure request timeout
    property int maxRequestTimeout: 20000  //20s

    // initialization
    Component.onCompleted: {
        // immediately activate loading indicator when a request is started
        HttpNetworkActivityIndicator.setActivationDelay(0)
    }

    // private
    QtObject { //everything in this object is not accessible outside of the outer Item class

        id: _

        property string url: "http://127.0.0.1:8000/api/films/"

        function fetch(url, success, error) { //success and error are callback function
            HttpRequest.get(url)
            .timeout(maxRequestTimeout)
            .then(function(res) {
                console.debug("keys of response in RestAPI.qml: "+ Object.keys(res))
                console.debug("résultat: " + Object.keys(res.body))
                success(res.body)
            })
            .catch(function(err) { error(err) });
        }

        function post(url, data, success, error) {
            HttpRequest.post(url)
            .timeout(maxRequestTimeout)
            .set('Content-Type', 'application/json')
            .send(data)
            .then(function(res) {
                console.debug("keys of response: "+ Object.keys(res))
                console.debug("résultat: " + res.body)
                success(res.body)
                listingsReceived()
            })
            .catch(function(err) { error(err) });
        }
    }

    // public rest api functions

    function getFilmsFromCatalog(success, error) {
        _.fetch(_.url, success, error)
    }

    function getFilmFromImdb(searchText, success, error) {
        var searchUrl = _.url+"?title="+searchText
        console.debug("In getFilmfromImbdb - url : " + searchUrl)
        _.fetch(searchUrl, success, error)
    }

    function addFilm(film, success, error) {
        console.log("will fire a post request in addFilm function")
        _.post(_.url, film, success, error)
    }
}

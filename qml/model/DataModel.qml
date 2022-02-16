import QtQuick 2.0
import Felgo 3.0

Item {

    // property to configure target dispatcher / logic
    property alias dispatcher: logicConnection.target

    // whether api is busy (ongoing network requests)
    readonly property bool isBusy: api.busy

    // whether a user is logged in
    readonly property bool userLoggedIn: _.userLoggedIn

    // model data properties
    readonly property var filmsFromCatalog: _.createListingsModel(_.filmsFromCatalog)
    readonly property var searchedFilms: _.createListingsModel(_.searchedFilms)

    // action success signals
    signal filmStored(var film)
    signal listingsReceived

    // action error signals
    signal fetchFilmsFromCatalogFailed(var error)
    signal fetchSearchedFilmFailed(var searchText, var error)
    signal onStoreFilmFailed(var title, var error)

    // listen to actions from dispatcher
    Connections {
        id: logicConnection

        // action 1 - fetch films from catalog
        onFetchFilmsFromCatalog: {
            // check cached value first
            var cached = cache.getValue("filmsFromCatalog")
            if(cached)
                _.filmsFromCatalog = cached

            // load from api
            api.getFilmsFromCatalog(
                        function(data) { //success
                            // cache data before updating model property
                            console.debug("keys of data in DataModel.qml: "+ Object.keys(data))
                            cache.setValue("filmsFromCatalog",data.results)
                            _.filmsFromCatalog = data.results
                            _.numTotalListings = data.count
                        },
                        function(error) { //error
                            // action failed if no cached data
                            if(!cached)
                                fetchFilmsFromCatalogFailed(error)
                        })
        }
        //action 2 - fetch film from IMDb
        onSearchListings: {
            console.debug("Signal searchListings works!")
            var cachedSearchedFilm = cache.getValue("Searched_" + searchText)
            console.debug("cachedSearchedFilm: " + cachedSearchedFilm)
            if (cachedSearchedFilm) {
                console.debug("research in cache")
                console.debug("keys of cachedSearchedFilm[0] DataModel.qml : " + Object.keys(cachedSearchedFilm[0]) )
                _.searchedFilms = cachedSearchedFilm
            } else {
                api.getFilmFromImdb(searchText,
                                    function(data) {
                                        console.debug("keys of data in DataModel.qml: "+ Object.keys(data))
                                        var response = data.response
                                        console.debug("keys of response in DataModel.qml (line 90): "+ Object.keys(response))
                                        var countSearch = response.count
                                        console.debug("Number of results (count): " + countSearch)
                                        var results = response.results
                                        console.debug("reuslt from search: "+ results)
                                        cache.setValue("Searched_" + searchText, results)
                                        _.searchedFilms = results
                                        listingsReceived()
                                    },
                                    function(error) {
                                        // action failed if no cached data
                                        if(!cached) {
                                            fetchSearchedFilmFailed(searchText, error)
                                        }
                                    })
            }
        }

        // action 3 - storeFilm
        onStoreFilm: {
            // store with api
            console.debug("In datamodel.qml ..... storing .....")
            api.addFilm(film,
                        function(data) {

                            // update cache with newly added item details
                            //var cachedFilms = cache.getValue("filmsFromCatalog")
                            //cache.setValue("filmsFromCatalog", cachedFilms.push(data))

                            // add new item to filmsFromCatalog
                            _.filmsFromCatalog.unshift(data)

                            todoStored(data)
                        },
                        function(error) {
                            console.log("We could not save the film  in the catallog - title : " + film.title)
                            storeFilmFailed(film.title, error)
                        })
        }

        // action 4 - clearCache
        onClearCache: {
            cache.clearAll()
        }

        // action 5 - login
        onLogin: _.userLoggedIn = true

        // action 6 - logout
        onLogout: _.userLoggedIn = false
    }

    // you can place getter functions here that do not modify the data
    // pages trigger write operations through logic signals only

    // rest api for data access
    RestAPI {
        id: api
        //maxRequestTimeout: 3000 // use max request timeout of 3 sec
    }

    // storage for caching
    Storage {
        id: cache
    }

    // private
    Item {
        id: _

        // data properties
        property var filmsFromCatalog: []  // Array // former todos
        property var searchedFilms: [] // Array // todoDetails
        property int numTotalListings

        // auth
        property bool userLoggedIn: false

        function createListingsModel(source) {
            return source.map(function(data) {
                console.debug("In create listings: " + data.title)
                var poster
                if (data.poster == null){
                    poster = Qt.resolvedUrl("./assets/film-reel.png")
                } else {
                    poster = data.poster //or data.full_size_poster
                }
                return {
                    text: data.title,
                    model: data,
                    image: poster,
                }
            })
        }
    }
}

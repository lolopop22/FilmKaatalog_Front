import Felgo 3.0
import QtQuick 2.0

Page {

    id: searchPage
    title: "Recherche"

    rightBarItem: NavigationBarRow { //it is going to create a row inside the navigation bar
        //it was added to the existing navbar
        ActivityIndicatorBarItem {
            visible: true
        }
    }

    SearchBar {
        id: searchBar
        placeHolderText: qsTr("Rechercher un film sur IMDb...")

        onAccepted: {
            console.log("search accepted: "+ text)
            if(navigationStack.currentPage === searchPage) { //we check which page we are on every page has only one stack
                console.debug("we are on the search page")
                search(searchBar.text)
            }
        }
    }

    AppListView {
        id: listView
        anchors.top: searchBar.bottom
        anchors.bottom: parent.bottom

        model: JsonListModel {
            id: listModel
            source: dataModel.searchedFilms
            fields: ["text", "model"]
        }

        /*property var jsonData: [
            {id: 1, title: "Apple", type: "Fruit"},
            {id: 2, title: "Ham", type: "Meat"},
            {id: 3, title: "Bacon", type: "Meat"},
            {id: 4, title: "Banana", type: "Fruit"},
            {id: 5, title: "Strawberry", type: "Fruit"}
        ]
        // list model for json data
        model : JsonListModel {
            id: jsonModel
            source: listView.jsonData
            keyField: "id"
            fields: ["id","title","type"]
        }
        delegate: AppListItem {
            text: model.title
            detailText: model.type
            onSelected: {
                console.debug("clicked")
                showPopup(model.title) //, item.image
            }
        }*/

        delegate: SimpleRow {
            item: listView.model.get(index)
            onSelected: {
                console.debug("clicked")
                showPopup(model.title, model.model) //, item.image
            }
        }
    }

    Item {
        id: popupOverlay
        anchors.fill: parent
        visible: false // hidden by default
        enabled: visible // disables all input elements (like MouseArea) of the popup if not visible

        // an alias to the text property, so popupOverlay.text can be used from outside to modify the text
        property alias text: popupText.text
        property var filmToBeStored

        MouseArea {
            anchors.fill: parent
            onClicked: {
                popupOverlay.visible = false
            }
        }

        // dark/transparent background
        Rectangle {
            anchors.fill: parent // fill whole screen
            color: "black"
            opacity: 0.7
        }


        Rectangle {
            id: popUpContent
            anchors.centerIn: parent
            width: parent.width - contentPadding

            height: 150
            color: "white"

            AppText {
                id: popupText
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                padding: contentPadding
                anchors.centerIn: parent
                text: "Voulez-vous ajouté le film" + popupOverlay.text + " à votre catalogue?"
            }

            Row {
                anchors.horizontalCenter: popupText.horizontalCenter
                anchors.top: popupText.bottom
                spacing: contentPadding

                AppButton {
                    text: qsTr("Oui")
                    textColor: "Blue"
                    onClicked: storeFilmInCatalog(popupOverlay.filmToBeStored)
                    flat: false
                }

                AppButton {
                    text: qsTr("Non")
                    textColor: "Red"
                    flat: false
                    onClicked: {
                        popupOverlay.visible = false
                    }
                }
            }
        }
    }

    Connections {
      target: dataModel
      onListingsReceived: {
          popupOverlay.visible = false
      }
    }

    function search(title) {
        console.debug("Searching for: " + title)
        searchBar.focus = false
        logic.searchListings(title) //we are calling/firing the signal each time we submit a text
    }

    function showPopup(title, model) {
        popupOverlay.text = "Voulez-vous ajouter le film " + title + " au catalogue?"
        popupOverlay.visible = true
        popupOverlay.filmToBeStored = model
    }

    function storeFilmInCatalog(filmToBeStored) {
        console.debug("Storing.........")
        console.debug("storing.....  keys of filmToBeStored: " + Object.keys(filmToBeStored))
        logic.storeFilm(filmToBeStored)
    }


}

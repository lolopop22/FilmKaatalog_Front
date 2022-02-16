import QtQuick 2.0
import Felgo 3.0
import "pages"
import "model"
import "logic"

Item {

    anchors.fill: parent

    // app initialization
    Component.onCompleted: {
        // if device has network connection, clear cache at startup
        if(isOnline) {
            logic.clearCache()
        }

        // fetch todo list data
        logic.fetchFilmsFromCatalog()
    }

    // business logic
    Logic {
        id: logic
    }

    // helper functions for view
    ViewHelper {
        id: viewHelper
    }

    // model
    DataModel {
        id: dataModel
        dispatcher: logic // data model handles actions sent by logic

        // global error handling
        onFetchFilmsFromCatalogFailed: nativeUtils.displayMessageBox("Unable to load films from catalog", error, 1)
        onFetchSearchedFilmFailed: nativeUtils.displayMessageBox("Unable to load searched film "+id, error, 1)
        //onStoreFilmFailed: nativeUtils.displayMessageBox("Failed to store "+ title, error, 1)
    }

    FilmKaatalogMainPage { }

    // login page lies on top of previous items and overlays if user is not logged in
    LoginPage {
        visible: opacity > 0
        enabled: visible
        opacity: dataModel.userLoggedIn ? 0 : 1 // hide if user is logged in

        Behavior on opacity { NumberAnimation { duration: 250 } } // page fade in/out
    }

}

import QtQuick 2.0
import Felgo 3.0

Page {

    title: "New Page"

    readonly property real contentPadding: dp(Theme.navigationBar.defaultBarItemPadding) //helps in defining de the default bar's padding of the page

    // view
    Navigation {
        id: navigation

        // only enable if user is logged in
        // login page below overlays navigation then
        enabled: dataModel.userLoggedIn

        // first tab
        NavigationItem {
            title: qsTr("Catalogue")
            icon: IconType.list
            onSelected: {
                logic.fetchFilmsFromCatalog()
            }

            NavigationStack {
                splitView: tablet // use side-by-side view on tablets
                initialPage: CatalogListingsPage { } // former TodoListPage
            }
        }

        // second tab
        NavigationItem {
            title: qsTr("Rechercher") // use qsTr for strings you want to translate
            icon: IconType.search

            NavigationStack {
                initialPage: SearchPage { // former ProfilePage
                    /*// handle logout

                    onLogoutClicked: {
                        logic.logout()

                        // jump to main page after logout
                        navigation.currentIndex = 0
                        navigation.currentNavigationItem.navigationStack.popAllExceptFirst()
                    }*/

                }
            }
        }

        // second tab
        /*NavigationItem {
            title: qsTr("Profile")
            icon: IconType.circle

            NavigationStack {
                splitView: tablet // use side-by-side view on tablets
                initialPage: ProfilePage { } // former TodoListPage
            }
        }*/

    }

}

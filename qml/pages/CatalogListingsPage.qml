import Felgo 3.0
import QtQuick 2.0

Page {
    title: "Catalogue"

    rightBarItem: NavigationBarRow {
        // network activity indicator
        ActivityIndicatorBarItem {
            enabled: dataModel.isBusy
            visible: enabled
            showItem: showItemAlways // do not collapse into sub-menu on Android
        }
    }

    JsonListModel {
        id: jsonListModel
        source: dataModel.filmsFromCatalog
        fields: ["title", "image", "model"]
    }

    // A gridview takes a linear model and displays it as a grid
    GridView {
        id: gridView
        anchors.fill: parent
        bottomMargin: nativeUtils.safeAreaInsets.bottom

        //model: 100

        model: jsonListModel

        // We force the cellWidth to be exactly one fourth of total width (so that 4 columns are displayed)
        cellWidth: gridView.width / 3

        // We force the cell to be squared
        cellHeight: 1.75*cellWidth

        delegate: Item {
            // We force the delegate to have the exact size of the cell
            width: gridView.cellWidth
            height: gridView.cellHeight

            AppPaper {
                anchors {
                    margins: dp(3)
                    fill: parent
                }

                AppImage {
                    anchors.fill: parent
                    fillMode: Image.PreserveAspectCrop
                    source: Qt.resolvedUrl(image)
                }
            }

            MouseArea {
                anchors.fill: parent
                // Push detail movie page when clicked pass pass chosen model
                onClicked: {
                    page.navigationStack.popAllExceptFirstAndPush(detailPageComponent, { model: model })
                }
            }
        }
    }

    // component for creating detail pages
    Component {
        id: detailPageComponent
        FilmDetailPage { }
    }
}


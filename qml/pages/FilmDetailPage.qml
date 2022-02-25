import QtQuick 2.0
import Felgo 3.0

FlickablePage {

    id: detailPage
    property var model: ({})
    title: qsTr("Fiche du film")

    clip: true

    // Set contentHeight of flickable to allow scrolling
    flickable.contentHeight: contentCol.height
    flickable.bottomMargin: nativeUtils.safeAreaInsets.bottom

    // Set false to hide the scroll indicator, it is visible by default
    scrollIndicator.visible: true

    Column {
        id: contentCol
        y: contentPadding
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: contentPadding
        spacing: contentPadding

        AppImage{
            source: Qt.resolvedUrl(model.poster) // the image will be laoded asynchronously
            //width: parent.width
            //height: model && width * model.img_height / (2*model.img_width) || 0 // we are checking for the model and then we set the height (if no model then height = 0)
            anchors.horizontalCenter: parent.horizontalCenter
            sourceSize.width: 384
            sourceSize.height: 384
        }

        AppText{
            text: "<b><i>" + model.title + "</i></b>"
            width: parent.width
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            font.pixelSize: sp(40)
            horizontalAlignment : Text.AlignHCenter
            anchors.horizontalCenter: parent.horizontalCenter
        }

        AppText{
            text: model.synopsis
            width: parent.width
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            horizontalAlignment : Text.AlignJustify
            font.pixelSize: sp(24)
            padding: contentPadding
        }

       /* AppPaper {

            AppText{
                text: model.synopsis
                width: parent.width
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                horizontalAlignment : Text.AlignJustify
                font.pixelSize: sp(24)
                padding: contentPadding
            }
        }*/

        AppText{
            text: "<u><b>Durée :</b></u> " + model.runtime
            width: parent.width
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            font.pixelSize: sp(20)
            padding: contentPadding
        }

        AppText{
            text: "<u><b>Réalisation :</b></u> " + detailPage.model.directors.join(", ")
            width: parent.width
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            font.pixelSize: sp(20)
            padding: contentPadding
        }

        AppText{
            text: "<u><b>Producteur :</b></u> " + detailPage.model.producers.join(", ")
            width: parent.width
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            font.pixelSize: sp(20)
            padding: contentPadding
        }

        AppText{
            text: "<u><b>Distribution :</b></u>  " + detailPage.model.cast.join(", ")
            width: parent.width
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            font.pixelSize: sp(20)
            padding: contentPadding
        }

    }
}

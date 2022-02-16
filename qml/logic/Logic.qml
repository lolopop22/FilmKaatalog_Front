import QtQuick 2.0

Item {

    // actions
    signal fetchFilmsFromCatalog() //signal fetchTodos()

    signal searchListings(string searchText)

    signal storeFilm(var film)

    signal clearCache()

    signal login(string username, string password)

    signal logout()

}

# LocationsApp
iOS app that stores locations

Uses TableView that displays all saved locations with button that segue to Map View

Map View shows user location and has button to save User's current location
* Also has button to center view on user's location.
* Long Press will save location pressed and place pin on that location
* Pressing location saved in table will take User to that particular location on the map


Files of interest:
* LocationTableVC.swift (Table of locations)
* MapVC.swift (Implentation of Map View)

Learned so far:
* Built a basic iOS app with segueways between views
* Sent data between view-controllers
* Saved data permanently on local device
* Able to centre map on user or scroll around the map
* Long pressing on map will store specific location
* Pressing row in table view will segue to map view
    - location will be centred with map pin
* Location is parsed geocoder
    - had to learn how to use callbacks/closures to implement this

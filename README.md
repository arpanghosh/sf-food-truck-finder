# SF Food Truck Finder

A Ruby-on-Rails + Bootstrap web-app for locating food trucks in San Francisco.

 
## Features & Dependencies 
* Uses the [Food Trucks](https://data.sfgov.org/Permitting/Mobile-Food-Facility-Permit/rqzj-sfat) dataset from the [Data SF](https://data.sfgov.org/) open dataset repository.
* Integrates with the [Socrata Open Data API](http://dev.socrata.com/) (using the [soda-ruby](https://github.com/socrata/soda-ruby) gem) to query and retrieve the [Food Trucks](https://data.sfgov.org/Permitting/Mobile-Food-Facility-Permit/rqzj-sfat) dataset.
* Integrates with [typeahead.js](http://twitter.github.io/typeahead.js/) for an easy, prompted search through food-items and locations.
* Integrates with the [Autocomplete](https://developers.google.com/places/documentation/autocomplete) endpoint of the Google Places API to fetch suggestions for the location-based typeahead.
* Integrates with [Geocoder](https://github.com/alexreisner/geocoder) for geocoding street addresses.
* Uses [Bootstrap](http://getbootstrap.com/) CSS and Javascript for the UI components.


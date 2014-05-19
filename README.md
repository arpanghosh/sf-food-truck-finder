# SF Food Truck Finder

A Ruby-on-Rails + Bootstrap web-app for locating food trucks in San Francisco.
Hungry? <strong>[Find a truck](http://ec2-54-203-10-188.us-west-2.compute.amazonaws.com:3000)</strong>


### Technical Track
full-stack
 
## Features & Dependencies 
* Uses the [Food Trucks](https://data.sfgov.org/Permitting/Mobile-Food-Facility-Permit/rqzj-sfat) dataset from the [Data SF](https://data.sfgov.org/) open dataset repository.
* Integrates with the [Socrata Open Data API](http://dev.socrata.com/) (using the [soda-ruby](https://github.com/socrata/soda-ruby) gem) to query and retrieve the [Food Trucks](https://data.sfgov.org/Permitting/Mobile-Food-Facility-Permit/rqzj-sfat) dataset.
* Integrates with [typeahead.js](http://twitter.github.io/typeahead.js/) for an easy, prompted search through food-items and locations.
* Integrates with the [Autocomplete](https://developers.google.com/places/documentation/autocomplete) endpoint of the Google Places API to fetch suggestions for the location-based typeahead.
* Integrates with [Geocoder](https://github.com/alexreisner/geocoder) for geocoding street addresses.
* Uses [Bootstrap](http://getbootstrap.com/) CSS and Javascript for the UI components.


### Technical Choices
Most of my web-app development in the past has been restricted to providing a bare-bones frontend to better explore and vizualize results from data-mining or machine learning applications and tasks. I prefer using Ruby on Rails because of its extensive gem library which covers almost any app feature one can think of. It is also well documented and has a very large developer community. Rails scaffolding and generators help generate a lot of the boilerplate code typically required for an entire web-application, which enables you to get up and running really quickly. Bootstrap provides polished versions of the most basic UI elements which have typically been sufficient for my use-cases. I am not very experienced with Javascript and Bootstrap also helps create several dynamic UI elements without writing too much JS code.

## Design Decisions & Trade-offs
### SFData vs. Local DB
I chose to use the Food Trucks dataset directly through SODA instead of loading it into a local database for the following reasons:

* Since we are dealing with food truck locations, I assumed that these change pretty frequently. Given the time constraints, I did not want to implement a mechanism for keeping the local copy of the data up to date in this iteration of the product. This of course increases query latency. In the next iteration I would like to implement a caching layer so that every search does not go the SF Data backend. I have currently implemented caching only for the food-item typeahead.

* The SODA API already provides a SQL-like query language (SoQL), which statisfied most of the query use-cases for this application. It also maintains a full-text index over the dataset which made it really easy to search using a particular food-item. Hence, I did not feel compelled to maintain the data in a local DB. If the application query requirements become significantly more complex or the dataset was stored as a flat file, it would become imperative to load the dataset into a local DB. Doing this would also allow us to better tune query performance for a production-level application.


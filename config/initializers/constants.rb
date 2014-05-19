#Datasets accessed using the SODA API are referenced using a 'domain' and 'dataset identifier'
SF_FOOD_TRUCK_SODA_DOMAIN = "data.sfgov.org"
SF_FOOD_TRUCK_SODA_DATASET_ID = "rqzj-sfat"

# App token required to use the SODA API
FOOD_TRUCK_FINDER_SODA_APP_TOKEN = "4yS1K6sN9viNluH6szUqUkGKW"

# Singleton SODA client that is used by the web-app to make queries against the SF Food trucks dataset
FOOD_TRUCK_FINDER_SODA_CLIENT = SODA::Client.new({:domain => SF_FOOD_TRUCK_SODA_DOMAIN, :app_token => FOOD_TRUCK_FINDER_SODA_APP_TOKEN})
SODA_SEARCH_LIMIT = 50

# Geographic constants around the San Francisco area
SF_CENTER_LAT = 37.7833
SF_CENTER_LONG = -122.4167
SF_RADIUS_METERS = 8050
MAX_DIST_FROM_SF_MILES = 10
SEARCH_RADIUS_MILES = 0.5

# API key and URL for the Google Places API
GOOGLE_PLACES_API_KEY = "AIzaSyBCirkyRgWEbWUOEeMWLh93aTfM8cU_8X4"
GOOGLE_PLACES_AUTOCOMPLETE_API_URL = "https://maps.googleapis.com/maps/api/place/autocomplete/json"

#UI formatting params
MAPS_INFOWINDOW_PER_ROW_HEIGHT = 35
MAPS_INFOWINDOW_PER_ROW_CHARS = 20
MAPS_INFOWINDOW_DEFAULT_ROWS = 2


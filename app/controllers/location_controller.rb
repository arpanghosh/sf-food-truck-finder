class LocationController < ApplicationController

  # Endpoint to fetch all Food Truck matches based on a street address  
  # GET location/index
  def index
    if params["query"]
      # Geocode a street address or place into [lat,long]
      coordinates = Geocoder.coordinates(params["query"])

      # Dont bother searching the food trucks dataset if the coordinates
      # are nowhere close to the SF area
      if coordinates && 
          Geocoder::Calculations.distance_between(coordinates, [SF_CENTER_LAT, SF_CENTER_LONG]) < MAX_DIST_FROM_SF_MILES

          #Creating a 'box' half a mile around the specified coordinates
          box = Geocoder::Calculations.bounding_box(coordinates, SEARCH_RADIUS_MILES)

          # Representing SoQL query as HTTP params. Only selecting records where lat, long are in 'box'
          args = {"$where" => "latitude > #{box[0]} AND latitude < #{box[2]} AND longitude > #{box[1]} AND longitude < #{box[3]}", 
                  "$select" => "applicant, address, latitude, longitude, schedule", 
                  "$limit" => SODA_SEARCH_LIMIT.to_s}
          response = FOOD_TRUCK_FINDER_SODA_CLIENT.get(SF_FOOD_TRUCK_SODA_DATASET_ID,
                                                    args)

          # Formating the SODA response into a dictionary of attributes which
          # the Google Maps plugin can consume
          @trucks = response.flat_map { |truck|
            if (truck.applicant &&
                truck.schedule &&
                truck.latitude &&
                truck.longitude &&
                truck.address)
              [{ "applicant" => truck.applicant,
                "schedule" => truck.schedule,
                "lat" => truck.latitude,
                "lng" => truck.longitude,
                "title" => truck.applicant,
                "address" => truck.address,
                #Generating and dynamically formatting the HTML for the 
                #'info-window' that pops up when a map marker is clicked on
                "infowindow" => generate_infowindow(truck)
              }]
            else
              # Removing trucks with missing attributes
              []
            end
          }
      else
        @trucks = []
      end
    else
      @trucks = []
    end 

    respond_to do |format|
      format.html
    end
  end

  # Endpoint to fetch all matching locations from the Google Places Autocomplete API
  # GET /location/autocomplete.json
  def autocomplete
    if params["query"]
      #Creating an autocomplete query and providing a central location and radius as a search hint
      response = JSON.parse(RestClient.get GOOGLE_PLACES_AUTOCOMPLETE_API_URL, {:params => {:key => GOOGLE_PLACES_API_KEY, 
                                                                      :input => params["query"],
                                                                      :location => SF_CENTER_LAT.to_s + ',' + SF_CENTER_LONG.to_s,
                                                                      :radius => SF_RADIUS_METERS.to_s }})

      # Formtting the returned location suggestions in a way the typeahead JS can parse
      locations = response["predictions"].map {|prediction|
        {"name" => prediction["description"]}
      }
    else
      locations = []
    end

    respond_to do |format|
      format.json { render json: locations }
    end
  
  end

  
  private

  # private helper method to generate infowindow HTML for each map marker
  def generate_infowindow(truck)
    render_to_string(:partial => "/food/infobox",
                     :locals => { applicant: truck.applicant,
                                  address: truck.address,
                                  style: "height:" + 
                                         (MAPS_INFOWINDOW_PER_ROW_HEIGHT * (truck.applicant.length/MAPS_INFOWINDOW_PER_ROW_CHARS + 
                                          MAPS_INFOWINDOW_DEFAULT_ROWS)).to_s + "px;" })
  end

end

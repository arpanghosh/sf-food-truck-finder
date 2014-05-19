class LocationController < ApplicationController

  def index
    if params["query"]
      coordinates = Geocoder.coordinates(params["query"])
      if coordinates && 
          Geocoder::Calculations.distance_between(coordinates, [SF_CENTER_LAT, SF_CENTER_LONG]) < 10

          box = Geocoder::Calculations.bounding_box(coordinates, 1)
          args = {"$where" => "latitude > #{box[0]} AND latitude < #{box[2]} AND longitude > #{box[1]} AND longitude < #{box[3]}", 
                  "$select" => "applicant, address, latitude, longitude, schedule", "$limit" => "50"}
          response = FOOD_TRUCK_FINDER_SODA_CLIENT.get(SF_FOOD_TRUCK_SODA_DATASET_ID,
                                                    args)

          @trucks = response.first(50).flat_map { |truck|
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
                "infowindow" => render_to_string(:partial => "/food/infobox",
                                              :locals => { applicant: truck.applicant,
                                                            address: truck.address,
                                                            style: "height:" + (35 * (truck.applicant.length/20 + 2)).to_s + "px;" })
              }]
            else
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


  def autocomplete
    if params["query"]
      response = JSON.parse(RestClient.get GOOGLE_PLACES_AUTOCOMPLETE_API_URL, {:params => {:key => GOOGLE_PLACES_API_KEY, 
                                                                      :input => params["query"],
                                                                      :location => SF_CENTER_LAT.to_s + ',' + SF_CENTER_LONG.to_s,
                                                                      :radius => SF_RADIUS_METERS.to_s }})
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

end

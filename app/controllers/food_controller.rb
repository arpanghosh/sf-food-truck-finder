class FoodController < ApplicationController
  # Endpoint to fetch all possible food items from the Food Trucks dataset
  # GET /food/autocomplete.json
  def autocomplete
    #Represent SoQL query as HTTP params
    args = {"$select" => "fooditems"}
    response = FOOD_TRUCK_FINDER_SODA_CLIENT.get(SF_FOOD_TRUCK_SODA_DATASET_ID, 
                                                  args)
    #Each record returned has multiple food items in a string. 
    #Flatmapping these to a global list of unique food items. 
    fooditems = response.flat_map { |truck|
      truck.fooditems.nil? ? [] : truck.fooditems.split(': ') 
    }.uniq

    respond_to do |format|
      format.json { render json: fooditems }
    end
  end

  # Endpoint to fetch all Food Truck matches based on a food item
  # GET /food/index?query=<food_item>
  def index
    if params["query"]
      #Represent SoQL query as HTTP params
      args = {"$q" => params["query"], 
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
          #Remove food trucks with missing attributes 
          []
        end
      }
    else
      @trucks = []
    end

    respond_to do |format|
      format.html
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

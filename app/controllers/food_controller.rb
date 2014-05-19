class FoodController < ApplicationController

  def autocomplete
    args = {"$select" => "fooditems"}
    response = FOOD_TRUCK_FINDER_SODA_CLIENT.get(SF_FOOD_TRUCK_SODA_DATASET_ID, 
                                                  args)
    fooditems = response.flat_map { |truck|
      truck.fooditems.nil? ? [] : truck.fooditems.split(': ') 
    }.uniq

    respond_to do |format|
      format.json { render json: fooditems }
    end
  end

  def index
    if params["query"]
      args = {"$q" => params["query"], "$select" => "applicant, address, latitude, longitude, schedule", "$limit" => "50"}
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

    respond_to do |format|
      format.html
    end
  end

end

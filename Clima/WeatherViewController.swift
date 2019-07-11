//
//  ViewController.swift
//  WeatherApp
//


import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class WeatherViewController: UIViewController ,CLLocationManagerDelegate,changedCityDelegate{
    let weatherData = WeatherDataModel()
    let locationManager = CLLocationManager()
    //Constants
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "fb7743ba2dadf8737bea780049092ce6"
    
    

    
    
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        

      
        
        
    
        
        
    }
    
    
    
  
    func getWeatherData(url: String, parameters: [String: String]) {
     
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
                
                print("Success! Got the weather data")
                let weatherJSON : JSON = JSON(response.result.value!)
                
                
                print(weatherJSON)
                
               self.updateWeatherData(json: weatherJSON)
                
            }
            else {
                print("Error \(String(describing: response.result.error))")
                self.cityLabel.text = "Connection Issues"
            }
        }
        
    }
    
    
    
    
    
    
    func updateWeatherData(json : JSON)
    {
       if let tempResult = json["main"]["temp"].double
       {
        weatherData.temperature = Int(tempResult - 273.15)
        }
       else{
        cityLabel.text = "UNAVAILAIBLE"
        }
       if let cityResult = json["name"].string
       {
        weatherData.city = cityResult
        }
       else{
        cityLabel.text = "UNAVAILAIBLE"
        }
         let weathcond = json["weather"]["0"]["id"].intValue
        print("shuasuhauha")
            print(weathcond)
        weatherData.weatherIconName = weatherData.updateWeatherIcon(condition: weathcond)
            
    
       
        updateUIWithWeatherData()
    }

    
    
    
   
    
    func updateUIWithWeatherData()
    {
        
        cityLabel.text = weatherData.city
        temperatureLabel.text = String(weatherData.temperature) + "°"
     
        weatherIcon.image = UIImage(named: weatherData.weatherIconName)
        
     
        
        
    }
    
    
    
    
 
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            
            self.locationManager.stopUpdatingLocation()
            
            print("longitude = \(location.coordinate.longitude), latitude = \(location.coordinate.latitude)")
            
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            
            let params : [String : String] = ["lat" : latitude, "lon" : longitude, "appid" : APP_ID]
            
            getWeatherData(url: WEATHER_URL, parameters: params)
        }
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        cityLabel.text = "Location Unavailaible "
    }
    

    
   
    func userEnteredAnewCityName(cityName: String) {
        let params : [String : String] = ["q": cityName,"appid": APP_ID]
        getWeatherData(url: WEATHER_URL, parameters: params)
    }

    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "changeCityName"
        {
            let destination = segue.destination as! ChangeCityViewController
            destination.delegate = self
        }
        
    }
    
    
    
}



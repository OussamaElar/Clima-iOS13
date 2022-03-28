//
//  WeatherManager.swift
//  Clima
//
//  Created by Ouss Elar on 12/9/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather (_ weatherManager: WeatherManger,weather: WeatherModel)
    func didFailWithError (error: Error)
}
struct WeatherManger {
    let weatherUrl = "https://api.openweathermap.org/data/2.5/weather?appid=ac58a29a9edce35724f51cd671896c2f&units=metric"
    
    var delegate: WeatherManagerDelegate?
    func fetchWeather (cityName: String) {
        let urlString = "\(weatherUrl)&q=\(cityName)"
        performRequest(with: urlString)

    }
    func performRequest (with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let weather = self.parseJSON(weatherData: safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON (weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder ()
        do {
        let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            
            let id = decodedData.weather[0].id
            let name = decodedData.name
            let temp = decodedData.main.temp
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            
           return weather
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}
extension WeatherManger {
    func fetchWeather (latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        let urlString = "\(weatherUrl)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
}

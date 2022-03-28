//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManger = WeatherManger()
    let locationManger = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManger.delegate = self
        locationManger.requestWhenInUseAuthorization()
        locationManger.requestLocation()
        
        weatherManger.delegate = self
        searchTextField.delegate = self
    }
    @IBAction func currentLocation(_ sender: Any) {
       
        locationManger.requestLocation()
        
    }
}
    
 //MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {
        @IBAction func searchButton(_ sender: UIButton) {
            print(searchTextField.text!)
            searchTextField.endEditing(true)
        }
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            print(searchTextField.text!)
            searchTextField.endEditing(true)
            return true
        }
        func textFieldDidEndEditing(_ textField: UITextField) {
            if let city = searchTextField.text {
                weatherManger.fetchWeather(cityName: city)
            }
            searchTextField.text = ""
        }
        func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
            if searchTextField.text != "" {
                return true
            } else {
                searchTextField.placeholder = "Type somthing"
                return false
            }
        }
}

  //MARK: - WeatherMangerDelegate

extension WeatherViewController: WeatherManagerDelegate {
    func didUpdateWeather (_ weatherManager: WeatherManger,weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
        }
    }
    func didFailWithError(error: Error) {
        print(error)
    }
}
 //MARK: - LocationMangerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManger.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManger.fetchWeather(latitude: lat, longitude: lon)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}



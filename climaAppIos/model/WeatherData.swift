//
//  WeatherData.swift
//  climaAppIos
//
//  Created by chekir walid on 27/7/2021.
//

import Foundation

struct WeatherData: Decodable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Weather: Decodable {
    let id: Int
}

struct Main: Decodable{
    let temp: Double
}

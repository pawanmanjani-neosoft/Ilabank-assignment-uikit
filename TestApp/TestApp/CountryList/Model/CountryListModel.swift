//
//  CountryListModel.swift
//  TestApp
//
//  Created by NeoSOFT on 27/06/24.
//

import Foundation

struct CountryListModel: Decodable {
    let countries: [CountryModel]
}
struct CountryModel: Decodable {
    let countryName: String
    let countryFlagUrl: String
    let touristPlaces: [TouristPlaceModel]
}
struct TouristPlaceModel: Decodable {
    let placeName: String
    let placeUrl: String
}

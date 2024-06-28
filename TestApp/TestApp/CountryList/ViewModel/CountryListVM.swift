//
//  CountryListVM.swift
//  TestApp
//
//  Created by NeoSOFT on 27/06/24.
//

import Foundation
import Combine

protocol CountryListVMProtocol {
    func loadData()
    func setTouristListBy(index: Int)
    func filterDataby(_ searchTxt: String)
    var errorEvent: PassthroughSubject<String, Never> { get set }
    var reloadEvent: PassthroughSubject<Void, Never> { get set }
    var dataReceivedEvent: PassthroughSubject<Void, Never> { get set }
    var getListOfCountry: [CountryModel] { get }
    var isFilterPlacesIsEmpty: Bool { get }
    var filterData: [TouristPlaceModel] { get }
}
final class CountryListVM: CountryListVMProtocol {
    var errorEvent = PassthroughSubject<String, Never>()
    var reloadEvent = PassthroughSubject<Void, Never>()
    var dataReceivedEvent = PassthroughSubject<Void, Never>()
    var listCountries: [CountryModel] = []
    private var arrFilteredPlaces: [TouristPlaceModel] = []
    private var arrCurrentPlaces: [TouristPlaceModel] = []
    private var requestManager: FileReaderProtocol = FileReader()
    // MARK: Get List of Countries
    var getListOfCountry: [CountryModel] {
        return listCountries
    }
    var filterData: [TouristPlaceModel] {
        return arrFilteredPlaces
    }
    var isFilterPlacesIsEmpty: Bool {
        return arrFilteredPlaces.isEmpty
    }
    // MARK: Getting data from local path
    func loadData() {
        do {
            let response: CountryListModel = try requestManager.loadDataFrom(file: "DataResponse", type: "json")
            listCountries = response.countries
            setTouristListBy(index: .zero) //initial loaded first index
        } catch {
            errorEvent.send(error.localizedDescription)
        }
    }
    // MARK: Setting selected data and reloading
    func setTouristListBy(index: Int) {
        guard listCountries.indices.contains(index) else { return }
        let places = listCountries[index].touristPlaces
        arrCurrentPlaces = places
        arrFilteredPlaces = places
        reloadEvent.send()
        dataReceivedEvent.send()
    }
    // MARK: Filter data by search text
    func filterDataby(_ searchTxt: String) {
        if searchTxt.isEmpty {
            arrFilteredPlaces = arrCurrentPlaces
        } else {
            arrFilteredPlaces = arrCurrentPlaces.filter { model in
                return model.placeName.lowercased().range(of: searchTxt.lowercased()) != nil
            }
        }
        reloadEvent.send()
    }
}

//
//  BottomSheetVM.swift
//  TestApp
//
//  Created by NeoSOFT on 27/06/24.
//

import Foundation
import Combine

protocol BottomSheetVMProtocol {
    var displayData: [BottomSheetModel] { get set }
    var reloadEvent: PassthroughSubject<Void, Never> { get set }
    func setupData(countryData: [CountryModel])
}

final class BottomSheetVM: BottomSheetVMProtocol {
    var displayData: [BottomSheetModel] = []
    var reloadEvent = PassthroughSubject<Void, Never>()
    
    // MARK: Setting up array to display data
    func setupData(countryData: [CountryModel]) {
        for data in countryData {
            let occ = getTopOccChar(touristPlaces: data.touristPlaces)
            let id = displayData.count + 1
            displayData.append(BottomSheetModel(id: id, listCount: data.touristPlaces.count, occurrence: occ))
        }
        reloadEvent.send()
    }
    // MARK: Filling data with char count
    private func getOccChar(touristPlaces: [TouristPlaceModel]) -> [BottomSheetOccuranceModel] {
        var charOcc: [BottomSheetOccuranceModel] = []
        for touristPlace in touristPlaces {
            for char in touristPlace.placeName where !char.isWhitespace {
                let strChar = String(char)
                let containsValue  = charOcc.first(where: ({ $0.value == strChar }))
                if let containsValue {
                    containsValue.count += 1
                } else {
                    charOcc.append(.init(value: strChar, count: 1))
                }
            }
        }
        return charOcc
    }
    // MARK: Getting top 3 count data from the list
    private func getTopOccChar(touristPlaces: [TouristPlaceModel]) -> [BottomSheetOccuranceModel] {
        let occChar = getOccChar(touristPlaces: touristPlaces)
        let maxOccChar = occChar.sorted { $0.count > $1.count }.prefix(3)
        return Array(maxOccChar)
    }
}

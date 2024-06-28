//
//  BottomSheetModel.swift
//  TestApp
//
//  Created by NeoSOFT on 27/06/24.
//

import Foundation

struct BottomSheetModel {
    let id: Int
    let listCount: Int
    let occurrence: [BottomSheetOccuranceModel]
    var detailTxt: String = ""
    init(id: Int, listCount: Int, occurrence: [BottomSheetOccuranceModel]) {
        self.id = id
        self.listCount = listCount
        self.occurrence = occurrence
        setOccuranceTxt()
    }
    var title: String {
        String(format: "List %@(%@ Items)", id.description, listCount.description)
    }
    mutating
    private func setOccuranceTxt() {
        for data in occurrence {
            detailTxt.append(data.title)
            detailTxt.append("\n")
        }
    }
}

final class BottomSheetOccuranceModel {
    let value: String
    var count: Int
    init(value: String, count: Int) {
        self.value = value
        self.count = count
    }
    
    var title: String {
        String(format: "%@ = %@", value, count.description)
    }
}

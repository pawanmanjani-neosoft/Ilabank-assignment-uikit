//
//  FileReader.swift
//  TestApp
//
//  Created by NeoSOFT on 27/06/24.
//

import Foundation

protocol FileReaderProtocol {
    func loadDataFrom<T: Decodable>(file: String, type: String) throws -> T
}

final class FileReader: FileReaderProtocol {
    // MARK: loading data from local path file
    func loadDataFrom<T: Decodable>(file: String, type: String) throws -> T {
        guard let path = Bundle.main.path(forResource: file, ofType: type) else {
            throw CustomError("Invalid path")
        }
        let data = try Data(contentsOf: URL(filePath: path))
        let response = try JSONDecoder().decode(T.self, from: data)
        return response
    }
}

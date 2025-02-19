//
//  FileService.swift
//  WeatherClientSwiftUI
//
//  Created by Ruslan Liulka on 19.02.2025.
//

import Foundation

protocol FileServiceProtocol {
    func saveData<T: Encodable>(object: T, fileName: String) throws
    func loadData<T: Decodable>(type: T.Type, fileName: String) throws -> T
}

class FileService: FileServiceProtocol {
    private let fileManager = FileManager.default
    
    func saveData<T>(object: T, fileName: String) throws where T : Encodable {
        let url = try getFileUrl().appendingPathComponent(fileName)
        let data = try JSONEncoder().encode(object)
        try data.write(to: url)
    }
    
    func loadData<T>(type: T.Type, fileName: String) throws -> T where T : Decodable {
        let url = try getFileUrl().appendingPathComponent(fileName)
        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    private func getFileUrl() throws -> URL {
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        return documentDirectory
    }
}

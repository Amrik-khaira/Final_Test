//
//  LocalStorage.swift
//  BMICalculator
//  Author's name : Amrik Singh
//  Created by Amrik on 13/12/22.
//  StudentID : 301296257
//  BMI Calculator App
//  Version: 1.0
//

import Foundation
import UIKit

class LocalStorage {
    //MARK: - shared instance for Local Storage class
    static let shared = LocalStorage()
    
    //MARK: - Save Data In Local storage
    func saveDataInPersistent(BMIArr:[BMIRecords]) {
        UserDefaults.standard.set(try? PropertyListEncoder().encode(BMIArr), forKey:"BMIRecords")
    }
    
    //MARK: - Get Saved Items
    func GetSavedItems() -> [BMIRecords] {
        if let data = UserDefaults.standard.value(forKey:"BMIRecords") as? Data {
            do
            {
                return try PropertyListDecoder().decode(Array<BMIRecords>.self, from: data)
            } catch {
                return [BMIRecords]()
            }
        } else {
            return [BMIRecords]()
        }
    }
}

//MARK: - Json Structure for handel data BMI Records 
struct BMIRecords:Codable {
    var name: String?
    var bmiScore: String?
    var age: String?
    var height: String?
    var gender: String?
    var isMatric: Bool?
    var strDate: String?
    var weight: String?
    var descriptor: String?
}

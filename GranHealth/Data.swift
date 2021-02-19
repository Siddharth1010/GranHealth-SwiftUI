//
//  Data.swift
//  GranHealth
//
//  Created by MANI NAIR on 19/02/21.
//  Copyright © 2021 com.siddharthnair. All rights reserved.
//

import Foundation


let healthData:[Health] = load("health.json")

func load<T: Decodable>(_ filename:String, as type:T.Type = T.self) -> T {
    
    let data:Data
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else{
            fatalError("Couldnt find \(filename) in main bundle")
    }
    
    do{
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldnt load \(filename) from main bundle:\n\(error)")
    }
    
    do{
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldnt pass \(filename) as \(T.self):\n\(error)")
    }
    
}

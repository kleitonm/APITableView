//
//  TableViewController.swift
//  APITableView
//
//  Created by Kleiton Mendes on 02/06/22.
//

import Foundation
import CryptoKit
import Alamofire

class TableViewController {
    
    var charactersArray:[Character] = []
    
    let ts = String(Date().timeIntervalSince1970)
    let privateKey = "52a8120753f358d679a81d6a2a7e07aa"
    let publicKey = "85bec0b844e009a0dda99007cfb76ead5b44f72b"
    let characterId = ""
    
    func getCount() -> Int {
        return charactersArray.count
    }
    
    func getCharacter(indexPath: IndexPath) -> Character {
        return self.charactersArray[indexPath.row]
    }
    
    func MD5(data: String) -> String {
        let hash = Insecure.MD5.hash(data: data.data(using: .utf8) ?? Data())
        return hash.map { String(format: "%002hx", $0) }.joined()
            
    }
    
    func networkCharacters(name: String?, completion: @escaping (Bool, Error?) -> Void)  {
        
        var url: String = ""
        let hash = self.MD5(data: "\(ts)\(privateKey)\(publicKey)")
        
        if name != nil {
            let nameCharacter: String = name ?? ""
            print(nameCharacter)
            url = "https://gateway.marvel.com:443/v1/public/characters?nameStartsWith=\(nameCharacter)&ts=\(ts)&apikey=\(publicKey)&hash=\(hash)"
        } else {
            url = "https://gateway.marvel.com:443/v1/public/characters?limit=100&ts=\(ts)&apikey=\(publicKey)&hash=\(hash)"
        }
        print("======================\(url)==========================")
        
        AF.request(url).responseJSON { response in
            if let data = response.data {
                do {
                    let result: CharacterAPIResult = try JSONDecoder().decode(CharacterAPIResult.self, from: data)
                    self.charactersArray = result.data.results
                    completion(true, nil)
                } catch  {
                    completion(false, error)
                }
            }
        }
        
        
    }
}

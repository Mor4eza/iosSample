//
//  MarketActivityModel.swift
//  SabadBan
//
//  Created by ehsan on 9/16/16.
//  Copyright © 2016 Sefr Yek. All rights reserved.
//

import Foundation
import Gloss

//MARK: - Response
public struct MarketActivityModel: Glossy {
    
    public let marketDateTime : String!
    public let marketStatusEn : String!
    public let marketStatusFa : String!
    public let marketValue : Double!
    public let numberOfTransactions : Double!
    public let valueOfTransactions : Double!
    public let volumeOfTransactions : Double!
    
    
    
    //MARK: Decodable
    public init?(json: JSON){
        marketDateTime = "marketDateTime" <~~ json
        marketStatusEn = "marketStatusEn" <~~ json
        marketStatusFa = "marketStatusFa" <~~ json
        marketValue = "marketValue" <~~ json
        numberOfTransactions = "numberOfTransactions" <~~ json
        valueOfTransactions = "valueOfTransactions" <~~ json
        volumeOfTransactions = "volumeOfTransactions" <~~ json
    }
    
    
    //MARK: Encodable
    public func toJSON() -> JSON? {
        return jsonify([
            "marketDateTime" ~~> marketDateTime,
            "marketStatusEn" ~~> marketStatusEn,
            "marketStatusFa" ~~> marketStatusFa,
            "marketValue" ~~> marketValue,
            "numberOfTransactions" ~~> numberOfTransactions,
            "valueOfTransactions" ~~> valueOfTransactions,
            "volumeOfTransactions" ~~> volumeOfTransactions,
            ])
    }
    
}
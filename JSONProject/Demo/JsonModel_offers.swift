//
//  JsonModel_params.swift
//  Demo
//
//  Created by MAC ISTV on 26/03/2017.
//  Copyright © 2017 UVHC. All rights reserved.
//

import Foundation


class Offer: Hashable, CustomStringConvertible {
    let title: String
    let description: String
    let price: Int
    
    let specificFields: Set<CommonField>
    let features: Set<Feature>

    init?(jsonContent: [String: Any]) throws {
        
        guard let title = jsonContent["title"] as? String else {
            throw SerializationError.missing("title")
        }
        guard let description = jsonContent["description"] as? String else {
            throw SerializationError.missing("description")
        }
        guard let price = jsonContent["price"] as? Int else {
            throw SerializationError.missing("price")
        }
        
        // Extract and validate SpecificField
        guard let specificFieldsJsonArray = jsonContent["specificFields"] as? [[String: Any]] else {
            throw SerializationError.missing("specificFields")
        }
        print("specificFieldsJsonArray : \(specificFieldsJsonArray)")//FIXME: pour debug uniquement
        var specificFields: Set<CommonField> = []
        for specificFieldJsonElement in specificFieldsJsonArray {
            print("specificFieldJsonElement : \(specificFieldJsonElement)")//FIXME: pour debug uniquement
            
            do {
                guard let specificField = try CommonField(jsonContent: specificFieldJsonElement) else {
                    throw SerializationError.invalid("specificFields", specificFieldJsonElement)
                }
                specificFields.insert(specificField)
                
            } catch let serializationError {
                print(serializationError)
            }
            
        }
        
        // Extract and validate SpecificField
        guard let featuresJsonArray = jsonContent["features"] as? [[String: Any]] else {
            throw SerializationError.missing("features")
        }
        //print("featuresJsonArray : \(featuresJsonArray)")//FIXME: pour debug uniquement
        var features: Set<Feature> = []
        for featureJsonElement in featuresJsonArray {
            //print("featureJsonElement : \(featureJsonElement)")//FIXME: pour debug uniquement
            
            do {
                guard let feature = try Feature(jsonContent: featureJsonElement) else {
                    throw SerializationError.invalid("features", featureJsonElement)
                }
                features.insert(feature)
                
            } catch let serializationError {
                print(serializationError)
            }
            
        }
        
        //assignation
        self.title = title
        self.description = description
        self.price = price
        self.specificFields = specificFields
        self.features = features
    }
    
    //Hashable
    var hashValue: Int {
        return title.hashValue ^ title.hashValue
    }
    static func == (o1: Offer, o2: Offer) -> Bool {
        return o1.title == o2.title
    }

    
    //toString()
    //public var description: String { return "Offers(title:'\(title)', description:'\(description)', price:'\(price)', specificFields:\(specificFields), features:\(features) )" }
    
}

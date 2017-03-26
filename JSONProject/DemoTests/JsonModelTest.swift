//
//  JsonModelTest.swift
//  Demo
//
//  Created by MAC ISTV on 26/03/2017.
//  Copyright © 2017 UVHC. All rights reserved.
//

import XCTest
@testable import Demo

class JsonModelTest: XCTestCase {
    
    var jsonString: String!;
    var data: Data!;

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        jsonString = "{     \"title\": \"Free\",     \"description\": \"Abonnez-vous chez nous yaura de la 4g partout\",     \"commonFields\": [                      {                      \"required\": true,                      \"fieldType\": \"name\",                      \"fieldId\": \"firstName\",                      \"label\": \"Prénom\",                      \"input\": \"text\",                      \"params\": {                         \"minLength\": 2,                         \"maxLenght\": 25,                         \"placeholder\": \"Entrez votre prénom\"                      }                      },                      {                      \"required\": true,                      \"fieldType\": \"name\",                      \"fieldId\": \"lastName\",                      \"label\": \"Name\",                      \"input\": \"text\",                      \"params\": {                      \"minLength\": 2,                      \"maxLenght\": 25,                      \"placeholder\": \"Entrez votre nom\"                      }                      },                      {                      \"required\": true,                      \"fieldType\": \"other\",                      \"fieldId\": \"sexe\",                      \"label\": \"Sexe\",                      \"input\": \"radio\",                      \"params\": {                      \"choices\": [                                  {                                  \"value\": \"M\",                                  \"label\": \"Homme\"                                  },                                  {                                  \"value\": \"F\",                                  \"label\": \"Femme\"                                  }                                  ]                      }                      },                      {                      \"required\": true,                      \"fieldType\": \"date\",                      \"fieldId\": \"birthDate\",                      \"label\": \"Date de naissance\",                      \"input\": \"date\"                      },                      {                      \"required\": true,                      \"fieldType\": \"other\",                      \"fieldId\": \"country\",                      \"label\": \"Pays\",                      \"input\": \"select\",                      \"params\": {                      \"choices\": [                                  {                                  \"value\": \"FRA\",                                  \"label\": \"France\",                                  \"selected\": true                                  },                                  {                                  \"value\": \"BEL\",                                  \"label\": \"Belgique\"                                  }                                  ]                      }                      }                      ],     \"paymentWays\": [                     \"creditCard\",                     \"bankTransfer\"                     ],     \"offers\": [                {                \"title\": \"Abonnoment petit\",                \"description\": \"Offre de merde sms illimité mais que 2h d'appel et 500Mo\",                \"price\": 2,                \"specificFields\": [                                   {                                   \"fieldType\": \"phone\",                                   \"fieldId\": \"phone\",                                   \"label\": \"Numéro de téléphone\",                                   \"input\": \"string\"                                   }                                   ],                \"features\": [                             {                             \"price\": 2,                             \"title\": \"+2 Go\",                             \"description\": \"Profitez de 2 Go en plus pour seulement 2€ par mois\"                             },                             {                             \"price\": 5,                             \"title\": \"Deezer\",                             \"description\": \"Offrez-vous un abonnement Deezer pour seulement 5€/mois au lieu de 9,99€\"                             }                             ]                },                {                \"title\": \"Abonnoment grand\",                \"description\": \"Offre tout illimité et 50Go\",                \"price\": 20,                \"specificFields\": [                                   {                                   \"fieldType\": \"email\",                                   \"fieldId\": \"email\",                                   \"label\": \"Email\",                                   \"input\": \"string\"                                   }                                   ],                \"features\": [                             {                             \"price\": 2,                             \"title\": \"+2 Go\",                             \"description\": \"Profitez de 2 Go en plus pour seulement 2€ par mois\"                             },                             {                             \"price\": 5,                             \"title\": \"Deezer\",                             \"description\": \"Offrez-vous un abonnement Deezer pour seulement 5€/mois au lieu de 9,99€\"                             }                             ]                }                ]      } "
        
        data = jsonString.data(using: String.Encoding.utf8, allowLossyConversion: false)!
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInitJsonModel() {
        
        do {
            let json = try? JSONSerialization.jsonObject(with: data!, options: [])
            
            let jsonModel = try JsonModel(jsonContent: json as! [String: Any])
            print("jsonModel from testInitJsonModel : \(jsonModel)")
            
            XCTAssertNotNil(jsonModel)
            
            XCTAssertEqual(jsonModel!.title, "Free")
            XCTAssertEqual(jsonModel!.description, "Abonnez-vous chez nous yaura de la 4g partout")
            
            XCTAssertEqual(jsonModel!.commonFields.count, 5)
            
        } catch let serializationError {
            //No error expected
            XCTFail(serializationError as! String)
        }
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}

//
//  Favorite.swift
//  TourMore
//
//  Created by Michael Di Cesare on 11/25/19.
//  Copyright © 2019 Christopher Alegre. All rights reserved.
//

import Foundation
import Firebase


class Favorite {
    var businessID: String
    
    init(businessID: String){
        self.businessID = businessID
    }
    
    convenience init?(snapshot: DataSnapshot) {
        guard let snapshotValue = snapshot.value as? [String : Any],
            let businessID = snapshotValue["businessID"] as? String
            else {return nil}
        self.init(businessID: businessID)
    }
}

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
    
//    init(snapshot: DataSnapshot) {
//    let snapshotValue = snapshot.value as? [String : AnyObject],
//    businessID = snapshotValue["businessID"] as? String
//    }
}

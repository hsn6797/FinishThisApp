//
//  User.swift
//  FinishThisApp
//
//  Created by Hassan on 27/08/2020.
//  Copyright © 2020 sufnatech. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

/// A user corresponding to a Firebase user. Additional metadata for each user is stored in
/// Firestore.
class User: Codable{
    
    /// The ID of the user. This corresponds with a Firebase user's uid property.
    var userID: String = ""
    var email: String = ""
    var password: String = ""
    var userName: String = ""

    private enum CodingKeys : String, CodingKey{
        case userName
 
    }
    
    
    /// All users are stored by their userIDs for easier querying later.
    var documentID: String {
        return userID
    }
    
    /// The default URL for profile images.
//    static let defaultPhotoURL =
//        URL(string: "https://storage.googleapis.com/firestorequickstarts.appspot.com/food_1.png")!
    
    /// A user object's representation in Firestore.
    public var documentData: [String: Any] {
        return [
            "userName": userName,

        ]
    }
    
}



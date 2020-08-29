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
class Quiz: Codable{
    
    /// The ID of the user. This corresponds with a Firebase user's uid property.
    var QuizID: String = ""
    var QuizName: String = ""
    
    
    private enum CodingKeys : String, CodingKey{
        case QuizName
    }
    
    /// A user object's representation in Firestore.
    public var documentData: [String: Any] {
        return [
            "QuizName": QuizName,
        ]
    }
    
}



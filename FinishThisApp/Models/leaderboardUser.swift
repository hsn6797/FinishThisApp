//
//  leaderboardUser.swift
//  FinishThisApp
//
//  Created by Asad on 29/08/2020.
//  Copyright © 2020 sufnatech. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class leaderUser: Codable
{
    var leadID:String = ""
    var userName: String = ""
    var quizName: String = ""
    var streak: String = ""
  
    
    
    private enum CodingKeys : String, CodingKey{
        case userName
        case quizName
        case streak
        case leadID
    }
    
    /// A user object's representation in Firestore.
    public var documentData: [String: Any] {
        return [
            "LeadID":leadID,
            "UserName":userName,
            "QuizName":quizName,
            "Streak":streak,

        ]
    }
    
    
    
}

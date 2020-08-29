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
class Question: Codable{
    
    /// The ID of the user. This corresponds with a Firebase user's uid property.
    var QuestionID: String = ""
    var QuizID: String = ""
    var Question: String = ""
    var correctAns: String = ""
    var wrongAns1: String = ""
    var wrongAns2: String = ""
    var wrongAns3: String = ""

    
    private enum CodingKeys : String, CodingKey{
        case QuizID
        case Question
        case correctAns
        case wrongAns1
        case wrongAns2
        case wrongAns3
    }
    
    /// A user object's representation in Firestore.
    public var documentData: [String: Any] {
        return [
            "QuizID":     QuizID,
            "Question":   Question,
            "correctAns": correctAns,
            "wrongAns1":  wrongAns1,
            "wrongAns2":  wrongAns2,
            "wrongAns3":  wrongAns3,

        ]
    }
    
}



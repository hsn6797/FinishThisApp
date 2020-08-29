//
//  Firestore+Populate.swift
//  FinishThisApp
//
//  Created by Hassan on 27/08/2020.
//  Copyright © 2020 sufnatech. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

extension Firestore {
    
    /// Returns a reference to the top-level Users collection.
    var users: CollectionReference {
        return self.collection("Users")
    }
    
    /// Returns a reference to the top-level Quizes collection.
    var quizes: CollectionReference {
        return self.collection("Quiz")
    }
    
    /// Returns a reference to the top-level Questions collection.
    var questions: CollectionReference {
        return self.collection("Questions")
    }
    
    
}

// MARK: Write operations
extension Firestore {
    
    /// Writes a user to the top-level users collection, overwriting data if the
    /// user's uid already exists in the collection.
    func add(user: User) {
        self.users.document(user.documentID).setData(user.documentData)
    }
    
    func getCurrentUser(userID: String,completionHandler: @escaping (User) -> ()){
        let docRef = self.users.document(userID)
        
        docRef.getDocument(source: .default) { (document, error) in
            if let document = document {
//                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                
                guard let d = Helper.ParametersToData(prams: document.data()! as [String : AnyObject]) else{
                    return
                }
                guard let user = Helper.dataToObject(data: d, object: User.self) else{
                    return
                }
                user.userID = userID
                completionHandler(user)

                
//                print("Cached document data: \(dataDescription)")

            } else {
                print("Document does not exist in cache")

            }
        }
        
        
        
//        self.users.getDocuments(completion: {
//            (querySnapshot, err) in
//            if(err != nil){
//                // Error
//            }else{
//                for document in querySnapshot!.documents {
//                    let u = User()
//                    u.userID = document.documentID
//                    u.userName = document.data()
//
//                    print("\(document.documentID) => \(document.data())")
//                }
//            }
//        })
    }
    
    
    func getQuezies(completionHandler: @escaping ([Quiz]) -> ()){
        
        self.quizes.getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    var quizList: [Quiz] = []

                    for document in querySnapshot!.documents {
//                        print("\(document.documentID) => \(document.data())")
                        
                        guard let d = Helper.ParametersToData(prams: document.data() as [String : AnyObject]) else{
                            return
                        }
                        guard let quiz = Helper.dataToObject(data: d, object: Quiz.self) else{
                            return
                        }
                        quiz.QuizID = document.documentID
                        quizList.append(quiz)
                        
                    }
                    completionHandler(quizList)

                }
        }
    }
    
    func getQuestionByQuizID(_ quizID: String, completionHandler: @escaping ([Question]) -> ()){
        
        self.questions.whereField("QuizID", isEqualTo: quizID).getDocuments(){ (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                var questionList: [Question] = []
                
                for document in querySnapshot!.documents {
//                    print("\(document.documentID) => \(document.data())")
                    
                    guard let d = Helper.ParametersToData(prams: document.data() as [String : AnyObject]) else{
                        return
                    }
                    guard let question = Helper.dataToObject(data: d, object: Question.self) else{
                        return
                    }
                    question.QuizID = document.documentID
                    questionList.append(question)
                    
                }
                completionHandler(questionList)
                
            }
        }
    }

}

extension WriteBatch {
    
    /// Writes a user to the top-level users collection, overwriting data if the
    /// user's uid already exists in the collection.
    func add(user: User) {
        let document = Firestore.firestore().users.document(user.documentID)
        self.setData(user.documentData, forDocument: document)
    }
    
}

extension Auth {
    
    func logout(){
        do {
            try self.signOut()
        } catch let signOutError as NSError {
            signOutError.errorMesssage()
        }
    }
}

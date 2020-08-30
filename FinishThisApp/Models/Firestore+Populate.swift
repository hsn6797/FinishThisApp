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
    
    /// Returns a reference to the top-level leaderBoard collection.
    var leaderboards: CollectionReference {
        return self.collection("leaderBoard")
    }
    
    
}

// MARK: Write operations
extension Firestore {
    
    /// Writes a user to the top-level users collection, overwriting data if the
    /// user's uid already exists in the collection.
    func add(user: User) {
        self.users.document(user.documentID).setData(user.documentData)
    }
    
    func add(lUser: leaderUser) {
        self.leaderboards.document(lUser.leadID).setData(lUser.documentData)
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
        
    }
    
    func leaderboardExist(quizName: String, userName: String, completionHandler: @escaping (leaderUser?) -> ()){
        
        let myGroup = DispatchGroup()
        myGroup.enter()
        
        var lUser: leaderUser? = nil

        self.leaderboards.whereField("quizName", isEqualTo: quizName).whereField("userName", isEqualTo: userName).getDocuments() {(querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                return
            }
            else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    
                    guard let d = Helper.ParametersToData(prams: document.data() as [String : AnyObject]) else{
                        return
                    }
                    guard let leaderU = Helper.dataToObject(data: d, object: leaderUser.self) else{
                        return
                    }
                    leaderU.leadID = document.documentID
                    lUser = leaderU
                    break
                    
                }
            }
            myGroup.leave()
        }
        
        myGroup.notify(queue: .main) {
            print("Got from Firebase")
            completionHandler(lUser)
        }

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

    
    func getLeaderboardsQuizName(_ quizName: String, completionHandler: @escaping ([leaderUser]) -> ()){
        
        self.leaderboards.whereField("quizName", isEqualTo: quizName).getDocuments(){ (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                var leaderboards: [leaderUser] = []
                
                for document in querySnapshot!.documents {
                    //                    print("\(document.documentID) => \(document.data())")
                    
                    guard let d = Helper.ParametersToData(prams: document.data() as [String : AnyObject]) else{
                        return
                    }
                    guard let leaderboard = Helper.dataToObject(data: d, object: leaderUser.self) else{
                        return
                    }
                    leaderboard.leadID = document.documentID
                    leaderboards.append(leaderboard)
                    
                }
                completionHandler(leaderboards)
                
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

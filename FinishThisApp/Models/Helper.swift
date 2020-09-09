//
//  Helper.swift
//  MaidAndServent
//
//  Created by Hassan on 03/10/2019.
//  Copyright © 2019 Hassan. All rights reserved.
//

struct Questions {
    var QUESTION = ""
    var CORRECT_ANSWER = ""
    var WRONG_ANSWER_1 = ""
    var WRONG_ANSWER_2 = ""
    var WRONG_ANSWER_3 = ""

}



import UIKit


class Helper{
    
    static func showSimpleAlert(message: String, presentingVC: UIViewController) {
        Helper.showSimpleAlert(title: nil, message: message, presentingVC: presentingVC)
    }
    
    static func showSimpleAlert(title: String?, message: String, presentingVC: UIViewController) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        presentingVC.present(alertController, animated: true, completion: nil)
    }
   
 
    
    
    
    // throw Questions in firebase database
    static func loadJson(filename fileName: String)-> [Questions]?{
        guard let path = Bundle.main.path(forResource: fileName, ofType: "json")else{return nil }
        let url = URL(fileURLWithPath:path)
        do{
            let data = try Data(contentsOf: url)
            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            guard let array = json as? [Any] else{return nil}
            var returnarry: [Questions] = []
            for ques in array{
                guard let questdic = ques as? [String:Any] else{return nil }
                guard let ques = questdic["QUESTION"] as? String else{return nil}
                guard let cans = questdic["CORRECT_ANSWER"] as? String else{return nil}
                guard let wans1 = questdic["WRONG_ANSWER_1"] as? String else{return nil}
                guard let wasn2 = questdic["WRONG_ANSWER_2"] as? String else{return nil}
                guard let wans3 = questdic["WRONG_ANSWER_3"] as? String else{return nil}
                
                
                returnarry.append(Questions(QUESTION: ques, CORRECT_ANSWER: cans, WRONG_ANSWER_1: wans1, WRONG_ANSWER_2: wasn2, WRONG_ANSWER_3: wans3))
            }
            return returnarry
            
        }catch{
            print(error)
            return nil
            
        }
    }

    
    static func objectToData<T:Encodable>(object:T)-> Data?{
        
        var data:Data? = nil
        let encoder = JSONEncoder()
        
        do{
            encoder.outputFormatting = .prettyPrinted
//            encoder.dateEncodingStrategy =  .formatted(DateFormatter.iso8601FullDateTime)

            data = try encoder.encode(object)
            
        }catch let error{
            error.errorMesssage()
        }
        
        return data
    }
    static func dataToObject<T:Decodable>(data: Data, object: T.Type)-> T?{
        
        //printDataToJson(data: data)
        var result: T? = nil
        let decoder = JSONDecoder()
        
        do{
            result = try decoder.decode(object, from: data)
        }catch let error{
            print("Acha g: ")
            error.errorMesssage()

        }
        return result
        
    }
    
    
    
    
    
    
    static func dataToParameters(data:Data?)->[String:AnyObject]?{
        
        var parameters:[String: AnyObject]?
        
        if(data != nil){
            
            do{
                let json = try JSONSerialization.jsonObject(with: data!, options: [])
                if let prams = json as? [String: AnyObject] {
                    parameters = prams
                    
                }else{
                    print("Data parsing to Parameters fails")
                }
            }catch let error{
                error.errorMesssage()
            }
        }else{
            print("Data object is nil")
        }
        return parameters
        
    }
    
    static func ParametersToData(prams:[String:AnyObject])->Data?{
        
        if let theJSONData = try? JSONSerialization.data(
            withJSONObject: prams,
            options: []) {
            
//            let theJSONText = String(data: theJSONData,
//                                     encoding: .ascii)
//            print("JSON string = \(theJSONText!)")
            return theJSONData
        }
        return nil
    }
    
    static func printDataToJson(data: Data){
        if let returnData = String(data: data, encoding: .utf8) {
            print("\n---- Print data ----\n\(returnData)\n---- ********** ----\n")
        }
        
    }

    // MARK: - Compress Image (use when user object is send to web API)
    static func compressImage(image : UIImage) -> UIImage?
    {
        var _actualImageHeight: CGFloat = image.size.height
        var _actualImageWidth: CGFloat  = image.size.width
        let _maxHeight: CGFloat = 300.0
        let _maxWidth: CGFloat = 400.0
        var _imageRatio: CGFloat = _actualImageWidth / _actualImageHeight
        let _maxRatio: CGFloat = _maxWidth / _maxHeight
        let _imageCompressionQuality: CGFloat = 0.5 // makes the image get compressed to 50% of its actual size
        
        if _actualImageHeight > _maxHeight || _actualImageWidth > _maxWidth
        {
            if _imageRatio < _maxRatio
            {
                // Adjust thw width according to the _maxHeight
                _imageRatio = _maxHeight / _actualImageHeight
                _actualImageWidth = _imageRatio * _actualImageWidth
                _actualImageHeight = _maxHeight
            }
            else
            {
                if _imageRatio > _maxRatio
                {
                    // Adjust height according to _maxWidth
                    _imageRatio = _maxWidth / _actualImageWidth
                    _actualImageHeight = _imageRatio * _actualImageHeight
                    _actualImageWidth = _maxWidth
                }
                else
                {
                    _actualImageHeight = _maxHeight
                    _actualImageWidth = _maxWidth
                }
                
            }
        }
        let _compressedImage = CGRect(x: 0.0 , y: 0.0 ,width: _actualImageWidth ,height: _actualImageHeight)
        
//        var imageData: Data? = nil
        UIGraphicsBeginImageContext(_compressedImage.size)
        image.draw(in: _compressedImage)
        if let img = UIGraphicsGetImageFromCurrentImageContext(){
            
            guard let imageData = img.jpegData(compressionQuality: CGFloat(_imageCompressionQuality))
            else{
                print("Error: jpegData() Compression Fails")
                UIGraphicsEndImageContext()
                return nil
            }
            
            UIGraphicsEndImageContext()
            return UIImage(data: imageData)!
        }else{
            print("Error: UIGraphicsGetImageFromCurrentImageContext() Fails")
            return nil
        }
    }
    

    
} // End Helper Class


extension UIViewController {
    
    func showToast(message : String) {
        
        let toastLabel = UILabel(frame: CGRect(x:40, y: 480, width: 300, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = UIFont(name:"FontAwesome",size:15)
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
}

// MARK: - Date Time formater used in API Parameters
extension DateFormatter{
    static let iso8601Full :DateFormatter = {
        let formatter = dateFormatter(formate: "yyyy-MM-dd'T'HH:mm:ss")
        //        formatter.calendar = Calendar(identifier: .iso8601)
        //        formatter.timeZone = TimeZone(abbreviation: "UTC")
        //        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        //        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
    static let iso8601FullDateTime :DateFormatter = {

        let formatter = dateFormatter(formate: "yyyy-MM-dd'T'HH:mm:ss.SSS")
        //        formatter.calendar = Calendar(identifier: .iso8601)
        //        formatter.timeZone = TimeZone(abbreviation: "UTC")
        //        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        //        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
    static let iso8601VeryFullDateTime :DateFormatter = {
        let formatter = dateFormatter(formate: "yyyy-MM-dd'T'HH:mm:ss.SZ")
//        formatter.calendar = Calendar(identifier: .iso8601)
//        formatter.timeZone = TimeZone(abbreviation: "UTC")
//        formatter.timeZone = TimeZone(secondsFromGMT: 0)
//        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
    static func dateFormatter(formate: String)-> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = formate
        formatter.calendar = NSCalendar.current
        formatter.timeZone = TimeZone.current
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        return formatter
    }
    static let iso8601: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()
    static let iso8601noFS = ISO8601DateFormatter()
}

extension String {

    // MARK: - Formating Phone No
    func formatedPhoneNo()-> String{
        
        let countryCode = "+92"
        let code = String(self.prefix(3))
        let number = String(self.suffix(7))
        
        return "\(countryCode) \(code) \(number)"
    }
    func toIso8601FullDate()-> Date{
        
        return DateFormatter.iso8601Full.date(from: self)!
    }
    
}

extension Date {
    
    func toIso8601FullString()-> String {
        return DateFormatter.iso8601Full.string(from: self)
    }
    // MARK: - Formating Date Functions
    func formateDateTime()-> String{
        let formatter = DateFormatter()
     
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }
    
    func formateDate()-> String{
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: self)
    }
    
    func formateTime()-> String{
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }
    
    func formateSmartDateTime()-> String{
    
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        var day = ""
        if Calendar.current.isDateInToday(self){
            day = "Today at"
        }
        else if Calendar.current.isDateInYesterday(self){
            day = "Yesterday at"
        }
        else if Calendar.current.isDateInTomorrow(self) {
            day = "Tomorrow at"
        }else{
            formatter.dateStyle = .medium
        }
        
        let formate = formatter.string(from: self)
        
        return "\(day) \(formate)"
    }
    
}
extension UIStoryboard{
    
    func IVC<T:UIViewController>(vc:T)-> T?{
        var result: T? = nil

        //let sb = UIStoryboard(name: "", bundle: nil)
        
        if let popup = self.instantiateInitialViewController() as? T {
            result = popup
        }else{
            print("Error: Initial View Controller")
        }
        return result
        
    }
    
    func IIVC<T:UIViewController>(vc:T,id:String)-> T?{
        var result: T? = nil
        
        //let sb = UIStoryboard(name: "", bundle: nil)
        
        if let popup = self.instantiateViewController(withIdentifier: id) as? T {
            result = popup
        }else{
            print("Error: Instantiate initial View Controller")
        }
        return result
        
    }
 
}
extension Error {
    // MARK: - Printing Error Message
    func errorMesssage(){
        print("Error with code number: \(self._code)\nDescription: \(self.localizedDescription)")
    }
}

extension UITableView {
    func reloadData(completion: @escaping ()->()) {
        UIView.animate(withDuration: 0, animations: {self.reloadData()}){
            _ in completion()
        }

    }
}

extension DispatchQueue {
    
    static func background(delay: Double = 0.0, background: (()->Void)? = nil, completion: (() -> Void)? = nil) {
        DispatchQueue.global(qos: .background).async {
            background?()
            if let completion = completion {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                    completion()
                })
            }
        }
    }
    
}

extension UIButton {
    func changeColor(color: UIColor, text: String) {
        self.isEnabled = true
        self.setTitle(text, for: .normal)
        if color == UIColor.green{
            self.setTitleColor(UIColor.black, for: .normal)
        }else{
            self.setTitleColor(UIColor.white, for: .normal)
        }
        self.backgroundColor = color
    }
    
    func disableButton() {
        self.isEnabled = false
        self.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        self.setTitleColor(UIColor.black, for: .disabled)
    }
    
    func resetButton() {
        self.isEnabled = true
        self.setTitleColor(UIColor.white, for: .normal)
        self.backgroundColor = #colorLiteral(red: 0.2470588235, green: 0.2705882353, blue: 0.3490196078, alpha: 1)
    }
   
}

extension UIRefreshControl {
    
    func refreshMe(sender:UITableViewController? = nil,selector:Selector){
        
        self.attributedTitle = NSAttributedString(string: "")
        self.addTarget(sender, action: selector, for: UIControl.Event.valueChanged)
        sender?.refreshControl = self
    }
}

extension Sequence {
    func group<U: Hashable>(by key: (Iterator.Element) -> U) -> [U:[Iterator.Element]] {
        return Dictionary.init(grouping: self, by: key)
    }
    

    
    
    
    
    
// <<<<<<<___________----------------_____________------------_____________------------>>>>
    
    
    // Fetch Json File and save to struct

//    guard let returnarry = Helper.loadJson(filename: "FTA_Questions")else{
//    return
//    }
//    var ref: DocumentReference? = nil
//    for data in returnarry{
//    
//    ref = Firestore.firestore().collection("Questions").addDocument(data: [
//    "Question": data.QUESTION,
//    "correctAns": data.CORRECT_ANSWER,
//    "wrongAns1": data.WRONG_ANSWER_1,
//    "wrongAns2": data.WRONG_ANSWER_2,
//    "wrongAns3": data.WRONG_ANSWER_3,
//    "QuizID": "T30fiSO1FoyMHrfkYgAB"
//    
//    ]) { err in
//    if let err = err {
//    print("Error adding document: \(err)")
//    } else {
//    print("Document added with ID: \(ref!.documentID)")
//    }
//    }
//    
//    }
    
// <<<<<<<___________----------------_____________------------_____________------------>>>>
    
    
    
    
    
    
}


// --------------------------------------------------- //

//// Date Time Decoding Work
//protocol HasDateFormatter {
//    static var dateFormatter: DateFormatter { get }
//}

//struct CustomDate<E:HasDateFormatter>: Codable {
//
//    let value: Date
//    init(from decoder: Decoder) throws {
//        let container = try decoder.singleValueContainer()
//        let text = try container.decode(String.self)
//        guard let date = E.dateFormatter.date(from: text) else {
//            throw CustomDateError.general
//        }
//        self.value = date
//    }
//    enum CustomDateError: Error {
//        case general
//    }
//
//}
//
//struct FullDate: HasDateFormatter {
//    static var dateFormatter: DateFormatter {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
//        formatter.calendar = Calendar(identifier: .iso8601)
//        formatter.timeZone = TimeZone(secondsFromGMT: 0)
//        formatter.locale = Locale(identifier: "en_US_POSIX")
//        return formatter
//    }
//}
//struct SmallDate: HasDateFormatter {
//    static var dateFormatter: DateFormatter {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
//        formatter.calendar = Calendar(identifier: .iso8601)
//        formatter.timeZone = TimeZone(secondsFromGMT: 0)
//        formatter.locale = Locale(identifier: "en_US_POSIX")
//        return formatter
//    }
//}

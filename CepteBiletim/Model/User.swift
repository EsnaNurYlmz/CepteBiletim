//
//  User.swift
//  CepteBiletim
//
//  Created by Esna nur Yılmaz on 29.05.2025.
//

import Foundation
class User : Codable {
   
    var userID : String?
    var userName : String?
    var userSurname : String?
    var userEmail : String?
    var userPassword : String?
    var countryCode : String?
    var userPhoneNumber : String?
    var userGender : String?
    var userBirthDate : Date?
    
    init(){
    }
    
    init(userID: String, userName: String , userSurname: String , userEmail: String , userPassword: String , countryCode : String, userPhoneNumber: String , userGender: String , userBirthDate: Date ) {
        self.userID = userID
        self.userName = userName
        self.userSurname = userSurname
        self.userEmail = userEmail
        self.userPassword = userPassword
        self.countryCode = countryCode
        self.userPhoneNumber = userPhoneNumber
        self.userGender = userGender
        self.userBirthDate = userBirthDate
    }
}

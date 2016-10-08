//
//  UserMain.swift
//  MySampleApp
//
//
// Copyright 2016 Amazon.com, Inc. or its affiliates (Amazon). All Rights Reserved.
//
// Code generated by AWS Mobile Hub. Amazon gives unlimited permission to 
// copy, distribute and modify it.
//
// Source code generated from template: aws-my-sample-app-ios-swift v0.4
//

import Foundation
import UIKit
import AWSDynamoDB

class UserMain: AWSDynamoDBObjectModel, AWSDynamoDBModeling {
    
    var _userId: String?
    var _userIDInt: NSNumber?
    var _email: String?
    var _firstName: String?
    var _lastName: String?
    var _student: NSNumber?
    var _tutor: NSNumber?
    var _universityID: NSNumber?
    
    class func dynamoDBTableName() -> String {

        return "tutortonight-mobilehub-1959870186-user_main"
    }
    
    class func hashKeyAttribute() -> String {

        return "_userId"
    }
    
    class func rangeKeyAttribute() -> String {

        return "_userIDInt"
    }
    
    override class func JSONKeyPathsByPropertyKey() -> [NSObject : AnyObject] {
        return [
               "_userId" : "userId",
               "_userIDInt" : "userID_int",
               "_email" : "email",
               "_firstName" : "firstName",
               "_lastName" : "lastName",
               "_student" : "student",
               "_tutor" : "tutor",
               "_universityID" : "universityID",
        ]
    }
}

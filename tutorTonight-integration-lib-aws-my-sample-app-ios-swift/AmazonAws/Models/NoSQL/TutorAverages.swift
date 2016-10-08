//
//  TutorAverages.swift
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

class TutorAverages: AWSDynamoDBObjectModel, AWSDynamoDBModeling {
    
    var _userId: String?
    var _averageGrade: String?
    var _courseLevelID: NSNumber?
    
    class func dynamoDBTableName() -> String {

        return "tutortonight-mobilehub-1959870186-tutor_averages"
    }
    
    class func hashKeyAttribute() -> String {

        return "_userId"
    }
    
    override class func JSONKeyPathsByPropertyKey() -> [NSObject : AnyObject] {
        return [
               "_userId" : "userId",
               "_averageGrade" : "averageGrade",
               "_courseLevelID" : "courseLevelID",
        ]
    }
}

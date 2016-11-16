//
//  LessonArray.swift
//  MySampleApp
//
//  
//
//

import Foundation



class LessonData {
    
    
    
    var Stars = ""
    var Price = ""
    var UserName = ""
    var CourseName = ""
    var Date = ""
    var FromTime = ""
    var ToTime = ""
    
    
    
    init(Stars: String, Price: String, UserName: String, CourseName: String, Date: String, FromTime: String, ToTime: String) {
        
        self.Stars = Stars
        self.Price = Price
        self.UserName = UserName
        self.CourseName = CourseName
        self.Date = Date
        self.FromTime = FromTime
        self.ToTime = ToTime

        
        
    }
    
}

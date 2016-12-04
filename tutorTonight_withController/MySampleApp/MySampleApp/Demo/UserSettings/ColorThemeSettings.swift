//
//  ColorThemeSettings.swift
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
import AWSCore
import AWSCognito

let ColorThemeSettingsTitleTextColorKey = "title_text_color"
let ColorThemeSettingsTitleBarColorKey = "title_bar_color"
let ColorThemeSettingsBackgroundColorKey = "background_color"

let ColorThemeSettingsDefaultTitleTextColor: Int32 = Int32(bitPattern: 0xFFFFFFFF)
//let ColorThemeSettingsDefaultTitleBarColor: Int32 = Int32(bitPattern: 0xFFF58535)
let ColorThemeSettingsDefaultTitleBarColor: Int32 = Int32(bitPattern: 0x000000)
let ColorThemeSettingsDefaultBackgroundColor: Int32 = Int32(bitPattern: 0xFFFFFFFF)

class ColorThemeSettings {
    
    var theme: Theme
    static let sharedInstance: ColorThemeSettings = ColorThemeSettings()

    private init() {
        theme = Theme()
    }
    
    // MARK: - User Settings Functions
    
    func loadSettings(completionBlock: (ColorThemeSettings?, NSError?) -> Void) {
        let syncClient: AWSCognito = AWSCognito.defaultCognito()
        let userSettings: AWSCognitoDataset = syncClient.openOrCreateDataset("user_settings")
        
        userSettings.synchronize().continueWithExceptionCheckingBlock({(result: AnyObject?, error: NSError?) -> Void in
            if let error = error {
                 print("loadSettings error: \(error.localizedDescription)")
                completionBlock(nil, error)
                return
            }
            let titleTextColorString: String? = userSettings.stringForKey(ColorThemeSettingsTitleTextColorKey)
            let titleBarColorString: String? = userSettings.stringForKey(ColorThemeSettingsTitleBarColorKey)
            let backgroundColorString: String? = userSettings.stringForKey(ColorThemeSettingsBackgroundColorKey)
            
            if let titleTextColorString = titleTextColorString,
                titleBarColorString = titleBarColorString,
                backgroundColorString = backgroundColorString {
                    self.theme = Theme(titleTextColor: titleTextColorString.toInt32(),
                        withTitleBarColor: titleBarColorString.toInt32(),
                        withBackgroundColor: backgroundColorString.toInt32())
            } else {
                self.theme = Theme()
            }
            completionBlock(self, error)
        })
    }
    
    func saveSettings(completionBlock: ((ColorThemeSettings?, NSError?) -> Void)?) {
        let syncClient: AWSCognito = AWSCognito.defaultCognito()
        let userSettings: AWSCognitoDataset = syncClient.openOrCreateDataset("user_settings")
        userSettings.setString("\(theme.titleTextColor)", forKey: ColorThemeSettingsTitleTextColorKey)
        userSettings.setString("\(theme.titleBarColor)", forKey: ColorThemeSettingsTitleBarColorKey)
        userSettings.setString("\(theme.backgroundColor)", forKey: ColorThemeSettingsBackgroundColorKey)
        userSettings.synchronize().continueWithExceptionCheckingBlock({(result: AnyObject?, error: NSError?) -> Void in
            if let error = error {
                 print("saveSettings AWS task error: \(error.localizedDescription)")
            }
            if let completionBlock = completionBlock{
                completionBlock(self, error)
            }
        })
    }
    
    func wipe() {
        AWSCognito.defaultCognito().wipe()
    }
}


class Theme: NSObject {
    
    private(set) var titleTextColor: Int32
    private(set) var titleBarColor: Int32
    private(set) var backgroundColor: Int32
    
    override init() {
        titleTextColor = ColorThemeSettingsDefaultTitleTextColor
        titleBarColor = ColorThemeSettingsDefaultTitleBarColor
        backgroundColor = ColorThemeSettingsDefaultBackgroundColor
        super.init()
    }
    
    init(titleTextColor: Int32, withTitleBarColor titleBarColor: Int32, withBackgroundColor backgroundColor: Int32) {
        self.titleTextColor = titleTextColor
        self.titleBarColor = titleBarColor
        self.backgroundColor = backgroundColor
        super.init()
    }
}

// MARK: - Utility

extension Int32 {
    public func UIColorFromARGB() -> UIColor {
        let argbValue: Int64 = Int64(self)
        let divider: Float = 255.0
        
        return UIColor(red: CGFloat((Float((argbValue & 0x00FF0000) >> 16)) / divider),
            green: CGFloat((Float((argbValue & 0x0000FF00) >> 8)) / divider),
            blue: CGFloat((Float((argbValue & 0x000000FF) >> 0)) / divider),
            alpha: CGFloat((Float((argbValue & 0xFF000000) >> 24)) / divider))
    }
}

extension String {
    public func toInt32() -> Int32 {
        return Int32(self)!
    }
}

extension AWSTask {
    public func continueWithExceptionCheckingBlock(completionBlock:(result: AnyObject?, error: NSError?) -> Void) {
        self.continueWithBlock({(task: AWSTask) -> AnyObject? in
            if let exception = task.exception {
                print("Fatal exception: \(exception)")
                kill(getpid(), SIGKILL);
            }
            let result: AnyObject? = task.result
            let error: NSError? = task.error
            completionBlock(result: result, error: error)
            return nil
        })
        
    }
}

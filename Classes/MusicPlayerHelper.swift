//
//  MusicPlayerHelper.swift
//  ADMusicPlayerBanner
//
//  Created by Aniruddha Das on 2/21/17.
//  Copyright © 2017 Aniruddha Das. All rights reserved.
//
import Foundation

import Gloss

public struct Properties: Decodable {
    
    public let playerBackgroundColor: String?
    public let playerAlpha: CGFloat?
    public let musicTitleColor: String?
    public let tableViewBackgroundColor: String?
    public let tableViewCellBackgroundColor: String?
    public let tableViewCellLabelSelectedColor: String?
    public let tableViewCellLabelColor: String?
    public let timerLabelColor: String?
    
    public init?(json: JSON) {
        self.playerBackgroundColor = "playerBackgroundColor" <~~ json
        self.playerAlpha = "playerAlpha" <~~ json
        self.musicTitleColor = "musicTitleColor" <~~ json
        self.tableViewBackgroundColor = "tableViewBackgroundColor" <~~ json
        self.tableViewCellBackgroundColor = "tableViewCellBackgroundColor" <~~ json
        self.tableViewCellLabelColor = "tableViewCellLabelColor" <~~ json
        self.tableViewCellLabelSelectedColor = "tableViewCellLabelSelectedColor" <~~ json
        self.timerLabelColor = "timerLabelColor" <~~ json

    }
    
    public func toJSON() -> JSON? {
        return jsonify([
            "playerBackgroundColor" ~~> self.playerBackgroundColor,
            "playerAlpha" ~~> self.playerAlpha,
            "musicTitleColor" ~~> self.musicTitleColor,
            "tableViewBackgroundColor" ~~> self.tableViewBackgroundColor,
            "tableViewCellBackgroundColor" ~~> self.tableViewCellBackgroundColor,
            "tableViewCellLabelColor" ~~> self.tableViewCellLabelColor,
            "tableViewCellLabelSelectedColor" ~~> self.tableViewCellLabelSelectedColor,
            "timerLabelColor" ~~> self.timerLabelColor
            ])
    }
}

public struct Icons: Decodable {
    
    public let pauseImageName: String?
    public let playImageName: String?
    public let prevImageName: String?
    public let nextImageName: String?
    public let cancelImageName: String?
    public let downImageName: String?
    public let placeholderImgString: String?
    
    public init?(json: JSON) {
        self.pauseImageName = "pauseImageName" <~~ json
        self.playImageName = "playImageName" <~~ json
        self.prevImageName = "prevImageName" <~~ json
        self.nextImageName = "nextImageName" <~~ json
        self.cancelImageName = "cancelImageName" <~~ json
        self.downImageName = "downImageName" <~~ json
        self.placeholderImgString = "placeholderImgString" <~~ json
        
    }
    
    public func toJSON() -> JSON? {
        return jsonify([
            "pauseImageName" ~~> self.pauseImageName,
            "playImageName" ~~> self.playImageName,
            "prevImageName" ~~> self.prevImageName,
            "nextImageName" ~~> self.nextImageName,
            "cancelImageName" ~~> self.cancelImageName,
            "downImageName" ~~> self.downImageName,
            "placeholderImgString" ~~> self.placeholderImgString
            ])
    }
}

public struct MusicPlayerConfig: Decodable {
    
    public let properties : Properties?
    public let icons: Icons?
    
    public init?(json: JSON) {
        self.properties = "properties" <~~ json
        self.icons = "icons" <~~ json
    }
    
    public func toJSON() -> JSON? {
        return jsonify([
            "properties" ~~> self.properties,
            "icons" ~~> self.icons
            ])
    }
    
}


public struct Server {
    
    //Map the json object with Swift class with Gloss
    public static func mapJSON(_ resultDictionary: [String: AnyObject]) -> MusicPlayerConfig {
        let config = MusicPlayerConfig(json: resultDictionary)
        return config!
    }
    
    public static func getJSONData(fileName: String, fileType: String) -> AnyObject {
        // a string which will hold path of file named `Player.json`
        let str: String? = Bundle.main.path(forResource: fileName, ofType: fileType)
        
        // load file
        let data: NSData? = NSData(contentsOfFile: str!)
        
        // try to parse the data in form of json
        do {
            // if json-data parsed
            let jsonData = try JSONSerialization.jsonObject(with: data! as Data,
                                                            options: JSONSerialization.ReadingOptions.allowFragments)
            
            if let dictionary = jsonData as? [String: AnyObject] {
                //Do what you want with the JSON Dictionary
                //print(dictionary)
                return self.mapJSON(dictionary) as AnyObject
                
            } else if let array = jsonData as? [AnyObject] {
                //Do what you want with the JSON Dictionary
                //print(array)
                return NSError()
            } else {
                //print("Error in JSON Parsing")
                return NSError()
            }
            
        } catch {
            // handle exception. Here, I'm just logging the error
            //print(error)
            return NSError()
        }
    }
}

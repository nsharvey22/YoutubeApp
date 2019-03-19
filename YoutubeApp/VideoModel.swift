//
//  VideoModel.swift
//  YoutubeApp
//
//  Created by Nick Harvey on 1/26/19.
//  Copyright © 2019 Nick Harvey. All rights reserved.
//

import UIKit
import Alamofire

protocol VideoModelDelegate {
    func dataReady()
    func moreDataReady()
}

class VideoModel: NSObject {
    
    let API_KEY = "AIzaSyAMCjrj2uyQTze0nq6kXVJrcParvCUnMMQ"
    let PLAYLIST_ID = ""
    //UUAW-NpUFkMyCNrvRSSGIvDQ
    var videoArray = [Video]()
    var moreVideoArray = [Video]()
    var nextToken:String = ""
    
    var totalResults: Int = 0
    
    var delegate:VideoModelDelegate?
    
    func getFeedVideos(PLAYLIST_ID: String, nextToken: String) {

        //Fetch the videos dynamically through the Youttube Data API
        // TODO - set maxresults as parameter so app can display more than 5 videos
        Alamofire.request("https://www.googleapis.com/youtube/v3/playlistItems", method: .get, parameters: ["part":"snippet", "playlistId":PLAYLIST_ID, "key":API_KEY, "maxResults": 10, "pageToken": nextToken], encoding: URLEncoding.default, headers: nil)

            .responseJSON { (response) -> Void in

                guard let data = response.data else {return}
                do {
                    
                    
                    let decoded = try JSONDecoder().decode(NextToken.self, from: data)

                    //Now access the data
                    print("nextpagetoken")
                    print(decoded.nextPageToken) // 25
 
                 //   self.totalResults = decoded.pageInfo["totalResults"]!
                    self.nextToken = decoded.nextPageToken
                    
                    
                } catch {
                    debugPrint("\(error)")
                    
                }
                
                do {
                    
                    
                    let decoded = try JSONDecoder().decode(PageInfo.self, from: data)
                    
                    //Now access the data
                    print("pageInfo")
                    print(decoded.pageInfo) // 25
                    
                    self.totalResults = decoded.pageInfo["totalResults"]!
   
                    
                    
                } catch {
                    debugPrint("\(error)")
                    
                }

    
                if let JSON = response.result.value {
                    print(JSON)
                    var arrayOfVideos = [Video]()
                    
                    if let dictionary = JSON as? [String:Any] {
                        
                        for item in dictionary["items"] as! NSArray {
                            // Create video objects off fo the JSON response
                            let videoObj = Video()
                            videoObj.videoId = (item as AnyObject).value(forKeyPath: "snippet.resourceId.videoId") as? String ?? ""
                            videoObj.videoTitle = (item as AnyObject).value(forKeyPath: "snippet.title") as? String ?? ""
                            videoObj.videoDescription = (item as AnyObject).value(forKeyPath: "snippet.description") as? String ?? ""
                            videoObj.videoThumbnailUrl = (item as AnyObject).value(forKeyPath: "snippet.thumbnails.high.url") as? String ?? ""
                            
                            arrayOfVideos.append(videoObj)
                            
                        }
                        
                        // When all the video objects have been constructed, assign the array to the VideoModel property
                        self.videoArray = arrayOfVideos
                        print("got new vids stored")
                        // Notify the delegate that the data is ready
                        if self.delegate != nil {
                            print("delegate notified")
                            print(self.videoArray)
                            self.delegate?.dataReady()
                        }
            }
        }
        
    }
        

        
        struct NextToken: Decodable {
            var nextPageToken = ""
        }
        
        struct PageInfo: Decodable {
            var pageInfo = ["key": 0]
        }


    }
    
    func getMoreVideos(PLAYLIST_ID: String, nextToken: String) {
        
        //Fetch the videos dynamically through the Youttube Data API
        // TODO - set maxresults as parameter so app can display more than 5 videos
        Alamofire.request("https://www.googleapis.com/youtube/v3/playlistItems", method: .get, parameters: ["part":"snippet", "playlistId":PLAYLIST_ID, "key":API_KEY, "maxResults": 10, "pageToken": nextToken], encoding: URLEncoding.default, headers: nil)
            
            .responseJSON { (response) -> Void in
                guard let data = response.data else {return}
                do {
                    
                    
                    let decoded = try JSONDecoder().decode(Result.self, from: data)
                    
                    //Now access the data
                    print(decoded.nextPageToken) // 25
                    self.nextToken = decoded.nextPageToken
                    self.totalResults = decoded.pageInfo["totalResults"]!
                    
                    
                } catch {
                    debugPrint("\(error.localizedDescription)")
                }
                
                if let JSON = response.result.value {
                    
                    
                    var arrayOfVideos = [Video]()
                    
                    if let dictionary = JSON as? [String:Any] {
                        
                        for item in dictionary["items"] as! NSArray {
                            // Create video objects off fo the JSON response
                            let videoObj = Video()
                            videoObj.videoId = (item as AnyObject).value(forKeyPath: "snippet.resourceId.videoId") as? String ?? ""
                            videoObj.videoTitle = (item as AnyObject).value(forKeyPath: "snippet.title") as? String ?? ""
                            videoObj.videoDescription = (item as AnyObject).value(forKeyPath: "snippet.description") as? String ?? ""
                            videoObj.videoThumbnailUrl = (item as AnyObject).value(forKeyPath: "snippet.thumbnails.high.url") as? String ?? ""
                            
                            arrayOfVideos.append(videoObj)
                            
                        }
                        
                        // When all the video objects have been constructed, assign the array to the VideoModel property
                        self.videoArray = arrayOfVideos
                        
                        // Notify the delegate that the data is ready
                        if self.delegate != nil {
                            self.delegate?.moreDataReady()
                        }
                    }
                }
        }
        
        
        
        struct Result: Decodable {
            var nextPageToken = ""
            //var totalResults = 0
            var pageInfo = ["key": 0]
        }
        
        
    }
}


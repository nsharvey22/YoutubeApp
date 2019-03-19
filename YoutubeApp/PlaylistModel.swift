//
//  PlaylistModel.swift
//  YoutubeApp
//
//  Created by Nick Harvey on 1/27/19.
//  Copyright © 2019 Nick Harvey. All rights reserved.
//

import UIKit
import Alamofire

protocol PlaylistModelDelegate {
    func playlistDataReady()
}

class PlaylistModel: NSObject {
    
    let API_KEY = "AIzaSyAMCjrj2uyQTze0nq6kXVJrcParvCUnMMQ"
    let CHANNEL_ID = "UCAW-NpUFkMyCNrvRSSGIvDQ"
    //UUAW-NpUFkMyCNrvRSSGIvDQ
    var playlistArray = [Playlist]()
    
    var delegate:PlaylistModelDelegate?
    
    func getPlaylists() {

        //Fetch the playlists dynamically through the Youttube Data API

        Alamofire.request("https://www.googleapis.com/youtube/v3/playlists", method: .get, parameters: ["part":"snippet, id", "channelId":CHANNEL_ID, "maxResults": 50, "key":API_KEY], encoding: URLEncoding.default, headers: nil)
            
            .responseJSON { (response) -> Void in
                //print(response)
                if let JSON = response.result.value {
                    
                    var arrayOfPlaylists = [Playlist]()
                    
                    if let dictionary = JSON as? [String:Any] {

                        for item in dictionary["items"] as! NSArray {
                            // Create playlist objects off fo the JSON response
                            let playlistObj = Playlist()
                            playlistObj.playlistId = (item as AnyObject).value(forKeyPath: "id") as! String
                           // print(playlistObj.playlistId)
                            playlistObj.playlistTitle = (item as AnyObject).value(forKeyPath: "snippet.title") as! String
                           // print(playlistObj.playlistTitle)

                            arrayOfPlaylists.append(playlistObj)

                        }
                        let playlistObj = Playlist()
                        playlistObj.playlistId = "UUAW-NpUFkMyCNrvRSSGIvDQ"
                        playlistObj.playlistTitle = "Most Recent Videos"
                        arrayOfPlaylists.insert(playlistObj, at: 0)
                        // When all the video objects have been constructed, assign the array to the VideoModel property
                        self.playlistArray = arrayOfPlaylists

                        // Notify the delegate that the data is ready
                        if self.delegate != nil {
                            self.delegate!.playlistDataReady()
                        }
                    }
                }
        }

}

}

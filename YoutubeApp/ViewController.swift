//
//  ViewController.swift
//  YoutubeApp
//
//  Created by Nick Harvey on 1/26/19.
//  Copyright © 2019 Nick Harvey. All rights reserved.
//

import UIKit
import SideMenu
import GoogleMobileAds


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, VideoModelDelegate, MenuTableViewControllerDelegate, GADBannerViewDelegate {


    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var menuButton: UIButton!
    var videos:[Video] = [Video]()
    var moreVideos:[Video] = [Video]()
    var token:String = ""
    var totalResults:Int = 0
    var selectedVideo:Video?
    let model:VideoModel = VideoModel()
    let model2:MenuTableViewController = MenuTableViewController()
    let MOST_RECENT_VIDS = "UUAW-NpUFkMyCNrvRSSGIvDQ"
    var selectedPlaylist:Playlist?
    var fetchingMore = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
       // setupNavigationBarItems()

        //self.videos = VideoModel().getVedeos()
        self.model.delegate = self
        self.model2.delegate = self
        
        // Fire off request to get videos
        if let playlist = selectedPlaylist {
            title = playlist.playlistTitle
            model.getFeedVideos(PLAYLIST_ID: playlist.playlistId, nextToken: token)

        } else {
            title = "Most Recent Videos"
            model.getFeedVideos(PLAYLIST_ID: MOST_RECENT_VIDS, nextToken: token)

        }
      
        
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
        
        // Define the menus
        let menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as! UISideMenuNavigationController
        SideMenuManager.default.menuLeftNavigationController = menuLeftNavigationController
        
        
        // (Optional) Enable gestures. The left and/or right menus must be set up above for these to work.
        // Note that these continue to work on the Navigation Controller independent of the view controller it displays!
        //SideMenuManager.default.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        //SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        
        // (Optional) Prevent status bar area from turning black when menu appears:
        SideMenuManager.default.menuFadeStatusBar = false
        SideMenuManager.default.menuPresentMode = .menuSlideIn
        SideMenuManager.default.menuAnimationOptions = .curveEaseInOut
        SideMenuManager.default.menuBlurEffectStyle = UIBlurEffect.Style.dark
        
        bannerView.adUnitID = "ca-app-pub-7701577602240298/1260977523"
        
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
        bannerView.delegate = self
        
    }
    
    /// Tells the delegate an ad request loaded an ad.
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("adViewDidReceiveAd")
    }
    /// Tells the delegate an ad request failed.
    func adView(_ bannerView: GADBannerView,
                didFailToReceiveAdWithError error: GADRequestError) {
        print("adView:didFailToReceiveAdWithError: \(error)")
    }
 

    override func viewDidAppear(_ animated: Bool) {
        fetchingMore = false
        print(" fetingmore is now false")

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Don't forget to reset when view is being removed
        AppDelegate.AppUtility.lockOrientation(.all)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        AppDelegate.AppUtility.lockOrientation(.portrait)
        // Or to rotate and lock
        // AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
        
        if (self.tableView.numberOfRows(inSection: 0) == 0) {
            tableView.separatorStyle = .none
        }
    }
    
    
    func dataReady() {
        print("data is now ready")
        
        // Access the video objects that have been downloaded
        self.videos = self.model.videoArray
        self.token = self.model.nextToken
        self.totalResults = self.model.totalResults
 
        // Tell the tableview to reload
        self.tableView.reloadData()

    }
    
    func moreDataReady() {
        
        // Access the video objects that have been downloaded
        self.moreVideos = self.model.videoArray
        self.totalResults = self.model.totalResults
        self.token = self.model.nextToken
        print("""
        



        
        """)
        print("videos count: ", self.videos.count)
        print("totalResults: ", self.totalResults)
        if self.videos.count < self.totalResults {
            self.videos.append(contentsOf: self.moreVideos)
//            if let visibleIndexPaths = self.tableView.indexPathsForVisibleRows as? [NSIndexPath] {
//                self.tableView.reloadRows(at: visibleIndexPaths as [IndexPath], with: UITableView.RowAnimation.automatic)
//            }
            let offset = self.tableView.contentOffset.y
            self.tableView.reloadData()
            self.tableView.contentOffset.y = offset

        }
//        self.videos.append(contentsOf: self.moreVideos)
//        self.tableView.reloadData()
        
        // Tell the tableview to reload
        //tableView.reloadRows(at: [lastCell], with: .fade)

        
    }
    
    
    // Mark: 
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        // Get the width of the screen to calculate the height of the row
        return (self.view.frame.size.width / 320) * 180
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return videos.count
        
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        if(velocity.y>0) {
            //Code will work without the animation block.I am using animation block incase if you want to set any delay to it.
            UIView.animate(withDuration: 2.5, delay: 0, options: UIView.AnimationOptions(), animations: {
                self.navigationController?.setNavigationBarHidden(true, animated: true)
               // self.navigationController?.setToolbarHidden(true, animated: true)
                print("Hide")
            }, completion: nil)
            
        } else {
            UIView.animate(withDuration: 2.5, delay: 0, options: UIView.AnimationOptions(), animations: {
                self.navigationController?.setNavigationBarHidden(false, animated: true)
              //  self.navigationController?.setToolbarHidden(false, animated: true)
                print("Unhide")
            }, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasicCell")!
        let image = cell.viewWithTag(1) as! UIImageView
        
        image.image = UIImage(named: "defaultCell")
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.frame = cell.bounds
        cell.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        let videoTitle = videos[indexPath.row].videoTitle
        
        // Get the label for the cell
        let label = cell.viewWithTag(2) as! UILabel
        label.text = videoTitle
        
        // Consturct the video thumbnail url
        let videoThumbnailUrlString = videos[indexPath.row].videoThumbnailUrl
        
        // Creat an NSURL object
        let videoThumbnailUrl = URL(string: videoThumbnailUrlString)
        
        if videoThumbnailUrl != nil {
            // Create an NSURLRequest object
            let request = URLRequest(url: videoThumbnailUrl!)
            
            // Create an NSURLSession
            let configuration = URLSessionConfiguration.default
            let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
            
            // Create a datatask and pass in the request
            let task = session.dataTask(with: request){(data,response,error) in
                
                if(error != nil) {
                    print("Error on dataTask")
                }
                else {
                    // Move to a background thread to do some long running work
                    DispatchQueue.global(qos: .userInitiated).async {
                        let imageView = cell.viewWithTag(1) as! UIImageView
                        // Bounce back to the main thread to update the UI
                        
                        DispatchQueue.main.async {
                            activityIndicator.stopAnimating()
                            activityIndicator.removeFromSuperview()
                            imageView.image = UIImage(data: data!)
                        }
                    }
                }
            }
            task.resume()
        }
    
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Take note of which video the user selected
        self.selectedVideo = self.videos[indexPath.row]
        
        // Call the segue
        self.performSegue(withIdentifier: "goToDetail", sender: self)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(0), execute: {
            // Put your code which should be executed with a delay here
            if !self.fetchingMore && indexPath.row == self.videos.count - 1 {
                print("Reached bottom ")
                // Reached last cell in videos array
                // if videos.count < 30 {
                // append more videos to the list of showed videos
                // model.getFeedVideos(PLAYLIST_ID: MOST_RECENT_VIDS, nextToken: self.token)
                self.fetchMoreVideos()
                // }
            }
        })
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = tableView.contentOffset.y
        let contentHeight = tableView.contentSize.height
        print("offsetY: \(offsetY) | contententHeight: \(contentHeight)")

        if offsetY > contentHeight - scrollView.frame.height {
            if !fetchingMore {
               // fetchMoreVideos()
            }
        }
    }
    
    func fetchMoreVideos() {
        fetchingMore = true
 
        if let playlist = selectedPlaylist {
            print(" ")
            print("fetch more videos")
            print(" ")
            
            model.getMoreVideos(PLAYLIST_ID: playlist.playlistId, nextToken: self.token)

        } else {
            
            model.getMoreVideos(PLAYLIST_ID: MOST_RECENT_VIDS, nextToken: token)
            
        }
        fetchingMore = false

    }
    
    func doSomethingWith(data: Playlist) {
        
        self.selectedPlaylist = data
        print("new Playlist: ",data)
       // self.model.delegate = self
        self.token = ""
        
        if let playlist = selectedPlaylist {
            title = selectedPlaylist?.playlistTitle
            model.getFeedVideos(PLAYLIST_ID: playlist.playlistId, nextToken: token)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                self.tableView.scrollToRow(at: [0,0], at: .top, animated: true)
            })
            
        }
        
    }
    

    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToDetail" {
            
            //Get a reference to the destination view controller
            let detailViewController = segue.destination as! VideoDetailViewController
            
            // Set the selected video property of the destination view controller
            detailViewController.selectedVideo = self.selectedVideo
            
        }
        
        if(segue.identifier == "InputVCToDisplayVC"){
            let displayVC = segue.destination as! MenuTableViewController
            displayVC.delegate = self
        }
    
    }

}


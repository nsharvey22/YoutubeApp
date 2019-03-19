//
//  MenuTableViewController.swift
//  YoutubeApp
//
//  Created by Nick Harvey on 1/27/19.
//  Copyright © 2019 Nick Harvey. All rights reserved.
//

import UIKit

protocol MenuTableViewControllerDelegate : NSObjectProtocol{
    func doSomethingWith(data: Playlist)
}


class MenuTableViewController: UITableViewController, PlaylistModelDelegate {
    
    func playlistDataReady() {
        // Access the video objects that have been downloaded
        self.playlists = self.model.playlistArray
        
        // Tell th etableview to reload
        self.tableView.reloadData()
    }
    
    weak var delegate : MenuTableViewControllerDelegate?
    
    var playlists:[Playlist] = [Playlist]()
    var selectedPlaylist:Playlist?
    let model:PlaylistModel = PlaylistModel()

    var pickedCell:Playlist?
    
    var testValue: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        title = "Ninja's Playlists"
        
        self.model.delegate = self as? PlaylistModelDelegate
        // Fire off request to get videos
        model.getPlaylists()

        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (self.tableView.numberOfRows(inSection: 0) == 0) {
            tableView.separatorStyle = .none
        }
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return playlists.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasicCell")!
        
        let playlistTitle = playlists[indexPath.row].playlistTitle
        
        // Get the label for the cell
        let label = cell.viewWithTag(1) as! UILabel
        label.text = playlistTitle
        
        return cell
    }
    
    

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        // Take note of which video the user selected
        self.selectedPlaylist = self.playlists[indexPath.row]

        let viewController = UIApplication.shared.windows[0].rootViewController?.children[0] as! ViewController
        print(" I just selected this playlist: ", self.selectedPlaylist!.playlistId)
        viewController.doSomethingWith(data: self.selectedPlaylist!)
        //self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
        // Call the segue
        //self.performSegue(withIdentifier: "goToSelectedPL", sender: self)
        
    }
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
       // if segue.identifier == "goToSelectedPL" {
            
            //Get a reference to the destination view controller
            let nextViewController = segue.destination as! ViewController
        print("preparing fo rsegue")
            
            // Set the selected video property of the destination view controller
            nextViewController.selectedPlaylist = self.selectedPlaylist
            
        //}
        
    }
    

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

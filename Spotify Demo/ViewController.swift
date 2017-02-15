//
//  ViewController.swift
//  Spotify Demo
//
//  Created by Henry Aguinaga on 2016-12-25.
//  Copyright © 2016 Henry Aguinaga. All rights reserved.
//

import UIKit
import Alamofire
import AVFoundation

var player = AVAudioPlayer()

struct post {
    let mainImage : UIImage!
    let name : String!
    let previewURL : String!
}

class TableViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchbar: UISearchBar!
    
    var searchUrl = String()
    typealias JSONStandard = [String : AnyObject]
    var posts = [post]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
    }
    
    func callAlamo(url: String) {
        
        Alamofire.request(url).responseJSON(completionHandler: {
            response in
            
            self.parseData(JSONData: response.data!)
            
        })
        
    
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let keywords = searchbar.text
        let finalKeywords = keywords?.replacingOccurrences(of: " ", with: "+")
        
        searchUrl = "https://api.spotify.com/v1/search?q=\(finalKeywords!)&type=track"
        
        callAlamo(url: searchUrl)
        
        self.view.endEditing(true)
    }
    func parseData(JSONData: Data) {
        
        do {
            var readableJSON = try JSONSerialization.jsonObject(with: JSONData, options: .mutableContainers) as! JSONStandard
            
            if let tracks = readableJSON["tracks"] as? JSONStandard {
            
                if let items = tracks["items"]  as? [JSONStandard] {
                    
                    //let numOfItems = items.count
                    
                    for i in 0..<items.count {
                        let item = items[i]
                        //print(item)
                        
                        let name = item["name"] as! String
                        let previewURl = item["preview_url"] as! String
                        
                        
                        
                        
                        if let album = item["album"] as? JSONStandard {
                        
                            if let images = album["images"] as? [JSONStandard] {
                            
                                let imageData = images[0]
                                let mainImageUrl = URL(string: imageData["url"] as! String)
                                let mainImageData = NSData(contentsOf: mainImageUrl!)
                                
                                let mainImage = UIImage(data: mainImageData as! Data)
                                
                                
                                posts.append(post.init(mainImage: mainImage, name: name, previewURL: previewURl))
                                
                                self.tableView.reloadData()
                            }
                        }
                        
                       
                    }
                }
            }
            
            print(readableJSON)

        }
        catch {
        
            print(error)
        }
        
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        
        //cell?.textLabel?.text = names[indexPath.row]
        
        let mainImageView = cell?.viewWithTag(2) as! UIImageView
        mainImageView.image = posts[indexPath.row].mainImage
        
        
        let mainLabel = cell?.viewWithTag(1) as! UILabel
        mainLabel.text = posts[indexPath.row].name
        
        
        
        
        return cell!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let indexPath = self.tableView.indexPathForSelectedRow?.row
        
        let vc = segue.destination as! AudioVC
        vc.image = posts[indexPath!].mainImage
        vc.mainSongTitle = posts[indexPath!].name
        vc.mainPreviewURl = posts[indexPath!].previewURL
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}









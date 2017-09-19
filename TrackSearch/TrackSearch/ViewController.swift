//
//  ViewController.swift
//  TrackSearch
//
//  Created by Ajay Somanal on 9/17/17.
//  Copyright © 2017 Exilant. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    var tracks : [TrackModel] = [TrackModel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Invoked when search button tapped
    @IBAction func searchButtonTapped (_ sender: UIButton)
    {
        
        //Clear the Table View before fetching new tracks
        tracks.removeAll()
        self.tableView.reloadData()

        //Prepare URL
        let baseURL = "https://itunes.apple.com/search?term="  //tom waits
        let nameToSearch = searchTextField.text?.replacingOccurrences(of: " ", with: "+")
        let urlToSearch = URL.init(string: baseURL + nameToSearch!)
        print (urlToSearch!)
        
        // Hit the URL and get the track details
        let task = URLSession.shared.dataTask(with: urlToSearch! as URL) { data, response, error in
            
            guard let data = data, error == nil else { return }
            //Parse the response
            let json = try? JSONSerialization.jsonObject(with: data, options: [])
            let tracksArray = (json as AnyObject).object(forKey:"results") as? [Any]
            //Check the tracks
            if (tracksArray?.count)! > 0      {
                for case let trackJson  in tracksArray! {
                    do{
                        //Convert all tracks into model
                        let track  = TrackModel()
                        track.artistName = (trackJson as AnyObject).object(forKey: "artistName") as? String
                        track.trackName = (trackJson as AnyObject).object(forKey: "trackName") as? String
                        track.collectionName = (trackJson as AnyObject).object(forKey: "collectionName") as? String
                        let imageURLString = (trackJson as AnyObject).object(forKey: "artworkUrl100") as? String
                        //Fetch the image of the Album ( it can be fetched Async )
                        let imageURL = URL.init(string: imageURLString!)
                        let data = try? Data(contentsOf:imageURL!)
                        track.imageOfTheAlbum = UIImage(data: data!)
                        self.tracks.append(track)
                    }
                }
            }
            else
            {
                // Show the alert message since tracks are not found
                DispatchQueue.main.async {
                let alertController = UIAlertController(title: "Track Search", message:
                    "Tracks are not avilable", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: nil))
                self.present(alertController, animated: true, completion: nil)
                }
            }
            // Reload the table view to show all tracks
            self.tableView.reloadData()
        }
        task.resume()
    }
    
    
    // Prepare segue to pass the data to another view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Detail"
        {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let controller = segue.destination as! LyricsScreenViewController
                controller.trackDetails = tracks[indexPath.row]
            }
        }
    }

}


// Table view related methods 
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    @available(iOS 2.0, *)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Track", for: indexPath) as! MusicSearchTableCellView
        let track = tracks[indexPath.row]  as TrackModel
        cell.artistName.text = track.artistName
        cell.collectionName.text = track.collectionName
        cell.trackName.text = track.trackName
        cell.imgView.image = track.imageOfTheAlbum
        return cell
    }
}






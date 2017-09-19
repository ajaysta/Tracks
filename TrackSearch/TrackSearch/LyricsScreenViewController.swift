//
//  LyricsScreenViewController.swift
//  TrackSearch
//
//  Created by Ajay Somanal on 9/17/17.
//  Copyright © 2017 Exilant. All rights reserved.
//

import UIKit

// Display the lyrics
class LyricsScreenViewController: UIViewController {

    var trackDetails : TrackModel!
    @IBOutlet weak var trackName: UILabel!
    @IBOutlet weak var collectionName: UILabel!
    @IBOutlet weak var trackImage: UIImageView!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var lyricsView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.trackName.text = trackDetails.trackName
        self.collectionName.text = trackDetails.collectionName
        self.trackImage.image = trackDetails.imageOfTheAlbum
        self.artistName.text = trackDetails.artistName
        self.loadTheLyrics(artistName: trackDetails.artistName!, trackName: trackDetails.trackName!)
        // Do any additional setup after loading the view.
    }
    
    // Fetch the lyrics and load in Lyrics screen
    func loadTheLyrics(artistName: String, trackName: String)
    {
        //http://lyrics.wikia.com/api.php?func=getSong&artist=Tom+Waits&song=new+coat+of+paint&fmt=json
        //This URL should be put in plist file
        let baseURL = "https://lyrics.wikia.com/api.php?func=getSong&artist="
        let nameToSearch = artistName.replacingOccurrences(of: " ", with: "+")
        let trackNameToSerach = trackName.replacingOccurrences(of: " ", with: "+")
        let urlToSearch = URL.init(string: baseURL + nameToSearch + "&song=" + trackNameToSerach + "&fmt=realjson")
        //Fetch the lyrics 
        let task = URLSession.shared.dataTask(with: urlToSearch!){ data, response, error in
            guard let jsonData = data, error == nil else { return }
            let jsonString = try? JSONSerialization.jsonObject(with: jsonData, options: []) as! Dictionary<String, Any>
            DispatchQueue.main.async {
            self.lyricsView.text = jsonString?["lyrics"] as! String
            }
        }
        task.resume()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

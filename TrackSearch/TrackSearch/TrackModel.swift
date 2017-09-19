//
//  TrackModel.swift
//  TrackSearch
//
//  Created by Ajay Somanal on 9/17/17.
//  Copyright © 2017 Exilant. All rights reserved.
//

import UIKit
// Model to hold the track details, strcut also can be used to create a model 
class TrackModel: NSObject {

    var trackName : String? //track name
    var artistName : String? //artist name
    var collectionName : String?  //album name
    var imageOfTheAlbum : UIImage?
    var lyrics : String?
}

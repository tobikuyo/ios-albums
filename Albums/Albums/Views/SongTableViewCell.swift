//
//  SongTableViewCell.swift
//  Albums
//
//  Created by Tobi Kuyoro on 09/03/2020.
//  Copyright © 2020 Tobi Kuyoro. All rights reserved.
//

import UIKit

class SongTableViewCell: UITableViewCell {

    // MARK: - Outlets
    
    @IBOutlet weak var songName: UITextField!
    @IBOutlet weak var songDuration: UITextField!
    @IBOutlet weak var addSongButton: UIButton!
    
    
    // MARK: - Actions
    
    @IBAction func addSongButtonTapped(_ sender: UIButton) {
        
    }
}

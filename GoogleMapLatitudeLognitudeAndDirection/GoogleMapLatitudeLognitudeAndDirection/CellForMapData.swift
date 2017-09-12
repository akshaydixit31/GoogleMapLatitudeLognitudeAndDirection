//
//  CellForMapData.swift
//  GoogleMapLatitudeLognitudeAndDirection
//
//  Created by Appinventiv Technologies on 12/09/17.
//  Copyright © 2017 Appinventiv Technologies. All rights reserved.
//

import UIKit

class CellForMapData: UITableViewCell {
   
    @IBOutlet weak var startLatitude: UILabel!
    @IBOutlet weak var startLognitude: UILabel!
    @IBOutlet weak var stopLatitude: UILabel!
    
    @IBOutlet weak var stopLongnitude: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

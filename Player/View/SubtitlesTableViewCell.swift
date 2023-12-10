//
//  SubtitlesTableViewCell.swift
//  Player
//
//  Created by SHAYANUL HAQ SADI on 12/6/23.
//

import UIKit

class SubtitlesTableViewCell: UITableViewCell {

    @IBOutlet weak var subtitleLabel: UILabel!
    
    @IBOutlet weak var selectionImage: UIImageView!
    
    public static let identifier = "SubtitlesTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        selectionImage.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
        selectionImage.isHidden = !selected
    }
    
    
}

//
//  BottomSheetSubtitlesTableViewCell.swift
//  Player
//
//  Created by SHAYANUL HAQ SADI on 12/18/23.
//

import UIKit

class BottomSheetSubtitlesTableViewCell: UITableViewCell {

    @IBOutlet weak var subtitleLabel: UILabel!

    @IBOutlet weak var selectionImage: UIImageView!

    public static let identifier = "BottomSheetSubtitlesTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
//        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        selectionImage.isHidden = !selected

        if selected {
            subtitleLabel.textColor = .tintColor
        } else {
            subtitleLabel.textColor = .label
        }
    }
    
}

//
//  PodCell.swift
//  IBMCaptureSDK-Sample
//
//  Created by David Kwok Ho Chan on 1/31/17.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import UIKit

class PodCell: UITableViewCell {
    
    var vc : PodDataSaveProtocol?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func saveBtnCLicked(sender: AnyObject) {
        let key = itemLabel.text
        let value = itemValue.text
        self.vc?.savePodData(key!, value: value!)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var itemValue: UITextField!
    
}

//
//  ColorsCollectionViewCell.swift
//  Deteccao de planos
//
//  Created by Gabriel Oliveira Borges on 19/03/22.
//

import UIKit

class ColorsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var button: UIButton!
    
    static let identifier = "ColorsCollectionViewCell"
    static let nib = UINib(nibName: "ColorsCollectionViewCell", bundle: nil)
    private var onClick: ((UIColor) -> Void)? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    @IBAction func didTapButton(_ sender: Any) {
        onClick?(self.button.tintColor)
    }
    
    func configure(_ color: UIColor, action: @escaping (_ selectedColor: UIColor) -> Void) {
        self.button.tintColor = color
        self.button.backgroundColor = color
        self.onClick = action
    }

}

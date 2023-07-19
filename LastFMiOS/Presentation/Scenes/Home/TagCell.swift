//
//  ItemCell.swift
//  LastFMiOS
//
//  Created by valeri mekhashishvili on 18.07.23.
//

import UIKit

class TagCell: UICollectionViewCell {
    
    @IBOutlet weak var genreName: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var reachLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
    }
    
    private func setupCell() {
        layer.cornerRadius = 15
        clipsToBounds = true
    }
    
    func configure(with tag: Tag) {
        nameLabel.text = tag.name
        reachLabel.text = "Reach: \(tag.reach)"
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let attributes = super.preferredLayoutAttributesFitting(layoutAttributes)
        attributes.size = CGSize(width: 322, height: 140)
        return attributes
    }
}

//
//  MovieCollectionViewCell.swift
//  filmLibrary
//
//  Created by Давид Тоноян  on 06.01.2023.
//

import UIKit
import Kingfisher

final class MovieCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var cellImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = Constants.Size.cornerRadius
        cellImage.tintColor = Constants.Color.white
    }
}

struct MovieCollectionViewCellModel {
    let imageUrl: String
}

extension MovieCollectionViewCellModel: CellViewModel {
    func setup(cell: MovieCollectionViewCell) {
        cell.cellImage.setupImage(with: imageUrl)
    }
}

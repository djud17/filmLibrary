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
        
        layer.cornerRadius = 15
    }
}

struct MovieCollectionViewCellModel {
    let imageUrl: String
}

extension MovieCollectionViewCellModel: CellViewModel {
    func setup(cell: MovieCollectionViewCell) {
        let imageUrl = URL(string: imageUrl)
        let processor = DownsamplingImageProcessor(size: cell.cellImage.bounds.size)
        cell.cellImage.kf.indicatorType = .activity
        cell.cellImage.kf.setImage(
            with: imageUrl,
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
    }
}

protocol CellViewAnyModel {
    static var cellAnyType: UIView.Type { get }
    func setupAny(cell: UIView)
}

protocol CellViewModel: CellViewAnyModel {
    associatedtype CellType: UIView
    func setup(cell: CellType)
}

extension CellViewModel {
    static var cellAnyType: UIView.Type {
        return CellType.self
    }
    
    func setupAny(cell: UIView) {
        guard let cell = cell as? CellType else {
            assertionFailure("Cann`t setup cell")
            return
        }
        
        setup(cell: cell)
    }
}

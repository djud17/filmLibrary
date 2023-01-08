//
//  ActorCollectionViewCell.swift
//  filmLibrary
//
//  Created by Давид Тоноян  on 08.01.2023.
//

import UIKit

final class ActorCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var actorImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = self.frame.height / 2
        layer.borderColor = Constants.Color.white.cgColor
        layer.borderWidth = 2
        
        actorImageView.tintColor = Constants.Color.white
        actorImageView.backgroundColor = .white
        actorImageView.contentMode = .scaleAspectFill
    }
}

struct ActorCollectionViewCellModel {
    let imageUrl: String
}

extension ActorCollectionViewCellModel: CellViewModel {
    func setup(cell: ActorCollectionViewCell) {
        DispatchQueue.main.async {
            cell.actorImageView.setupImage(with: imageUrl)
        }
    }
}

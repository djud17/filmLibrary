//
//  MovieTableViewCell.swift
//  filmLibrary
//
//  Created by Давид Тоноян  on 08.01.2023.
//

import UIKit

final class MovieTableViewCell: UITableViewCell {
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var movieInfoLabel: UILabel!
    @IBOutlet weak var backView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = Constants.Color.white
        
        backView.layer.cornerRadius = Constants.Size.cornerRadius
        backView.layer.borderColor = Constants.Color.orange.cgColor
        backView.layer.borderWidth = Constants.Size.borderWidth
        backView.backgroundColor = Constants.Color.white
        
        movieImageView.tintColor = Constants.Color.orange
    }
    
    override func prepareForReuse() {
        movieImageView.image = nil
        movieNameLabel.text = ""
        movieInfoLabel.text = ""
    }
}

struct MovieTableViewCellModel {
    let imageUrl: String
    let movieName: String
    let movieInfo: String
}

extension MovieTableViewCellModel: CellViewModel {
    func setup(cell: MovieTableViewCell) {
        cell.movieImageView.setupImage(with: imageUrl)
        cell.movieNameLabel.text = movieName
        cell.movieInfoLabel.text = movieInfo
    }
}

//
//  ImageView.swift
//  filmLibrary
//
//  Created by Давид Тоноян  on 07.01.2023.
//

import UIKit
import Kingfisher

extension UIImageView {
    func setupImage(with imageUrl: String) {
        DispatchQueue.main.async { [weak self] in
            self?.tintColor = Constants.Color.orange
            let url = URL(string: imageUrl)
            let processor = DownsamplingImageProcessor(size: self?.bounds.size ?? .zero)
            self?.kf.indicatorType = .activity
            self?.kf.setImage(
                with: url,
                placeholder: UIImage(systemName: Constants.ImageName.placeholder),
                options: [
                    .processor(processor),
                    .scaleFactor(UIScreen.main.scale),
                    .transition(.fade(1)),
                    .cacheOriginalImage
                ])
        }
    }
}

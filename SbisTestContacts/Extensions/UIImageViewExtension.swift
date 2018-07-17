//
//  UIImageViewExtension.swift
//  SbisTestContacts
//
//  Created by Евгений Стадник on 10.07.2018.
//  Copyright © 2018 Евгений Стадник. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func loadImage(urlString: String) {
        self.image = nil
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                DispatchQueue.main.async {
                    if let downloadedImage = UIImage(data: data!) {
                        self.image = downloadedImage
                    } else {
                        self.image = UIImage(named: "profileImage")
                    }
                }
            }.resume()
        }
    }
}

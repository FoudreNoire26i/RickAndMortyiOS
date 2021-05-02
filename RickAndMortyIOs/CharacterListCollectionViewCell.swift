//
//  CharacterListCollectionViewCell.swift
//  RickAndMortyIOs
//
//  Created by lpiem2 on 24/02/2021.
//

import UIKit

class CharacterListCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var nameCharacterLabel: UILabel!
    @IBOutlet weak var specieCharacterLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var character : SerieCharacter?
    
    func setData(_ characterData : SerieCharacter) {
        character = characterData
        nameCharacterLabel.text = characterData.name
        self.layer.cornerRadius = 5.0
        self.layer.masksToBounds = true
        specieCharacterLabel.text = characterData.specie
        
        let imageUrl = URL(string: characterData.imageURL.absoluteString)!

        do {
            let imageData = try Data(contentsOf: imageUrl)
            imageView.image = UIImage(data: imageData, scale: 1.5)
        } catch {
            print(error)
        }
        
        contentView.layer.borderWidth = 1
        
        contentView.layer.borderColor = UIColor.lightGray.cgColor
    }
    
}

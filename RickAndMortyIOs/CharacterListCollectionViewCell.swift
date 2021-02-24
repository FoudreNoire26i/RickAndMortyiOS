//
//  CharacterListCollectionViewCell.swift
//  RickAndMortyIOs
//
//  Created by lpiem2 on 24/02/2021.
//

import UIKit

class CharacterListCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet weak var nameCharacterTextView: UILabel!
    @IBOutlet weak var specieCharacterTextView: UILabel!
    
    func setData(_ characterData : SerieCharacter) {
        
        nameCharacterTextView.text = characterData.name
        specieCharacterTextView.text = characterData.specie
    }
    
}

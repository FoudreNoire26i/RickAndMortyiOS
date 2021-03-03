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
    
    
    func setData(_ characterData : SerieCharacter) {
        nameCharacterLabel.text = characterData.name
        specieCharacterLabel.text = characterData.specie
    }
    
}

//
//  characterDetailTableViewController.swift
//  RickAndMortyIOs
//
//  Created by lpiem2 on 03/03/2021.
//

import UIKit

class CharacterDetailTableViewController: UITableViewController {
    @IBOutlet weak var characterImageView: UIImageView!
    
    @IBOutlet weak var characterNameTextView: UILabel!
    
    @IBOutlet weak var characterSpecieTextView: UILabel!
    
    @IBOutlet weak var characterStatusTextView: UILabel!
    
    var character : SerieCharacter!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (character != nil){
            let imageUrl = URL(string: character.imageURL.absoluteString)!

            do {
                let imageData = try Data(contentsOf: imageUrl)
                characterImageView.image = UIImage(data: imageData, scale: 1.5)
            } catch {
                print(error)
            }
            
            characterNameTextView.text = character.name
            characterSpecieTextView.text = character.specie
            
            characterStatusTextView.text = character.status
            
            switch character.status {
            case "Alive":
                characterStatusTextView.textColor = .systemGreen
            case "Dead":
                characterStatusTextView.textColor = .systemRed
            default:
                print("no changement of color")
            }
        }
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
}

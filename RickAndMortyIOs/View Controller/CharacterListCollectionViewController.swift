//
//  CharacterListCollectionViewController.swift
//  RickAndMortyIOs
//
//  Created by lpiem2 on 24/02/2021.
//

import UIKit

private let reuseIdentifier = "collectionCharacterListCell"

class CharacterListCollectionViewController: UICollectionViewController {
    
    private enum Section {
        case main
    }

    private enum Item: Hashable {
        case character(SerieCharacter)
    }

    private var diffableDataSource: UICollectionViewDiffableDataSource<Section, Item>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        // Do any additional setup after loading the view.
        diffableDataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
            switch item {
            case .character(let serieCharacter):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CharacterListCollectionViewCell
                cell.setData(serieCharacter)
                return cell
            }
        })
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        NetworkManager.shared.getCharacters { (result : Result<PaginatedElements<SerieCharacter>, Error>) in
            switch result {
            case .failure(let error):
                print(error)

            case .success(let paginatedElements):
                print("appel api ok")
                print(paginatedElements.information.nextURL!)
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        // Configure the cell
    
        return cell
    }

}

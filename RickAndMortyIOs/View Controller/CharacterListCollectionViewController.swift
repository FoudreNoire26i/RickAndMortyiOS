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
    
    private var listPerso:[SerieCharacter] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        // Do any additional setup after loading the view.
        self.collectionView!.register(CharacterListCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        
        diffableDataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
            switch item {
            case .character(let serieCharacter):
                /*
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CharacterListCollectionViewCell*/
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CharacterListCollectionViewCell
                
                cell.setData(serieCharacter)
                return cell
            }
        })
        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        NetworkManager.shared.getCharacters { (result : Result<PaginatedElements<SerieCharacter>, Error>) in
            switch result {
            case .failure(let error):
                print(error)

            case .success(let paginatedElements):
                self.listPerso = paginatedElements.decodedElements
                
                let snapshot = self.createSnapshot()
                self.diffableDataSource.apply(snapshot)
            }
        }
    }

    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout(sectionProvider: { (section, environment) -> NSCollectionLayoutSection? in
            let snapshot = self.diffableDataSource.snapshot()
            let currentSection = snapshot.sectionIdentifiers[section]
            
            switch currentSection {
            case .main:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .fractionalHeight(1.0))

                let item = NSCollectionLayoutItem(layoutSize: itemSize)

                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .absolute(50))

                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize,
                                                             subitem: item,
                                                             count: 2)

                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 10

                return section

                }
        })

        return layout
    }

    private func createSnapshot() -> NSDiffableDataSourceSnapshot<Section, Item> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])

        let myItems = listPerso
            .map { Item.character($0) }

        snapshot.appendItems(myItems, toSection: .main)

        return snapshot
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCharacterDetail" {
            let dest = segue.destination
        }
    }

}

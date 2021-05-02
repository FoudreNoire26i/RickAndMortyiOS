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
    
    private var listPersoFiltered:[SerieCharacter] = []
    private var listPersoAll:[SerieCharacter] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        // Do any additional setup after loading the view.
        setupView()
        
        
        diffableDataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
            switch item {
            case .character(let serieCharacter):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CharacterListCollectionViewCell
                
                cell.setData(serieCharacter)
                return cell
            }
        })
        collectionView.collectionViewLayout = createLayout()
        
        NetworkManager.shared.getCharacters { (result : Result<PaginatedElements<SerieCharacter>, Error>) in
            switch result {
            case .failure(let error):
                print(error)

            case .success(let paginatedElements):
                self.listPersoFiltered = paginatedElements.decodedElements
                
                self.listPersoAll = self.listPersoFiltered
                
                let snapshot = self.createSnapshot()
                self.diffableDataSource.apply(snapshot)
                
            }
        }
    }
    
    private func setupView() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
    }

    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout(sectionProvider: { (section, environment) -> NSCollectionLayoutSection? in
            let snapshot = self.diffableDataSource.snapshot()
            let currentSection = snapshot.sectionIdentifiers[section]
            switch currentSection {
                case .main:
                    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                          heightDimension: .fractionalHeight(1))

                    let item = NSCollectionLayoutItem(layoutSize: itemSize)

                    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                           heightDimension: .estimated(100))

                    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

                    let section = NSCollectionLayoutSection(group: group)
                    section.interGroupSpacing = 10

                    return section
            }
        })
        print(layout.indexPathsToInsertForSupplementaryView(ofKind: "SearcBarCollectionReusableView"))
        return layout
    }

    private func createSnapshot() -> NSDiffableDataSourceSnapshot<Section, Item> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])

        let myItems = listPersoFiltered
            .map { Item.character($0) }

        snapshot.appendItems(myItems, toSection: .main)
        
        
        print(snapshot.numberOfSections)

        return snapshot
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        print("oooooooooooojh")
        if (kind == UICollectionView.elementKindSectionHeader) {
            let headerView:UICollectionReusableView =  collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CharacterCollectionHeader", for: indexPath)
            
            if (headerView.subviews[0] is UISearchBar){
                (headerView.subviews[0] as! UISearchBar).delegate = self
            }
            
             return headerView
         }

         return UICollectionReusableView()

    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCharacterDetail" {
            
            let nav = segue.destination as! UINavigationController
            let dest = nav.viewControllers[0] as! CharacterDetailTableViewController
            dest.character = (sender as! CharacterListCollectionViewCell).character
        }
    }

}

extension CharacterListCollectionViewController : UISearchControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchQuery = searchController.searchBar.text
        
        print("update :"+(searchController.searchBar.text ?? "naze"))
        let newList : [SerieCharacter];
        if (searchQuery != nil && searchQuery != ""){
            newList = listPersoAll.filter { character in
                return character.name.lowercased().contains(searchQuery!.lowercased())
            }
        } else {
            newList = listPersoAll
        }
        if (newList != listPersoFiltered){
            listPersoFiltered = newList
            let snapshot = self.createSnapshot()
            self.diffableDataSource.apply(snapshot)
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("find")
        listPersoFiltered =  listPersoAll.filter { character in
            return character.name.contains(searchBar.text ?? "")
        }
    }
    
}

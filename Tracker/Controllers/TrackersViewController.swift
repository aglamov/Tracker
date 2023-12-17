//
//  ViewController.swift
//  Tracker
//
//  Created by Рамиль Аглямов on 16.12.2023.
//

import UIKit

protocol TrackersViewControllerProtocol: AnyObject {
    var presenter: TrackersPresenterProtocol? { get }
    var trackersCollectionView: UICollectionView { get }
}

final class TrackersViewController: UIViewController, TrackersViewControllerProtocol {
    
    private enum Contstants {
        static let cellIdentifier = "TrackerCell"
        static let headerIdentifier = "TrackersHeader"
        static let contentInsets: CGFloat = 16
        static let spacing: CGFloat = 9
    }
    
    var presenter: TrackersPresenterProtocol?
    
    lazy var trackersCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.alwaysBounceVertical = true
        collectionView.contentInset = UIEdgeInsets(top: 24, left: Contstants.contentInsets, bottom: 24, right: Contstants.contentInsets)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTrackersScreen()
    }
    
    private func setupTrackersScreen() {
        view.backgroundColor = .white
        setupNavigationBar()
        addSubviews()
        contstraintSubviews()
    }
    
    private func setupNavigationBar() {
        guard let navigationBar = navigationController?.navigationBar else { return }
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        addButton.tintColor = .black
        navigationBar.topItem?.setLeftBarButton(addButton, animated: true)
        
        navigationBar.topItem?.title = "Трекеры"
        navigationBar.prefersLargeTitles = true
        navigationBar.topItem?.largeTitleDisplayMode = .always
    }
    
    private func addSubviews() {
            view.addSubview(trackersCollectionView)
        }
    
    private func contstraintSubviews() {
            NSLayoutConstraint.activate([
                trackersCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
                trackersCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                trackersCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                trackersCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            ])
        }
    
    @objc private func addButtonTapped() {
        // Обработка нажатия на кнопку “+”
    }
}



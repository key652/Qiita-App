//
//  ContributionListViewController.swift
//  QiitaApp
//
//  Created by 矢田悠馬 on 2022/06/26.
//

import Foundation
import UIKit

final class ContributionListViewController: UIViewController {
    let qiitaModel = Qiita()
    var dataSource: UICollectionViewDiffableDataSource<Int, QiitaItem>! = nil
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        qiitaModel.delegate = self
        qiitaModel.getItems()
        
        collectionView.collectionViewLayout = createLayout()
        configureDataSource()
        collectionView.delegate = self
    }
}

extension ContributionListViewController {
    private func createLayout() -> UICollectionViewLayout {
        let config = UICollectionLayoutListConfiguration(appearance: .plain)
        return UICollectionViewCompositionalLayout.list(using: config)
    }
    
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<CustomCell, QiitaItem>{ cell, indexPath, item in
            cell.update(item)
        }
        
        dataSource = UICollectionViewDiffableDataSource<Int, QiitaItem>(collectionView: collectionView) {
            (collectionView, indexPath, itemIdentifier) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        }
    }
}

extension ContributionListViewController: UICollectionViewDelegate {
    
}

extension ContributionListViewController: QiitaDelegate {
    func updateQiitaItems() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, QiitaItem>()
        snapshot.appendSections([0])
        snapshot.appendItems(qiitaModel.qiitaItems)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

fileprivate extension UIConfigurationStateCustomKey {
    static let qiitaItem = UIConfigurationStateCustomKey("com.QiitaApp.QiitaItemListCell.QiitaItem")
}

private extension UICellConfigurationState {
    var qiitaItem: QiitaItem? {
        get { return self[.qiitaItem] as? QiitaItem }
        set { self[.qiitaItem] = newValue }
    }
}

private class QiitaItemListCell: UICollectionViewListCell {
    private var qiitaItem: QiitaItem? = nil
    
    func update(_ newItem: QiitaItem) {
        guard qiitaItem != newItem else { return }
        qiitaItem = newItem
        setNeedsUpdateConfiguration()
    }
    
    override var configurationState: UICellConfigurationState {
        var state = super.configurationState
        state.qiitaItem = self.qiitaItem
        return state
    }
}

private class CustomCell: QiitaItemListCell {
    private let titleLabel = UILabel()
    private let tagsLabel = UILabel()
    private let tagIcon = UIImageView(image: UIImage(systemName: "tag.fill"))
    private let lgtmLabel = UILabel()
    
    private func setupLayout() {
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        
        tagsLabel.numberOfLines = 0
        tagsLabel.font = UIFont.systemFont(ofSize: 14)
        tagsLabel.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.87)
        
        tagIcon.tintColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        tagIcon.frame = CGRect(x: 0, y: 0, width: 14, height: 14)
        
        lgtmLabel.font = UIFont.systemFont(ofSize: 14)
        lgtmLabel.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.87)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(lgtmLabel)
        contentView.addSubview(tagsLabel)
        contentView.addSubview(tagIcon)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        tagsLabel.translatesAutoresizingMaskIntoConstraints = false
        tagIcon.translatesAutoresizingMaskIntoConstraints = false
        lgtmLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // titleLabel
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            // tagIcon
            tagIcon.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            tagIcon.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            tagIcon.widthAnchor.constraint(equalToConstant: 14),
            tagIcon.heightAnchor.constraint(equalToConstant: 14),
            // tagsLabel
            tagsLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            tagsLabel.leadingAnchor.constraint(equalTo: tagIcon.trailingAnchor, constant: 6),
            tagsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            // lgtmLabel
            lgtmLabel.topAnchor.constraint(equalTo: tagsLabel.bottomAnchor, constant: 10),
            lgtmLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            lgtmLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        setupLayout()
        
        titleLabel.text = state.qiitaItem?.title
        tagsLabel.text = createTagsText(tags: state.qiitaItem?.tags ?? [])
        if let likesCount = state.qiitaItem?.likes_count {
            lgtmLabel.text = "LGTM " + String(likesCount)
        }
    }
    
    private func createTagsText(tags: [Tag]) -> String {
        var tagsText = ""
        
        for (index, value) in zip(tags.indices, tags) {
            if index != tags.count - 1 {
                tagsText += "\(value.name), "
            } else {
                tagsText += "\(value.name)"
            }
        }
        
        return tagsText
    }
}

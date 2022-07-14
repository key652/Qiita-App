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

extension ContributionListViewController {
    private func createLayout() -> UICollectionViewLayout {
        let config = UICollectionLayoutListConfiguration(appearance: .plain)
        return UICollectionViewCompositionalLayout.list(using: config)
    }
    
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<ContributionListCell, QiitaItem>{ cell, indexPath, item in
            cell.update(item)
        }
        
        dataSource = UICollectionViewDiffableDataSource<Int, QiitaItem>(collectionView: collectionView) {
            (collectionView, indexPath, itemIdentifier) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        }
    }
}

private class ContributionListCell: UICollectionViewListCell {
    var qiitaItem: QiitaItem?
    
    func update(_ newValue: QiitaItem) {
        guard qiitaItem != newValue else { return }
        qiitaItem = newValue
        setNeedsUpdateConfiguration()
    }
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        guard let qiitaItem = qiitaItem else { return }
        
        var content = ContributionListCellConfiguration(
            userIconUrl: qiitaItem.user.profile_image_url,
            userIdAndname: "@\(qiitaItem.user.id)",
            createdAt: qiitaItem.displayCreatedAt(dateFormat: "yyyy年MM月dd日"),
            title: qiitaItem.title,
            tagIcon: UIImage(systemName: "tag.fill"),
            tags: createTagsText(tags: qiitaItem.tags),
            lgtm: "LGTM \(String(qiitaItem.likes_count))"
        )
        if qiitaItem.user.name != "" {
            content.userIdAndname += " (\(qiitaItem.user.name))"
        }
        contentConfiguration = content
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

struct ContributionListCellConfiguration: UIContentConfiguration, Hashable {
    var userIconUrl: String
    var userIdAndname: String
    var createdAt: String
    var title: String
    var tagIcon: UIImage?
    var tags: String
    var lgtm: String
    
    
    func makeContentView() -> UIView & UIContentView {
        ContributionListCellView(configuration: self)
    }
    
    func updated(for state: UIConfigurationState) -> ContributionListCellConfiguration {
        return self
    }
}

//
//  ContributionListCellView.swift
//  QiitaApp
//
//  Created by 矢田悠馬 on 2022/07/10.
//

import UIKit

final class ContributionListCellView: UIView, UIContentView {
    @IBOutlet var containerView: UIView! {
        didSet {
            addSubview(containerView)
            containerView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                containerView.topAnchor.constraint(equalTo: self.topAnchor),
                containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ])
            containerView.backgroundColor = .clear
        }
    }
    @IBOutlet weak var userIconImageView: UIImageView!
    @IBOutlet weak var userIdAndnameLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tagIcon: UIImageView!
    @IBOutlet weak var tagsLabel: UILabel!
    @IBOutlet weak var lgtmLabel: UILabel!
    
    private var currentConfiguration: ContributionListCellConfiguration!
    var configuration: UIContentConfiguration {
        get {
            currentConfiguration
        }
        set {
            guard let newConfiguration = newValue as? ContributionListCellConfiguration else { return }
            
            apply(configuration: newConfiguration)
        }
    }
    
    init(configuration: ContributionListCellConfiguration) {
        super.init(frame: .zero)
        
        loadNib()
        
        apply(configuration: configuration)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ContributionListCellView {
    private func loadNib() {
        UINib(nibName: "ContributionListCellView", bundle: nil)
            .instantiate(withOwner: self, options: nil)
        
        userIconImageView.layer.cornerRadius = 17.5
        userIconImageView.clipsToBounds = true
    }
    
    private func apply(configuration: ContributionListCellConfiguration) {
        guard currentConfiguration != configuration else {
            return
        }
        
        currentConfiguration = configuration
        
        Utils.loadImageFromUrl(url: configuration.userIconUrl) { [weak self] uiimage in
            DispatchQueue.main.async {
                self?.userIconImageView.image = uiimage
            }
        }
        userIdAndnameLabel.text = configuration.userIdAndname
        createdAtLabel.text = configuration.createdAt
        titleLabel.text = configuration.title
        tagIcon.image = configuration.tagIcon
        tagsLabel.text = configuration.tags
        lgtmLabel.text = configuration.lgtm
    }
}

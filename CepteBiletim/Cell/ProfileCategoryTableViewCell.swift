//
//  ProfileCategoryTableViewCell.swift
//  CepteBiletim
//
//  Created by Esna nur Yılmaz on 29.05.2025.
//

import UIKit

class ProfileCategoryTableViewCell: UITableViewCell {
    let profileCategoryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .systemBlue
        label.font = UIFont(name: "Helvetica-Oblique", size: 18)
        label.shadowColor = UIColor.blue
        label.shadowOffset = CGSize(width: 0.6, height: 0.6)
        label.textAlignment = .center
        return label
       }()
       
       override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
           super.init(style: style, reuseIdentifier: reuseIdentifier)
           setupUI()
       }

       required init?(coder: NSCoder) {
           super.init(coder: coder)
           setupUI()
       }

    private func setupUI() {
        contentView.addSubview(profileCategoryLabel)
        NSLayoutConstraint.activate([
            profileCategoryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            profileCategoryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            profileCategoryLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        profileCategoryLabel.textAlignment = .center
    }

       override func awakeFromNib() {
           super.awakeFromNib()
       }

       override func setSelected(_ selected: Bool, animated: Bool) {
           super.setSelected(selected, animated: animated)
       }


}

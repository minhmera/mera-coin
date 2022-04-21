//
//  CoinDetailCell.swift
//  MeraCoin
//
//  Created by GoSELL_MacMini on 17/04/2022.
//

import UIKit
import SDWebImage
import SDWebImageFLPlugin


class CoinDetailCell: UITableViewCell {

    
    
    @IBOutlet weak var avatarWrapperView: UIView!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var shortNameLabel: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var revenueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        avatarWrapperView.layer.cornerRadius = avatarWrapperView.frame.size.width * 0.5
    }
    
    func setupData(coinVM: CoinViewModel) {
        shortNameLabel.text = coinVM.shortNameText
        fullNameLabel.text = coinVM.fullNameText
        priceLabel.text = coinVM.priceText
        revenueLabel.text = coinVM.revenueText
        
        if coinVM.getRevenue() > 0 {
            revenueLabel.textColor = .green
        } else if  coinVM.getRevenue() < 0 {
            revenueLabel.textColor = .red
        } else {
            revenueLabel.textColor = .darkGray
        }
        self.avatarImageView.sd_setImage(with: URL(string: coinVM.logoUrlString))
    }

    
}

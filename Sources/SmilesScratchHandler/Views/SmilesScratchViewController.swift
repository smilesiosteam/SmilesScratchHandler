//
//  SmilesScratchViewController.swift
//  
//
//  Created by Abdul Rehman Amjad on 15/09/2023.
//

import UIKit
import SmilesUtilities
import SmilesLanguageManager

public protocol ScratchAndWinDelegate: AnyObject {
    func viewVoucherPressed(voucherCode: String)
}

public class SmilesScratchViewController: UIViewController {

    // MARK: - OUTLETS -
    @IBOutlet weak var topHeaderView: UIStackView!
    @IBOutlet weak var scratchStackView: UIStackView!
    @IBOutlet weak var congratulationsView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var scratchView: SmilesScratchView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var instructionsLabel: UILabel!
    @IBOutlet weak var giftImageView: UIImageView!
    @IBOutlet weak var greetingsLabel: UILabel!
    @IBOutlet weak var voucherLabel: UILabel!
    @IBOutlet weak var viewVoucherButton: UICustomButton!
    
    
    // MARK: - PROPERTIES -
    private let scratchObj: ScratchAndWin
    public weak var delegate: ScratchAndWinDelegate?
    
    // MARK: - ACTIONS -
    @IBAction func viewVoucherPressed(_ sender: Any) {
        
        dismiss(animated: true)
        if let voucher = scratchObj.voucherCode, !voucher.isEmpty {
            delegate?.viewVoucherPressed(voucherCode: voucher)
        }
        
    }
    
    @IBAction func closePressed(_ sender: Any) {
        dismiss(animated: true)
    }
    
    // MARK: - METHODS -
    public init(scratchObj: ScratchAndWin) {
        self.scratchObj = scratchObj
        super.init(nibName: "SmilesScratchViewController", bundle: .module)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        
        titleLabel.text = scratchObj.themeResources?.title
        subTitleLabel.text = scratchObj.themeResources?.subTitle
        if let imageUrl = URL(string: scratchObj.themeResources?.scratchImageURL ?? ""), let scratchImage = UIImage(url: imageUrl) {
            scratchView.scratchImage = scratchImage
        }
        let giftImageUrl = scratchObj.themeResources?.giftImageURL ?? scratchObj.themeResources?.failureImageURL ?? ""
        giftImageView.setImageWithUrlString(giftImageUrl) { [weak self] image in
            self?.scratchView.backgroundImage = image
        }
        messageLabel.text = scratchObj.themeResources?.message
        instructionsLabel.text = scratchObj.themeResources?.instruction
        scratchView.scratchDelegate = self
        
    }

}

extension SmilesScratchViewController: ScratchDelegate {
    
    func scratch(percentage value: Int) {
        if value > 50 {
            scratchStackView.isHidden = true
            if let voucher = scratchObj.voucherCode, !voucher.isEmpty {
                greetingsLabel.text = scratchObj.themeResources?.greetingText
                voucherLabel.text = scratchObj.fullTitle
                viewVoucherButton.setTitle(SmilesLanguageManager.shared.getLocalizedString(for: "View my vouchers"), for: .normal)
            } else {
                greetingsLabel.text = scratchObj.themeResources?.failureTitle
                voucherLabel.text = scratchObj.themeResources?.failureMessage
                viewVoucherButton.setTitle(SmilesLanguageManager.shared.getLocalizedString(for: "CloseTitle"), for: .normal)
            }
            congratulationsView.isHidden = false
        }
    }
    
}

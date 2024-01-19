//
//  SmilesScratchViewController.swift
//  
//
//  Created by Abdul Rehman Amjad on 15/09/2023.
//

import UIKit
import SmilesUtilities
import SmilesLanguageManager
import Combine
import SmilesLoader

public protocol ScratchAndWinDelegate: AnyObject {
    func viewVoucherPressed(voucherCode: String)
    func proceedToOfferDetails(offerId: String, offerType: String)
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
    private var scratchObj: ScratchAndWinResponse
    private let orderId: String
    public weak var delegate: ScratchAndWinDelegate?
    private lazy var viewModel: ScratchAndWinViewModel = {
        return ScratchAndWinViewModel()
    }()
    private var input: PassthroughSubject<ScratchAndWinViewModel.Input, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - ACTIONS -
    @IBAction func viewVoucherPressed(_ sender: Any) {
        
        dismiss(animated: true)
        if let voucher = scratchObj.voucherCode, !voucher.isEmpty {
            delegate?.viewVoucherPressed(voucherCode: voucher)
        } else if let offerId = scratchObj.offerId, let offerType = scratchObj.offerType {
            delegate?.proceedToOfferDetails(offerId: offerId, offerType: offerType)
        }
        
    }
    
    @IBAction func closePressed(_ sender: Any) {
        dismiss(animated: true)
    }
    
    // MARK: - METHODS -
    public init(scratchObj: ScratchAndWinResponse, orderId: String) {
        self.orderId = orderId
        self.scratchObj = scratchObj
        super.init(nibName: "SmilesScratchViewController", bundle: .module)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bind(to: viewModel)
    }
    
    private func setupViews() {
        
        titleLabel.text = scratchObj.themeResources?.title
        subTitleLabel.text = scratchObj.themeResources?.subTitle
        if let imageUrl = URL(string: scratchObj.themeResources?.scratchImageURL ?? ""), let scratchImageData = UIImage(url: imageUrl)?.jpegData(compressionQuality: 1), let scratchImage = UIImage(data: scratchImageData) {
            scratchView.scratchImage = scratchImage
        }
        messageLabel.text = scratchObj.themeResources?.message
        instructionsLabel.text = scratchObj.themeResources?.instruction
        scratchView.scratchDelegate = self
        
    }
    
    private func updateUI() {
        
        let giftImageUrl: String?
        scratchStackView.isHidden = true
        if scratchObj.voucherWon ?? false {
            greetingsLabel.text = scratchObj.themeResources?.greetingText
            voucherLabel.text = scratchObj.fullTitle
            viewVoucherButton.setTitle(scratchObj.voucherCode == nil ? scratchObj.themeResources?.paidVoucherButtonText : scratchObj.themeResources?.freeVoucherButtonText, for: .normal)
            giftImageUrl = scratchObj.themeResources?.giftImageURL
        } else {
            greetingsLabel.text = scratchObj.themeResources?.failureTitle
            voucherLabel.text = scratchObj.themeResources?.failureMessage
            viewVoucherButton.setTitle(SmilesLanguageManager.shared.getLocalizedString(for: "Okay"), for: .normal)
            giftImageUrl = scratchObj.themeResources?.failureImageURL
        }
        giftImageView.setImageWithUrlString(giftImageUrl ?? "") { [weak self] image in
            SmilesLoader.dismiss()
            self?.scratchView.backgroundImage = image
        }
        congratulationsView.isHidden = false
        
    }

}

// MARK: - VIEWMODEL BINDING -
extension SmilesScratchViewController {
    
    func bind(to viewModel: ScratchAndWinViewModel) {
        input = PassthroughSubject<ScratchAndWinViewModel.Input, Never>()
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        output
            .sink { [weak self] event in
                switch event {
                case .fetchScratchAndWinDidSucceed(let response):
                    self?.scratchObj = response
                    self?.updateUI()
                case .fetchScratchAndWinDidFail(_):
                    self?.updateUI()
                }
            }.store(in: &cancellables)
    }
    
}

// MARK: - SCRATCH VIEW DELEGATE -
extension SmilesScratchViewController: ScratchDelegate {
    
    func scratch(percentage value: Int) {
        if value > 50 {
            scratchView.isUserInteractionEnabled = false
            scratchView.scratchDelegate = nil
            SmilesLoader.show()
            input.send(.getScratchAndWinData(orderId: orderId, isVoucherScratched: true, paymentType: scratchObj.paymentType))
        }
    }
    
}

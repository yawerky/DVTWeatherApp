//
//  CCToolbar.swift
//  DVTWeatherApp
//
//  Created by Yawer Khan on 28/10/25.
//  Copyright © 2025 DVT. All rights reserved.
//
//  USAGE EXAMPLE:
//
//  // In any view controller that extends CCBaseVC:
//  override func viewDidLoad() {
//      super.viewDidLoad()
//
//      // Add toolbar with title
//      let toolbar = addToolbar(title: "Weather Forecast")
//
//      // Show back button
//      toolbar.showBackButton()
//      toolbar.delegate = self
//
//      // Show right button with system icon
//      toolbar.showRightButton(systemName: "gear")
//  }
//
//  // Implement delegate methods:
//  extension MyViewController: CCToolbarDelegate {
//      func toolbarBackButtonTapped() {
//          popVC()
//      }
//
//      func toolbarRightButtonTapped() {
//          // Handle settings tap
//      }
//  }

import UIKit

protocol CCToolbarDelegate: AnyObject {
    func toolbarBackButtonTapped()
    func toolbarRightButtonTapped()
}

// MARK: - Global Toolbar
class CCToolbar: UIView {

    @IBOutlet private weak var m_contentView: UIView!
    @IBOutlet private weak var m_titleLabel: UILabel!
    @IBOutlet private weak var m_backButton: UIButton!
    @IBOutlet private weak var m_rightButton: UIButton!

    weak var delegate: CCToolbarDelegate?


    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        loadNib()
        setupUI()
    }

    private func loadNib() {
        let bundle = Bundle(for: type(of: self))
        bundle.loadNibNamed("CCToolbar", owner: self, options: nil)
        addSubview(m_contentView)
        m_contentView.frame = bounds
        m_contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }

    // MARK: - Setup

    private func setupUI() {
        m_contentView.backgroundColor = .systemBackground

        m_titleLabel.font = .poppinsSemiBold(size: 18)
        m_titleLabel.textColor = .label
        m_titleLabel.textAlignment = .center

        m_backButton.tintColor = .label
        m_backButton.isHidden = true

        m_rightButton.tintColor = .label
        m_rightButton.isHidden = true

        addShadow()
    }

    private func addShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.1
    }
    
    func setTitle(_ title: String) {
        m_titleLabel.text = title
    }
    
    func showBackButton(image: UIImage? = nil) {
        m_backButton.isHidden = false
        if let customImage = image {
            m_backButton.setImage(customImage, for: .normal)
        } else {
            m_backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        }
    }
    
    func hideBackButton() {
        m_backButton.isHidden = true
    }
    
    func showRightButton(image: UIImage?) {
        m_rightButton.isHidden = false
        m_rightButton.setImage(image, for: .normal)
    }
    
    func showRightButton(systemName: String) {
        m_rightButton.isHidden = false
        m_rightButton.setImage(UIImage(systemName: systemName), for: .normal)
    }

    func hideRightButton() {
        m_rightButton.isHidden = true
    }

    func setTitleFont(_ font: UIFont) {
        m_titleLabel.font = font
    }

    func setTitleColor(_ color: UIColor) {
        m_titleLabel.textColor = color
    }

    func setBackgroundColor(_ color: UIColor) {
        m_contentView.backgroundColor = color
    }


    @IBAction private func backButtonTapped(_ sender: UIButton) {
        delegate?.toolbarBackButtonTapped()
    }

    @IBAction private func rightButtonTapped(_ sender: UIButton) {
        delegate?.toolbarRightButtonTapped()
    }
}

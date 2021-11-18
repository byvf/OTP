//
//  OTPView.swift
//  NEOBANK
//
//  Created by VF Work on 29.09.2021.
//  Copyright © 2021 NEOBANK. All rights reserved.
//

import UIKit

extension OTP {
    enum State {
        case normal
        case active
        case error(Error?)
    }
}

final class OTP: UIView {
    
    // MARK: - InternalProperty
    private(set) var onTextChange: ((String) -> Void)?
    private var fieldState: State = .normal { didSet { updateLabes() } }
    private var digitCount: Int = 0 {
        didSet {
            refreshUI()
        }
    }
    
    // MARK: - Constants (included color, width, height)
    struct Constants {
        static let height_OTP_View: CGFloat = 60.0
        static let height_OTP_Point: CGFloat = 8
        static let width_OTP_Point: CGFloat = 8
        static let textColor: UIColor = UIColor("#2F2F3E") // Brand Blakc
        static let font: UIFont = .systemFont(ofSize: 16.0)
        static let symbolBackgroundColor: UIColor = .white
        static let borderColorNormalState: UIColor = UIColor("#858D95")
        static let borderColorActiveState: UIColor = UIColor("#00C9C5") // Brand Cosmo
        static let borderColorErrorState: UIColor = .red
    }
    
    // UI Components
    private var labels: [UILabel] = [UILabel]()
    
    private var textField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.keyboardType = .numberPad
        tf.isHidden = true
        return tf
    }()
    
    final private let containerVStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4.0
        stack.distribution = .fill
        stack.alignment = .fill
        return stack
    }()
    
    final private let containerElementsHStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 0.0
        stack.distribution = .fill
        stack.alignment = .fill
        return stack
    }()
    
    final private let containerElementsWithErrorVStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4.0
        stack.distribution = .fill
        stack.alignment = .fill
        return stack
    }()
    
    final private let elementsHStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8.0
        stack.distribution = .fill
        stack.alignment = .fill
        return stack
    }()
    
    final private var errorLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 14)
        l.textColor = .red
        l.numberOfLines = 0
        l.textAlignment = .left
        l.isHidden = true
        return l
    }()
    
    final private var spaceViewFirst: UIView = {
        let v = UIView()
        v.backgroundColor = nil
        v.setContentCompressionResistancePriority(.init(100), for: .horizontal)
        v.setContentCompressionResistancePriority(.init(100), for: .vertical)
        v.setContentHuggingPriority(.init(100), for: .vertical)
        v.setContentHuggingPriority(.init(100), for: .horizontal)
        return v
    }()
    
    final private var spaceViewSecond: UIView = {
        let v = UIView()
        v.backgroundColor = nil
        v.setContentCompressionResistancePriority(.init(100), for: .horizontal)
        v.setContentCompressionResistancePriority(.init(100), for: .vertical)
        v.setContentHuggingPriority(.init(100), for: .vertical)
        v.setContentHuggingPriority(.init(100), for: .horizontal)
        return v
    }()
    
    // MARK: - Init
    convenience init(digitNumber: Int) {
        self.init(frame: .zero)
        self.digitCount = digitNumber
        self.setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: .greatestFiniteMagnitude, height: 80.0)
    }
    
    // MARK: Setup UI
    // MARK: - Setup View
    private func setupView() {
        textField.delegate = self
        addSubviewWithConstraints(textField)
        
        addSubviewWithConstraints(containerVStack)
        containerVStack.addArrangedSubview(containerElementsHStack)
        containerElementsHStack.addArrangedSubview(spaceViewFirst)
        containerElementsHStack.addArrangedSubview(containerElementsWithErrorVStack)
        containerElementsHStack.addArrangedSubview(spaceViewSecond)
        
        containerElementsWithErrorVStack.addArrangedSubview(elementsHStack)
        containerElementsWithErrorVStack.addArrangedSubview(errorLabel)
        
        setupLabels()
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(becomeFirstResponder)))
    }
    
    // MARK: - Refresh View
    func refreshUI() {
        setupLabels()
    }
    
    // MARK: Setup Labels for OTPView
    private func setupLabels() {
        self.elementsHStack.subviews.forEach({ $0.removeFromSuperview() })
        
        for indexCount in 0 ..< digitCount {
            let label = makeLabel()
            label.tag = indexCount
            labels.append(label)
            elementsHStack.addArrangedSubview(label)
            
            if indexCount == 0 {
                setCode(at: 0 , state: .normal)
            }
        }
        
        spaceViewFirst
            .widthAnchor
            .constraint(equalTo: spaceViewSecond.widthAnchor, constant: 0)
            .with(priority: .init(249))
            .isActive = true
    }
    
    // MARK: Update OTP Fields
    func updateLabes() {
        labels.enumerated().forEach({ index, label in
            setCode(at: index, state: fieldState)
        })
        
        switch fieldState {
        case .active:
            self.isHiddenError(true)
        case .normal:
            self.isHiddenError(true)
        case .error(let error):
            self.isHiddenError(false, with: error?.localizedDescription)
        }
    }
    
    // MARK: Configure One Label
    private func makeLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Constants.font
        label.textColor = Constants.textColor
        label.textAlignment = .center
        label.clipsToBounds = true
        label.layer.cornerRadius = 8.0
        label.layer.borderColor = Constants.borderColorNormalState.cgColor
        label.layer.borderWidth = 1.0
        label.backgroundColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
        label.widthAnchor.constraint(equalToConstant: 44.0).isActive = true
        return label
    }
    
    func setCode(at index: Int, state: State) {
        var boardColor: UIColor
        
        switch state {
        case .normal:
            boardColor = Constants.borderColorNormalState
        case .active:
            boardColor = Constants.borderColorActiveState
        case .error:
            boardColor = Constants.borderColorErrorState
        }
        
        labels[index].createBorder(1.0,
                                   color: boardColor)
    }
    
    func validateCode(code: String) {
        onTextChange?(code)
    }
    
    func set(state: State) {
        fieldState = state
    }
    
}

extension OTP {
    
    @discardableResult
    override func becomeFirstResponder() -> Bool {
        textField.becomeFirstResponder()
        return true
    }
    
    @discardableResult
    override func resignFirstResponder() -> Bool {
        return textField.resignFirstResponder()
    }
    
    @discardableResult
    func set(onTextChange: ((String) -> Void)?) -> Self {
        self.onTextChange = onTextChange
        return self
    }
    
}

extension OTP: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var newText = string
        
        newText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        
        let codeLength = newText.count
        guard codeLength <= digitCount else { return false }
        textField.text = newText
        
        func setTextToActiveBox() {
            for i in 0 ..< codeLength {
                let char = newText.substring(from: i, to: i)
                labels[i].text = char
                setCode(at: i, state: .active)
            }
        }
        
        func setTextToInactiveBox() {
            for i in codeLength ..< digitCount {
                labels[i].text = ""
                setCode(at: i, state: .normal)
            }
            
            if codeLength <= digitCount - 1 {
                setCode(at: codeLength, state: .normal)
            }
        }
        
        setTextToActiveBox()
        setTextToInactiveBox()
        
        if codeLength == digitCount {
            validateCode(code: textField.text!)
            fieldState = .active
        }
        
        return false
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        onTextChange?(textField.text ?? "")
    }
    
    func isHiddenError(_ isHidden: Bool, with errorString: String? = nil) {
        self.errorLabel.text = errorString
        self.errorLabel.isHidden = isHidden
        self.errorLabel.alpha = isHidden ? 0 : 1
    }
}

//
//  ViewController.swift
//  OTPView
//
//  Created by Vladylav Filippov on 18.11.2021.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupOTP()
    }

    func setupOTP() {
        let otp = OTP(digitNumber: 6)
        
        otp.set(onTextChange: { text in
            self.showAlert(with: text)
        })
        
        otp.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(otp)
        
        NSLayoutConstraint.activate([
            otp.heightAnchor.constraint(equalToConstant: 48.0),
            otp.widthAnchor.constraint(equalToConstant: 312.0),
            otp.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            otp.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
    }
    
    func showAlert(with otp: String) {
        let alertVC = UIAlertController(title: "OTP Code: \(otp)", message: "Your otp code is correct", preferredStyle: .actionSheet)
        
        
        let action = UIAlertAction(title: "Send", style: .destructive, handler: {_ in
            alertVC.dismiss(animated: true)
        })
        
        alertVC.addAction(action)
        
        self.present(alertVC, animated: true, completion: nil)
    }

}


//
//  SettingsController.swift
//  Ten Timer
//
//  Created by ibrahim uysal on 13.02.2023.
//

import UIKit

class SettingsController: UIViewController {
    
    //MARK: - Properties
    
    private let timer: TenTimer
    
    private let timeTextField = UITextField()
    private let pickerView = UIPickerView()
    
    var minute = "10"
    var second = "10"
    
    let minutes = [00,01,02,03,04,05,06,07,08,09,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59]
    
    let seconds = [00,01,02,03,04,05,06,07,08,09,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59]
    
    //MARK: - Lifecycle
    
    init(timer: TenTimer) {
        self.timer = timer
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        style()
        layout()
    }
    
    //MARK: - Selectors
    
    @objc private func leftBarButtonPressed() {
        print("DEBUG: leftBarButtonPressed")
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func rightBarButtonPressed() {
        print("DEBUG: rightBarButtonPressed")
    }
    
    //MARK: - Helpers
    
    private func style(){
        view.backgroundColor = .systemGroupedBackground
        
        pickerView.delegate = self
        pickerView.dataSource = self
        timeTextField.inputView = pickerView
        timeTextField.translatesAutoresizingMaskIntoConstraints = false
        timeTextField.isSecureTextEntry = false // true
        timeTextField.placeholder = "lorem"
        timeTextField.backgroundColor = .systemGray3
        timeTextField.layer.cornerRadius = 8
        timeTextField.tintColor = .clear
        timeTextField.setLeftPaddingPoints(10)
    }
    
    private func layout(){
        view.addSubview(timeTextField)
        timeTextField.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,
                             right: view.rightAnchor, paddingTop: 16,
                             paddingLeft: 16, paddingRight: 16)
        timeTextField.setHeight(height: 50)
    }
    
    private func configureNavigationBar() {
        title = "\(timer.timerNumber+1)"
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        let leftBarButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self,
                                            action: #selector(leftBarButtonPressed))
        
        let rightBarButton = UIBarButtonItem(barButtonSystemItem: .save, target: self,
                                             action: #selector(rightBarButtonPressed))

        navigationItem.leftBarButtonItem = leftBarButton
        navigationItem.rightBarButtonItem = rightBarButton
        navigationController?.navigationBar.tintColor = .label
    }
}


//MARK: - UIPickerViewDelegate/DataSource

extension SettingsController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        timeTextField.text = "10'10\"10"
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return minutes.count
        } else {
            return seconds.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return "\(minutes[row])"
        } else {
            return "\(seconds[row])"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            minute = "\(minutes[row])"
        } else {
            second = "\(seconds[row])"
        }
        timeTextField.text = "\(minute)\"\(second)"
    }
}

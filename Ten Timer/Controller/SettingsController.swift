//
//  SettingsController.swift
//  Ten Timer
//
//  Created by ibrahim uysal on 13.02.2023.
//

import UIKit

protocol SettingsControllerDelegate: AnyObject {
    func reloadData()
}

class SettingsController: UIViewController {
    
    //MARK: - Properties
    
    private let timer: TTimer
    private let index: Int
    
    weak var delegate: SettingsControllerDelegate?
    
    private let lineView = UIView()
    
    private let titleTextField = UITextField()
    private let pickerView = UIPickerView()
    
    private let colorLabel = makeLabel(withText: "Color")
    private let colorButton = makeButton(withText: "")
    
    private let soundLabel = makeLabel(withText: "Sound")
    private lazy var soundButton = makeButton(withText: "\(soundArray[Int(timer.innerTimerArray[index].soundInt)].name)")
    
    private lazy var otherSettingsButton = UIButton()
    private lazy var removeButton = UIButton()
    
    private var hour = 0
    private var minute = 0
    private var second = 0
    
    //MARK: - Lifecycle
    
    init(timer: TTimer, index: Int) {
        self.timer = timer
        self.index = index
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        addGestureRecognizer()
        style()
        layout()
        configurePickerView()
    }
    
    //MARK: - Selectors
    
    @objc private func soundButtonPressed() {
        let controller = SoundsController(innerTimer: timer.innerTimerArray[index])
        controller.delegate = self
        controller.modalPresentationStyle = .formSheet
        present(controller, animated: true)
    }
    
    @objc private func colorButtonPressed() {
        let controller = ColorController(innerTimer: timer.innerTimerArray[index])
        controller.delegate = self
        controller.modalPresentationStyle = .formSheet
        present(controller, animated: true)
    }
    
    @objc private func deleteBarButtonPressed() {
        let alert = UIAlertController(title: nil, message: "Are you sure you want to delete?",
                                      preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            self.dismiss(animated: true) {
                TT.shared.removeInnerTimer(timer: self.timer, index: self.index)
                self.navigationController?.popViewController(animated: true)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }
    
    //MARK: - Helpers
    
    private func style(){
        view.backgroundColor = .systemGroupedBackground
        lineView.backgroundColor = .systemGray
        
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.backgroundColor = .systemGray4
        pickerView.setViewCornerRadius(10)
        
        titleTextField.placeholder = "Title"
        titleTextField.text = timer.innerTimerArray[index].title
        titleTextField.backgroundColor = .clear
        titleTextField.textAlignment = .center
        titleTextField.delegate = self
        titleTextField.setLeftPaddingPoints(8)
  
        let hex = colorArray[Int(timer.innerTimerArray[index].colorInt)].hex
        colorButton.backgroundColor = UIColor(hex: "#\(hex)")
        colorButton.addTarget(self, action: #selector(colorButtonPressed), for: .touchUpInside)
        
        soundButton.addTarget(self, action: #selector(soundButtonPressed), for: .touchUpInside)
        soundButton.contentHorizontalAlignment = .right
        soundButton.setTitleColor(.darkGray, for: .normal)
        
        otherSettingsButton.setTitle("Other Settings", for: .normal)
        otherSettingsButton.backgroundColor = .systemGray4
        otherSettingsButton.layer.cornerRadius = 10
        otherSettingsButton.setTitleColor(.label, for: .normal)
        otherSettingsButton.setImageWithRenderingMode(image: UIImage(named: "next"), width: 15, height: 15, color: .darkGray)
    }
    
    private func layout(){
        
        view.addSubview(lineView)
        lineView.setHeight(height: 1)
        lineView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor)
        
        view.addSubview(titleTextField)
        titleTextField.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor)
        titleTextField.setHeight(height: 50)
        
        view.addSubview(pickerView)
        pickerView.centerX(inView: view)
        pickerView.anchor(top: titleTextField.bottomAnchor, left: view.leftAnchor,
                          right: view.rightAnchor, paddingLeft: 16, paddingRight: 16)
        
        view.addSubview(colorButton)
        colorButton.anchor(top: pickerView.bottomAnchor, left: view.leftAnchor,
                           right: view.rightAnchor, paddingTop: 8, paddingLeft: 16, paddingRight: 16)
        colorButton.setHeight(height: 50)

        view.addSubview(colorLabel)
        colorLabel.centerY(inView: colorButton)
        colorLabel.anchor(left: colorButton.leftAnchor, paddingLeft: 16)

        view.addSubview(soundButton)
        soundButton.anchor(top: colorButton.bottomAnchor, left: view.leftAnchor,
                           right: view.rightAnchor, paddingTop: 8, paddingLeft: 16, paddingRight: 16)
        soundButton.setHeight(height: 50)

        view.addSubview(soundLabel)
        soundLabel.centerY(inView: soundButton)
        soundLabel.anchor(left: soundButton.leftAnchor, paddingLeft: 16)
        
        view.addSubview(otherSettingsButton)
        otherSettingsButton.anchor(top: soundButton.bottomAnchor, left: view.leftAnchor,
                                   right: view.rightAnchor, paddingTop: 8, paddingLeft: 16, paddingRight: 16)
        otherSettingsButton.setHeight(height: 50)
        otherSettingsButton.moveImageRight()
    }
    
    private func configureNavigationBar() {
        title = "\(timer.timerNumber+1).\(index+1)"
        navigationController?.navigationBar.topItem?.backButtonTitle = "Timers"
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.tintColor = .label
        
        let deleteBarButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteBarButtonPressed))
        
        navigationItem.rightBarButtonItem = index == 0 ? UIBarButtonItem() : deleteBarButton
    }
    
    private func configurePickerView() {
        let timeInt = TT.shared.getTimeInt(Int(timer.innerTimerArray[index].seconds))
        hour = timeInt.0
        minute = timeInt.1
        second = timeInt.2
        
        pickerView.selectRow(hour, inComponent: 0, animated: true)
        pickerView.selectRow(minute, inComponent: 1, animated: true)
        pickerView.selectRow(second, inComponent: 2, animated: true)
    }
    
    private func checkZero() {
        if hour == 0 && minute == 0 && second == 0 {
            second = 1
            pickerView.selectRow(second, inComponent: 2, animated: true)
        }
    }
}

//MARK: - UITextFieldDelegate

extension SettingsController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        TT.shared.updateInnerTimerTitle(timer: timer, index: index, newTitle: text)
        delegate?.reloadData()
    }
}


//MARK: - UIPickerViewDelegate/DataSource

extension SettingsController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return hours.count
        } else if component == 1 {
            return minutes.count
        } else {
            return seconds.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return "\(hours[row]) hour"
        } else if component == 1 {
            return "\(minutes[row]) min"
        } else {
            return "\(seconds[row]) sec"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            hour = hours[row]
        } else if component == 1 {
            minute = minutes[row]
        } else {
            second = seconds[row]
        }
        checkZero()
        let newTotalSeconds = (hour*3600) + (minute*60) + second
        TT.shared.updateInnerTimerSeconds(timer: timer, index: index, seconds: newTotalSeconds)
        delegate?.reloadData()
    }
}

//MARK: - Swipe Gesture

extension SettingsController {
    func addGestureRecognizer(){
        hideKeyboardWhenTappedAround()
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeRightGesture))
        swipeRight.direction = .right
        
        view.addGestureRecognizer(swipeRight)
    }
    
    @objc func respondToSwipeRightGesture(gesture: UISwipeGestureRecognizer) {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: - SoundsControllerDelegate

extension SettingsController: SoundsControllerDelegate {
    func updateSound(newSoundInt: Int) {
        TT.shared.updateInnerTimerSound(innerTimer: timer.innerTimerArray[index], newSoundInt: newSoundInt)
        soundButton.setTitle("\(soundArray[newSoundInt].name)", for: .normal)
    }
}

//MARK: - ColorControllerDelegate

extension SettingsController: ColorControllerDelegate {
    func updateColor(newColorInt: Int) {
        TT.shared.updateInnerTimerColor(innerTimer: timer.innerTimerArray[index],
                                        newColorInt: newColorInt)
        let hex = colorArray[newColorInt].hex
        colorButton.backgroundColor = UIColor(hex: "#\(hex)")
    }
}

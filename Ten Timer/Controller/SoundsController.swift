//
//  SoundsController.swift
//  Ten Timer
//
//  Created by ibrahim uysal on 16.02.2023.
//

import UIKit
import AVFoundation

protocol SoundsControllerDelegate: AnyObject {
    func updateSound(newSoundInt: Int)
}

private let reuseIdentifier = "SoundCell"

class SoundsController: UIViewController {
    
    //MARK: - Properties
    
    private let innerTimer: InnerTimer
    weak var delegate: SoundsControllerDelegate?
    
    private let lineView = UIView()
    private let dismissButton = UIButton()
    private let vibrateLabel = makePaddingLabel(withText: "Vibrate")
    private let vibrateSwitch = makeSwitch(isOn: true)
    private let tableView = UITableView()
    
    //MARK: - Lifecycle
    
    init(innerTimer: InnerTimer) {
        self.innerTimer = innerTimer
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        layout()
        configureSelectedSound()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Player.shared.stopSound()
    }
    
    //MARK: - Selectors
    
    @objc private func vibrateChanged(sender: UISwitch) {
        if sender.isOn {
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
        TT.shared.updateInnerTimerVibrate(innerTimer: innerTimer, isVibrate: sender.isOn)
    }
    
    @objc private func dismissView() {
        dismiss(animated: true)
    }
    
    //MARK: - Helpers
    
    private func configureSelectedSound() {
        resetCheckmark()
        soundArray[Int(innerTimer.soundInt)].selected = true
        tableView.reloadData()
    }
    
    private func resetCheckmark() {
        for i in 0..<soundArray.count {
            soundArray[i].selected = false
        }
    }
    
    private func style(){
        view.backgroundColor = .systemGroupedBackground
        
        lineView.backgroundColor = .darkGray
        lineView.setDimensions(height: 6, width: 50)
        lineView.layer.cornerRadius = 3
        
        dismissButton.backgroundColor = .clear
        dismissButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        
        vibrateLabel.backgroundColor = .systemGray4
        vibrateLabel.layer.masksToBounds = true
        vibrateLabel.layer.cornerRadius = 10
        vibrateLabel.setHeight(height: 50)
        
        vibrateSwitch.isOn = innerTimer.isVibrate
        vibrateSwitch.addTarget(self, action: #selector(vibrateChanged), for: .valueChanged)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(SoundCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .clear
        tableView.layer.cornerRadius = 10
    }
    
    private func layout(){
        view.addSubview(lineView)
        lineView.centerX(inView: view)
        lineView.anchor(top: view.topAnchor, paddingTop: 16)
        
        let stack = UIStackView(arrangedSubviews: [vibrateLabel, tableView])
        stack.spacing = 16
        stack.axis = .vertical
        
        view.addSubview(stack)
        stack.anchor(top: lineView.bottomAnchor, left: view.leftAnchor,
                     bottom: view.bottomAnchor, right: view.rightAnchor,
                     paddingTop: 16, paddingLeft: 16, paddingBottom: 16, paddingRight: 16)
        
        stack.addSubview(vibrateSwitch)
        vibrateSwitch.centerY(inView: vibrateLabel)
        vibrateSwitch.anchor(right: vibrateLabel.rightAnchor, paddingRight: 16)
        
        view.addSubview(dismissButton)
        dismissButton.anchor(top: view.topAnchor, left: view.leftAnchor,
                             bottom: stack.topAnchor, right: view.rightAnchor)
    }
}

//MARK: - UITableViewDataSource

extension SoundsController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return soundArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SoundCell
        cell.sound = soundArray[indexPath.row]
        return cell
    }
}

//MARK: - UITableViewDelegate

extension SoundsController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.updateSound(newSoundInt: indexPath.row)
        
        let sound = soundArray[indexPath.row]
        Player.shared.play(sound: sound)
        
        resetCheckmark()
        soundArray[indexPath.row].selected = true
        tableView.reloadData()
    }
}

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
    
    private let timer: TTimer
    weak var delegate: SoundsControllerDelegate?
    
    private let lineView = UIView()
    
    private let vibrateLabel = makePaddingLabel(withText: "Vibrate")
    private let vibrateSwitch = makeSwitch(isOn: true)
    
    private let tableView = UITableView()
    
    //MARK: - Lifecycle
    
    init(timer: TTimer) {
        self.timer = timer
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
        UDM.setValue(sender.isOn, UDM.isVibrate)
    }
    
    //MARK: - Helpers
    
    private func configureSelectedSound() {
        resetCheckmark()
        soundArray[Int(timer.soundInt)].selected = true
        tableView.reloadData()
    }
    
    private func resetCheckmark() {
        for i in 0..<soundArray.count {
            soundArray[i].selected = false
        }
    }
    
    private func style(){
        lineView.backgroundColor = .darkGray
        lineView.setDimensions(height: 6, width: 50)
        lineView.layer.cornerRadius = 3
        
        vibrateLabel.backgroundColor = .systemBackground
        vibrateLabel.layer.masksToBounds = true
        vibrateLabel.layer.cornerRadius = 10
        
        vibrateSwitch.isOn = UDM.getBoolValue(UDM.isVibrate)
        vibrateSwitch.addTarget(self, action: #selector(vibrateChanged), for: .valueChanged)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(SoundCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .clear
        tableView.setViewCornerRadius(10)
    }
    
    private func layout(){
        view.backgroundColor = .systemGroupedBackground
        
        view.addSubview(lineView)
        lineView.centerX(inView: view)
        lineView.anchor(top: view.topAnchor, paddingTop: 16)
        
        view.addSubview(vibrateLabel)
        vibrateLabel.anchor(top: lineView.bottomAnchor, left: view.leftAnchor,
                            right: view.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingRight: 16)
        vibrateLabel.setHeight(height: 50)
        
        view.addSubview(vibrateSwitch)
        vibrateSwitch.anchor(right: vibrateLabel.rightAnchor, paddingRight: 16)
        vibrateSwitch.centerY(inView: vibrateLabel)
        
        view.addSubview(tableView)
        tableView.anchor(top: vibrateLabel.bottomAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor,              right: view.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingBottom: 16, paddingRight: 16)
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

//
//  TimerController.swift
//  Ten Timer
//
//  Created by ibrahim uysal on 14.02.2023.
//

import UIKit
import AudioToolbox
import NotificationCenter

enum StopOptions {
    case auto
    case user
}

enum TimerMode {
    case all
    case single
}

class TimerController: UIViewController {
    
    //MARK: - Properties
    
    private let timer: TTimer
    
    private let stopButton = UIButton()
    private let timerView = UIView()
    private var timeR = Timer()
    private var timerCounter: CGFloat = UDM.getCGFloatValue(UDM.currentTimerCounter)+1
    private var totalSecond: CGFloat = 0
    let notificationCenter = UNUserNotificationCenter.current()
    
    var currentTimer: Int = UDM.getIntValue(UDM.currentTimer)
    var timerMode: TimerMode = .all
    
    var viewArray: [UIView] = []
    var secondsArray: [Int] = []
    var compoundSecondsArray: [Int] = []
    
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
        configureNavigationBar()
        configureViews()
        style()
        layout()
        
        self.timeR = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            self.handleTimer()
        })
    }
    
    //MARK: - Selectors
    
    @objc private func stopButtonPressed() {
        handleStop(.user)
    }
    
    //MARK: - Helpers
    
    private func handleTimer() {
        timerCounter += 1
        
        if UIApplication.shared.applicationState != .active {
            setNotification(remindSecond: totalSecond-(timerCounter-1))
        } else {
            if timerCounter > totalSecond {
                handleStop()
            } else {
                checkIfInnerTimerCompleted()
                handleAnimation()
                stopButton.setTitle("\(Int(totalSecond-timerCounter+1))", for: .normal)
            }
        }
    }
    
    private func checkIfInnerTimerCompleted() {
        if timerMode == .all {
            if Int(timerCounter) > compoundSecondsArray[currentTimer] {
                let sound = soundArray[Int(timer.innerTimerArray[currentTimer].soundInt)]
                Player.shared.play(sound: sound)
                currentTimer += 1
            }
        }
    }
    
    private func handleAnimation() {
        if timerMode == .single {
            timerView.setHeightWithAnimation(view.bounds.height/totalSecond*timerCounter, animateTime: 1.5)
        } else {
            let second = CGFloat(secondsArray[currentTimer])
            var timerCounter = self.timerCounter
            
            if currentTimer > 0 {
                timerCounter = self.timerCounter - CGFloat(compoundSecondsArray[currentTimer-1])
            }
            
            viewArray[currentTimer].setHeightWithAnimation(view.bounds.height/second*timerCounter, animateTime: 1.5)
        }
    }
    
    private func handleStop(_ stopOption: StopOptions? = .auto) {
        timeR.invalidate()
        if stopOption == .auto {
            if UDM.getBoolValue(UDM.isVibrate) {
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            }
            
            let sound = soundArray[Int(timer.innerTimerArray[currentTimer].soundInt)]
            Player.shared.play(sound: sound)
        }
        navigationController?.popViewController(animated: false)
    }
    
    //MARK: - Notification
    
    func getNotificationSound() -> UNNotificationSound? {
        let timerSoundInt = Int(timer.innerTimerArray[currentTimer].soundInt)
        switch timerSoundInt {
        case 0:
            return nil
        case 1:
            return UNNotificationSound.default
        default:
            let soundName = soundArray[timerSoundInt].id
            return UNNotificationSound(named: UNNotificationSoundName(rawValue: "\(soundName).m4a"))
        }
    }
    
    func setNotification(remindSecond: CGFloat){
        handleStop(.user)
        if remindSecond > 0 {
            
            UDM.setValue(timerCounter, UDM.lastTimerCounter)
            UDM.setValue(currentTimer, UDM.currentTimer)
            UDM.setValue(Date(), UDM.currentNotificationDate)
            UDM.setValue(timer.timerNumber, UDM.selectedTimerIndex)
            self.notificationCenter.removeAllPendingNotificationRequests()
            
            if compoundSecondsArray.count == 1 {
                let content = UNMutableNotificationContent()
                content.title = "\(timer.timerNumber): Completed"
                content.sound = getNotificationSound()
                
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: remindSecond, repeats: false)
                let id = UUID().uuidString
                let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
                
                self.notificationCenter.add(request) { (error) in
                    if(error != nil){
                        print("Error " + error.debugDescription)
                        return
                    }
                }
            } else {
                for i in currentTimer..<compoundSecondsArray.count {
                    let newRemindSecond = CGFloat(compoundSecondsArray[i]) - ((timerCounter)-1)
                    currentTimer = i //sound
                    
                    if newRemindSecond > 0 {
                        let content = UNMutableNotificationContent()
                        content.title = "\(timer.timerNumber+1).\(i+1): Completed"
                        content.sound = getNotificationSound()
                        
                        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: newRemindSecond, repeats: false)
                        let id = UUID().uuidString
                        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
                        
                        self.notificationCenter.add(request) { (error) in
                            if(error != nil){
                                print("Error " + error.debugDescription)
                                return
                            }
                        }
                    }
                }
            }
        }
    }
    
    //MARK: - UI
    
    private func configureViews() {
        if timerMode == .all {
            let innerTimerArray = timer.innerTimerArray
            for i in 0..<innerTimerArray.count {
                let newView = UIView()
                newView.backgroundColor = UIColor(hex: "#\(colorArray[Int(innerTimerArray[i].colorInt)].hex)")
                secondsArray.append(Int(innerTimerArray[i].seconds))
                compoundSecondsArray.append(i)
                viewArray.append(newView)
            }
            for i in 0..<secondsArray.count {
                for j in 0...i {
                    compoundSecondsArray[i] += secondsArray[j]
                }
                compoundSecondsArray[i] -= i
            }
        }
    }
    
    private func style(){
        view.backgroundColor = .systemGroupedBackground
        
        if timerMode == .all {
            totalSecond = CGFloat(timer.totalSeconds)
        } else {
            totalSecond = CGFloat(timer.innerTimerArray[currentTimer].seconds)
        }
        
        let hex = colorArray[Int(timer.innerTimerArray[currentTimer].colorInt)].hex
        timerView.backgroundColor = UIColor(hex: "#\(hex)")
        
        stopButton.setTitle("\(Int(totalSecond))", for: .normal)
        stopButton.titleLabel?.font = UIFont(name: Fonts.AvenirNextDemiBold, size: 23)
        stopButton.backgroundColor = .systemRed
        stopButton.setTitleColor(.white, for: .normal)
        stopButton.layer.borderWidth = 6
        stopButton.layer.borderColor = UIColor.white.cgColor
        stopButton.setDimensions(height: 90, width: 90)
        stopButton.layer.cornerRadius = 90 / 2
        stopButton.addTarget(self, action: #selector(stopButtonPressed), for: .touchUpInside)
    }
    
    private func layout(){
        view.addSubview(timerView)
        timerView.anchor(bottom: view.bottomAnchor)
        timerView.setWidth(width: view.frame.width)
        timerView.setHeight(height: 0)
        
        for i in 0..<viewArray.count {
            view.addSubview(viewArray[i])
            viewArray[i].setHeight(height: 0)
            viewArray[i].setWidth(width: view.bounds.width/CGFloat(viewArray.count))
            if i == 0 {
               viewArray[i].anchor(left: view.leftAnchor, bottom: view.bottomAnchor)
            } else {
               viewArray[i].anchor(left: viewArray[i-1].rightAnchor, bottom: view.bottomAnchor)
            }
       }
        
        view.addSubview(stopButton)
        stopButton.centerY(inView: view)
        stopButton.centerX(inView: view)
    }
    
    private func configureNavigationBar() {
        title = timerMode == .all ? "\(timer.timerNumber+1)" : "\(timer.timerNumber+1).\(timer.innerTimerArray[currentTimer].timerNumber+1)"
        navigationItem.leftBarButtonItem = UIBarButtonItem()
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
    }
}

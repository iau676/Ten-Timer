//
//  TimerController.swift
//  Ten Timer
//
//  Created by ibrahim uysal on 14.02.2023.
//

import UIKit
import AVFoundation
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
    var timerMode: TimerMode = .all
    var currentTimer: Int = UDM.getIntValue(UDM.currentTimer)
    
    private let stopButton = UIButton()
    private let timerView = UIView()
    private let timerTitleLabel = UILabel()
    
    private var timeR = Timer()
    private var timerCounter: CGFloat = UDM.getCGFloatValue(UDM.currentTimerCounter)+1
    private lazy var totalSecond: CGFloat = timerMode == .all ? CGFloat(timer.totalSeconds) :
                                                                CGFloat(timer.innerTimerArray[currentTimer].seconds)
    
    private var titleForNotification: String = ""
    private var viewArray: [UIView] = []
    private var secondsArray: [Int] = []
    private var compoundSecondsArray: [Int] = []
    
    private let notificationCenter = UNUserNotificationCenter.current()
    
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
        startTimer()
        configureNavigationBar()
        style()
        layout()
        addObserver()
    }
    
    //MARK: - Selectors
    
    @objc private func stopButtonPressed() {
        handleStop(.user)
    }
    
    @objc func appMovedToBackground() {
        setNotification(remindSecond: totalSecond-(timerCounter-1))
    }
    
    @objc private func handleNotification() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }
    
    @objc private func handleMute() {
        showAlert(title: "", errorMessage: "Please increase the volume to hear sounds.")
        navigationItem.leftBarButtonItem = UIBarButtonItem()
    }
    
    //MARK: - Helpers
    
    private func startTimer() {
        self.timeR = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            self.handleTimer()
        })
    }
    
    private func handleTimer() {
        timerCounter += 1
        if timerCounter > totalSecond {
            stopButton.isHidden = true
            showCompletedAlert()
            handleStop()
        } else {
            checkIfInnerTimerCompleted()
            handleAnimation()
            let second = Int(totalSecond-timerCounter+1)
            let secondStr = TT.shared.getTimeString(second)
            stopButton.setTitle("\(secondStr)", for: .normal)
        }
    }
    
    private func checkIfInnerTimerCompleted() {
        if timerMode == .all {
            if Int(timerCounter) > compoundSecondsArray[currentTimer] {
                playSound()
                currentTimer += 1
                updateTitles()
            }
        }
    }
    
    private func playSound() {
        let innerTimer = timer.innerTimerArray[currentTimer]
        if innerTimer.isVibrate { AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate)) }

        let sound = soundArray[Int(innerTimer.soundInt)]
        Player.shared.play(sound: sound)
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
        NotificationCenter.default.removeObserver(self)
        if stopOption == .auto {
            playSound()
        } else {
            showStopAlert()
        }
    }
    
    private func showStopAlert() {        
        let alert = UIAlertController(title: "Are you sure you want to stop timer?", message: "", preferredStyle: .alert)
        let actionStop = UIAlertAction(title: "Stop", style: .destructive) { (action) in
            self.navigationController?.popViewController(animated: true)
        }
        let actionContinue = UIAlertAction(title: "Continue", style: UIAlertAction.Style.cancel) { (action) in
            self.startTimer()
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(actionStop)
        alert.addAction(actionContinue)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showCompletedAlert() {
        showAlert(title: "Timer Completed", errorMessage: "") { OKpressed in
            Player.shared.stopSound()
            self.navigationController?.popViewController(animated: false)
        }
    }
    
    private func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(appMovedToBackground),
                                               name: UIApplication.willResignActiveNotification, object: nil)
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
    
    func setNotification(remindSecond: CGFloat) {
        timeR.invalidate()
        self.navigationController?.popToRootViewController(animated: false)
        if remindSecond > 0 {
            UDM.setValue(timerCounter, UDM.lastTimerCounter)
            UDM.setValue(currentTimer, UDM.currentTimer)
            UDM.setValue(Date(), UDM.currentNotificationDate)
            UDM.setValue(timer.timerNumber, UDM.selectedTimerIndex)
            self.notificationCenter.removeAllPendingNotificationRequests()
            
            if timerMode == .all {
                for i in currentTimer..<compoundSecondsArray.count {
                    let newRemindSecond = CGFloat(compoundSecondsArray[i]) - ((timerCounter)-1)
                    currentTimer = i //sound
                    
                    if newRemindSecond > 0 {
                        let content = UNMutableNotificationContent()
                        
                        if secondsArray.count > 1 {
                            content.title = "\(titleForNotification).\(i+1): Completed"
                        } else {
                            content.title = "\(titleForNotification): Completed"
                        }
                        
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
            } else {
                let content = UNMutableNotificationContent()
                content.title = "\(titleForNotification): Completed"
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
        
        //update current timer for relaunch
         for i in 0..<compoundSecondsArray.count {
             if Int(timerCounter) > compoundSecondsArray[i] {
                 currentTimer = i+1
             }
         }
        
        if currentTimer > 0 && timerMode == .all {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
                for i in 0...self.currentTimer {
                    self.viewArray[i].setHeightWithAnimation(self.view.bounds.height, animateTime: 1.5)
                }
            }
        }
    }
    
    private func style(){
        view.backgroundColor = .systemGroupedBackground
        
        configureViews()
     
        let hex = colorArray[Int(timer.innerTimerArray[currentTimer].colorInt)].hex
        timerView.backgroundColor = UIColor(hex: "#\(hex)")
        
        timerTitleLabel.numberOfLines = 0
        timerTitleLabel.textAlignment = .center
        
        stopButton.titleLabel?.numberOfLines = 1
        stopButton.titleLabel?.adjustsFontSizeToFitWidth = true
        stopButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        stopButton.setTitle("\(TT.shared.getTimeString(Int(totalSecond)))", for: .normal)
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
        
        view.addSubview(timerTitleLabel)
        timerTitleLabel.centerX(inView: view)
        timerTitleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,
                               right: view.rightAnchor, paddingLeft: 16, paddingRight: 16)
        
        view.addSubview(stopButton)
        stopButton.centerY(inView: view)
        stopButton.centerX(inView: view)
    }
    
    //MARK: - NavigationBar
    
    private func configureNavigationBar() {
        updateTitles()
        configureLeftBarButton()
        configureRightBarButton()
    }
    
    private func configureLeftBarButton() {
        let muteIV = makeImageView(height: 32, width: 32, image: Images.mute)
        
        let muteTap = UITapGestureRecognizer(target: self, action: #selector(handleMute))
        muteIV.addGestureRecognizer(muteTap)
        
        do {
            try AVAudioSession.sharedInstance().setActive(true)
            let vol = AVAudioSession.sharedInstance().outputVolume
            self.navigationItem.leftBarButtonItem = vol == 0.0 ? UIBarButtonItem(customView: muteIV) : UIBarButtonItem()
        } catch {
         print(error)
        }
    }
    
    private func configureRightBarButton() {
        let notificationIV = makeImageView(height: 32, width: 32, image: Images.notification)
        
        let ivTap = UITapGestureRecognizer(target: self, action: #selector(self.handleNotification))
        notificationIV.addGestureRecognizer(ivTap)
        
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            if settings.authorizationStatus != .authorized {
                DispatchQueue.main.async {
                    self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: notificationIV)
                }
            }
        }
    }
    
    private func updateTitles() {
        let currentInnerTimer = timer.innerTimerArray[currentTimer]
        if timerMode == .single {
            titleForNotification = "\(timer.timerNumber+1).\(currentInnerTimer.timerNumber+1)"
            title = titleForNotification
        } else {
            titleForNotification = "\(timer.timerNumber+1)"
            title = secondsArray.count > 1 ?
            "\(timer.timerNumber+1).\(currentInnerTimer.timerNumber+1)" :
            "\(timer.timerNumber+1)"
        }
        timerTitleLabel.text = currentInnerTimer.title
    }
}

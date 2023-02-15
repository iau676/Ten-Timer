//
//  HomeController.swift
//  Ten Timer
//
//  Created by ibrahim uysal on 13.02.2023.
//

import UIKit

private let reuseIdentifier = "TimerCell"

class HomeController: UIViewController {
    
    //MARK: - Properties
            
    fileprivate lazy var timerCV: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 8, left: 16, bottom: 0, right: 16)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .clear
        cv.register(TimerCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        return cv
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDefaultTimers()
        configureNavigationBar()
        style()
        layout()
        
        //it will run when user reopen the app after pressing home button
        NotificationCenter.default.addObserver(self, selector: #selector(self.checkTimer),
                                               name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    //MARK: - Selectors
    
    @objc func checkTimer() {
        TT.shared.checkIfThereIsNotification { ThereIsNotification in
            if ThereIsNotification {
                TT.shared.updateUserDefaultsForTimer()
                self.goTimer()
            }
        }
    }
    
    //MARK: - Helpers
    
    private func goTimer() {
        DispatchQueue.main.async {
            let timer = TT.shared.timerArray[UDM.getIntValue(UDM.selectedTimerIndex)]
            let controller = TimerController(timer: timer)
            controller.modalPresentationStyle = .overFullScreen
            //self.present(controller, animated: false)
            self.navigationController?.pushViewController(controller, animated: false)
        }
    }
    
    private func setDefaultTimers() {
        if UDM.getStringValue(UDM.currentVersion) == nil {
            UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert]) { _, _ in }
            UDM.setValue("1.0", UDM.currentVersion)
            for i in 0...9 {
                TT.shared.appendItem(i)
            }
        }
        TT.shared.loadTimers()
    }

    private func style(){
        view.backgroundColor = .systemGroupedBackground
    }
    
    private func layout(){
        view.addSubview(timerCV)
        timerCV.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,
                       bottom: view.bottomAnchor, right: view.rightAnchor)
    }
    
    private func configureNavigationBar() {
        title = "Ten Timer"
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
    }
}

//MARK: - UICollectionViewDelegate/DataSource

extension HomeController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return TT.shared.timerArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TimerCell
        cell.timer = TT.shared.timerArray[indexPath.row]
        cell.delegate = self
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        UDM.setValue(indexPath.row, UDM.selectedTimerIndex)
        UDM.setValue(0, UDM.currentTimerCounter)
        goTimer()
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension HomeController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.bounds.width-3*16+4)/2, height: (view.safeAreaLayoutGuide.layoutFrame.height-5*16)/5)
    }
}

//MARK: - TimerCellDelegate

extension HomeController: TimerCellDelegate {
    func settingsPressed(_ timer: TenTimer) {
        let controller = SettingsController(timer: timer)
        controller.modalPresentationStyle = .overFullScreen
        navigationController?.pushViewController(controller, animated: true)
    }
}

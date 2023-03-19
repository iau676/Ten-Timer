//
//  InnerTimerController.swift
//  Ten Timer
//
//  Created by ibrahim uysal on 20.02.2023.
//

import UIKit

private let reuseIdentifier = "InnerTimerCell"

class InnerTimerController: UIViewController {
    
    //MARK: - Properties
    
    private let timer: TTimer
    
    private let label = UILabel()
    
    fileprivate lazy var innerTimerCV: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 8, left: 16, bottom: 0, right: 16)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .clear
        cv.register(InnerTimerCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        return cv
    }()
    
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
        addGestureRecognizer()
        style()
        layout()
        checkInnerTimerCount()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        innerTimerCV.reloadData()
    }
    
    //MARK: - Selectors
    
    @objc private func addBarButtonPressed() {
        TT.shared.addInnerTimer(timer: timer)
        innerTimerCV.reloadData()
        showSettings(index: timer.innerTimerArray.count-1)
        checkInnerTimerCount()
    }
    
    //MARK: - Helpers
    
    private func checkInnerTimerCount() {
        if timer.innerTimerArray.count > 9 {
            navigationItem.setRightBarButton(nil, animated: false)
        }
    }
    
    private func style(){
        view.backgroundColor = .systemGroupedBackground
    }
    
    private func layout(){
        view.addSubview(label)
        label.centerX(inView: view)
        label.centerY(inView: view)
        
        view.addSubview(innerTimerCV)
        innerTimerCV.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,
                       bottom: view.bottomAnchor, right: view.rightAnchor)
    }
    
    func configureNavigationBar() {
        title = "\(timer.timerNumber+1)"
        navigationController?.navigationBar.topItem?.backButtonTitle = "Back"
        
        let addBarButton = UIBarButtonItem(barButtonSystemItem: .add,
                                           target: self,
                                           action: #selector(addBarButtonPressed))
        
        navigationItem.rightBarButtonItem = addBarButton
    }
}


//MARK: - UICollectionViewDelegate/DataSource

extension InnerTimerController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return timer.innerTimerArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! InnerTimerCell
        cell.innerTimer = timer.innerTimerArray[indexPath.row]
        cell.configureTimerNumber(timer: timer, number: indexPath.row)
        cell.delegate = self
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        UDM.setValue(timer.timerNumber, UDM.selectedTimerIndex)
        UDM.setValue(0, UDM.currentTimerCounter)
        UDM.setValue(0, UDM.currentTimer)
        UDM.setValue(true, UDM.fromInner)
        let controller = TimerController(timer: timer)
        controller.currentTimer = indexPath.row
        controller.timerMode = .single
        controller.modalPresentationStyle = .overFullScreen
        navigationController?.pushViewController(controller, animated: false)
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension InnerTimerController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.bounds.width-3*16+4)/2, height: (view.safeAreaLayoutGuide.layoutFrame.height-5*16)/5)
    }
}

//MARK: - Swipe Gesture

extension InnerTimerController {
    func addGestureRecognizer(){
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeRightGesture))
        swipeRight.direction = .right
        
        view.addGestureRecognizer(swipeRight)
    }
    
    @objc func respondToSwipeRightGesture(gesture: UISwipeGestureRecognizer) {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: - InnerTimerCellDelegate

extension InnerTimerController: InnerTimerCellDelegate {
    func showSettings(index: Int) {
        let controller = SettingsController(timer: timer, index: index)
        controller.modalPresentationStyle = .overFullScreen
        navigationController?.pushViewController(controller, animated: true)
    }
}

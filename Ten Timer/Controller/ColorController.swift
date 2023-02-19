//
//  ColorController.swift
//  Ten Timer
//
//  Created by ibrahim uysal on 17.02.2023.
//

import UIKit

protocol ColorControllerDelegate: AnyObject {
    func updateColor(newColorInt: Int)
}

private let reuseIdentifier = "ColorCell"

class ColorController: UIViewController {
    
    //MARK: - Properties
    
    private let timer: TTimer
    weak var delegate: ColorControllerDelegate?
    
    private let lineView = UIView()
    
    fileprivate lazy var colorCV: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .clear
        cv.register(ColorCell.self, forCellWithReuseIdentifier: reuseIdentifier)
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
        style()
        layout()
        configureSelectedColor()
    }
    
    //MARK: - Helpers
    
    private func configureSelectedColor() {
        resetCheckmark()
        colorArray[Int(timer.colorInt)].selected = true
        colorCV.reloadData()
    }
    
    private func resetCheckmark() {
        for i in 0..<colorArray.count {
            colorArray[i].selected = false
        }
    }
 
    private func style(){
        lineView.backgroundColor = .darkGray
        lineView.setDimensions(height: 6, width: 50)
        lineView.layer.cornerRadius = 3
    }
    
    private func layout(){
        view.backgroundColor = .systemGroupedBackground
        
        view.addSubview(lineView)
        lineView.centerX(inView: view)
        lineView.anchor(top: view.topAnchor, paddingTop: 16)
        
        view.addSubview(colorCV)
        colorCV.anchor(top: lineView.bottomAnchor, left: view.leftAnchor,
                       bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 16)
    }
}

//MARK: - UICollectionViewDelegate/DataSource

extension ColorController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colorArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ColorCell
        cell.color = colorArray[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.updateColor(newColorInt: indexPath.row)
        dismiss(animated: true)
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension ColorController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ((view.bounds.width)/4), height: ((view.bounds.width)/4))
    }
}

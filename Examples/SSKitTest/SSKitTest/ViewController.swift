//
//  ViewController.swift
//  SSKitTest
//
//  Created by SUU NGUYEN on 6/8/21.
//

import UIKit
import SSKit

struct QRCode{
    let name: String
    let provider: String
    let price: Double
    let code: String
}

class QRCodeGeneratorViewModel{
    public static let shared = QRCodeGeneratorViewModel()
    public private(set) var codeGenerator: SSQRCodeGenerator!
    
    private init(){
        self.codeGenerator = SSQRCodeGenerator()
    }
}

class QRCollectionViewCell: UICollectionViewCell{
    public static let identifier : String = "QRTableViewCell"
    private lazy var imageViewCode: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    @objc private func imageViewCodeOnTap(_ gesture: UITapGestureRecognizer){
        UIPasteboard.general.string = qrCode?.code
    }
    
    private lazy var labelName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var labelPrice: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var labelProvider: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var labelCode: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var imageViewProvider: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    public var qrCode: QRCode?{
        didSet{
            if let qrCode = qrCode,
               let ciImage = QRCodeGeneratorViewModel.shared.codeGenerator.image(with: qrCode.code.data(using: .utf8)!, outputImageSize: CGSize(width: UIScreen.main.bounds.width - 10, height: UIScreen.main.bounds.width - 10 )){
                self.imageViewCode.image = UIImage(ciImage: ciImage)
                
                self.labelCode.text = qrCode.code
                self.labelName.text = qrCode.name
                self.labelPrice.text = "\(qrCode.price)"
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initializeView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.initializeView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initializeView()
    }
    
    private func initializeView(){
        self.contentView.addSubview(self.imageViewCode)
        self.imageViewCode.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
        self.imageViewCode.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        self.imageViewCode.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
        self.imageViewCode.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        
        self.contentView.addSubview(self.labelPrice)
        self.labelPrice.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
        self.labelPrice.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor, constant: -50).isActive = true
        self.labelPrice.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
        self.labelPrice.heightAnchor.constraint(equalToConstant: 40).isActive = true
        self.contentView.addSubview(self.labelName)
        self.labelName.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
        self.labelName.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor, constant: 0).isActive = true
        self.labelName.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
        self.labelName.heightAnchor.constraint(equalToConstant: 40).isActive = true
        self.contentView.addSubview(self.labelProvider)
        
        self.contentView.addSubview(self.labelCode)
        
        self.contentView.addSubview(self.imageViewProvider)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(imageViewCodeOnTap))
        self.contentView.addGestureRecognizer(gesture)
    }
}

class ViewController: UIViewController {
    
    private lazy var qrCodes = [QRCode]()
    
    private lazy var collectionViewCodes: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.minimumLineSpacing = 0
        collectionViewLayout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(QRCollectionViewCell.self, forCellWithReuseIdentifier: QRCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializeView()
        self.initializeData()
    }

    private func initializeView(){
        self.view.addSubview(self.collectionViewCodes)
        self.collectionViewCodes.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        self.collectionViewCodes.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        self.collectionViewCodes.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        self.collectionViewCodes.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
    }
    
    private func initializeData(){
        for _ in 0..<20 {
//            let code = QRCode()
//            self.qrCodes.append(code)
        }
        DispatchQueue.main.async {
            self.collectionViewCodes.reloadData()
        }
        
    }

}

extension ViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.qrCodes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: QRCollectionViewCell.identifier, for: indexPath) as! QRCollectionViewCell
        cell.qrCode = qrCodes[indexPath.row]
        return cell
    }
}

extension ViewController: UICollectionViewDelegate{
    
}

extension ViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - 10, height: UIScreen.main.bounds.width/2 - 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

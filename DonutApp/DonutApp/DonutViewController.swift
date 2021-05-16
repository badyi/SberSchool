//
//  ViewController.swift
//  DonutApp
//
//  Created by badyi on 14.05.2021.
//

import UIKit

final class DonutViewController: UIViewController {
    
    lazy var donut: DonutView = {
        let view = DonutView(innerRadius: 50, color: .cyan)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("Next VC", for: .normal)
        button.backgroundColor = .red
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    
    @objc func buttonTapped() {
        navigationController?.pushViewController(SecondViewController(), animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    func configView() {
        view.backgroundColor = .gray
        view.addSubview(nextButton)
        view.addSubview(donut)
        
        nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nextButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        nextButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        donut.widthAnchor.constraint(equalToConstant: 200).isActive = true
        donut.heightAnchor.constraint(equalToConstant: 200).isActive = true
        donut.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        donut.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}


//
//  ViewController.swift
//  Currency
//
//  Created by Laurent Favard on 10/07/2018.
//  Copyright © 2018 Laurent Favard. All rights reserved.
//

import UIKit
import AVFoundation
import RxSwift
import RxCocoa

class CurrencyViewController: AncestorViewController {

    @IBOutlet weak var movableView: UIView!
    @IBOutlet weak var amountUpField: UITextField!
    @IBOutlet weak var amountDownField: UITextField!
    @IBOutlet weak var timeUKLabel: UILabel!
    
    private var viewModel = CurrencyViewModel()
    private static let kTimerPeriod = 1.0
    private var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.amountUpField.delegate = self
        self.amountDownField.delegate = self
        
        self.amountUpField.keyboardType = UIKeyboardType.decimalPad
        self.amountDownField.keyboardType = UIKeyboardType.decimalPad
        
        self.amountUpField.returnKeyType = UIReturnKeyType.default
        self.amountDownField.returnKeyType = UIReturnKeyType.default
        
        self.addRxObservers()
        
        self.addDoneButtonOnKeyboard(for: [self.amountUpField, self.amountDownField ])
        
        self.timer = Timer.scheduledTimer(timeInterval: CurrencyViewController.kTimerPeriod, target: self, selector:#selector(timerBody), userInfo: nil, repeats: true)

        self.timeUKLabel.text = "UK: \(Date().asTimeUK)"
        
        AudioServicesPlaySystemSound (1104)
    }

    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        self.initKeyboardObservers(withView: self.movableView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //  MARK: - RxObservers
    private func addRxObservers() {
        
        self.viewModel.amountUpOutput.asObservable().subscribe(onNext: {
            
            [unowned self] value in
            
            self.amountUpField.text = value
            
            
        } ).disposed(by: self.disposeBag)
        
        self.viewModel.amountDownOutput.asObservable().subscribe(onNext: {
            
            [unowned self] value in
            
            self.amountDownField.text = value
            
        } ).disposed(by: self.disposeBag)
    }

    @objc private func timerBody() {
        
        self.timeUKLabel.text = "UK: \(Date().asTimeUK)"
    }
    
    //  MARK: - IBAction functions
    @IBAction func amountUpEditBegin(_ sender: UITextField) {
        
        self.viewModel.amountUpInput.value = String.empty
        self.viewModel.amountDownInput.value = String.empty
        
        self.textFieldForKeyboard = self.amountUpField
    }
    
    @IBAction func amountUpChanged(_ sender: UITextField) {

        self.viewModel.amountUpInput.value = self.amountUpField.text ?? String.empty        
    }

    @IBAction func amountUpEditEnd(_ sender: UITextField) {
        
        self.viewModel.amountUpInput.value = self.amountUpField.text ?? String.empty
    }
    
    @IBAction func amountDownEditBegin(_ sender: UITextField) {
        
        self.viewModel.amountUpInput.value = String.empty
        self.viewModel.amountDownInput.value = String.empty
        
        self.textFieldForKeyboard = self.amountDownField
    }
    
    @IBAction func amountDownChanged(_ sender: UITextField) {
    
        self.viewModel.amountDownInput.value = self.amountDownField.text ?? String.empty
    }
    
    @IBAction func amountDownEditEnd(_ sender: UITextField) {
        
        self.viewModel.amountDownInput.value = self.amountDownField.text ?? String.empty
    }

}


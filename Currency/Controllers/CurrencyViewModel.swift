//
//  CurrencyViewModel
//  Currency
//
//  Created by Laurent Favard on 10/07/2018.
//  Copyright © 2018 Laurent Favard. All rights reserved.
//


import Foundation
import RxSwift

class CurrencyViewModel {

    //---------------------------------------------------------------------------------------------------------------------------------------------
    //  MARK: - Public Consts

    //---------------------------------------------------------------------------------------------------------------------------------------------
    //  MARK: - Public Variables

    var amountUpInput = Variable<String>(String.empty)
    var amountDownInput = Variable<String>(String.empty)
    
    var amountUpOutput = Variable<String>(String.empty)
    var amountDownOutput = Variable<String>(String.empty)

    //---------------------------------------------------------------------------------------------------------------------------------------------
    private let disposeBag = DisposeBag()

    //---------------------------------------------------------------------------------------------------------------------------------------------
    //  MARK: - Private Variables
    //---------------------------------------------------------------------------------------------------------------------------------------------

    init() {
        
        self.amountUpOutput.value = String.empty
        self.amountDownOutput.value = String.empty

        self.addRxObservers()
    }
    

    //---------------------------------------------------------------------------------------------------------------------------------------------
    //---------------------------------------------------------------------------------------------------------------------------------------------

    //  MARK: - RxObservers
    private func addRxObservers() {
        
        self.amountUpInput.asObservable().subscribe(onNext: {

            value in

            self.convertAmontUpToDown(from: value)
            
        } ).disposed(by: self.disposeBag)

        self.amountDownInput.asObservable().subscribe(onNext: {
            
            value in
            
            self.convertAmontDownToUp(from: value)

        } ).disposed(by: self.disposeBag)
    }

    /// --------------------------------------------------------------------------------------------------------------------------------------------
    /// ---------------------------------------------------------------------------------------------------------------------------------------------
  
    private func convertAmontUpToDown(from value:String) {
        
        self.amountUpOutput.value = value.fromNumberLocal ?? String.empty
        
        if let amount = Double( value ) {
            
            let amountDown = amount * 1.13
            
            print("value: \(amountDown)")
            self.amountDownOutput.value = amountDown.asPercentWithoutSymbol
        }
    }

    private func convertAmontDownToUp(from value:String) {
        
        self.amountDownOutput.value = value.fromNumberLocal ?? String.empty

        if let amount = Double( value ) {
            let amountUp = amount / 1.13
            
            print("value: \(amountUp)")
            self.amountUpOutput.value = amountUp.asPercentWithoutSymbol
        }
    }
}


//
//  AncestorViewController
//  Currency
//
//  Created by Laurent Favard on 10/07/2018.
//  Copyright © 2018 Laurent Favard. All rights reserved.
//



import UIKit
import RxSwift
import AVFoundation
import NVActivityIndicatorView

class AncestorViewController: UIViewController, UITextFieldDelegate {
    
    /// ---------------------------------------------------------------------------------------------------------------------------------------------
    var tapDismissKeyboard : UITapGestureRecognizer?
    
    var textFieldForKeyboard : UITextField?
    var activityIndicator : NVActivityIndicatorView?    //OSLActivityIndicatorView?
    
    private var movableKeyboardView : UIView?
    var observers = [NSObjectProtocol]()
    /// ---------------------------------------------------------------------------------------------------------------------------------------------
    let disposeBag = DisposeBag()
    
    /// ---------------------------------------------------------------------------------------------------------------------------------------------
       
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
    //  Good citizen...
    override func viewWillDisappear(_ animated: Bool) {
        
        if let tapDismissKeyboard = self.tapDismissKeyboard {
            
            self.view.removeGestureRecognizer(tapDismissKeyboard)
        }
        
        for observer in self.observers {
            
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
    /// ---------------------------------------------------------------------------------------------------------------------------------------------
    /// ---------------------------------------------------------------------------------------------------------------------------------------------

    /**
     Add programmaticaly an UIActivityIndicatorView
     */
    func addActivityIndicator(viewParent:UIView) {
        
        //  If not already created
        if self.activityIndicator == nil {
            
            let frame = CGRect(x: 0, y: 0, width: 64, height: 64)
            self.activityIndicator = NVActivityIndicatorView(frame: frame, type: .ballSpinFadeLoader, color: self.colorIMO(), padding: nil)
            
            //  Unwrap to manipulate easily
            if let activityIndicator = self.activityIndicator {

                //  Set my preferrences
                activityIndicator.translatesAutoresizingMaskIntoConstraints = false

                viewParent.addSubview(activityIndicator)

                //  finally add the constraints for the UI
                let horizontalConstraint = NSLayoutConstraint(item: activityIndicator, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: viewParent, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)

                let verticalConstraint = NSLayoutConstraint(item: activityIndicator, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: viewParent, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0)

                viewParent.addConstraint(horizontalConstraint)
                viewParent.addConstraint(verticalConstraint)

                viewParent.bringSubview(toFront: activityIndicator)
            }
        }
    }

    func delay(delay: Double, closure: @escaping () -> ()) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            closure()
        }
    }
    
    func appTitle() -> String {
    
        return (Bundle.main.infoDictionary![kCFBundleNameKey as String] as? String) ?? "Currency"
    }
    
    func colorIMO() -> UIColor {

        if #available(iOS 10.0, *) {

            //return UIColor(displayP3Red: 54.0, green: 152.0, blue: 254.0, alpha: 1.0)
            return UIColor.hexStringToUIColor(hex: "#3698FE")
        }
        else {

            return UIColor.blue
        }
    }
    
    func showAlert(forMessage message:String) {
        
        let alert  = UIAlertController(title: self.appTitle(), message: message, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "OK", style: .default, handler: nil ))

        self.present(alert, animated: true, completion: nil)
    }
    
    /// --------------------------------------------------------------------------------------------------------------------------------------------
    /// ---------------------------------------------------------------------------------------------------------------------------------------------
    
    //  MARK: - Keyboard handling


    func addDoneButtonOnKeyboard(for textFields:[UITextField]) {
        
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
        doneToolbar.barStyle       = UIBarStyle.default
        
        let flexSpaceLeft = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let flexSpaceRight = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem(title: "OK", style: UIBarButtonItemStyle.done, target: self, action: #selector(self.doneButtonAction))
        
        var items = [UIBarButtonItem]()
        items.append(flexSpaceLeft)
        items.append(done)
        items.append(flexSpaceRight)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        for textField in textFields {
         
            textField.inputAccessoryView = doneToolbar
        }
    }
    
    @objc private func doneButtonAction() {
        
        self.view.endEditing(true)
    }

    func initKeyboardObservers(withView keyboardView:UIView) {
        
        self.movableKeyboardView = keyboardView
        
        self.tapDismissKeyboard = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        if let tapDismissKeyboard = self.tapDismissKeyboard {
        
            tapDismissKeyboard.cancelsTouchesInView = false
            self.view.addGestureRecognizer(tapDismissKeyboard)
        }
        
        let notificationCenter = NotificationCenter.default
        let mainQueue = OperationQueue.main
        
        self.observers.append( notificationCenter.addObserver(forName: NSNotification.Name.UIKeyboardWillShow, object: nil, queue: mainQueue)
        {
            notification in
            
            self.keyboardWillShow(notification: notification)
        })
        
        self.observers.append( notificationCenter.addObserver(forName: NSNotification.Name.UIKeyboardWillHide, object: nil, queue: mainQueue)
        {
            notification in
            
            self.keyboardWillHide(notification: notification)
        })
    }
    
    @objc private func dismissKeyboard() {
        
        self.view.endEditing(true)
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            if let keyboardView = self.movableKeyboardView, keyboardView.frame.origin.y == 0 {
                
                if let textField = textFieldForKeyboard {
                
                    let yKeyboard = self.view.frame.size.height - keyboardSize.height
                    if let originField = textField.superview?.convert(textField.frame.origin, to: self.view)
                    {
                        let yField = originField.y + textField.frame.size.height

                        if yField > yKeyboard {
                            
                            let delta = (yField - yKeyboard) + 20               //  Add 20 px to have a nice space with the field
                            
                            //print("keyboardWillShow content: \(textField.text) with delta: \(delta)")
                            
                            keyboardView.frame.origin.y -= delta
                        }
                        else {
                            //  Moving the view is unuseful
                        }
                    }
                }
            }
        }
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        
        if let keyboardView = self.movableKeyboardView, keyboardView.frame.origin.y != 0 {
            
            keyboardView.frame.origin.y = 0
        }
    }

}

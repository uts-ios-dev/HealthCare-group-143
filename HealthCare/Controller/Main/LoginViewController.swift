import UIKit
import FirebaseAuth
import FirebaseAnalytics


class LoginViewController: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var loginButton: UIButton!
    
    
    //Move TextField when typing
    var activeTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changeLayout()
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        
        //Move TextField when typing
        let center: NotificationCenter = NotificationCenter.default;
        center.addObserver(self, selector: #selector(keyboardDidShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        center.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        self.hideKeyboard()
        
    }
    @objc func keyboardDidShow(notification: Notification){
        let info:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardSize = (info[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let keyboardY = self.view.frame.size.height - keyboardSize.height
        let editingTextFieldY:CGFloat! = self.activeTextField?.frame.origin.y
        //Checking if the textfield is really hidden behind the keyboard
        if editingTextFieldY > keyboardY-60{
            UIView.animate(withDuration: 0.25, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
                self.view.frame = CGRect(x:0, y:self.view.frame.origin.y - (editingTextFieldY! - (keyboardY - 60)), width: self.view.bounds.width, height: self.view.bounds.height)
            }, completion: nil)
        }
    }
    
    @objc func keyboardWillHide(notification: Notification){
        UIView.animate(withDuration: 0.25, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.view.frame = CGRect(x:0, y:0, width: self.view.bounds.width, height: self.view.bounds.height)
            }, completion: nil)
    }
    //When typeing in textfield
    func textFieldDidBeginEditing(_ textField: UITextField){
        activeTextField = textField
    }
    //press return key to hide keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name:UIResponder.keyboardWillShowNotification,object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func changeLayout(){
        bannerImageView.image = UIImage(named:"banner")
        logoImageView.image = UIImage(named: "logo")
        loginButton.layer.cornerRadius = 10.0
        loginButton.layer.masksToBounds = true 
    }
    
    @IBAction func loginView(_ sender: UIButton) {
        
        
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            if user != nil{
                    self.performSegue(withIdentifier: "loginHome", sender: self)
            }
            else{
                let title = "Error"
                var message = "Incorrect email or password"
                if(self.emailTextField.text! == ""){
                    message = "Please fill in your email address"
                }
                else if(self.passwordTextField.text! == ""){
                    message = "Please fill in your password"
                }
                
                let okTitle = "Dismiss"
                let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                let okButton = UIAlertAction(title: okTitle, style: .cancel, handler: nil)
                alert.addAction(okButton)
                
                self.present(alert,animated: true, completion: nil)
                
            }
        }
        
    }
    
    
    @IBAction func resetPassword(_ sender: UIButton) {
        performSegue(withIdentifier: "resetPassword", sender: self)
    }
    
}

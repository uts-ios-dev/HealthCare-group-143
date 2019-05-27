import UIKit
import FirebaseAuth
import FirebaseAnalytics

class ResetPasswordViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Reset Password"
        if(Auth.auth().currentUser != nil){
            emailTextField.text = Auth.auth().currentUser?.email
        }
        changeLayout()
        self.hideKeyboard()
    }
    
    func changeLayout(){
        saveButton.layer.cornerRadius = 10.0
        saveButton.layer.masksToBounds = true
    }
    
    @IBAction func saveDetails(_ sender: UIButton) {
        let password = passwordTextField.text
        let confirmPassword = confirmPasswordTextField.text
        if password!.count<6{
            let title = "Error"
            let message = "Password should have at least six characters"
            let okTitle = "Dismiss"
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okButton = UIAlertAction(title: okTitle, style: .cancel, handler: nil)
            alert.addAction(okButton)
            self.present(alert,animated: true, completion: nil)
        }
        if(password == confirmPassword){
            Auth.auth().currentUser?.updatePassword(to: password!) { (error) in
                if((error) != nil){
                    let title = "Error"
                    let message = "Error was happen \(error)"
                    let okTitle = "Dismiss"
                    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                    let okButton = UIAlertAction(title: okTitle, style: .cancel, handler: nil)
                    alert.addAction(okButton)
                    self.present(alert,animated: true, completion: nil)
                }
                else{
                    let title = "Successfully"
                    let message = "Your passowrd was updated successfully \n Please login again!"
                    let okTitle = "Logout"
                    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                    let okButton = UIAlertAction(title: okTitle, style: .cancel, handler: nil)
                    alert.addAction(okButton)
                    let firebaseAuth = Auth.auth()
                    do {
                        try firebaseAuth.signOut()
                    } catch let signOutError as NSError {
                        print ("Error signing out: %@", signOutError)
                    }
                    self.present(alert, animated: true, completion: {
                        
                        self.performSegue(withIdentifier: "backToLogin", sender: self)
                    })
                    
                }
            }
            
        }
        else{
            let title = "Error"
            let message = "Two passwords are not matched"
            let okTitle = "Dismiss"
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okButton = UIAlertAction(title: okTitle, style: .default, handler: nil)
            alert.addAction(okButton)
            
            self.present(alert,animated: true, completion: nil)
        }
    }
        
    

    @IBAction func cancelButton(_ sender: Any) {
        performSegue(withIdentifier: "backtoProfile", sender: self)
    }
}

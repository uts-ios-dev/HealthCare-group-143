import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseAnalytics
class LoginViewController: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var loginButton: UIButton!
    var userProfile:User?


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

    override func viewWillLayoutSubviews() {
        checkUser()
    }

    @objc func checkUser(){
        if Auth.auth().currentUser?.uid != nil{
            let role = UserDefaults.standard.string(forKey: "role")
            if(role == "doctor"){
                let vc = UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "DoctorView")
                let viewController = self
                // Present the view controller
                let currentViewController = UIApplication.shared.keyWindow?.rootViewController
                currentViewController?.dismiss(animated: true, completion: nil)

                if viewController.presentedViewController == nil {
                    currentViewController?.present(vc, animated: false, completion: nil)
                } else {
                    viewController.present(vc, animated: false, completion: nil)
                }
            }
            else{
                let vc = UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "homeViewController")
                let viewController = self
                // Present the view controller
                let currentViewController = UIApplication.shared.keyWindow?.rootViewController
                currentViewController?.dismiss(animated: true, completion: nil)

                if viewController.presentedViewController == nil {
                    currentViewController?.present(vc, animated: true, completion: nil)
                } else {
                    viewController.present(vc, animated: true, completion: nil)
                }
            }

        }
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
            let roleReference = Database.database().reference().child("User")
            if user != nil{
                let userID = Auth.auth().currentUser?.uid
                roleReference.child(userID!).child("role").observeSingleEvent(of: .value, with: { (snapshot) in
                    if let accountType = snapshot.value as? String{
                        if accountType == "user"{
                            UserDefaults.standard.set("user", forKey: "role")
                            self.performSegue(withIdentifier: "loginHome", sender: self)
                        }
                        if accountType == "doctor"{
                            UserDefaults.standard.set("doctor", forKey: "role")
                            self.performSegue(withIdentifier: "doctorHomeView", sender: self)
                        }
                    }
                })
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




    //Funciton when you click button on reset password
    @IBAction func resetPassword(_ sender: UIButton) {
        var title = "Forgot Password"
        var message = "Do you want to reset your password?"
        let email = emailTextField.text
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)


        //Check is email text field empty
        if(email != ""){
            self.present(alert,animated: true, completion: nil)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default) { (action) in
            })
            alert.addAction(UIAlertAction(title: "Yes", style: .default) { (action) in
                Auth.auth().sendPasswordReset(withEmail: email!) { error in
                    title = "Successfully!"
                    message = "Please check your inbox!"
                    let alert2 = UIAlertController(title: title, message: message, preferredStyle: .alert)
                    alert2.addAction(UIAlertAction(title: "Dismiss", style: .default))
                    self.present(alert2,animated: true, completion: nil)
                    if(error != nil){
                        message = "Error was happen \(error!)"
                        let alert2 = UIAlertController(title: title, message: message, preferredStyle: .alert)
                        alert2.addAction(UIAlertAction(title: "Dismiss", style: .default))
                        self.present(alert2,animated: true, completion: nil)
                    }
                }
            })
        }
        else{
            message = "Please enter your email address"
            let alert2 = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert2.addAction(UIAlertAction(title: "Dismiss", style: .default))
            self.present(alert2,animated: true, completion: nil)
        }
    }

    //Go to signup view
    @IBAction func SignupView(_ sender: UIButton) {
        performSegue(withIdentifier: "SignupView", sender: self)
    }

}

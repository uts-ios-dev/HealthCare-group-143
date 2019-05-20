import UIKit
import FirebaseDatabase
import Firebase

//Close the keyboard when click outside of textfield
extension UIViewController{
    func hideKeyboard(){
        let Tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DismissKeyboard))
        
        view.addGestureRecognizer(Tap)
    }
    
    @objc func DismissKeyboard(){
        view.endEditing(true)
    }
}

class RegistrationViewController: UIViewController ,UITextFieldDelegate{
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var dateOfBirthPicker: UIDatePicker!
    @IBOutlet weak var genderSegment: UISegmentedControl!
    @IBOutlet weak var registerButton: UIButton!
    
    var userReference:DatabaseReference!
    var dateString:String = ""
    var uid:String = ""
    
    //Move TextField when typing
    var activeTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLoggedUser()
        changeLayout()
        self.navigationItem.title = "Register"
        
        //Firebase Reference of User
        userReference = Database.database().reference().child("User")
        
        //Move TextField when typing
        self.emailTextField.delegate = self
        self.firstNameTextField.delegate = self
        self.lastNameTextField.delegate = self
        self.passwordTextField.delegate = self
        self.confirmPasswordTextField.delegate = self
        self.addressTextField.delegate = self
        self.phoneTextField.delegate = self
        let center: NotificationCenter = NotificationCenter.default;
        center.addObserver(self, selector: #selector(keyboardDidShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        center.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        self.hideKeyboard()
        
    }
    
    func checkLoggedUser(){
        if Auth.auth().currentUser?.uid == nil{
            
        }
        else{
            uid = Auth.auth().currentUser!.uid
        }
    }
    
    //Move TextField when typing
    @objc func keyboardDidShow(notification: Notification){
        let info:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardSize = (info[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let keyboardY = self.view.frame.size.height - keyboardSize.height
        let editingTextFieldY:CGFloat! = self.activeTextField?.frame.origin.y
        //Checking if the textfield is really hidden behind the keyboard
        if editingTextFieldY > keyboardY - 60{
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
        registerButton.layer.cornerRadius = 10.0
        registerButton.layer.masksToBounds = true
    }
    
    @IBAction func datePicker(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = DateFormatter.Style.short
        dateString = dateFormatter.string(from: dateOfBirthPicker.date)
        
    }
    
    
    func addUser(uid: String){
        let genderString = genderSegment.titleForSegment(at: genderSegment.selectedSegmentIndex)!
        let user = ["uid": uid, "firstName": firstNameTextField.text!, "lastName": lastNameTextField.text!, "dateOfBirth": dateString, "gender": genderString, "address": addressTextField.text!, "phone": phoneTextField.text!, "email": emailTextField.text!]
        //let key = userReference.childByAutoId().key
        userReference.child(uid).setValue(user)
    }
    
    @IBAction func registerPage(_ sender: UIButton) {
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!){autoResult, error in
            if(autoResult != nil){
                self.uid = (autoResult?.user.uid)!
                self.addUser(uid: self.uid)
                self.performSegue(withIdentifier: "registerHome", sender: self)
            }
            else{
                let title = "Error"
                var message = "Error: + \(error!)"
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
                
                self.present(alert,animated: true, completion: nil)            }
        }
        
    }
    
}

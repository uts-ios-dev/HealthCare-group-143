import UIKit
import FirebaseDatabase
import Firebase

class EditProfileViewController: UIViewController ,UITextFieldDelegate{

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var dateOfBirthTextField: UITextField!
    @IBOutlet weak var genderTextField: UISegmentedControl!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!

    var userReference:DatabaseReference!
    var dateString:String = ""
    var uid:String = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Edit Profile"

        //Firebbase Reference of User
        checkLoggedUser()
        userReference = Database.database().reference().child("User").child(uid)
        changeLayout()
        getProfile()
        
        self.hideKeyboard()
    }

    //check whether login or not
    func checkLoggedUser(){
        if Auth.auth().currentUser?.uid == nil{

        }
        else{
            uid = Auth.auth().currentUser!.uid
        }
    }

    
    //change layout
    func changeLayout(){
        saveButton.layer.cornerRadius = 10.0
        saveButton.layer.masksToBounds = true

    }

    //Get user data from firebase
    func getProfile(){
        var userProfile:User?
        userReference?.observe(.value, with: { snapshot in

            print(snapshot.value as Any)
            if let dict = snapshot.value as? [String:Any],
                let _ = dict["uid"] as? String,
                let firstName = dict["firstName"] as? String,
                let lastName = dict["lastName"] as? String,
                let dateOfBirth = dict["dateOfBirth"] as? String,
                let gender = dict["gender"] as? String,
                let address = dict["address"] as? String,
                let phone = dict["phone"] as? String,
                let email = dict["email"] as? String,
                let role = dict["role"] as? String{

                userProfile = User(uid: snapshot.key, firstName: firstName, lastName: lastName, dateOfBirth: dateOfBirth, gender: gender, address: address, phone: phone, email: email, role: role)
                print(userProfile as Any)
                if(userProfile != nil){
                    self.firstNameTextField.text = userProfile?.firstName
                    self.lastNameTextField.text = userProfile?.lastName
                    self.dateOfBirthTextField.text = userProfile?.dateOfBirth
                    if(userProfile?.gender == "Female"){
                        self.genderTextField.selectedSegmentIndex = 1
                    }
                    else{
                        self.genderTextField.selectedSegmentIndex = 0
                    }
                    self.addressTextField.text = userProfile?.address
                    self.phoneTextField.text = userProfile?.phone
                    self.emailTextField.text = userProfile?.email
                }

            }
            })


    }
    
    
    @IBAction func backToHome(_ sender: UIButton) {
        performSegue(withIdentifier: "saveDetail", sender: self)
    }
    
    @IBAction func saveDetails(_ sender: UIButton) {
        let genderString = genderTextField.titleForSegment(at: genderTextField.selectedSegmentIndex)!
        let user = ["uid": uid, "firstName": firstNameTextField.text!, "lastName": lastNameTextField.text!, "dateOfBirth": dateOfBirthTextField.text!, "gender": genderString, "address": addressTextField.text!, "phone": phoneTextField.text!, "email": emailTextField.text!, "role": "user"]
        userReference.setValue(user)
        performSegue(withIdentifier: "saveDetail", sender: self)
    }
}

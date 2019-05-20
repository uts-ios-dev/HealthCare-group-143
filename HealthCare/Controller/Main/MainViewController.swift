import UIKit
import FirebaseAuth
import FirebaseAnalytics

class MainViewController: UIViewController {

    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var signupButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
//        checkLoggedUser()
        changeLayout()
        self.navigationItem.title = "Health Care"
    }

    func changeLayout(){
        bannerImageView.image = UIImage(named:"banner")
        logoImageView.image = UIImage(named: "logo")
        signupButton.layer.cornerRadius = 10.0
        signupButton.layer.masksToBounds = true
    }

    func checkLoggedUser(){
        if Auth.auth().currentUser?.uid != nil{//loggined
            //let uid = Auth.auth().currentUser?.uid
            let vc = UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "homeViewController") as! HomeViewController
            self.present(vc, animated: false, completion: nil)
        }
    }

    @IBAction func signupView(_ sender: UIButton) {
        performSegue(withIdentifier: "registerView", sender: self)
    }
    @IBAction func loginView(_ sender: UIButton) {
        performSegue(withIdentifier: "loginView", sender: self)
    }

}

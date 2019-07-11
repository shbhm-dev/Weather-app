

import UIKit



protocol changedCityDelegate {
    func userEnteredAnewCityName(cityName : String)
}


class ChangeCityViewController: UIViewController {
    
    

    var delegate : changedCityDelegate?
  
    @IBOutlet weak var changeCityTextField: UITextField!

    
    
    @IBAction func getWeatherPressed(_ sender: AnyObject) {
        
        
        
     
        
        let cityName = changeCityTextField.text!
        
        
        delegate?.userEnteredAnewCityName(cityName: cityName)
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    

    
    @IBAction func backButtonPressed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

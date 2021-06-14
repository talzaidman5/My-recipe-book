//
//  File.swift
//  My recipe book
//
//  Created by bobo on 13/06/2021.
//

import Foundation
import UIKit

class RecipeController: UIViewController{
    
    @IBOutlet weak var recipe_TXT_name: UILabel!
    @IBOutlet weak var recipe_TXT_type: UILabel!
    @IBOutlet weak var recipe_TXT_Ingredients: UITextView!
    @IBOutlet weak var recipe_images: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
          let name =  UserDefaults.standard.string(forKey: "name")
        recipe_TXT_name.text = name
    }
}

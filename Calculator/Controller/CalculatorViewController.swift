//  ViewController.swift
//  Calculator
//
//  Created by Ben Gohlke on 5/29/19.
//  Recreated by Alfredo Colon
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController{
    // MARK: - IBOutlets
    @IBOutlet weak var outputLabel: UILabel!
    @IBOutlet var buttonCollection: [UIButton]!
    @IBOutlet var scientificCalculatorStackViews: [UIStackView]!
    
    func updateButtons(){
        for button in buttonCollection{
//            button.frame.height = 50
//            button.frame.width = 50
            button.backgroundColor = .red
        }
    }
    var brain: CalculatorBrain?
    
    override func viewDidLoad() {
        //force load in portrait
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        super.viewDidLoad()
        brain = CalculatorBrain()
        // Hide Scientific Calculator
        hideScientificCalculator()
        // Track orientation Change
//        NotificationCenter.default.addObserver(self, selector: #selector(self.adjustViewForOrientation), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
//    deinit{
//        NotificationCenter.default.removeObserver(
//            self,
//            name: UIDevice.orientationDidChangeNotification,
//            object: nil)
//    }
    // Hide Scientific Calculator
    @objc func hideScientificCalculator(){
        for stackView in scientificCalculatorStackViews{
            stackView.isHidden = true
        }
    }
    // Hides scientific calculator buttons when in portrait orientaton
//    @objc func adjustViewForOrientation(){
//        let isInLandscapeOrientation = UIDevice.current.orientation.isLandscape
//        for stackView in scientificCalculatorStackViews{
//            stackView.isHidden = !isInLandscapeOrientation
//        }
//    }
//Functions Coming Soon!
//    @IBAction func functionTapped(_ sender: UIButton) {
//        if let functionName = sender.titleLabel?.text {
//            if let evaluatedFunction = brain?.evaluateFunction(functionName){
//                outputLabel.text = evaluatedFunction
//            }
//        }
//    }
    // MARK: - Action Handlers
    @IBAction func inverseSignPressed(_ sender: Any) {
        if (brain?.canInvertSign()) != nil{
            if let label: String = outputLabel.text{
                outputLabel.text = "-" + label
            }
        }
        else{
            outputLabel.text = "-0"
        }
    }
    @IBAction func percentageSignPressed(_ sender: Any) {
        if let validCase = brain?.addPercentage() {
            outputLabel.text = validCase
        }
    }
    @IBAction func decimalPressed(_ sender: Any) {
        brain?.addDecimal()
        outputLabel.text! += "."
    }
    @IBAction func operandTapped(_ sender: UIButton) {
        if let operandString = sender.titleLabel?.text {
                outputLabel.text = brain?.addOperandDigit(operandString)
            }
    }
    @IBAction func operatorTapped(_ sender: UIButton) {
        if let operatorString = sender.titleLabel?.text {
            // Sets operator
            if let _ = brain?.setOperator(operatorString){
                // Update precedence expression
                if let _ = brain?.updatePrecedence(operatorString: operatorString){
                    //display precedenceTotal
                    if let precedenceTotal = brain?.precedenceTotal{
                        if precedenceTotal != ""{
                            outputLabel.text = precedenceTotal
                        }
                    }
                }
                // Update expression
                brain?.updateExpression()
            }
        }
    }
    @IBAction func equalTapped(_ sender: UIButton) {
          if let result = brain?.calculateIfPossible(){
            outputLabel.text = result
        }
    }
    
    @IBAction func clearTapped(_ sender: UIButton) {
        clearTransaction()
        outputLabel.text = "0"
    }
    
    // MARK: - Private
    
    private func clearTransaction() {
        brain = nil
        brain = CalculatorBrain()
    }
}

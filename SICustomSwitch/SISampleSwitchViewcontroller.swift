//
//  SISampleSwitchViewcontroller.swift
//  SICustomSwitch
//
//  Created by Mohd Sazid Iqabal on 01/05/20.
//  Copyright © 2020 Sazid. All rights reserved.
//

import UIKit

class SISampleSwitchViewcontroller: UIViewController {
    
    @IBOutlet weak var switchFirst: SICustomeSwitchView!
    @IBOutlet weak var switchSecond: SICustomeSwitchView!
    @IBOutlet weak var switchThird: SICustomeSwitchView!
    @IBOutlet weak var switchFourth: SICustomeSwitchView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switchFirst.delegate = self
        switchSecond.delegate = self
        switchThird.delegate = self
        switchFourth.delegate = self
    }
}

extension SISampleSwitchViewcontroller: SICustomeSwitchViewDelegate {
    func didTap(_ siCustomeSwitchView: SICustomeSwitchView) {
        print(#function)
    }
    
    func animationDidStop(for siCustomeSwitchView: SICustomeSwitchView) {
        print(#function)
    }
    
    func valueDidChanged(_ siCustomeSwitchView: SICustomeSwitchView, on: Bool) {
        print(#function)
    }
}


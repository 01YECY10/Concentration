//
//  VCLLoggingViewController.swift
//  Concentration
//
//  Created by Vicatechnology on 1/02/22.
//

import UIKit

class VCLLoggingViewController: UIViewController {

    private struct LogGlobals {
        var prefix = ""
        var instanceCounts = [String: Int]()
        var lastLogTime = Date()
        var indentationInterval: TimeInterval = 1
        var indentationString = "__"
    }
    
    private static var logGlobals = LogGlobals()
    
    private static func logPrefix(for loggingName: String) -> String {
        if LogGlobals.lastLogTime.timeIntervalSinceNow < -LogGlobals.indentationInterval {
            LogGlobals.prefix += LogGlobals.indentationString
            print("")
        }
        LogGlobals.lastLogTime = Date()
        return LogGlobals.prefix + loggingName
    }
    
    private static func bumpInstanceCount(for loggingName: String) -> Int {
        LogGlobals.instanceCounts[loggingName] = (LogGlobals.instanceCounts[loggingName] ?? 0) + 1
        return LogGlobals.instanceCounts[loggingName]!
    }
    
    private var instanceCount: Int!
    
    var vclLoggingName: String {
        return String(describing: type(of: self))
    }
    
    private func logVCL(_ msg: String) {
        if instanceCount == nil {
            instanceCount = VCLLoggingViewController.bumpInstanceCount(for: vclLoggingName)
        }
        print("\(VCLLoggingViewController.logPrefix(for: vclLoggingName))(\(instanceCount!)) \(msg)")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        logVCL("init(coder:) - created via InterfaceBuilder")
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        logVCL("init(nibName: bundle:) - create in code")
    }
    
    deinit {
        logVCL("left the heap")
    }
    
    override func awakeFromNib() {
        logVCL("awakeFromNib()")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logVCL("viewDidLoad()")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        logVCL("viewWillAppear(animated = \(animated))")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        logVCL("viewDidAppear(animated = \(animated))")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        logVCL("viewWillDesappear(animated = \(animated))")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        logVCL("viewDidDisappear(animated = \(animated))")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        logVCL("didReceiveMemoryWarning()")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        logVCL("viewWillLayoutSubviews() bounds.size = \(view.bounds.size)")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        logVCL("viewDidLayoutSubviews() bounds.size = \(view.bounds.size)")
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        logVCL("viewWillTransition(to: \(size), width: coordinator)")
        coordinator.animate(alongsideTransition: { (context: UIViewControllerTransitionCoordinatorContext!) -> Void in self.logVCL("begin animate(alongsideTransition:completion:)")
            
        }, completion: { context -> Void in self.logVCL("end animate(alongsideTransition:completion:)")
            
        })
    }
}

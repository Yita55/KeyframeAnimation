//
//  ViewController.swift
//  KeyframeAnimation
//
//  Created by ZhangHS on 16/8/11.
//  Copyright © 2016年 ZhangHS. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var cloud1: UIImageView!
    @IBOutlet weak var cloud2: UIImageView!
    @IBOutlet weak var cloud3: UIImageView!
    @IBOutlet weak var cloud4: UIImageView!
    @IBOutlet weak var startStationLabel: UILabel!
    @IBOutlet weak var endStationLabel: UILabel!
    @IBOutlet weak var plane: UIImageView!

    let screenWidth = UIScreen.mainScreen().bounds.size.width

    enum Direction: Int {
        case Left = -1
        case Right = 1
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        cloudAnimate(cloud1)
        cloudAnimate(cloud2)
        cloudAnimate(cloud3)
        cloudAnimate(cloud4)
    }


    @IBAction func fly(sender: UIButton) {
        sender.userInteractionEnabled = false
        planeAir(plane, clickBtn: sender)
        let start = startStationLabel.text!
        let end = endStationLabel.text!
        moveLabel(startStationLabel, text: start, direction: .Left)
        moveLabel(endStationLabel, text: end, direction: .Right)
    }

    func cloudAnimate(cloud: UIImageView) {
        //保持漂动速度相等
        let cloudSpeed = 20/screenWidth
        let duration = Double( (screenWidth - CGRectGetMinX(cloud.frame)) * cloudSpeed)
        UIView.animateWithDuration(duration, delay: 0, options: .CurveLinear, animations: {
            cloud.frame.origin.x = self.screenWidth
            }, completion: {
                if $0 {
                    cloud.frame.origin.x = -CGRectGetWidth(cloud.bounds)
                    self.cloudAnimate(cloud)
                }
        })
    }

    func planeAir(airplane: UIImageView, clickBtn: UIButton?) {
        let originalCenter = plane.center
        UIView.animateKeyframesWithDuration(1.5, delay: 0.0, options: [], animations: {
            UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: 0.15, animations: {
                self.plane.center.x += 200.0
                self.plane.center.y -= 80.0
            })
            UIView.addKeyframeWithRelativeStartTime(0.15, relativeDuration: 0.3, animations: {
                self.plane.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI_4))
                self.plane.center.x += 150.0
                self.plane.center.y -= 100
                self.plane.alpha = 0.0
            })
            UIView.addKeyframeWithRelativeStartTime(0.51, relativeDuration: 0.01, animations: {
                self.plane.transform = CGAffineTransformIdentity
                self.plane.center = CGPoint(x: 0, y: originalCenter.y)
            })
            UIView.addKeyframeWithRelativeStartTime(0.55, relativeDuration: 0.45, animations: {
                self.plane.alpha = 1.0
                self.plane.center = originalCenter
            })
            }, completion: { _ in
                if let btn = clickBtn {
                    btn.userInteractionEnabled = true
                }
        })
    }

    func moveLabel(label: UILabel, text: String, direction: Direction) {
        let movePixel = 50
        UIView.animateWithDuration(0.5, delay: 0, options: [.CurveEaseOut, .AllowUserInteraction], animations: {
            label.alpha = 0
            label.transform = CGAffineTransformMakeTranslation(CGFloat(direction.rawValue * movePixel), 0)
            }, completion: { _ in
                label.text = text
                UIView.animateWithDuration(0.5, delay: 0, options: [.CurveEaseOut, .AllowUserInteraction], animations: {
                    label.alpha = 1
                    label.transform = CGAffineTransformIdentity
                    }, completion: nil)
        })
    }
}


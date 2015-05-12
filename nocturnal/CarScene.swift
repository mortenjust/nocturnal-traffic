//
//  GameScene.swift
//  gamexperiment
//
//  Created by Morten Just Petersen on 1/11/15.
//  Copyright (c) 2015 Morten Just Petersen. All rights reserved.
//

import SpriteKit

class CarScene: SKScene {
    
   // var carThreshold = 10
    
    var removeCarPool = 0
    var carEmitter = SKEmitterNode()
    var redCarEmitter = SKEmitterNode()
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        println("did move to view")
        self.backgroundColor = SKColor.clearColor()
        self.size = UIScreen.mainScreen().bounds.size
        
        self.physicsWorld.gravity = CGVectorMake(0, 0)
        
        //addCars(300)
        
        var carPath = NSBundle.mainBundle().pathForResource("Cars", ofType: "sks")
        carEmitter = NSKeyedUnarchiver.unarchiveObjectWithFile(carPath!) as SKEmitterNode
        
        
        carPath = NSBundle.mainBundle().pathForResource("CarsRed", ofType: "sks")
        redCarEmitter = NSKeyedUnarchiver.unarchiveObjectWithFile(carPath!) as SKEmitterNode
        
        
        var maxX = CGRectGetMaxX(self.frame)
        var midY = CGRectGetMidY(self.frame)
        var minX = CGRectGetMinX(self.frame)
        
      //  carEmitter.position = CGPointMake(maxX-(maxX*0.25), midY-(midY*0.35))
        carEmitter.position = CGPointMake(maxX+300, midY+(midY*0.50))
        self.addChild(carEmitter)
        
        redCarEmitter.position = CGPointMake(minX-300, midY-(midY*0.50))
        self.addChild(redCarEmitter)
        
    }
    
    func updateRedTravelTime(travelTime : Int, view : UILabel) {
        println("got red traveltime \(travelTime)")
        println("got traveltime \(travelTime)")
        
        var birthRate : CGFloat = pow(CGFloat(travelTime), 2.5) / 10000
        var accelerationX : CGFloat = pow(CGFloat(travelTime), -1.75) * 10000
        var accelerationY : CGFloat = accelerationX / 2
        
        self.redCarEmitter.particleBirthRate = birthRate
        self.redCarEmitter.xAcceleration = accelerationX/15
        self.redCarEmitter.yAcceleration = accelerationY/15
        view.text = "\(travelTime)m North"
        
    }
    
    func updateTravelTime(travelTime : Int, view : UILabel) {
        println("got white traveltime \(travelTime)")
        
        var birthRate : CGFloat = pow(CGFloat(travelTime), 2.5) / 10000
        var accelerationX : CGFloat = pow(CGFloat(travelTime), -1.75) * 10000
        var accelerationY : CGFloat = accelerationX / 2
        
        self.carEmitter.particleBirthRate = birthRate
        self.carEmitter.xAcceleration = -accelerationX/5
        self.carEmitter.yAcceleration = -accelerationY/5

        view.text = "\(travelTime)m South"

    }
    
    func setTotalCars(carCount : Int) {
        println("got total \(carCount)")
        var birthRate : CGFloat = CGFloat(carCount) / 1000
        self.carEmitter.particleBirthRate = birthRate
        println("setting birthrate \(birthRate)")
    }
    
    func removeRealCars(carCount : Int) {
        
        removeCarPool += carCount // add to global counter
        var removeFromView = 0
        
        if removeCarPool > 10 { // if more than 10, let's remove 1 car per 10
            removeFromView = removeCarPool / 10
            removeCarPool -= (removeFromView*10) // update the global counter
        }
        
        for counter in 0...removeFromView {
            delay(Double(counter)*0.001, closure: { () -> () in
                self.children[0].removeFromParent()
            })
        }
    }

    func carAssetName() -> String {
        var types = ["yellow-car-small", "gray-car-small"]
        let max = UInt32(2)
        return types[Int(arc4random_uniform(max))]

    }
    
    
    func addCars(carCount : Int) {
    
    }
    
    
    func removeCars(carCount : Int) {
    
    }
    
    
    func addRealCars(carCount : Int) {
        var checker = 0
        
        for counter in 0...carCount {
            checker++
            delay(Double(counter)*0.01, closure: { () -> () in

                var car : SKSpriteNode = SKSpriteNode(imageNamed: self.carAssetName())
//                car.size = CGSizeMake(25, 15)
                car.size = CGSizeMake(car.size.width/1, car.size.height/1)
                car.alpha = 1
//                let xPos : CGFloat = CGFloat(Double(counter) % Double(CGRectGetMaxX(self.frame)))
//                car.position = CGPoint(x:xPos, y:CGRectGetMaxY(self.frame));
                car.position = CGPointMake(1, 200)
                car.blendMode = SKBlendMode.Screen
                self.addChild(car)
                
                // car.physicsBody = SKPhysicsBody(rectangleOfSize: car.frame.size)
                car.physicsBody = SKPhysicsBody(circleOfRadius: car.frame.size.width/4)
                self.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
                //car.physicsBody?.applyImpulse(CGVectorMake(0.5, 0))
                car.physicsBody?.applyImpulse(CGVectorMake(CGFloat(counter)+5, 0))

            })
         
        }
    }
    
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        addCars(1)

    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
    }

    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        
    }
    
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}

//
//  ViewController.swift
//  nocturnal
//
//  Created by Morten Just Petersen on 1/6/15.
//  Copyright (c) 2015 Morten Just Petersen. All rights reserved.
//

import UIKit
import SpriteKit
import AlamoFire


class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    
    @IBOutlet weak var clockView: UILabel!
    
    @IBOutlet weak var travelNorth: UILabel!
    @IBOutlet weak var travelSouth: UILabel!


    var cams = [String]()
    var clockTimer = NSTimer()
    var timer = NSTimer()
    var inGarageNow : Int = 0
    var carFactor : Int = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let skView = SKView()
        skView.frame = self.view.frame
        skView.userInteractionEnabled = false
        skView.ignoresSiblingOrder = true
        skView.allowsTransparency = true
        let scene = CarScene(size: self.view.bounds.size)
        scene.scaleMode = .AspectFill
        scene.backgroundColor = SKColor.clearColor()
        
        cams.append("")
        cams.append("http://cdn.abclocal.go.com/three/kgo/webcam/baybridge.jpg")
        cams.append("https://nexusapi.dropcam.com/get_image?uuid=5a1bf5bbe2d24297a48383296a447c79&height=600")
        cams.append("https://nexusapi.dropcam.com/get_image?uuid=3d0dd451a24e428188c2b9a7318dc99f&height=600")
        cams.append("http://abclocal.go.com/three/kabc/webcam/web2-1.jpg")
        cams.append("http://images.webcams.travel/original/1312234660-Weather-Cable-Car-Turnaround%2C-Extranomical-Tours%2C-Fisherman%27s-Wharf%2C-San-Francisco-Fishermans-Wharf.jpg")
        
        
        UIApplication.sharedApplication().idleTimerDisabled = true
        
        var layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        layout.itemSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)
//        layout.itemSize = CGSizeMake(300, 300)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        
        var camCollection = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        camCollection.pagingEnabled = true
        camCollection.backgroundColor = UIColor.blackColor()
        camCollection.registerClass(CamCell.self, forCellWithReuseIdentifier: "camCell")
    //    self.view.addSubview(camCollection)

        camCollection.dataSource = self
        camCollection.delegate = self
        
        
        let tellUpdater = NSArray(objects: clockView, scene)
        
        clockTimer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "updateTimeAndLiveData:", userInfo: tellUpdater, repeats: true)
        clockTimer.fire()
        

       // skView.showsNodeCount = true
        skView.presentScene(scene)
        self.view.addSubview(skView)
        self.view.addSubview(clockView)
        
        self.view.bringSubviewToFront(clockView)
        self.view.bringSubviewToFront(travelNorth)
        self.view.bringSubviewToFront(travelSouth)
        
    }

    
    func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
    }


    func timeAsString() -> String {
        var todaysDate:NSDate = NSDate()
        var dateFormatter:NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "H mm"
        var dateInFormat:String = dateFormatter.stringFromDate(todaysDate)
        return dateInFormat
    }
    
    
    func updateTimeAndLiveData(timer : NSTimer){
        
            var args = timer.userInfo as NSArray
            var clockV = args[0] as UILabel
            var scene = args[1] as CarScene
        
            clockV.text = timeAsString()
        
            
            // var url = "http://api.sfpark.org/sfpark/rest/availabilityservice?lat=37.7832776731&long=-122.405537559&radius=0.10&uom=mile&response=json"
        
            var urlSouth = "http://services.my511.org/traffic/getpathlist.aspx?token=3236226e-1efd-4efa-8436-8d8f5ffbefa8&d=278&o=780" // southbound
            var urlNorth = "http://services.my511.org/traffic/getpathlist.aspx?token=3236226e-1efd-4efa-8436-8d8f5ffbefa8&d=780&o=278" // northbound
        
        
        // SOUTH
        Alamofire.request(.GET, urlSouth, parameters: nil)
                    .response { (request, response, data, error) in
                        
                        println("got response")
                        var xml = SWXMLHash.parse(data! as NSData)
                        if var currentTravelTimeString = xml["paths"]["path"][0]["currentTravelTime"].element?.text {
                            println("travel time is \(currentTravelTimeString)")
                            var currentTravelTime = currentTravelTimeString.toInt()
                           scene.updateTravelTime(currentTravelTime!, view: self.travelSouth)
                        }
            } // alamo request
        
        // NORTH
        Alamofire.request(.GET, urlNorth, parameters: nil)
            .response { (request, response, data, error) in
                println("got response")
                var xml = SWXMLHash.parse(data! as NSData)
                if var currentTravelTimeString = xml["paths"]["path"][0]["currentTravelTime"].element?.text {
                    println("travel time is \(currentTravelTimeString)")
                    var currentTravelTime = currentTravelTimeString.toInt()
                    scene.updateRedTravelTime(currentTravelTime!, view: self.travelNorth)
                }
        } // alamo request

    
    
    }

    
    func addToGarage(amount : Int, scene : CarScene) {
//        println("adding \(amount/carFactor)")
//        scene.addCars(amount/carFactor)
    }
    
    func removeFromGarage(amount : Int, scene : CarScene) {
//        println("removing \(amount/carFactor)")
//        scene.removeCars(amount/carFactor)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        println("number of items in section")
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) ->
        UICollectionViewCell {
               let cell = collectionView.dequeueReusableCellWithReuseIdentifier("camCell", forIndexPath: indexPath) as CamCell

            var url = NSURL(string: cams[indexPath.row])

            let tellUpdater = NSArray(objects: url!, cell.imageView)
            
            timer.invalidate()
            timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "updateCam:", userInfo: tellUpdater, repeats: true)

            timer.fire()

        return cell
    }


    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        println("returning length as \(cams.count)")
        return cams.count
    }
    

    func updateCam( timer : NSTimer) {
        
        var params = timer.userInfo as NSArray
        var url = params[0] as NSURL
        var imageView = params[1] as UIImageView
        
        
        Alamofire.request(.GET, url, parameters: nil)
            .response { (request, response, data, error) in
                if let beginImage = CIImage(data: data as NSData) {
                    var filterName = "CIPhotoEffectChrome"
                    //filterName = "CIPhotoEffectInstant"
    //                filterName = "CIPhotoEffectTransfer"
                    filterName = "CIVignette"
                    var filter = CIFilter(name: filterName)
                    filter.setDefaults()
                    filter.setValue(beginImage, forKey: kCIInputImageKey)
                    filter.setValue("1", forKey: kCIInputRadiusKey)
                    filter.setValue("2", forKey: kCIInputIntensityKey)
                    let filter2 = CIFilter(name: "CIPhotoEffectInstant")
                    filter2.setDefaults()
                    filter2.setValue(filter.outputImage, forKey: kCIInputImageKey)
//                  filter2.setValue(1.1, forKey: 
                    
                    var finalImage = filter2.outputImage
                    
                    if filter2.outputImage.extent().size.width == 600 {
                         finalImage = filter2.outputImage.imageByCroppingToRect(CGRectMake(0, 30, 600, 300))
                    }
                    
                    let newImage = UIImage(CIImage: finalImage)
                    imageView.image = newImage
                }
        }
    
    }
    

}


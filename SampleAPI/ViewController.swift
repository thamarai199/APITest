//
//  ViewController.swift
//  SampleAPI
//
//  Created by ThamaraiD on 09/01/17.
//  Copyright © 2017 OnePointGlobal. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var txtCityName : UITextField!
    var data : Data?
    var display: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func findWeather(_ sender: Any) {
        let urlString = "https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20weather.forecast%20where%20woeid%20in%20(select%20woeid%20from%20geo.places(1)%20where%20text%3D%22\(self.txtCityName.text!)%2C%20IN%22)&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys"                             // append city name from text field to url
        let url = NSURL(string: urlString)                                                                             // create a url from string
        let urlRequest = NSURLRequest(url: url as! URL)                                                                // create a urlrequest
        let session = URLSession.shared                                                                                // create a URLSession(NSURLConnection is deprecated), other ways are also ther to hit webservice server
        
        let task = session.dataTask(with: urlRequest as URLRequest, completionHandler: {data, response, error -> Void in
            print("response from server \(response)")
            print("response data from server \(data)")
            self.data = data
            self.parseJSon()
            
        })                                                                                                              // performing request, used completeion handler(kind of background operations). Once server gives response 
                                                                                                                        // it'll be saved to "data"
        task.resume()
        
        
    }
    
    func parseJSon() {
        do {
            let json  : NSDictionary = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! NSDictionary   // serialise the data u got from server here
            print("json data from server \(json)")
            let query : NSDictionary = json["query"] as! NSDictionary                                // get objects from serialised dictionary(first see the response structure based on that we need to do these things)
            
            // The below all are constructed based on response structure. Before doing these for understandingget the url from above put in browser and take that response and use any online json formatter and paste the response ther u ll get to know about the JSON structure. from that structure u need to build these things whether they are JSONobject or JSONarray
            
            let results : NSDictionary = query["results"] as! NSDictionary
            let channels : NSDictionary = results["channel"] as! NSDictionary
            let wind : NSDictionary = channels["wind"] as! NSDictionary
            let atmosphere : NSDictionary = channels["atmosphere"] as! NSDictionary
            let item : NSDictionary = channels["item"] as! NSDictionary
            let forecastarray: NSArray = item["forecast"] as! NSArray              // run thro for loop to get weather details for today and next upcoming days
            print(forecastarray)
            let place : String = channels["description"] as! String
            display = "\(place) Humidity is\(atmosphere["humidity"]!) wind speed is \(wind["speed"]!)km/ph"
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Sample", message: self.display, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
            
        }
        catch let err as NSError {
            print(err.localizedDescription)
        }
    }

}


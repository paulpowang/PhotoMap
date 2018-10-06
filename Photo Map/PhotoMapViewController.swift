//
//  PhotoMapViewController.swift
//  Photo Map
//
//  Created by Nicholas Aiwazian on 10/15/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import AddressBookUI
import MessageUI

class customPin: NSObject, MKAnnotation{
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var photo: UIImage!
    
    init(pinTitle: String, pinSubTitle: String, location: CLLocationCoordinate2D, photo: UIImage) {
        self.title = pinTitle
        self.subtitle = pinSubTitle
        self.coordinate = location
        self.photo = photo
    }
}

class PhotoMapViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, LocationsViewControllerDelegate, MKMapViewDelegate {
    
    //var capturedPhoto: UIImage?
    @IBOutlet weak var mapView: MKMapView!
    var photoImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //one degree of latitude is approximately 111 kilometers (69 miles) at all times.
        let sfRegion = MKCoordinateRegionMake(CLLocationCoordinate2DMake(37.783333, -122.416667),
                                              MKCoordinateSpanMake(0.1, 0.1))
        mapView.setRegion(sfRegion, animated: false)
        mapView.delegate = self
        
    }
    
    //Camera Press Button - To call camera or photo library
    @IBAction func pressCameraButton(_ sender: Any) {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        
        //check camera available
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            print("Camera is available 📸")
            vc.sourceType = .camera
        } else {
            print("Camera 🚫 available so we will use photo library instead")
            vc.sourceType = .photoLibrary
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseID = "myAnnotationView"
        
        
        // resize the imageView
        let resizedImageView = UIImageView(frame: CGRect(x:0, y:0, width:45, height:45))
        resizedImageView.layer.borderColor = UIColor.white.cgColor
        resizedImageView.layer.borderWidth = 3.0
        resizedImageView.contentMode = UIViewContentMode.scaleAspectFill
        resizedImageView.image = (annotation as? PinAnnotation)?.photo
        
        // set postImage to resize
        resizedImageView.image = photoImage
        
        UIGraphicsBeginImageContext(resizedImageView.frame.size)
        resizedImageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let thumbnailImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID)
        if (annotationView == nil) {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            annotationView!.canShowCallout = true
            annotationView!.leftCalloutAccessoryView = UIImageView(frame: CGRect(x:0, y:0, width: 50, height:50))
            annotationView!.rightCalloutAccessoryView = UIButton(type: UIButtonType.infoDark)
            
        }
        
        let imageView = annotationView?.leftCalloutAccessoryView as! UIImageView
        //imageView.image = UIImage(named: "camera")
        imageView.image = thumbnailImage
        
        
        return annotationView
    }
    
    // UIButton in annotation right
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        performSegue(withIdentifier: "fullImageSegue", sender: nil)
    }
    

    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        // Get the image captured by the UIImagePickerController
        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        // Do something with the images (based on your use case)
        photoImage = editedImage
        
        // Dismiss UIImagePickerController to go back to your original view controller
        dismiss(animated: true, completion: nil)
        performSegue(withIdentifier: "tagSegue", sender: self)
    }
    
    //to get location: latitude and longtitude
    func locationsPickedLocation(controller: LocationsViewController, latitude: NSNumber, longitude: NSNumber) {
        
        let locationCoordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
        
        //let annotation = MKPointAnnotation()
        let annotation = PinAnnotation()
        
        annotation.coordinate = locationCoordinate
        
        //annotation.title = "Picture!"
        mapView.addAnnotation(annotation)
        self.navigationController?.popToViewController(self, animated: true)
        
    }
    
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "tagSegue" {
            let vc: LocationsViewController = segue.destination as! LocationsViewController
            vc.delegate = self
            
        }
        if segue.identifier == "fullImageSegue" {
            let vc: FullImageViewController = segue.destination as! FullImageViewController
            vc.photoImage = photoImage
        }
    }
    

}

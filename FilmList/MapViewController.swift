
import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var Map: MKMapView!
    
    
    var coordinates: [Any]!
    var names:[String]!
    var addresses:[String]!
    var phones:[String]!
    
    let locationManager = CLLocationManager()
    var regionRadius: CLLocationDistance = 5000
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        Map.delegate = self
        locationManager.delegate = self
        
        let MapCenter = CLLocationCoordinate2DMake(49.85096864,24.03086744)
        let region = MKCoordinateRegion.init(center: MapCenter, latitudinalMeters: regionRadius * 2, longitudinalMeters: regionRadius * 2)
        Map.setRegion(region, animated: true)
        
        // 1
        coordinates = [[49.85038,24.02202],[49.84327,24.02895],[49.83867,24.02712],[49.828059,24.007894],[49.81203,24.00431],[49.80741,23.978630],[49.79532,24.05779],[49.77376,24.01084]] // Latitude,Longitude
        names = ["Планета Кіно - Львів Forum","Кінопалац","Кінопалац «Копернік»","Антикінотеатр Rockfellow","Львівський кіноцентр","Multiplex Victoria Gardens","Кінопалац ім. Довженка","Планета Кіно IMAX"]
        addresses = ["Під Дубом, 7А,","вулиця Театральна, 22","вулиця Коперника, 9","вулиця Генерала Чупринки","18, вулиця Володимира Великого, 14А","Кульпарківська, 226А","Проспект Червоної Калини, 81","вул. Стрийська, 30, ТРЦ «King Cross Leopolis»"]
        phones = ["+380-800-300-600","+380-322-975-050","+380 322 975 177","+380 68 404 0350","+380 322 644 353","+380 322 593 300","+380 3222 16131","+380 800 300 600"]
        self.Map.delegate = self
        // 2
        for i in 0...7
        {
            let coordinate:[Double] = coordinates[i] as! [Double]
            let point = CustomAnnotation(coordinate: CLLocationCoordinate2D(latitude: coordinate[0], longitude: coordinate[1]))
            point.image = UIImage(named: "image-\(i+1).jpg")
            point.name = names[i]
            point.address = addresses[i]
            point.phone = phones[i]
            self.Map.addAnnotation(point)
        }
        
    }
    
    // Asking permission for location
    override func viewDidAppear(_ animated: Bool) {
        locationAuthStatus()
    }
    func locationAuthStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            Map.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    
    // map type button
    @IBAction func type_satellite(sender: UIButton) {
        Map.mapType = MKMapType.satellite
    }
    @IBAction func type_standard(sender: UIButton) {
        Map.mapType = MKMapType.standard
    }
    // Go to user location button
    @IBAction func getLocationButton(sender: UIButton) {
        Map.setCenter(Map.userLocation.coordinate, animated: true)
    }
    
    // Zoom in button
    
    @IBAction func zoomIn(sender: UIButton) {
        let span = MKCoordinateSpan(latitudeDelta: Map.region.span.latitudeDelta/2, longitudeDelta: Map.region.span.longitudeDelta/2)
        
        let region = MKCoordinateRegion(center: Map.region.center, span: span)
        Map.setRegion(region, animated: true)
    }
    
    // Zoom out button
    @IBAction func zoomOut(sender: UIButton) {
        let span = MKCoordinateSpan(latitudeDelta: Map.region.span.latitudeDelta*2, longitudeDelta: Map.region.span.longitudeDelta*2)
        
        let region = MKCoordinateRegion(center: Map.region.center, span: span)
        Map.setRegion(region, animated: true)
    }
    
    
    // annotations
    func mapView(_ viewFormapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation
        {
            return nil
        }
        var annotationView = self.Map.dequeueReusableAnnotationView(withIdentifier: "Pin")
        if annotationView == nil{
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "Pin")
            annotationView?.canShowCallout = false
        }else{
            annotationView?.annotation = annotation
        }
        annotationView?.image = UIImage(named: "map_pin")
        return annotationView
    }
    func mapView(_ mapView: MKMapView,
                 didSelect view: MKAnnotationView)
    {
        // 1
        if view.annotation is MKUserLocation
        {
            // Don't proceed with custom callout
            return
        }
        // 2
        let CalloutAnnotation = view.annotation as! CustomAnnotation
        let views = Bundle.main.loadNibNamed("CustomCalloutView", owner: nil, options: nil)
        let calloutView = views![0] as! CustomCalloutView
        calloutView.CalloutName.text = CalloutAnnotation.name
        calloutView.CalloutAddress.text = CalloutAnnotation.address
        calloutView.CalloutPhone.text = CalloutAnnotation.phone
        calloutView.CalloutPhone.isUserInteractionEnabled = true
        calloutView.CalloutImage.image = CalloutAnnotation.image
        // 3
        calloutView.center = CGPoint(x: view.bounds.size.width / 2, y: -calloutView.bounds.size.height*0.52)
        view.addSubview(calloutView)
    }
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        if view.isKind(of: MKAnnotationView.self)
        {
            for subview in view.subviews
            {
                subview.removeFromSuperview()
            }
        }
    }
    
    
    
} //end of class

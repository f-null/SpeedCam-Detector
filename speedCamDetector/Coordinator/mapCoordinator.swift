import Foundation
import MapKit

class mapCoordinator: NSObject, MKMapViewDelegate {
    
    var mapViewController: mapView

    init(_ control: mapView) {
        self.mapViewController = control
    }
        
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "cam")
        annotationView.canShowCallout = true
        
        let size = CGSize(width: 35, height: 35)
        let SFConfig = UIImage.SymbolConfiguration(weight: .ultraLight)
        let icon =  UIImage(systemName: "camera.viewfinder", withConfiguration: SFConfig)!.withTintColor(.systemRed)
        
        annotationView.image = UIGraphicsImageRenderer(size: size).image{
            _ in icon.draw(in: CGRect(origin: .zero, size: size))
        }
        
        annotationView.clusteringIdentifier = "cam"
//        annotationView.image = UIImage(systemName: "camera.circle", withConfiguration: config)?.withTintColor(.white)

        return annotationView
    }
}

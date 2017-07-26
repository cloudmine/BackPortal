import UIKit
import CMHealth

final class PatientImageFetcher {
    
    // MARK: Public
    
    static var shared: PatientImageFetcher = PatientImageFetcher()
    
    func fetchImage(for patient: OCKPatient, callback: @escaping (UIImage?) -> Void) {
        guard let photoId = patient.cmh_patientUserData?.userId else {
            callback(#imageLiteral(resourceName: "ProfilePlaceHolder").withRenderingMode(.alwaysTemplate))
            return
        }
        
        if let cachedImage = cache[photoId] {
            callback(cachedImage)
            return
        }
        
        patient.cmh_fetchProfileImage { (success, image, error) in
            guard let image = image, success else {
                print("[PORTAL] Error fetchign profile: \(String(describing: error?.localizedDescription))")
                callback(#imageLiteral(resourceName: "ProfilePlaceHolder").withRenderingMode(.alwaysTemplate))
                return
            }
            
            objc_sync_enter(self)
            self.cache[photoId] = image
            objc_sync_exit(self)
            
            callback(image)
        }
    }
    
    // MARK: Private
    
    private var cache: [String: UIImage] = [:]
    
    private init() {
        
    }
}

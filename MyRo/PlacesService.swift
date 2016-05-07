//
//  PlacesService.swift
//  MyRo
//
//  Written by: Shreyas Hirday
//  Tested by: Shreyas Hirday
//

/// Enum that handles server API request route to retrieve landmarks
public enum PlacesServiceRoute: APIRoute {
    
    private static let baseRoute = "\(APIClient.BaseUrl)/places"
    
    case Get(Double,Double,Double)
    
    
    public var description: String {
        
        get {
            
            var route = PlacesServiceRoute.baseRoute
            
            switch self {
            case .Get(let lat,let lng,let rad):
                route += "?lat=\(lat)&lng=\(lng)&radius=\(rad)"
            default:
                route += ""
            }
            
            return route
        }
        
        
    }
}

public class PlacesService {
    /**
     Retrieves all landmarks within a certain meter radius from (lat, lon)
     
     - parameter lat: Latitude coordinate
     - parameter lon: Longitude coordinate
     - parameter radius: Radius (in meters) in which to look for landmarks
     
     - returns: Task of an array of landmarks
     */
    public static func getLandmarks(lat: Double, lon: Double, radius: Double) -> Task<[Landmark]> {
        return APIClient.GET(PlacesServiceRoute.Get(lat, lon, radius), params: nil)
                .then { json -> [Landmark] in
                    var landmarks = [Landmark]()
                    
                    let ls = json["landmarks"] as! [JSON]
                    for l in ls {
                        landmarks.append(Landmark.fromJSON(l))
                    }
                    
                    return landmarks
                }
    }
}


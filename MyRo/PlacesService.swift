//
//  PlacesService.swift
//  MyRo
//
//  Created by Shreyas Hirday on 4/29/16.
//  Copyright © 2016 MyRo. All rights reserved.
//



public enum PlacesServceRoute: APIRoute {
    
    private static let baseRoute = "\(APIClient.BaseUrl)/places"
    
    case Get(Double,Double,Double)
    
    
    public var description: String {
        
        get {
            
            var route = PlacesServceRoute.baseRoute
            
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




//
//  EnumCoder.swift
//  MyRo
//
//  Written by: Aadesh Patel
//  Tested by: Aadesh Patel
//

/// JSONCoder subclass for Enums
public class EnumCoder<T: RawRepresentable>: JSONCoder {
    public typealias Obj = T
    public typealias JSON = T.RawValue
    
    public init() {
    }
    
    public func decode(value: AnyObject?) -> T? {
        guard let rawValue = value as? T.RawValue else {
            return nil
        }
        
        return T(rawValue: rawValue)
    }
    
    public func encode(value: T?) -> T.RawValue? {
        guard let e = value else {
            return nil
        }
        
        return e.rawValue
    }
}

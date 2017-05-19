//
//  DynamicType.swift
//  MovieBuff
//
//  Created by Mac Tester on 11/29/16.
//  Copyright © 2016 Lunaria Software LLC. All rights reserved.
//


public struct DynamicType<T> {
    typealias ModelEventListener = (T)->Void
    typealias Listeners = [ModelEventListener]
    
    private var listeners:Listeners = []
    var value:T? {
        didSet {
            for (_,observer) in listeners.enumerated() {
                if let value = value {
                    observer(value)
                }
            }
            
        }
    }
    
    
    mutating func bind(_ listener:@escaping ModelEventListener) {
        listeners.append(listener)
        if let value = value {
            listener(value)
        }
    }
    
}
/***** Alternate version of DynamicType wrapper with type tracking the observers in addition to the callback
 import Foundation
public struct DynamicType<T> {
    typealias ModelEventListener = (T)->Void
    typealias Listener = [NSValue:ModelEventListener]
    
    private var observerListener:Listener = [:]
    var value:T? {
        didSet {
            for (_,observer) in observerListener.enumerated() {
                if let value = value {
                    observer.value(value)
                }
            }

        }
    }
    

    
    mutating func setEventListener(target:AnyObject, listener:@escaping (T)->Void) {
        observerListener[NSValue.init(nonretainedObject:target)] = listener
        if let value = value {
            listener(value)
        }
        
    }
    
    mutating func detatchEventListener(target:AnyObject) {
        let value = NSValue.init(nonretainedObject:target)
        observerListener.removeValue(forKey: value)
        
    }
    
}
*/



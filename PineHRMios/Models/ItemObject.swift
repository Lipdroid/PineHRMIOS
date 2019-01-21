//
//  ItemObject.swift
//  PineHRMios
//
//  Created by Md Munir Hossain on 1/21/19.
//  Copyright © 2019 Md Munir Hossain. All rights reserved.
//

import Foundation

class ItemObject{
    private var _name: String!
    private var _icon: String!
    private var _url: String!
    
    var name: String{
        if _name == nil{
            _name = ""
        }
        return _name
    }
    
    var icon: String{
        if _icon == nil{
            _icon = ""
        }
        return _icon
    }
    var url: String{
        if _url == nil{
            _url = ""
        }
        return _url
    }
    
    init(name: String,icon:String,url:String) {
        _name = name
        _icon = icon
        _url = url
    }
}

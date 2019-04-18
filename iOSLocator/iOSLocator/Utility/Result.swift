//
//  Result.swift
//  iOSLocator
//
//  Created by Banerjee,Subhodip on 18/04/19.
//  Copyright © 2019 Banerjee,Subhodip. All rights reserved.
//

import Foundation

enum Result<T, U> where U: Error{
    case success(T)
    case failure(U)
}

//
//  Enum.swift
//  H-1B
//
//  Created by Bond Wong on 5/11/16.
//  Copyright © 2016 Bond Wong. All rights reserved.
//

import Foundation

enum Module {
    case HISTORY
    case SEARCH
    case BOOKMARK
}

enum Event: String {
    case ADD_BOOKMARK = "add_bookmark"
    case REMOVE_BOOKMARK = "remove_bookmark"
    case ADD_HISTORY = "add_history"
    case REMOVE_HISTORY = "remove_history"
}
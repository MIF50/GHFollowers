//
//  GFError.swift
//  GHFollowers
//
//  Created by Mohamed Ibrahim on 10/4/20.
//

import Foundation

enum GFError: String, Error {
    case invalidUserName = "This user name created an invalid request, please try again."
    case unableToComplete = "Unable to complete your request. Please check your internet connection."
    case invalidResponse = "Invalid response from the server. Please try again."
    case keyNotFound = "The data recieved from the server contained a field that did not match. Please try again."
    case typeMismatch = "The data recieved from the server contained a field that had an unexpected value type. Please try again."
    case invalidData = "The data recieved from the server was invalid. Please try again."
    case valueNotFound = "The data recieved from the server did not contain data in a required field"
    case dataCorrupted = "The data was corrupted in some way"
    case unableToFavorite = "There was an error favoriting this user. Please try again"
    case alreadyInFavorites = "You've already favorited this user."
}

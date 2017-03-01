//
//  Constants.swift
//  HostsShop
//
//  Created by Vishnu Vardhan PV on 26/12/16.
//  Copyright © 2016 vishnuvardhanpv. All rights reserved.
//

import Foundation

struct Constants {

    /*
      MARK: Base URLs: http://unnaogrocerystore.hostsshop.com , http://apnakirana.com
    
      MARK: Login URL credentials:
        1. username - vishnu  password - zaqxswcde@1987
        2. username - webtechcodes  password - 81aTewVENpUfM3ZCt74aRPvZLDeWTLMN
 
     */

    struct API {
        static let baseUrl = "http://apnakirana.com/mageapi/index/"
        static let registerUrl = "RegisterCustomer"
        static let loginUrl = "login"
        static let validateCustomerUrl = "validatecustomer"
        static let forgotPasswordUrl = "forgotPassword"
        static let getHomepageUrl = "getHomepage"
        static let getCatalogueData = "getCatalogData"
        static let addToCart = "AddProductToCart"
        static let addToWishlist = "addProductToWishlist"
        static let getWishlist = "getWishlist"
        static let getCartPage = "getCartPage"
        static let getProductData = "getProductData"
        static let getShippingAddress = "getShippingAddress"
        static let addDeliveryAddress = "AddDeliveryAddress"
        static let getShippingMethod = "getShippingMethod"
        static let saveShippingMethod = "saveShippingMethod"
        static let getCountryList = "getCountryList"
        static let getPaymentMethods = "getPaymentMethods"
        static let savePaymentMethod = "savePaymmentMethod"
        static let createOrder = "createOrder"
        static let UpdateCustomerAddress = "UpdateCustomerAddress"
        static let getRegionCode = "getRegionCode"
        static let getRegionCities = "getRegionCities"
        static let getCityPincodes = "getCityPincodes"
        static let getOrderTotal = "getOrderTotal"
        static let getOrderSuccessMessage = "getOrderSuccessMessage"
        static let getOrderFailureMessage = "getOrderFailureMessage"
        static let changeCustomerPassword = "changeCustomerPassword"
        static let getCustomerOrderList = "getCustomerOrderList"
        static let getOrderInfo = "getOrderInfo"
        static let getSearchedData = "getSearchedData"

        static let loginUsername = "vishnu"
        static let loginPassword = "zaqxswcde@1987"
    }
}

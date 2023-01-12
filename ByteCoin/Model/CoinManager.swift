//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

//MARK: -Protocols: CoinManagerDelegate
protocol CoinManagerDelegate{
    //func didUpdateCoin(coinManager: CoinManager, coin: CoinModel)
    func didUpdateCurrency(coinManager: CoinManager, currency: CoinModel)
    func didFailWithError(error: Error)
}

//MARK: -Struct: Manager

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "EAD4A8A3-38C4-4D66-8998-9FB265307465"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    var delegate: CoinManagerDelegate?
    
    func getCoinPrice(for currency: String){
        //Use String concatenation to add the selected currency at the end of the baseURL along with the API key.
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        
        //Use optional binding to unwrap the URL that's created from the urlString
        if let url = URL(string: urlString) {
            
            //Create a new URLSession object with default configuration.
            let session = URLSession(configuration: .default)
            
            //Create a new data task for the URLSession
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                //Format the data we got back as a string to be able to print it.
                guard let safeData = data else{
                    return
                }
                if let coinPrice = self.parseJSON(safeData, currency){
                    self.delegate?.didUpdateCurrency(coinManager: self, currency: coinPrice)
                }
                
            }
            //Start task to fetch data from bitcoin average's servers.
            task.resume()
        }
    }
    
    func parseJSON(_ priceData: Data, _ currency: String) -> CoinModel?{
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(CoinData.self, from: priceData)
            let lastRate = decodedData.rate
            
            let coinPrice = CoinModel(currency: currency, rate: lastRate)
            return coinPrice
        }catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    
}

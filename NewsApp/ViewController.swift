//
//  ViewController.swift
//  NewsApp
//
//  Created by Shantanu Tiwari on 23/09/20.
//  Copyright © 2020 Shantanu Tiwari. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,NewsTableViewCellDelegate {
    let BASE_URL = "http://newsapi.org/v2/"
    let API_KEY = "7da5a60d10844939aba7f27e2dc8d71f"
    let TOP_HEADLINES = "top-headlines"
    var newsModel: NewsData?
    let dataSource = [("News1","Title 1","Desc 1"),
                      ("News2","Title 2","Desc 2"),
                      ("News3","Title 3","Desc 3"),
                      ("News4","Title 4","Desc 4"),
                      ("News5","Title 5","Desc 5")]
    let identifier = "NewsTableViewCell"
    @IBOutlet weak var activtyIndicator: UIActivityIndicatorView!
    @IBOutlet weak var newstableview:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newstableview.register(UINib(nibName: "NewsTableViewCell", bundle: nil), forCellReuseIdentifier: "NewsTableViewCell")
        newstableview.dataSource = self
        newstableview.delegate = self
       loadData()
        // Do any additional setup after loading the view, typically from a nib.
    }
    func loadData(){
        activtyIndicator.isHidden = false
        activtyIndicator.startAnimating()
        
        self.callApi(country: "us", category: "business")
    }
    func callApi(country: String,category: String) {
        let params = ["country":country,
                      "category":category,
                      "apiKey":API_KEY]
        let urlString = BASE_URL + TOP_HEADLINES
        let loginheaders:HTTPHeaders = ["X-Requested-With":"XMLHttpRequest"]
        
        // print(params)
        AF.request(urlString, method: .get, parameters: params,headers: loginheaders)
            .responseJSON { (response) in
                debugPrint(response)
                
                switch response.result{
                case .success(let jsonData):
                    if let jsonData = try? JSONSerialization.data(withJSONObject: jsonData, options: .sortedKeys)  {
                        do {
                            let dataval = try JSONDecoder().decode(NewsData.self, from: jsonData)
                            print(dataval)
                            self.newsModel = dataval
                            DispatchQueue.main.async {
                                self.activtyIndicator.isHidden = true
                                self.activtyIndicator.stopAnimating()
                                self.newstableview.reloadData()
                                
                            }
                            //self.newstableview.reloadData()
                            //  completion(titleCast.map { $0.components(separatedBy: "/")[2] }, nil)
                        } catch {
                            print(error)
                            // completion(nil, .decodingError)
                        }
                    } else {
                        // completion(nil, .networkError)
                    }
                    
                default: return
                }
            }
    }
    
    
    func shareNews(url: String){
        if let name = URL(string: url), !name.absoluteString.isEmpty {
                let objectsToShare = [name]
                let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)

                self.present(activityVC, animated: true, completion: nil)
            }else  {
                // show alert for not available
            }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  newsModel?.articles?.count ?? 0//self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as! NewsTableViewCell
        //let data = dataSource[indexPath.row]
        //cell.newsimage.image = UIImage(named: data.0)
        guard let newsData = newsModel?.articles?[indexPath.row] else{
            return UITableViewCell()
        }
        cell.delagate = self
        cell.titlelabel.text = newsData.title//data.1
        cell.descriptionlabel.text = newsData.content
        cell.newUrl = newsData.url ?? ""
        cell.date.text = newsData.publishedAt ?? ""
        //Load image data from url
        let url = URL(string: newsData.urlToImage!)
        let imgData = try? Data(contentsOf: url!)
        
        //set image in cell
        if let imageData = imgData {
            cell.newsimage.image = UIImage(data: imageData)
        }
        
        return cell
    }
    
    // to handle tap
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let newsData = newsModel?.articles?[indexPath.row] else{return}
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FullNewsVC") as! FullNewsVC
        vc.newsUrl = newsData.url ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func reloadTapped(_ sender: Any){
        self.loadData()
    }
    
}
struct NewsData: Codable{
    let status: String?
    let totalResults: Int?
    let articles: [Article]?
}

// MARK: - Article
struct Article: Codable {
    //let source: Source
   let author: String?
    let title, description: String?
   let url: String?
    let urlToImage: String?
    let publishedAt: String?
   //let publishedAt: Date?
    let content: String?
    
//    enum CodingKeys: String, CodingKey {
//        case source, author, title
//        case articleDescription = "description"
//        case url, urlToImage, publishedAt, content
//    }
}

// MARK: - Source
struct Source: Codable {
    let id: String?
    let name: String?
}

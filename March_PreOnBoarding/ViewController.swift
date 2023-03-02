//
//  ViewController.swift
//  March_PreOnBoarding
//
//  Created by 강대민 on 2023/03/02.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var allLoadBtn: UIButton!
    
    // 이미지 URL 정보
    let imageURLs = [
        "https://picsum.photos/200/300",
        "https://picsum.photos/250/350",
        "https://picsum.photos/300/400",
        "https://picsum.photos/350/450",
        "https://picsum.photos/400/500"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 테이블뷰 설정
        tableView.dataSource = self
        tableView.delegate = self
    }
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyTableViewCell", for: indexPath) as? MyTableViewCell else { return UITableViewCell() }
        
        // 버튼 클릭 이벤트 설정
        cell.button1.tag = indexPath.row // 버튼에 tag 설정
        cell.button1.addTarget(self, action: #selector(downloadImage(_:)), for: .touchUpInside)
        
        return cell
    }
    
    @objc func downloadImage(_ sender: UIButton) {
        let row = sender.tag
        guard let cell = tableView.cellForRow(at: IndexPath(row: row, section: 0)) as? MyTableViewCell else { return }
        //let urlString = "https://example.com/image\(row+1).jpg" // 다운로드할 이미지 URL
        let urlString = imageURLs[row]
        guard let url = URL(string: urlString) else { return }
        
        // 이미지 다운로드 시작
        let task = URLSession.shared.downloadTask(with: url) { (location, response, error) in
            guard let location = location else { return }
            guard let data = try? Data(contentsOf: location) else { return }
            
            // 다운로드 완료 후 이미지뷰에 이미지 설정
            DispatchQueue.main.async {
                cell.imageView1.image = UIImage(data: data)
            }
        }
        task.resume()
        
    }
    
    @IBAction func allLoadBtnTapped(_ sender: Any) {
        for row in 0..<tableView.numberOfRows(inSection: 0) {
            guard let cell = tableView.cellForRow(at: IndexPath(row: row, section: 0)) as? MyTableViewCell else { continue }
            downloadImage(cell.button1)
        }
    }
}

class MyTableViewCell: UITableViewCell {
    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var progressView1: UIProgressView!
    @IBOutlet weak var button1: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}

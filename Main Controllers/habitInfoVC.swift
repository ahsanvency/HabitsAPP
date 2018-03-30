//
//  habitInfoVC.swift
//  Habits
//
//  Created by Ahsan Vency on 3/29/18.
//  Copyright © 2018 ahsan vency. All rights reserved.
//

import UIKit

class habitInfoVC: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var habitPic: UIImageView!
    
    @IBOutlet weak var scrollInfo: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var habitName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        habitPic.image = UIImage(named: habitName!)
        scrollInfo.delegate = self
        let Slides:[Slide] = createSlides()
        setupscrollInfo(Slides: Slides)
        pageControl.numberOfPages = Slides.count
        pageControl.currentPage = 0
        view.bringSubview(toFront: pageControl)
    }
    
    func createSlides() -> [Slide]{
        let Slide1:Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)!.first as! Slide
        
        let Slide2:Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)!.first as! Slide
        Slide2.label.text = "Slide2"
        let Slide3:Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)!.first as! Slide
        Slide3.label.text = "Slide3"
        return [Slide1,Slide2,Slide3]
    }
    
    func setupscrollInfo(Slides:[Slide]){
        scrollInfo.frame = CGRect(x: 0, y: 0, width: scrollInfo.frame.width, height: view.frame.height)
        scrollInfo.contentSize = CGSize(width: scrollInfo.frame.width * CGFloat(Slides.count), height: view.frame.height)
        scrollInfo.isPagingEnabled = true
        
        for i in 0..<Slides.count{
            Slides[i].frame = CGRect(x: scrollInfo.frame.width * CGFloat(i) , y: 0, width: scrollInfo.frame.width, height: view.frame.height)
            scrollInfo.addSubview(Slides[i])
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/scrollInfo.frame.width)
        pageControl.currentPage = Int(pageIndex)
    }
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

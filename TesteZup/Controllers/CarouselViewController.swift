//
//  CarouselViewController.swift
//  TesteZup
//
//  Created by Fredyson Costa Marques Bentes on 01/01/17.
//  Copyright © 2017 home. All rights reserved.
//

import UIKit


class CarouselViewController: UIViewController, iCarouselDataSource, iCarouselDelegate {
    
    // Properties
    @IBOutlet var carousel: iCarousel!
    
    var items: [[String]] = []
    let kSyncCarousels = false
    
    // MARK: - View lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        carousel.type = .linear
        carousel.centerItemWhenSelected = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updatePerspective()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - iCarousel methods
    
    func carouselItemWidth(_ carousel: iCarousel) -> CGFloat {
        return 210.0
    }
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        if carousel == self.carousel {
            return items.count
        } else {
            return items[carousel.tag].count
        }
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        var label: UILabel
        var itemView: UIImageView
        
        if carousel == self.carousel {
            // item for outer carousel
            if let view = view as? iCarousel {
                return view
            } else {
                var subCarousel: iCarousel
                subCarousel = iCarousel(frame: CGRect(x: 0.0, y: 0.0, width: 120.0, height: self.view.bounds.size.height))
                subCarousel.dataSource = self
                subCarousel.delegate = self
                subCarousel.isVertical = true
                subCarousel.type = .cylinder
                subCarousel.scrollOffset = 0.0
                subCarousel.tag = index;
                return subCarousel
            }
        } else {
            // item for inner carousel
            if let view = view as? UIImageView {
                itemView = view
                label = itemView.viewWithTag(1) as! UILabel
            } else {
                // create new view if no view is available for recycling
                itemView = UIImageView(frame: CGRect(x: 0, y: 0, width: 120.0, height: 50.0))
                itemView.image = UIImage(named: "page.png")
                itemView.contentMode = .center
                
                label = UILabel(frame: itemView.bounds)
                label.backgroundColor = .clear
                label.textAlignment = .center
                label.font = label.font.withSize(15)
                label.tag = 1
                itemView.addSubview(label)
            }
            
            let outerIndex = carousel.tag
            let subItems = items[outerIndex]
            label.text = "\(subItems[index])"
        }
        
        return itemView
    }
    
    func carouselDidScroll(_ carousel: iCarousel) {
        if carousel == self.carousel {
            updatePerspective()
        } else if kSyncCarousels {
            for item in self.carousel.visibleItemViews {
                if let subCarousel = item as? iCarousel {
                    subCarousel.scrollOffset = carousel.scrollOffset
                }
            }
        }
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        switch option {
        case .spacing:
            return value * 1.1
        case .showBackfaces:
            return 0;
        case .visibleItems:
            if carousel == self.carousel {
                return value + 2;
            }
            return value;
        case .count:
            if carousel != self.carousel {
                return 6;
            }
            return value;
        default:
            return value;
        }
    }
    
    func updatePerspective() {
        for item in self.carousel.visibleItemViews {
            if let subCarousel = item as? iCarousel {
                let index = subCarousel.tag
                let offset = self.carousel.offsetForItem(at: index)
                subCarousel.viewpointOffset = CGSize(width: -offset * self.carousel.itemWidth, height: 0.0)
                subCarousel.contentOffset = CGSize(width: -offset * self.carousel.itemWidth, height: 0.0)
            }
        }
    }
    
    @IBAction func backButtonClicked(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}

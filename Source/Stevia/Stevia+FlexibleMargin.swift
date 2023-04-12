//
//  Stevia+FlexibleMargin.swift
//  Stevia
//
//  Created by Sacha Durand Saint Omer on 10/07/16.
//  Copyright © 2016 Sacha Durand Saint Omer. All rights reserved.
//

#if canImport(UIKit)
import UIKit

prefix operator >=
@discardableResult
prefix func >= (p: Double) -> SteviaFlexibleMargin {
    SteviaFlexibleMargin(points: p, relation: .greaterThanOrEqual)
}

@discardableResult
prefix func >= (p: CGFloat) -> SteviaFlexibleMargin {
    >=Double(p)
}

@discardableResult
prefix func >= (p: Int) -> SteviaFlexibleMargin {
    >=Double(p)
}

prefix operator <=
@discardableResult
prefix func <= (p: Double) -> SteviaFlexibleMargin {
    SteviaFlexibleMargin(points: p, relation: .lessThanOrEqual)
}

@discardableResult
prefix func <= (p: CGFloat) -> SteviaFlexibleMargin {
    <=Double(p)
}

@discardableResult
prefix func <= (p: Int) -> SteviaFlexibleMargin {
    <=Double(p)
}

struct SteviaFlexibleMargin {
    var points: Double!
    var relation: NSLayoutConstraint.Relation!
}

struct PartialFlexibleConstraint {
    var fm: SteviaFlexibleMargin!
    var view1: UIView?
    var views: [UIView]?
}

@discardableResult
func - (left: UIView,
               right: SteviaFlexibleMargin) -> PartialFlexibleConstraint {
    return PartialFlexibleConstraint(fm: right, view1: left, views: nil)
}

@discardableResult
func - (left: [UIView],
               right: SteviaFlexibleMargin) -> PartialFlexibleConstraint {
    return PartialFlexibleConstraint(fm: right, view1: nil, views: left)
}

@discardableResult
func - (left: PartialFlexibleConstraint, right: UIView) -> [UIView] {
    if let views = left.views {
        if let spv = right.superview {
            let c = constraint(item: right, attribute: .leading,
                               relatedBy: left.fm.relation, toItem: views.last,
                               attribute: .trailing,
                               constant: left.fm.points)
            spv.addConstraint(c)
        }
        return views + [right]
    } else {
        if let spv = right.superview {
            let c = constraint(item: right, attribute: .leading,
                               relatedBy: left.fm.relation, toItem: left.view1!,
                               attribute: .trailing,
                               constant: left.fm.points)
            spv.addConstraint(c)
        }
        return [left.view1!, right]
    }
}

// Left Flexible margin

struct SteviaLeftFlexibleMargin {
    let fm: SteviaFlexibleMargin
}

@discardableResult
prefix func |- (fm: SteviaFlexibleMargin) -> SteviaLeftFlexibleMargin {
    return SteviaLeftFlexibleMargin(fm: fm)
}

@discardableResult
func - (left: SteviaLeftFlexibleMargin, right: UIView) -> UIView {
    if let spv = right.superview {
        let c = constraint(item: right, attribute: .leading,
                           relatedBy: left.fm.relation, toItem: spv,
                           attribute: .leading,
                           constant: left.fm.points)
        spv.addConstraint(c)
    }
    return right
}

// Right Flexible margin

struct SteviaRightFlexibleMargin {
    let fm: SteviaFlexibleMargin
}

@discardableResult
postfix func -| (fm: SteviaFlexibleMargin) -> SteviaRightFlexibleMargin {
    return SteviaRightFlexibleMargin(fm: fm)
}

@discardableResult
func - (left: UIView, right: SteviaRightFlexibleMargin) -> UIView {
    if let spv = left.superview {
        let c = constraint(item: spv, attribute: .trailing,
                           relatedBy: right.fm.relation, toItem: left,
                           attribute: .trailing,
                           constant: right.fm.points)
        spv.addConstraint(c)
    }
    return left
}

@discardableResult
func - (left: [UIView], right: SteviaRightFlexibleMargin) -> [UIView] {
    if let spv = left.last!.superview {
        let c = constraint(item: spv, attribute: .trailing,
                           relatedBy: right.fm.relation,
                           toItem: left.last!,
                           attribute: .trailing,
                           constant: right.fm.points)
        spv.addConstraint(c)
    }
    return left
}
#endif

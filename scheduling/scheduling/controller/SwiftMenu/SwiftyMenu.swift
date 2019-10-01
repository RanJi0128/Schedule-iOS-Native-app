//
//  SwiftyMenu.swift
//  SwiftyMenu
//
//  Created by Karim Ebrahem on 4/17/19.
//  Copyright © 2019 Karim Ebrahem. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

/// Selection is a wrapper alias around 3 parameters
/// 1: Object of SwiftyMenu where the selection occured
/// 2: Model on which the interaction was made
/// 3: Index of the model
public typealias Selection = (menu :SwiftyMenu, value: SwiftMenuDisplayable, index: Int)

public class SwiftyMenu: UIView {
    
    // MARK: - Properties
    
    var heightConstraint = NSLayoutConstraint()
    
    private var selectButton: UIButton!
    private var optionsTableView: UITableView!
    private var state: MenuState = .hidden
    private enum MenuState {
        case shown
        case hidden
    }
    
    /// defines Animation Style for the drop down animation
    ///
    /// - linear: smooth animation
    /// - spring: bouncy animation
    public enum AnimationStyle {
        case linear
        case spring(level: SpringPowerLevel)
        
        /// defines how bouncy the animation should be
        ///
        /// - low: a bit of smooth and a bit of bounciness at the end
        /// - normal: not too bouncy and not too smooth
        /// - high: too bouncy
        public enum SpringPowerLevel: Double {
            case low = 0.75
            case normal = 1.0
            case high = 1.5
        }
    }
    private var width: CGFloat!
    private var height: CGFloat!
    
    public var selectedIndex: Int?

    public var selectedIndecis: [Int: Int] = [:]
    public var options = [SwiftMenuDisplayable]() {
        didSet {
            self.optionsTableView.reloadData()
        }
    }
    public weak var delegate: SwiftyMenuDelegate?
    
    /// Callback triggered after the menu was expanded
    public var didExpand: (() -> Void) = { }
    
    /// Callback triggered after the menu was collapsed
    public var didCollapse: (() -> Void) = { }
    
    /// Callback triggered when the menu will expand
    public var willExpand: (() -> Void) = { }

    /// Callback triggered when the menu will collapse
    public var willCollapse: (() -> Void) = { }
    
    /// triggered after selecting an option from the menu where Selection is an alias
    /// which wraps on
    /// swiftyMenu: Object of the SwiftyMeny on which the interaction was made
    /// selectedOption: the model of the cell object which was selected
    /// index: the index of the model which was selected
    public var didSelectOption: ((Selection) -> Void) = { _ in }

    private var updateHeightConstraint: () -> () = { }
    private var didSelectCompletion: (SwiftMenuDisplayable, Int) -> () = { selectedText, index in }
    private var TableWillAppearCompletion: () -> () = { }
    private var TableDidAppearCompletion: () -> () = { }
    private var TableWillDisappearCompletion: () -> () = { }
    private var TableDidDisappearCompletion: () -> () = { }

    // MARK: - IBInspectable
    
    @IBInspectable public var isMultiSelect: Bool = false
    @IBInspectable public var hideOptionsWhenSelect: Bool = false
    @IBInspectable public var scrollingEnabled: Bool = true {
        didSet {
            optionsTableView.isScrollEnabled = scrollingEnabled
        }
    }
    @IBInspectable public var rowHeight: Double = 35
    @IBInspectable public var menuHeaderBackgroundColor: UIColor = .white {
        didSet {
            selectButton.backgroundColor = menuHeaderBackgroundColor
        }
    }
    @IBInspectable public var rowBackgroundColor: UIColor = .white
    @IBInspectable public var selectedRowColor: UIColor?
    @IBInspectable public var optionColor: UIColor = UIColor(red: 74.0/255.0, green: 74.0/255.0, blue: 74.0/255.0, alpha: 1.0)
    @IBInspectable public var placeHolderColor: UIColor = UIColor(red: 149.0/255.0, green: 149.0/255.0, blue: 149.0/255.0, alpha: 1.0) {
        didSet {
            selectButton.setTitleColor(placeHolderColor, for: .normal)
        }
    }
    @IBInspectable public var placeHolderText: String? {
        didSet {
            UIView.performWithoutAnimation {
                selectButton.setTitle(placeHolderText, for: .normal)
                selectButton.layoutIfNeeded()
            }
        }
    }
    @IBInspectable public var arrow: UIImage? {
        didSet {
//            selectButton.titleEdgeInsets.right = 100
            selectButton.setImage(arrow, for: .normal)
        }
    }
    @IBInspectable public var titleLeftInset: Int = 0 {
        didSet {
            selectButton.titleEdgeInsets.left = CGFloat(titleLeftInset)
        }
    }
    @IBInspectable public var borderColor: UIColor =  UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    @IBInspectable public var listHeight: Int = 0
    @IBInspectable public var borderWidth: CGFloat = 0.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable public var cornerRadius: CGFloat = 8.0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable public var expandingDuration: Double = 0.5
    @IBInspectable public var collapsingDuration: Double = 0.5
    
    @IBInspectable public var expandingDelay: Double = 0.0
    @IBInspectable public var collapsingDelay: Double = 0.0
    
    public var expandingAnimationStyle: AnimationStyle = .linear
    public var collapsingAnimationStyle: AnimationStyle = .linear
    
    // MARK: - Init
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setupUI()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        setupArrowImage()
    }
    
    private func setupUI () {
        setupView()
        getViewWidth()
        getViewHeight()
        setupSelectButton()
        setupDataTableView()
    }
    
    private func setupArrowImage() {
        let spacing = self.selectButton.frame.width - 20 // the amount of spacing to appear between image and title
        selectButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: CGFloat(spacing), bottom: 0, right: 0)
    }
    
    private func setupView() {
        clipsToBounds = true
        layer.cornerRadius = cornerRadius
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
    }
    
    private func getViewWidth() {
        width = self.frame.width
    }
    
    private func getViewHeight() {
        height = self.frame.height
    }
    
    private func setupSelectButton() {
        selectButton = UIButton(frame: self.frame)
        self.addSubview(selectButton)
        
        selectButton.snp.makeConstraints { maker in
            maker.leading.trailing.top.equalTo(self)
            maker.height.equalTo(height)
        }
        
        let color = placeHolderColor
        selectButton.setTitleColor(color, for: .normal)
        UIView.performWithoutAnimation {
            selectButton.setTitle(placeHolderText, for: .normal)
            selectButton.layoutIfNeeded()
        }
        selectButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        selectButton.imageEdgeInsets.left = width - 16
        selectButton.titleEdgeInsets.right = 16
        selectButton.backgroundColor = menuHeaderBackgroundColor
        
        let frameworkBundle = Bundle(for: SwiftyMenu.self)
        let image = UIImage(named: "downArrow", in: frameworkBundle, compatibleWith: nil)
        arrow = image
        
        if arrow == nil {
            selectButton.titleEdgeInsets.left = 16
        }
        
        if #available(iOS 11.0, *) {
            selectButton.contentHorizontalAlignment = .leading
        } else {
            selectButton.contentHorizontalAlignment = .left
        }
        
        selectButton.addTarget(self, action: #selector(handleMenuState), for: .touchUpInside)
    }
    
    private func setupDataTableView() {
        optionsTableView = UITableView()
        self.addSubview(optionsTableView)
        
        optionsTableView.snp.makeConstraints { maker in
            maker.leading.trailing.bottom.equalTo(self)
            maker.top.equalTo(selectButton.snp.bottom)
        }
        
        optionsTableView.delegate = self
        optionsTableView.dataSource = self
        optionsTableView.rowHeight = CGFloat(rowHeight)
        optionsTableView.separatorInset.left = 8
        optionsTableView.separatorInset.right = 8
        optionsTableView.backgroundColor = rowBackgroundColor
        optionsTableView.isScrollEnabled = scrollingEnabled
        optionsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "OptionCell")
    }
    
    @objc private func handleMenuState() {
        switch self.state {
        case .shown:
            collapseMenu()
        case .hidden:
            expandMenu()
        }
    }
    
}

// MARK: - UITableViewDataSource

extension SwiftyMenu: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if isMultiSelect {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OptionCell", for: indexPath)
            cell.textLabel?.text = options[indexPath.row].displayValue
            cell.textLabel?.textColor = optionColor
            cell.textLabel?.font = UIFont.systemFont(ofSize: 12)
            cell.tintColor = optionColor
            cell.backgroundColor = rowBackgroundColor
            cell.accessoryType = selectedIndecis[indexPath.row] != nil ? .checkmark : .none
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OptionCell", for: indexPath)
            cell.textLabel?.text = options[indexPath.row].displayValue
            cell.textLabel?.textColor = optionColor
            cell.textLabel?.font = UIFont.systemFont(ofSize: 12)
            cell.tintColor = optionColor
            cell.backgroundColor = rowBackgroundColor
            cell.accessoryType = indexPath.row == selectedIndex ? .checkmark : .none
            cell.selectionStyle = .none
            return cell
        }
    }
}

// MARK: - UITableViewDelegate

extension SwiftyMenu: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(rowHeight)
    }
    
    private func setSelectedOptionsAsTitle() {
        if isMultiSelect {
            if selectedIndecis.isEmpty {
                UIView.performWithoutAnimation {
                    selectButton.setTitle(placeHolderText, for: .normal)
                    selectButton.layoutIfNeeded()
                }
                selectButton.setTitleColor(placeHolderColor, for: .normal)
            } else {
                let titles = selectedIndecis.mapValues { (index) -> String in
                    return options[index].displayValue
                }
                var selectedTitle = ""
                titles.forEach { option in
                    selectedTitle.append(contentsOf: "\(option.value), ")
                }
                UIView.performWithoutAnimation {
                    selectButton.setTitle(selectedTitle, for: .normal)
                    selectButton.layoutIfNeeded()
                }
                selectButton.setTitleColor(optionColor, for: .normal)
            }
        } else {
            if selectedIndex == nil {
                UIView.performWithoutAnimation {
                    selectButton.setTitle(placeHolderText, for: .normal)
                    selectButton.layoutIfNeeded()
                }
                selectButton.setTitleColor(placeHolderColor, for: .normal)
            } else {
                UIView.performWithoutAnimation {
                    selectButton.setTitle(options[selectedIndex!].displayValue, for: .normal)
                    selectButton.layoutIfNeeded()
                }
                selectButton.setTitleColor(optionColor, for: .normal)
            }
        }
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if isMultiSelect {
            if selectedIndecis[indexPath.row] != nil {
                selectedIndecis[indexPath.row] = nil
                setSelectedOptionsAsTitle()
                tableView.reloadData()
                if hideOptionsWhenSelect {
                    collapseMenu()
                }
            } else {
                selectedIndecis[indexPath.row] = indexPath.row
                setSelectedOptionsAsTitle()
                let selectedText = self.options[selectedIndecis[indexPath.row]!]
                delegate?.didSelectOption(self, selectedText, indexPath.row)
                self.didSelectOption((self, selectedText, indexPath.row))
                tableView.reloadData()
                if hideOptionsWhenSelect {
                    collapseMenu()
                }
            }
        } else {
            if selectedIndex == indexPath.row {
                if hideOptionsWhenSelect {
                    collapseMenu()
                }
            } else {
                selectedIndex = indexPath.row
                setSelectedOptionsAsTitle()
                let selectedText = self.options[self.selectedIndex!]
                delegate?.didSelectOption(self, selectedText, indexPath.row)
                self.didSelectOption((self, selectedText, indexPath.row))
                tableView.reloadData()
                if hideOptionsWhenSelect {
                    collapseMenu()
                }
            }
        }
    }
}

// MARK: - Private Functions

extension SwiftyMenu {
    private func expandMenu() {
        delegate?.swiftyMenuWillAppear(self)
        self.willExpand()
        self.state = .shown
        heightConstraint.constant = listHeight == 0 || !scrollingEnabled ? CGFloat(rowHeight * Double(options.count + 1)) : CGFloat(listHeight)
        
        switch expandingAnimationStyle {
        case .linear:
            UIView.animate(withDuration: expandingDuration,
                           delay: expandingDelay,
                           animations: animationBlock,
                           completion: expandingAnimationCompletionBlock)
            
        case .spring(level: let powerLevel):
            let damping = CGFloat(0.5 / powerLevel.rawValue)
            let initialVelocity = CGFloat(0.5 * powerLevel.rawValue)
            
            UIView.animate(withDuration: expandingDuration,
                           delay: expandingDelay,
                           usingSpringWithDamping: damping,
                           initialSpringVelocity: initialVelocity,
                           options: [],
                           animations: animationBlock,
                           completion: expandingAnimationCompletionBlock)
        }
    }
    
    private func collapseMenu() {
        delegate?.swiftyMenuWillDisappear(self)
        self.willCollapse()
        self.state = .hidden
        heightConstraint.constant = CGFloat(rowHeight)
        
        switch collapsingAnimationStyle {
        case .linear:
            UIView.animate(withDuration: collapsingDuration,
                           delay: collapsingDelay,
                           animations: animationBlock,
                           completion: collapsingAnimationCompletionBlock)
            
        case .spring(level: let powerLevel):
            let damping = CGFloat(1.0 * powerLevel.rawValue)
            let initialVelocity = CGFloat(10.0 * powerLevel.rawValue)
            
            UIView.animate(withDuration: collapsingDuration,
                           delay: collapsingDelay,
                           usingSpringWithDamping: damping,
                           initialSpringVelocity: initialVelocity,
                           options: .curveEaseIn,
                           animations: animationBlock,
                           completion: collapsingAnimationCompletionBlock)
        }
        updateHeightConstraint()
    }
}

// MARK: - Delegates

extension SwiftyMenu {
    public func updateConstraints(completion: @escaping () -> ()) {
        updateHeightConstraint = completion
    }
    
    public func didSelectOption(completion: @escaping (_ selected: SwiftMenuDisplayable, _ index: Int) -> ()) {
        didSelectCompletion = completion
    }
    
    public func listWillAppear(completion: @escaping () -> ()) {
        TableWillAppearCompletion = completion
    }
    
    private func animationBlock() {
        self.parentViewController.view.layoutIfNeeded()
    }
    
    private func expandingAnimationCompletionBlock(didAppeared: Bool) {
        if didAppeared {
            self.delegate?.swiftyMenuDidAppear(self)
            self.didExpand()
        }
    }
    
    private func collapsingAnimationCompletionBlock(didAppeared: Bool) {
        if didAppeared {
            self.delegate?.swiftyMenuDidDisappear(self)
            self.didCollapse()
        }
    }
}

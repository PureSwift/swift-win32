// Copyright © 2020 Saleem Abdulrasool <compnerd@compnerd.org>
// SPDX-License-Identifier: BSD-3-Clause

import WinSDK
import class Foundation.NSNotification

/// Transition styles available when presenting view controllers.
public enum ModalTransitionStyle: Int {
  ///
  ///
  /// When the view controller is presented, its view slides up from the bottom
  /// of the screen. On dismissal, the view slides back down. This is the
  /// default transition style.
  case coverVertical

  ///
  ///
  /// When the view controller is presented, the current view initiates a
  /// horizontal 3D flip from right-to-left, resulting in the revealing of the
  /// new view as if it were on the back of the previous view. On dismissal, the
  /// flip occurs from left-to-right, returning to the original view.
  case flipHorizontal

  ///
  ///
  /// When the view controller is presented, the current view fades out while
  /// the new view fades in at the same time. On dismissal, a similar type of
  /// cross-fade is used to return to the original view.
  case crossDissolve

  ///
  ///
  /// When the view controller is presented, one corner of the current view
  /// curls up to reveal the presented view underneath. On dismissal, the curled
  /// up page unfurls itself back on top of the presented view. A view
  /// controller presented using this transition is itself prevented from
  /// presenting any additional view controllers.
  ///
  /// This transition style is supported only if the parent view controller is
  /// presenting a full-screen view and you use the
  /// `ModalPresentationStyle.fullScreen` modal presentation style. Attempting
  /// to use a different form factor for the parent view or a different
  /// presentation style triggers an exception.
  case partialCurl
}

/// Constants that specify the edges of a rectangle.
public struct RectEdge: OptionSet {
  public typealias RawValue = UInt

  public let rawValue: RawValue

  public init(rawValue: RawValue) {
    self.rawValue = rawValue
  }
}

extension RectEdge {
  /// The top edge of the rectangle.
  public static var top: RectEdge {
    RectEdge(rawValue: 1 << 0)
  }

  /// The left edge of the rectangle.
  public static var left: RectEdge {
    RectEdge(rawValue: 1 << 1)
  }

  /// The bottom edge of the rectangle.
  public static var bottom: RectEdge {
    RectEdge(rawValue: 1 << 2)
  }

  /// The right edge of the rectangle.
  public static var right: RectEdge {
    RectEdge(rawValue: 1 << 3)
  }

  /// All edges of the rectangle.
  public static var all: RectEdge {
    RectEdge(rawValue: 0xf)
  }
}

/// An object that manages a view hierarchy for your application.
public class ViewController: Responder {
  // MARK - Managing the View

  /// The view that the controller manages.
  public var view: View! {
    get {
      loadViewIfNeeded()
      return self.viewIfLoaded
    }
    set {
      self.viewIfLoaded = newValue
    }
  }

  /// The controller's view or `nil` if the view is not yet loaded.
  public private(set) var viewIfLoaded: View?

  /// Indicates if the view is loaded into memory.
  public var isViewLoaded: Bool {
    return self.viewIfLoaded == nil ? false : true
  }

  /// Creates the view that the controller manages.
  public func loadView() {
    self.view = View(frame: .zero)
  }

  /// Called after the controller's view is loaded info memory.
  public func viewDidLoad() {
  }

  /// Loads the controller's view if it has not yet been loaded.
  public func loadViewIfNeeded() {
    guard !self.isViewLoaded else { return }
    self.loadView()
    self.viewDidLoad()
  }

  /// A localized string that represents the view this controller manages.
  public var title: String? {
    get {
      let szLength: Int32 = GetWindowTextLengthW(view.hWnd)
      let buffer: [WCHAR] = Array<WCHAR>(unsafeUninitializedCapacity: Int(szLength) + 1) {
        $1 = Int(GetWindowTextW(view.hWnd, $0.baseAddress!, CInt($0.count)))
      }
      return String(decodingCString: buffer, as: UTF16.self)
    }
    set(value) { _ = SetWindowTextW(view.hWnd, value?.wide) }
  }

  /// The preferred size for the view controller's view.
  public var preferredContentSize: Size {
    get { fatalError("\(#function) not yet implemented") }
    set { fatalError("\(#function) not yet implemented") }
  }

  // MARK - Responding to View Related Events

  /// Notifies the view controller that its view is about to be added to a view
  /// hierarchy.
  public func viewWillAppear(_ animated: Bool) {
  }

  /// Notifies the view controller that its view was added to a view hierarchy.
  public func viewDidAppear(_ animated: Bool) {
  }

  /// Notifies the view controller that its view is about to be removed from a
  /// view hierarchy.
  public func viewWillDisappear(_ animated: Bool) {
  }

  /// Notifies the view controller that its view was removed from a view
  /// hierarchy.
  public func viewDidDisappear(_ animated: Bool) {
  }

  /// A boolean value indicating whether the view controller is being dismissed.
  public private(set) var isBeingDismissed: Bool = false

  /// A boolean value indicating whether the view controller is being presented.
  public private(set) var isBeingPresented: Bool = false

  /// A boolean value indicating whether the view controller is being removed
  /// from a parent view controller.
  public private(set) var isMovingFromParent: Bool = false

  /// A boolean value indicating whether the view controller is being moved to a
  /// parent view controller.
  public private(set) var isMovingToParent: Bool = false

  // MARK - Extending the View's Safe Area

  /// The inset distances for views.
  public var additionalSafeAreaInsets: EdgeInsets = .zero {
    didSet { self.viewSafeAreaInsetsDidChange() }
  }

  /// Notifies the view controller that the safe area insets of its root view
  /// changed.
  public func viewSafeAreaInsetsDidChange() {
  }

  // MARK - Managing the View's Margins

  /// A boolean value indicating whether the view controller's view uses the
  /// system-defined minimum layout margins.
  public var viewRespectsSystemMinimumLayoutMargins: Bool = true

  /// The minimum layout margins for the view controller's root view.
  public private(set) var systemMinimumLayoutMargins: DirectionalEdgeInsets = .zero {
    didSet { self.viewLayoutMarginsDidChange() }
  }

  /// Notifies the view controller that the layout margins of its root view
  /// changed.
  public func viewLayoutMarginsDidChange() {
  }

  // MARK - Configuring the View's Layout Behavior

  /// The edges that you extend for your view controller.
  public var edgesForExtendedLayout: RectEdge = .all

  /// A boolean value indicating whether or not the extended layout includes
  /// opaque bars.
  public var extendedLayoutIncludesOpaqueBars: Bool = false

  /// Notifies the view controller that its view is about to layout its
  /// subviews.
  public func viewWillLayoutSubviews() {
  }

  /// Notifes the view controller that its view has just laid out its subviews.
  public func viewDidLayoutSubviews() {
  }

  /// Called when the view controller's view needs to update its constraints.
  public func updateViewConstraints() {
    fatalError("\(#function) not yet implemented")
  }

  // MARK - Configuring the View Rotation Settings

  /// A boolean value that indicates whether the view controller's contents
  /// should autorotate.
  public private(set) var shouldAutorotate: Bool = true

  /// The interface orientations that the view controller supports.
  public private(set) var supportedInterfaceOrientations: InterfaceOrientationMask = .allButUpsideDown

  /// The interface orientation to use when presenting the view controller.
  public private(set) var preferredInterfaceOrientationForPresentation: InterfaceOrientation = .portrait

  /// Attempts to rotate all windows to the orientation of the device.
  public class func attemptRotationToDeviceOrientation() {
  }

  // MARK - Presenting a View Controller

  /// Presents a view controller in a primary context.
  public func show(_ viewController: ViewController, sender: Any?) {
  }

  /// Presents a view controller in a secondary (or detail) context.
  public func showDetailViewController(_ viewController: ViewController,
                                       sender: Any?) {
  }

  /// Presents a view controller modally.
  public func present(_ viewController: ViewController, animated flag: Bool,
                      completion: (() -> Void)? = nil) {
  }

  /// Dismisses the view controller that was presented modally by the view
  /// controller.
  public func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
  }

  /// The presentation style for modal view controllers.
  public var modalPresentationStyle: ModalPresentationStyle = .automatic {
    didSet { fatalError("\(#function) not yet implemented") }
  }

  /// The transition style to use when presenting the view controller.
  public var modalTransitionStyle: ModalTransitionStyle = .coverVertical

  /// A boolean value indicating whether the view controller enforces a modal
  /// behavior.
  public var isModalInPresentation: Bool = false {
    didSet { fatalError("\(#function) not yet implemented") }
  }

  /// A boolean value that indicates whether this view controller's view is
  /// covered when the view controller or one of its descendants presents a view
  /// controller.
  public var definesPresentationContext: Bool = false {
    didSet { fatalError("\(#function) not yet implemented") }
  }

  /// A boolean value that indicates whether the view controller specifies the
  /// transition style for view controllers it presents.
  public var providesPresentationContextTransitionStyle: Bool = false {
    didSet { fatalError("\(#function) not yet implemented") }
  }

  /// Returns a boolean indicating whether the current input view is dismissed
  /// automatically when changing controls.
  var disablesAutomaticKeyboardDismissal: Bool {
    return self.modalPresentationStyle == .formSheet
  }

  /// Posted when a split view controller is expanded or collapsed.
  public class var showDetailTargetDidChangeNotification: NSNotification.Name {
    NSNotification.Name(rawValue: "UIViewControllerShowDetailTargetDidChangeNotification")
  }

  // MARK - Responding to Containment Events

  /// Called just before the view controller is added or removed from a
  /// container view controller.
  public func willMove(toParent viewController: ViewController?) {
  }

  /// Called after the view controller is added or removed from a container view
  /// controller.
  public func didMove(toParent viewController: ViewController?) {
  }

  // MARK - Managing Child View Controllers in a Custom Controller

  /// An array of view controllers that are children of the current view
  /// controller.
  public private(set) var children: [ViewController] = []

  /// Adds the specified view controller as a child of the current view
  /// controller.
  public func addChild(_ controller: ViewController) {
    self.children.append(controller)
    controller.parent = self
  }

  /// Removes the view controller from its parent.
  public func removeFromParent() {
    self.parent?.children.remove(object: self)
    self.parent = nil
  }

  // MARK - Getting Other Related View Controllers

  /// The view controller that presented this view controller.
  public private(set) var presentingViewController: ViewController?

  /// The view controller that presented this view controller.
  public private(set) var presentedViewController: ViewController?

  /// The view controller that presented this view controller.
  public private(set) var parent: ViewController? {
    willSet { self.willMove(toParent: newValue) }
    didSet { self.didMove(toParent: self.parent) }
  }

  // MARK -

  override public init() {
  }

  // MARK - Responder Chain

  override public var next: Responder? {
    // If the view controller's view is the root view of a window, the next
    // responder is the Window object.
    if self.view is Window { return view }
    // If the view controller is presented by another view controller, the next
    // responder is the presenting view controller.
    return self.presentingViewController
  }
}

extension ViewController: Equatable {
  public static func ==(_ lhs: ViewController, _ rhs: ViewController) -> Bool {
    return lhs === rhs
  }
}

extension ViewController: ContentContainer {
  /// Notifies the container that the size of its view is about to change.
  public func willTransition(to: Size,
                             with coodinator: ViewControllerTransitionCoordinator) {
  }

  /// Notifies the container that its trait collection changed.
  public func willTransition(to: TraitCollection,
                             with coordinator: ViewControllerTransitionCoordinator) {
  }

  /// Returns the size of the specified child view controller’s content.
  public func size(forChildContentContainer container: ContentContainer,
                   withParentContainerSize parentSize: Size) -> Size {
    return .zero
  }

  /// Notifies an interested controller that the preferred content size of one
  /// of its children changed.
  public func preferredContentSizeDidChange(forChildContentContainer container: ContentContainer) {
  }

  /// Notifies the container that a child view controller was resized using auto
  /// layout.
  public func systemLayoutFittingSizeDidChange(forChildContentContainer container: ContentContainer) {
  }
}

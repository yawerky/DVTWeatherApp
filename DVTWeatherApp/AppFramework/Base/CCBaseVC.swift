//
//  CCBaseVC.swift
//  DVTWeatherApp
//
//  Created by Yawer Khan on 26/10/25.
//  Copyright © 2025 DVT. All rights reserved.
//

import UIKit
import CoreLocation

class CCBaseVC: UIViewController {

    private var activityIndicator: UIActivityIndicatorView?
    private var loadingView: UIView?
    private var showIndicator = true
    private var networkManager: CCNetworkManager?
    private var responseCallbacks: [CCTaskCode: (CCHTTPResponse) -> Void] = [:]
    private var toolbar: CCToolbar?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActivityIndicator()
        initViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewWillAppearTasks()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewDidAppearTasks()
    }

    // MARK: - Setup

    func setupUI() {
        // Use adaptive system background color for dark mode support
        view.backgroundColor = .systemBackground
    }

    func initViews() { }

    func viewWillAppearTasks() { }

    func viewDidAppearTasks() { }

    // MARK: - Activity Indicator

    private func setupActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator?.color = getLoaderColor()
        activityIndicator?.hidesWhenStopped = true

        if let indicator = activityIndicator {
            view.addSubview(indicator)
            indicator.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
        }
    }

    func getLoaderColor() -> UIColor {
        return .systemBlue
    }

    func showLoading() {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator?.startAnimating()
            self?.view.isUserInteractionEnabled = false
        }
    }

    func hideLoading() {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator?.stopAnimating()
            self?.view.isUserInteractionEnabled = true
        }
    }

    func showLoadingWithBlur() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

            if self.loadingView == nil {
                // Use adaptive blur effect for dark mode support
                let blurEffect = UIBlurEffect(style: .systemMaterial)
                let blurView = UIVisualEffectView(effect: blurEffect)
                blurView.frame = self.view.bounds
                blurView.alpha = 0.8
                self.view.addSubview(blurView)
                self.loadingView = blurView
            }

            self.activityIndicator?.startAnimating()
            self.view.bringSubviewToFront(self.activityIndicator!)
            self.view.isUserInteractionEnabled = false
        }
    }

    func hideLoadingWithBlur() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.loadingView?.removeFromSuperview()
            self.loadingView = nil
            self.activityIndicator?.stopAnimating()
            self.view.isUserInteractionEnabled = true
        }
    }

    // MARK: - Alerts

    func showAlert(title: String, message: String, onOK: (() -> Void)? = nil) {
        DispatchQueue.main.async { [weak self] in
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default) { _ in onOK?() }
            alert.addAction(ok)
            self?.present(alert, animated: true)
        }
    }

    func showError(message: String, onOK: (() -> Void)? = nil) {
        showAlert(title: "Error", message: message, onOK: onOK)
    }

    func showConfirmation(
        title: String,
        message: String,
        yesTitle: String = "Yes",
        noTitle: String = "No",
        onYes: @escaping () -> Void,
        onNo: (() -> Void)? = nil
    ) {
        DispatchQueue.main.async { [weak self] in
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let yes = UIAlertAction(title: yesTitle, style: .default) { _ in onYes() }
            let no = UIAlertAction(title: noTitle, style: .cancel) { _ in onNo?() }
            alert.addAction(no)
            alert.addAction(yes)
            self?.present(alert, animated: true)
        }
    }

    // MARK: - Global Toolbar

    /// Add toolbar to view with title
    @discardableResult
    func addToolbar(title: String, height: CGFloat = 60) -> CCToolbar {
        let toolbarView = CCToolbar()
        toolbarView.setTitle(title)
        toolbarView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(toolbarView)

        NSLayoutConstraint.activate([
            toolbarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            toolbarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            toolbarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            toolbarView.heightAnchor.constraint(equalToConstant: height)
        ])

        toolbar = toolbarView
        return toolbarView
    }

    /// Get toolbar instance
    func getToolbar() -> CCToolbar? {
        return toolbar
    }

    /// Remove toolbar from view
    func removeToolbar() {
        toolbar?.removeFromSuperview()
        toolbar = nil
    }

    // MARK: - Navigation

    func pushVC(_ viewController: UIViewController, animated: Bool = true) {
        navigationController?.pushViewController(viewController, animated: animated)
    }

    func presentVC(
        _ viewController: UIViewController,
        animated: Bool = true,
        style: UIModalPresentationStyle = .fullScreen,
        completion: (() -> Void)? = nil
    ) {
        viewController.modalPresentationStyle = style
        present(viewController, animated: animated, completion: completion)
    }

    func popVC(animated: Bool = true) {
        navigationController?.popViewController(animated: animated)
    }

    func popToRoot(animated: Bool = true) {
        navigationController?.popToRootViewController(animated: animated)
    }

    func dismissVC(animated: Bool = true, completion: (() -> Void)? = nil) {
        dismiss(animated: animated, completion: completion)
    }

    // MARK: - Keyboard

    func enableDismissKeyboardOnTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    // MARK: - Error Handling

    func handleNetworkError(_ error: Error?) {
        var message = "An unexpected error occurred. Please try again."

        if let error = error {
            let nsError = error as NSError
            if nsError.domain == NSURLErrorDomain {
                switch nsError.code {
                case NSURLErrorNotConnectedToInternet:
                    message = "No internet connection. Please check your network settings."
                case NSURLErrorTimedOut:
                    message = "Request timed out. Please try again."
                case NSURLErrorCannotFindHost, NSURLErrorCannotConnectToHost:
                    message = "Cannot connect to server. Please try again later."
                default:
                    message = "Network error occurred. Please check your connection."
                }
            } else {
                message = error.localizedDescription
            }
        }

        showError(message: message)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        handleMemoryWarning()
    }

    func handleMemoryWarning() { }

    func onAPIRequestStarted(taskCode: CCTaskCode) { }

    func onAPISuccess(response: CCHTTPResponse, taskCode: CCTaskCode) -> Bool {
        return true
    }

    func onAPIFailure(response: CCHTTPResponse, taskCode: CCTaskCode) { }

    deinit {
        networkManager?.cancelAllRequests()
        responseCallbacks.removeAll()
    }
}

// MARK: - Network
extension CCBaseVC {

    func downloadData(httpRequest: CCHTTPRequest, _ showIndicator: Bool = true) {
        guard CCNetworkManager.isNetworkAvailable() else {
            onInternetError(httpRequest.m_taskCode)
            return
        }

        self.showIndicator = showIndicator
        networkManager = CCNetworkManager(httpRequest: httpRequest, delegate: self)
        networkManager?.startRequest()
    }

    func downloadData(
        httpRequest: CCHTTPRequest,
        showIndicator: Bool = true,
        completion: @escaping (CCHTTPResponse) -> Void
    ) {
        responseCallbacks[httpRequest.m_taskCode] = completion
        downloadData(httpRequest: httpRequest, showIndicator)
    }

    func cancelAllRequests() {
        networkManager?.cancelAllRequests()
    }

    func onInternetError(_ taskCode: CCTaskCode) {
        hideLoading()
        showAlert(title: "No Internet Connection", message: "Please check your connection and try again.")
    }

    func isNetworkAvailable() -> Bool {
        return CCNetworkManager.isNetworkAvailable()
    }
}

// MARK: - Network Delegate
extension CCBaseVC: CCNetworkDelegate {

    func onPreExecute(requestObject: CCHTTPRequest, forTaskCode taskCode: CCTaskCode) {
        if showIndicator { showLoading() }
        onAPIRequestStarted(taskCode: taskCode)
    }

    func onSuccess(
        _ response: CCHTTPResponse,
        forTaskCode taskCode: CCTaskCode,
        requestObject: CCHTTPRequest
    ) -> Bool {
        if showIndicator { hideLoading() }

        if let callback = responseCallbacks[taskCode] {
            responseCallbacks.removeValue(forKey: taskCode)
            callback(response)
            return true
        }

        if let baseResponse = response.m_responseObject as? CCBaseResponse,
           !baseResponse.isSuccessful {
            showError(message: baseResponse.friendlyMessage)
            return false
        }

        return onAPISuccess(response: response, taskCode: taskCode)
    }

    func onFailure(
        _ response: CCHTTPResponse,
        forTaskCode taskCode: CCTaskCode,
        requestObject: CCHTTPRequest
    ) {
        if showIndicator { hideLoading() }

        if let callback = responseCallbacks[taskCode] {
            responseCallbacks.removeValue(forKey: taskCode)
            callback(response)
            return
        }

        showError(message: response.getErrorMessage())
        onAPIFailure(response: response, taskCode: taskCode)
    }
}

// MARK: - Location
extension CCBaseVC: CLLocationManagerDelegate {

    func requestLocationPermission(_ locationManager: CLLocationManager) {
        let status = CLLocationManager.authorizationStatus()

        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            showLocationPermissionAlert()
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        @unknown default:
            break
        }
    }

    private func showLocationPermissionAlert() {
        showConfirmation(
            title: "Location Access Required",
            message: "This app needs access to your location to show weather for your area.",
            yesTitle: "Open Settings",
            noTitle: "Cancel"
        ) {
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL)
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.startUpdatingLocation()
        case .denied, .restricted:
            showLocationPermissionAlert()
        default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        handleLocationError(error)
    }

    func handleLocationError(_ error: Error) {
        showError(message: "Unable to get your location. Please try again.")
    }
}

// MARK: - Orientation
extension CCBaseVC {
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .portrait }
    override var shouldAutorotate: Bool { false }
}

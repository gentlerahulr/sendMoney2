import UIKit
import CoreLocation

class SearchLandingViewController: BaseViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var trendingCollectionView: UICollectionView!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var viewAllPlacesButton: UIButton!
    @IBOutlet weak var trendingCollectionHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var categoryCollectionHeightConstraint: NSLayoutConstraint!
    let viewModel = SearchLandingViewModel()
    var locationManager: CLLocationManager?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        viewModel.delegate = self
        viewModel.loadData()
        setupUI()
    }
    
    private func setupUI() {
        registerNib()
        setupTrendingCollection()
        setupSearchBar()
        setupCategoryCollection()
    }
    
    private func setupTrendingCollection() {
        trendingCollectionView.layoutIfNeeded()
        trendingCollectionHeightConstraint.constant = trendingCollectionView.contentSize.height
    }
    
    private func setupSearchBar() {
        searchBar.textField?.font = UIFont.mediumFontWithSize(size: 16)
        searchBar.setLeftImage(UIImage(named: "coreIconSearch")!, tintColor: UIColor.themeDarkBlue)
        searchBar.changePlaceholderColor(UIColor.themeDarkBlueTint1)
    }
    
    private func setupCategoryCollection() {
        viewAllPlacesButton.underlineButton(text: localizedStringForKey(key: "search_view_all_places"))
        
        categoryCollectionView.layoutIfNeeded()
        categoryCollectionHeightConstraint.constant = categoryCollectionView.contentSize.height
    }
    
    private func registerNib() {
        categoryCollectionView.register(UINib(nibName: CuisineTileCell.nibName, bundle: Bundle.main), forCellWithReuseIdentifier: CuisineTileCell.reuseIdentifier)
    }
    
    @IBAction func viewAllPlacesAction(_ sender: Any) {
        navigateToAllPlaces()
    }
    
    private func navigateToAllPlaces() {
        /// TODO: merge AllPlaces storyboard into search and open it from correct storyboard
        let allPlacesViewController = PlacesViewController.instantiateFromStoryboard(storyboardName: "AllPlaces", storyboardId: StoryboardId.AllPlacesViewController)
        allPlacesViewController.viewModel = PlacesViewModel(placeMode: .allPlaces)
        navigationController?.pushViewController(allPlacesViewController, animated: true)
    }
    
    private func navigateToCuisine(cuisine: Cuisine) {
        /// TODO: merge AllPlaces storyboard into search and open it from correct storyboard
        let allPlacesViewController = PlacesViewController.instantiateFromStoryboard(storyboardName: "AllPlaces", storyboardId: StoryboardId.AllPlacesViewController)
        allPlacesViewController.viewModel = PlacesViewModel(placeMode: .cuisine(cuisine))
        navigationController?.pushViewController(allPlacesViewController, animated: true)
    }
    
    private func navigateToNearby() {
        /// TODO: merge AllPlaces storyboard into search and open it from correct storyboard
        let allPlacesViewController = PlacesViewController.instantiateFromStoryboard(storyboardName: "AllPlaces", storyboardId: StoryboardId.AllPlacesViewController)
        allPlacesViewController.viewModel = PlacesViewModel(placeMode: .nearby)
        navigationController?.pushViewController(allPlacesViewController, animated: true)
    }
}

extension SearchLandingViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        performSegue(withIdentifier: "openSearch", sender: self)
    }
}

extension SearchLandingViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == trendingCollectionView {
            if let trendingSearch = viewModel.trendingList?.data?[indexPath.row] {
                let searchViewController = SearchViewController.instantiateFromStoryboard(storyboardName: StoryboardName.Search, storyboardId: StoryboardId.SearchViewController)
                searchViewController.viewModel.trendingSearch = trendingSearch
                navigationController?.pushViewController(searchViewController, animated: true)
            }
        } else {
            if indexPath.row == 0 {
                locationManager = CLLocationManager()
                locationManager?.delegate = self
                let authorizationStatus = CLLocationManager.authorizationStatus()
                switch authorizationStatus {
                case .notDetermined:
                    locationManager?.requestAlwaysAuthorization()
                case .authorizedAlways, .authorizedWhenInUse:
                    navigateToNearby()
                case .denied, .restricted:
                    AlertViewAdapter.shared.showBottomMessageWithDismiss(localizedStringForKey(key: "search_location_denied_title"), details: localizedStringForKey(key: "search_location_denied_message"), state: .success)
                @unknown default:
                    navigateToNearby()
                }
            } else {
                if let cuisine = viewModel.cuisineList?[indexPath.row-1] {
                    navigateToCuisine(cuisine: cuisine)
                }
            }
        }
    }
}

extension SearchLandingViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let cuisines = viewModel.cuisineList, collectionView == categoryCollectionView {
            return cuisines.count + 1
        } else if let trendings = viewModel.trendingList?.data, collectionView == trendingCollectionView {
            return min(trendings.count, 6)
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == trendingCollectionView, let trendings = viewModel.trendingList?.data {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "trendingCell", for: indexPath) as! TagCollectionViewCell
            cell.config(info: trendings[indexPath.row])
            
            return cell
        } else if let cuisines = viewModel.cuisineList {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CuisineTileCell.reuseIdentifier, for: indexPath) as! CuisineTileCell
            if indexPath.row == 0 {
                cell.configureWithCuisine(nil)
            } else {
                cell.configureWithCuisine(cuisines[indexPath.row - 1])
            }
            
            return cell
        }
        return UICollectionViewCell()
    }

}
extension SearchLandingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView == categoryCollectionView ? CGSize(width: collectionView.frame.size.width / 2 - 5, height: 96) : CGSize(width: collectionView.frame.size.width / 3 - 8, height: 20)
    }
}

extension SearchLandingViewController: SearchLandingDelegate {
    func didReceiveData() {
        trendingCollectionView.reloadData()
        categoryCollectionView.reloadData()
        setupTrendingCollection()
        setupCategoryCollection()
    }
    func failureWithError() {
        trendingCollectionView.reloadData()
        categoryCollectionView.reloadData()
        setupTrendingCollection()
        setupCategoryCollection()
    }
}

extension SearchLandingViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if CLLocationManager.authorizationStatus() == .authorizedAlways || CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            navigateToNearby()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
}

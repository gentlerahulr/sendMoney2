import UIKit

class VenueDetailsViewController: BaseViewController {
    
    @IBOutlet private weak var skeletonView: UIView!
    @IBOutlet private weak var skeletonImage: UIView!
    @IBOutlet private weak var venueScrollView: UIScrollView!
    @IBOutlet weak private var scrollViewContentViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var venueImageView: UIImageView!
    @IBOutlet private weak var likeButton: UIButton!
    @IBOutlet private weak var addToPlaylistButtonTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var venueTitleLabel: UILabel!
    @IBOutlet private weak var venueInfosLabel: UILabel!
    @IBOutlet private weak var venueCaptionView: UIView!
    @IBOutlet private weak var venueCaptionLabel: UILabel!
    @IBOutlet private weak var badgeImageView: UIImageView!
    @IBOutlet private var tagsCollectionHeightConstraint: NSLayoutConstraint!
    @IBOutlet private var topConstraint: NSLayoutConstraint!
    @IBOutlet private weak var tagsCollectionView: UICollectionView!
    @IBOutlet private weak var viewAllView: UIStackView!
    @IBOutlet private weak var viewAllButton: UIButton!
    
    @IBOutlet private weak var contactFloatableButton: UIButton!
    @IBOutlet private weak var viewMenuView: UIStackView!
    @IBOutlet private weak var viewMenuButton: UIButton!
    
    @IBOutlet private weak var dealsView: UIStackView!
    @IBOutlet private weak var dealsTableView: UITableView!
    @IBOutlet private var dealsTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var loadMoreDealsView: UIView!
    @IBOutlet private weak var loadMoreDealsButton: UIButton!
    private var showAllDeals = false
    
    @IBOutlet private weak var placeDetailsView: UIView!
    @IBOutlet private weak var addressView: UIStackView!
    @IBOutlet private weak var addressLabel: UILabel!
    @IBOutlet private weak var openHoursView: UIStackView!
    @IBOutlet private weak var openHoursLabel: UILabel!
    @IBOutlet private weak var openHoursButton: UIButton!
    
    @IBOutlet private weak var reviewsView: UIStackView!
    @IBOutlet private weak var reviewsTableView: UITableView!
    @IBOutlet private var reviewsTableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var reviewsLabel: UILabel!
    @IBOutlet private weak var loadMoreReviewsView: UIView!
    @IBOutlet private weak var loadMoreReviewsButton: UIButton!
    private var showAllReviews = false
    
    @IBOutlet private weak var featuredInView: UIStackView!
    @IBOutlet private weak var featuredInCollectionView: UICollectionView!
    
    @IBOutlet private weak var similarVenuesView: UIStackView!
    @IBOutlet private weak var similarVenuesCollectionView: UICollectionView!
    final let tagHeight: CGFloat = 20
    
    var hasMoreTags = false
    var isShowingMoreTags = false
    
    var viewModel: VenueDetailsViewModel?
    var tagViews: [[String]] = [[]]
    
    private let dealsTableViewTag = 0
    private let reviewsTableViewTag = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        if let viewModel = viewModel {
            skeletonView.showSkeleton()
            viewModel.getVenue(id: viewModel.venueId)
        }
        addShapeTo(skeletonImage)
        setupDealsTableView()
        setupReviewsTableView()
        venueScrollView.delegate = self
    }
    
    fileprivate func setupNavigation() {
        topConstraint.constant = (UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0) * -1
        addToPlaylistButtonTopConstraint.constant = UIDevice.current.hasNotch ? 100 : 80
        showScreenTitleWithLeftBarButton(screenTitleColor: colorConfig.dark_navigation_header_text_color)
        showRightBarButton(arrOfRightButtonConfig: [NavButtonConfig(font: nil, textColor: nil, backgroundColor: nil, borderColor: nil, cornerRadius: 0, image: UIImage(named: "coreIconLike"), imageTintColor: .white, title: nil, frame: nil)])
        IBViewTop.setLeftButtonColor(color: UIColor.white)
        IBViewTop.hideRightButton()
    }
    
    private func setupDealsTableView() {
        dealsTableView.separatorStyle = .none
        dealsTableView.tag = dealsTableViewTag
        dealsTableView.register(UINib(nibName: DealsTableViewCell.nibName, bundle: Bundle.main), forCellReuseIdentifier: DealsTableViewCell.reuseIdentifier)
        
        featuredInCollectionView.register(UINib(nibName: PlaylistCompactCell.nibName, bundle: Bundle.main), forCellWithReuseIdentifier: PlaylistCompactCell.reuseIdentifier)
        
        similarVenuesCollectionView.register(UINib(nibName: SmallVenueCell.nibName, bundle: Bundle.main), forCellWithReuseIdentifier: SmallVenueCell.reuseIdentifier)
    }
    
    private func setupReviewsTableView() {
        reviewsTableView.separatorStyle = .none
        reviewsTableView.tag = reviewsTableViewTag
        reviewsTableView.dataSource = self
        reviewsTableView.delegate = self
        
        reviewsTableView.register(UINib(nibName: ReviewCell.nibName, bundle: Bundle.main), forCellReuseIdentifier: ReviewCell.reuseIdentifier)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    fileprivate func setupDeals(_ venue: Venue) {
        if let deals = venue.deals, deals.count > 0 {
            if deals.count > 4 {
                loadMoreDealsButton.underlineButton(text: localizedStringForKey(key: "deals_view_all"), fontSize: 16)
                loadMoreDealsView.isHidden = false
            } else {
                loadMoreDealsView.isHidden = true
            }
            dealsTableView.reloadData()
            dealsTableView.layoutSubviews()
        } else {
            dealsView.isHidden = true
        }
    }
    
    fileprivate func setupPlaceDetails(_ venue: Venue) {
        placeDetailsView.isHidden = true
        addressView.isHidden = true
        openHoursView.isHidden = true
        if let address = venue.address {
            placeDetailsView.isHidden = false
            addressView.isHidden = false
            addressLabel.setLabelConfig(lblConfig: LabelConfig(text: address, font: .regularFontWithSize(size: 13), textColor: .themeDarkBlue, lineSpacing: 3.0, textSpacing: 0.0, textAlignment: .left, numberOfLines: 0))
        }
        if let openHours = venue.openingHours {
            placeDetailsView.isHidden = false
            openHoursView.isHidden = false
            openHoursLabel.isHidden = true
            openHoursButton.setButtonConfig(btnConfig: ButtonConfig.getBoldButtonConfig(titleText: localizedStringForKey(key: "open_hours_title"), fontSize: 13, textColor: .themeDarkBlue, backgroundColor: .clear))
            openHoursButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            openHoursButton.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            openHoursButton.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            openHoursLabel.setLabelConfig(lblConfig: LabelConfig(text: openHours, font: .regularFontWithSize(size: 13), textColor: .themeDarkBlue, lineSpacing: 3.0, textSpacing: 0.0, textAlignment: .left, numberOfLines: 0))
        }
    }
    
    fileprivate func setupReviews(_ venue: Venue) {
        if let reviews = venue.reviews, reviews.count > 0 {
            if reviews.count > 4 {
                loadMoreReviewsButton.underlineButton(text: localizedStringForKey(key: "reviews_view_all"), fontSize: 16)
                loadMoreReviewsView.isHidden = false
            } else {
                loadMoreReviewsView.isHidden = true
            }
            reviewsTableView.reloadData()
            reviewsTableView.layoutSubviews()
        } else {
            reviewsView.isHidden = true
        }
    }
    
    override func viewDidLayoutSubviews() {
        dealsTableViewHeightConstraint.constant = dealsTableView.contentSize.height
        reviewsTableViewHeightConstraint.constant = reviewsTableView.contentSize.height
    }
    
    fileprivate func setupUI() {
        if let viewModel = viewModel, let venue = viewModel.venue {
            setupImage(venueImageView)
            venueTitleLabel.setLabelConfig(lblConfig: LabelConfig.getBoldLabelConfig(text: venue.name, fontSize: 22))
            if let imageUrl = venue.imageUrl {
                venueImageView.downloaded(from: imageUrl)
            }
            contactFloatableButton.backgroundColor = UIColor.themeNeonBlue
            contactFloatableButton.isHidden = venue.phoneNumber == nil && venue.facebookUrl == nil && venue.instagramUrl == nil && venue.websiteUrl == nil && venue.bookingUrl == nil
            setupInfosLabel(venue: venue)
            setupBadge(venue)
            setupDescription(venue)
            setupLikeButton(venue)
            setupTags(venue)
            setupMenuUrl(venue)
            setupDeals(venue)
            setupPlaceDetails(venue)
            setupReviews(venue)
            setupFeaturedLists(venue)
            setupSimilarVenues(venue)
        }
    }
    
    fileprivate func setupBadge(_ venue: Venue) {
        if let badge = venue.badgeUrl, !badge.isEmpty {
            badgeImageView.downloaded(from: badge)
            badgeImageView.isHidden = false
        } else {
            badgeImageView.isHidden = true
        }
    }
    
    fileprivate func setupDescription(_ venue: Venue) {
        if let description = venue.description, !description.isEmpty {
            venueCaptionView.isHidden = false
            venueCaptionLabel.setLabelConfig(lblConfig: LabelConfig.getRegularLabelConfig(text: description, lineSpacing: 3))
        } else {
            venueCaptionView.isHidden = true
        }
    }
    
    fileprivate func setupLikeButton(_ venue: Venue) {
        likeButton.setButtonConfig(btnConfig: ButtonConfig.getRegularButtonConfig(titleText: "\(venue.likeCount)", fontSize: 13))
        likeButton.isSelected = venue.isLiked
        IBViewTop.setRightButtonImage(image: UIImage(named: venue.isLiked  ? "coreIconLikeSolid" : "coreIconLike")!, tintColor: .white)
    }
    
    fileprivate func setupTags(_ venue: Venue) {
        if let hashTags = venue.hashtags, hashTags.count > 0 {
            tagViews = setupTagCollection(hashTags.map {$0})
            
            // Hack to align only cell to the left
            for n in 0...tagViews.count - 1 where tagViews[n].count == 1 {
                tagViews[n].append("")
            }
            
            if hasMoreTags {
                viewAllButton.underlineButton(text: localizedStringForKey(key: "tags_view_all"))
                viewAllView.isHidden = false
            } else {
                viewAllView.isHidden = true
            }
            tagsCollectionView.reloadData()
        } else {
            viewAllView.isHidden = true
            tagsCollectionView.isHidden = true
        }
    }
    
    fileprivate func setupMenuUrl(_ venue: Venue) {
        if let menuUrl = venue.menuUrl, !menuUrl.isEmpty {
            viewMenuView.isHidden = false
            viewMenuButton.underlineButton(text: localizedStringForKey(key: "venue_viewMenu"), fontSize: 16)
        } else {
            viewMenuView.isHidden = true
        }
    }
    
    fileprivate func setupInfosLabel(venue: Venue) {
        let attributedText: NSMutableAttributedString
        if let starRating = venue.starRating, starRating > 0.0 {
            let ratingImage = NSTextAttachment()
            ratingImage.image = UIImage(named: "coreIconRateFill")
            let imageOffsetY: CGFloat = -3.5
            ratingImage.bounds = CGRect(x: 0, y: imageOffsetY, width: 16, height: 16)
            attributedText = NSMutableAttributedString(attachment: ratingImage)
            attributedText.append(NSAttributedString(string: String(starRating), attributes: [
                .font: UIFont.boldFontWithSize(size: 13),
                .foregroundColor: UIColor.themeDarkBlue
            ]))
            if let reviewCount = venue.reviews?.count, reviewCount > 0 {
                attributedText.append(NSAttributedString(string: " (\(reviewCount))", attributes: [
                    .font: UIFont.regularFontWithSize(size: 13),
                    .foregroundColor: UIColor.themeDarkBlue
                ]))
            }
            attributedText.append(NSAttributedString(string: " • ", attributes: [
                .font: UIFont.regularFontWithSize(size: 13),
                .foregroundColor: UIColor.themeDarkBlueTint1
            ]))
        } else {
            attributedText = NSMutableAttributedString()
        }
        var tags = [String]()
      
        if venue.priceBracket > 0 {
            let price = String(repeating: "$", count: Int(venue.priceBracket))
            tags.append(price)
        }
        if let category = venue.category {
            tags.append(category)
        }
        if let area = venue.area {
            tags.append(area)
        }
        attributedText.append(NSAttributedString(string: tags.joined(separator: " • "), attributes: [
            .font: UIFont.regularFontWithSize(size: 13),
            .foregroundColor: UIColor.themeDarkBlueTint1
        ]))
        venueInfosLabel.attributedText = attributedText
    }
    
    fileprivate func addShapeTo(_ view: UIView) {
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: view.frame.height))
        path.addLine(to: CGPoint(x: view.frame.width, y: view.frame.height * 0.8))
        path.addLine(to: CGPoint(x: view.frame.width, y: view.frame.height))
        path.addLine(to: CGPoint(x: 0, y: view.frame.height))
        let shape = CAShapeLayer()
        shape.path = path
        shape.fillColor = UIColor.white.cgColor
        view.layer.insertSublayer(shape, at: 0)
    }
    
    fileprivate func setupImage(_ imageView: UIView) {
        addShapeTo(imageView)
        imageView.applyConditionalGradient(colours: [UIColor.themeDarkBlue, UIColor.themeDarkBlue.withAlphaComponent(0)], fromPoint: CGPoint(x: 0.0, y: 0.0), toPoint: CGPoint(x: 0.0, y: 0.5))
        imageView.applyConditionalGradient(colours: [UIColor.themeDarkBlue, UIColor.themeDarkBlue.withAlphaComponent(0)], fromPoint: CGPoint(x: 1.0, y: 1.0), toPoint: CGPoint(x: 0.9, y: 0.5))
    }
    
    private func setupTagCollection(_ tags: [String]) -> [[String]] {
        var index = 0
        var tagViews: [[String]] = [[]]
        var tagsWidth: CGFloat = 0
        tags.forEach {
            let tagView = VenueTagView()
            tagView.tagLabel.text = "#\($0)"
            tagsWidth += tagView.tagLabel.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: tagHeight)).width + 20
            
            if tagsWidth > tagsCollectionView.frame.size.width {
                hasMoreTags = true
                index += 1
                tagViews.append(["#\($0)"])
                tagsWidth = tagView.tagLabel.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: tagHeight)).width + 20
            } else {
                tagViews[index].append("#\($0)")
            }
        }
        return tagViews
    }
    
    fileprivate func setupFeaturedLists(_ venue: Venue) {
        if let featuredLists = venue.featuredPlaylists, featuredLists.count > 0 {
            featuredInCollectionView.reloadData()
            featuredInCollectionView.layoutIfNeeded()
            featuredInView.isHidden = false
            
        } else {
            featuredInView.isHidden = true
        }
    }
    
    fileprivate func setupSimilarVenues(_ venue: Venue) {
        if let similarVenues = venue.similarVenues, similarVenues.count > 0 {
            similarVenuesCollectionView.reloadData()
            similarVenuesCollectionView.layoutIfNeeded()
            similarVenuesView.isHidden = false
            
        } else {
            similarVenuesView.isHidden = true
        }
    }
    
    @IBAction func viewAllTagsAction(_ sender: Any) {
        isShowingMoreTags = !isShowingMoreTags
        viewAllButton.underlineButton(text: isShowingMoreTags ? localizedStringForKey(key: "tags_show_less") : localizedStringForKey(key: "tags_view_all"))
        tagsCollectionHeightConstraint.constant = isShowingMoreTags ? CGFloat(tagViews.count) * (tagHeight + 4) : tagHeight
    }
    
    @IBAction func viewMenuAction(_ sender: Any) {
        if let venue = viewModel?.venue, let menuUrl = venue.menuUrl, let url = URL(string: menuUrl) {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func addToPlaylistAction(_ sender: Any) {
        if let venue = viewModel?.venue {
            openAddToPlaylistMenu(venue: venue)
        }
    }
    
    private func openAddToPlaylistMenu(venue: Venue) {
        let addToPlaylistVC = AddToListViewController()
        let addToListVM = AddToListViewModel(venue: venue)
        addToListVM.delegate = addToPlaylistVC
        addToPlaylistVC.viewModel = addToListVM
        addToPlaylistVC.delegate = self
        let bottomSheetVC = BottomSheetViewController(childViewController: addToPlaylistVC)
        self.navigationController?.present(bottomSheetVC, animated: false, completion: nil)
    }
    
    @IBAction func likeVenueAction(_ sender: Any) {
        likeButton.isSelected = !(likeButton.isSelected)
        IBViewTop.setRightButtonImage(image: UIImage(named: likeButton.isSelected ? "coreIconLikeSolid" : "coreIconLike")!, tintColor: .white)
        let toAdd = likeButton.isSelected ? 1 : -1
        viewModel?.venue?.likeCount += toAdd
        likeButton.setTitle("\((viewModel?.venue?.likeCount)!)", for: .normal)
        likeVenue(nil)
    }
    
    override func rightButtonAction(button: UIButton) {
        likeVenueAction(button)
    }
    
    private func likeVenue(_ indexPath: IndexPath?) {
        if let indexPath = indexPath, var venue = viewModel?.venue?.similarVenues?.data[indexPath.row] {
            venue.isLiked = !venue.isLiked
            let toAdd = venue.isLiked ? 1 : -1
            venue.likeCount += toAdd
            viewModel?.venue?.similarVenues?.data[indexPath.row] = venue
            similarVenuesCollectionView.reloadItems(at: [indexPath])
        }
        viewModel?.likeVenue(indexPath: indexPath)
    }
    
    private func likePlaylist(_ indexPath: IndexPath?) {
        if let indexPath = indexPath, var playlist = viewModel?.venue?.featuredPlaylists?.data?[indexPath.row] {
            playlist.isLiked = !playlist.isLiked
            let toAdd = playlist.isLiked ? 1 : -1
            playlist.likeCount += toAdd
            viewModel?.venue?.featuredPlaylists?.data?[indexPath.row] = playlist
            featuredInCollectionView.reloadItems(at: [indexPath])
        }
        viewModel?.likePlaylist(indexPath: indexPath)
    }
    
    @IBAction func openContactSheetAction(_ sender: Any) {
        if let venue = viewModel?.venue {
            let contactSheetVC = ContactBottomSheetViewController()
            contactSheetVC.venue = venue
            let bottomSheetVC = BottomSheetViewController(childViewController: contactSheetVC)
            self.navigationController?.present(bottomSheetVC, animated: false, completion: nil)
        }
    }
    
    @IBAction func showMoreDealsAction(_ sender: Any) {
        showAllDeals.toggle()
        let lessDeals = localizedStringForKey(key: "deals_show_less")
        let moreDeals = localizedStringForKey(key: "deals_view_all")
        loadMoreDealsButton.underlineButton(text: showAllDeals ? lessDeals  : moreDeals, fontSize: 16)
        dealsTableView.reloadData()
        dealsTableView.layoutIfNeeded()
    }
    
    @IBAction func showOpenHours(_ sender: Any) {
        openHoursButton.isSelected.toggle()
        openHoursLabel.isHidden.toggle()
    }
    
    @IBAction func showMoreReviewsAction(_ sender: Any) {
        showAllReviews.toggle()
        let lessReviews = localizedStringForKey(key: "reviews_show_less")
        let moreReviews = localizedStringForKey(key: "reviews_view_all")
        loadMoreReviewsButton.underlineButton(text: showAllReviews ? lessReviews  : moreReviews, fontSize: 16)
        reviewsTableView.reloadData()
        reviewsTableView.layoutIfNeeded()
    }
    
    private func navigateToPlaylistControllerWith(playlistId: String) {
        let vc = PlaylistViewController.instantiateFromStoryboard(storyboardName: StoryboardName.Playlist, storyboardId: StoryboardId.PlaylistViewController)
        let vm = PlaylistViewModel(playlistId: playlistId)
        vm.delegate = vc
        vc.viewModel = vm
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func navigateToVenueControllerWith(venue: Venue) {
        let vc = VenueDetailsViewController.instantiateFromStoryboard(storyboardName: StoryboardName.Playlist, storyboardId: StoryboardId.VenueDetailsViewController)
        let vm = VenueDetailsViewModel(venueId: venue.id)
        vc.viewModel = vm
        vm.delegate = vc
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - Collection handler
extension VenueDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == tagsCollectionView {
            return tagViews[section].count
        } else if collectionView == featuredInCollectionView {
            return viewModel?.venue?.featuredPlaylists?.count ?? 0
        } else {
            return viewModel?.venue?.similarVenues?.count ?? 0
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == tagsCollectionView {
            return tagViews.count
        } else {
            return 1
        }
    }
    
    private func createSmallVenueCell(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath,
                                      venue: Venue) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SmallVenueCell.reuseIdentifier, for: indexPath) as? SmallVenueCell {
            
            cell.addVenueAction = { [weak self] in
                self?.openAddToPlaylistMenu(venue: venue)
            }
            cell.likeVenueAction = { [weak self] in
                self?.likeVenue(indexPath)
            }
            cell.configureWithVenue(venue: venue)
            return cell
        }
        return UICollectionViewCell()
    }
    
    private func createPlaylistCompactCell(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath, playlist: Playlist) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlaylistCompactCell.reuseIdentifier, for: indexPath) as? PlaylistCompactCell {
            cell.configureWithPlaylist(playlist: playlist)
            cell.likePlaylistAction = { [weak self] in
                self?.likePlaylist(indexPath)
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == tagsCollectionView {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tagCell", for: indexPath) as? TagCollectionViewCell {
                cell.config(info: tagViews[indexPath.section][indexPath.row])
                return cell
            }
        } else if collectionView == featuredInCollectionView {
            if let playlist = viewModel?.venue?.featuredPlaylists?.data?[indexPath.row] {
                return createPlaylistCompactCell(collectionView, cellForItemAt: indexPath, playlist: playlist)
            }
        } else {
            if let venue = viewModel?.venue?.similarVenues?.data[indexPath.row] {
                return createSmallVenueCell(collectionView, cellForItemAt: indexPath, venue: venue)
            }
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == featuredInCollectionView {
            guard let featuredLists = viewModel?.venue?.featuredPlaylists?.data else {
                return
            }
            let listId = featuredLists[indexPath.row].id
            navigateToPlaylistControllerWith(playlistId: listId)
            
        } else if collectionView == similarVenuesCollectionView {
            guard let similarVenues = viewModel?.venue?.similarVenues?.data else {
                return
            }
            let venue = similarVenues[indexPath.row]
            navigateToVenueControllerWith(venue: venue)
        }
    }
}

// -------------------------------------
// MARK: - TableView Handler
// -------------------------------------
extension VenueDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == dealsTableViewTag {
            if let viewModel = viewModel, let deals = viewModel.venue?.deals?.data {
                return showAllDeals ? deals.count : min(deals.count, 4)
            }
        }
        if tableView.tag == reviewsTableViewTag {
            if let viewModel = viewModel {
                let reviews = viewModel.sortedReviews
                return showAllReviews ? reviews.count : min(reviews.count, 4)
            }
            if let viewModel = viewModel, let deals = viewModel.venue?.deals?.data {
                return showAllDeals ? deals.count : min(deals.count, 4)
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == dealsTableViewTag {
            if let cell = tableView.dequeueReusableCell(withIdentifier: DealsTableViewCell.reuseIdentifier, for: indexPath) as? DealsTableViewCell, let viewModel = viewModel, let deal = viewModel.venue?.deals?.data?[indexPath.row] {
                cell.configureWith(deal: deal)
                return cell
            }
        } else if tableView.tag == reviewsTableViewTag {
            if let cell = tableView.dequeueReusableCell(withIdentifier: ReviewCell.reuseIdentifier, for: indexPath) as? ReviewCell, let viewModel = viewModel {
                cell.configureWith(review: viewModel.sortedReviews[indexPath.row])
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.tag == dealsTableViewTag {
            if let viewModel = viewModel, let deals = viewModel.venue?.deals?.data, let urlString = deals[indexPath.row].url, let url = URL(string: urlString) {
                UIApplication.shared.open(url)
            }
        } else if tableView.tag == reviewsTableViewTag {
            if let viewModel = viewModel, let review = viewModel.venue?.reviews?.data?[indexPath.row], let urlString = review.url, let url = URL(string: urlString) {
                UIApplication.shared.open(url)
            }
        }
    }
}

// -------------------------------------
// MARK: - Venue menu Delegate
// -------------------------------------
extension VenueDetailsViewController: VenueMenuProtocol {
    func openCreateListViewController(venue: Venue) {
        let editViewController = EditPlaylistFieldViewController.instantiateFromStoryboard(storyboardName: StoryboardName.Playlist, storyboardId: StoryboardId.EditPlaylistFieldViewController)
        let editViewModel = EditPlaylistFieldViewModel(withField: .newList)
        editViewModel.editDelegate = editViewController
        editViewModel.venue = venue
        editViewController.viewModel = editViewModel
        editViewController.delegate = self
        navigationController?.pushViewController(editViewController, animated: true)
    }
    func venueMenueAPIFail(error: Error) {
        let actionPopupView = ActionPopup()
        let text = ActionPopupViewConfig.Text(titleText: localizedStringForKey(key: "error_popup_title"), descText: localizedStringForKey(key: "error_popup_message"), positiveButtonText: localizedStringForKey(key: "Got it"), negativeButtonText: "")
        
        let actionConfig = ActionPopupViewConfig.getButtonPositiveBGColorConfig(text: text, positiveButtonBGColor: .themeDarkBlue, hideNegativeButton: true)
        actionPopupView.setActionPopupConfig(popupConfig: actionConfig, showOnFullScreen: true)
        view.addSubview(actionPopupView)
    }
}

// -------------------------------------
// MARK: - Playlist Data Delegate
// -------------------------------------
extension VenueDetailsViewController: VenueDataDelegate {
    func didReceiveData(venueResponse: Venue) {
        setupUI()
        skeletonView.hideSkeleton()
        skeletonView.isHidden = true
        view.sendSubviewToBack(skeletonView)
    }
    
    func failureWithError(message: String) {
        let actionPopupView = ActionPopup()
        let titleText = localizedStringForKey(key: "error_popup_title")
        let descText = localizedStringForKey(key: "error_popup_message")
        let posButtonText = localizedStringForKey(key: "YES_ACTION")
        let negButtonText = localizedStringForKey(key: "STAY_CONTINUE")
        let text = ActionPopupViewConfig.Text(titleText: titleText, descText: descText, positiveButtonText: posButtonText, negativeButtonText: negButtonText)
        let actionConfig = ActionPopupViewConfig.getButtonPositiveBGColorConfig(text: text, positiveButtonBGColor: .themeDarkBlue, hideNegativeButton: false)
        actionPopupView.setActionPopupConfig(popupConfig: actionConfig, showOnFullScreen: true)
        actionPopupView.addPositiveButtonAction = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        view.addSubview(actionPopupView)
    }
    
    func didToggleLikeVenue(error: APIError?, indexPath: IndexPath?) {
        if error != nil {
            if let indexPath = indexPath {
                if var venue = viewModel?.venue?.similarVenues?.data[indexPath.row] {
                    venue.isLiked = !venue.isLiked
                    let toAdd = venue.isLiked ? 1 : -1
                    venue.likeCount += toAdd
                    similarVenuesCollectionView.reloadItems(at: [indexPath])
                }
            } else {
                likeButton.isSelected = !(likeButton.isSelected)
                IBViewTop.setRightButtonImage(image: UIImage(named: likeButton.isSelected ? "coreIconLikeSolid" : "coreIconLike")!, tintColor: .white)
                let toAdd = likeButton.isSelected ? 1 : -1
                viewModel?.venue?.likeCount += toAdd
                likeButton.setTitle("\((viewModel?.venue?.likeCount)!)", for: .normal)
            }
        }
    }
    
    func didToggleLikePlaylist(error: APIError?, indexPath: IndexPath?) {
        if error != nil, let indexPath = indexPath {
            featuredInCollectionView.reloadItems(at: [indexPath])
        }
    }
}
// -------------------------------------
// MARK: - Playlist Data Delegate
// -------------------------------------
extension VenueDetailsViewController: PlaylistDetailsDataDelegate {
    func didReceiveData(playlistResponse: Playlist) {
        if let venue = playlistResponse.venues?.data[0] {
        AlertViewAdapter.shared.showBottomMessageWithDismiss(localizedStringForKey(key: "addTo_list_success_title"), details: String(format: localizedStringForKey(key: "addTo_list_success"), venue.name, playlistResponse.title ?? "playlist"), state: .success)
        }
    }
}

// -------------------------------------
// MARK: - Scroll View Delegate
// -------------------------------------
extension VenueDetailsViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.venueScrollView {
            if scrollView.contentOffset.y >= venueImageView.frame.height / 2 {
                UIView.animate(withDuration: 0.25) {
                    self.IBViewTop.setTitle(title: self.venueTitleLabel.text ?? "")
                    self.IBViewTop.backgroundColor = UIColor.themeDarkBlue
                    self.IBViewTop.showRightButton()
                    
                }
            } else {
                UIView.animate(withDuration: 0.25) {
                    self.IBViewTop.setTitle(title: "")
                    self.IBViewTop.backgroundColor = .clear
                    self.IBViewTop.hideRightButton()
                }
            }
        }
    }
}

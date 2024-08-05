//
//  ChatViewController.swift
//  ConnectMateCustomer
//
//  Created by macbook on 04/05/2023.
//

import UIKit
import  SwiftSignalRClient


import Photos
import MobileCoreServices
import Alamofire
//import ImageLoader

//import SwiftEventBus
import QuickLook
//import SwiftGifOrigin
import Kingfisher
//import BSImagePicker
import PhotosUI


var conversationByZeroId : [ConversationsByUUID]!
public class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var timer = Timer()
    var timerDatabase : Timer?
    
    //SignalR Interval
    var reconnectInterval: TimeInterval = 5.0 // Initial reconnect interval
    let maxReconnectInterval: TimeInterval = 60.0 // Maximum reconnect interval
    //let reconnectInterval: TimeInterval = 5.0 // Reconnect interval in seconds
    var reconnectTimer: Timer?
    
    static var sheard = ChatViewController()
    @IBOutlet weak var btnTopicMenu: UIButton!
    @IBOutlet weak var lblCompanyName: UILabel!
    @IBOutlet weak var lbl_timedetail: UILabel!
    var conversationStatusChangeModel : ConversationStatusListenerDataModel = ConversationStatusListenerDataModel()
    @IBOutlet weak var ivTopicMenu: UIImageView!
    @IBOutlet weak var menuTopicCOnstantWidth: NSLayoutConstraint!
    @IBOutlet weak var collectionTopicHeight: NSLayoutConstraint!
    @IBOutlet weak var constantLayoutTypingAndTopicHeight: NSLayoutConstraint!
    @IBOutlet weak var uiCvTopics: UICollectionView!
    @IBOutlet weak var uiViewTopics: UIView!
    @IBOutlet weak var uiViewTypingAndTopicsLayout: UIView!
    //property for show reconnecting layour while no network
    @IBOutlet weak var uiViewImageBg: UIView!
    @IBOutlet weak var lblReconnecting: UILabel!
    @IBOutlet weak var ivReconnectingImage: UIImageView!
    @IBOutlet weak var uiViewReconnection: UIView!
    //proerty for type message or select file or image and also capture image
    @IBOutlet weak var layoutTypingMain: UIView!
    @IBOutlet weak var layoutMainKeyboard: UIView!
    @IBOutlet weak var layoutMainSmile: UIView!
    var imagePicker = UIImagePickerController()
    var topicsModel = TopicDataModelClass()
    lazy var previewItem = NSURL()
    
    //used for add selected image or file for send to server using upload api
    var fileUploadArrayList : [UploadFilesDataModel] = [UploadFilesDataModel]()

    var isFeedback : Bool = false
    var indexCurrent = -1
    //MARK: Topics Boolean
    var isTopicSelect : Bool = false
    var isTopicSecondTimeSelect : Bool = false
    var topicMessage : String = ""
    var topicId : String = "0"
    var topicName : String = ""
    
    var isFromImageSelection : Bool = false
    var isFromCamera : Bool = false
    var isCalledFromPreviewActivity : Bool = false
    
    var tokenResult : String = ""

    //constrants for cell identifiers of tableviews
    let cellReuseIdentifier = "CellNologinUser"
    let cellReuseIdentifierLoginUser = "cellForLoginUser"
    let cellReuseIdentifierForImageNonLogin = "cellForImageNonLogin"
    let cellReuseIdentifierCellImageLoginUser = "CellImageLoginUser"
    let cellReuseIdentifierCellFIleForLoginUser = "CellFIleForLoginUser"
    let cellReuseIdentifierCellFIleForNonLoginUser = "CellForginUserFileNonLoginUser"
    let SystemsTVCell = "SystemsTVCell"
    
    let ActivityLoaderCell = "ActivityLoaderCell"
    //Base url for chatHUB
    
    private let serverUrl =  "\(UtilsClassChat.sheard.baseUrlChat)chatHub"
    private let dispatchQueue = DispatchQueue(label: "hubsamplephone.queue.dispatcheueuq")
    //properties used for pagination
    var pageNumber = 1
    var pageSize = 15
    var totalpages = 0
    // store user properties send to server
    private var connectionId = ""
    private var tempChatId = ""
    private var timeStamp = ""
    private var businessHoursMessage = ""
    private var temppChatIdWelcomeMessage = ""
    private var tempChatIdTopicWelcomeMsg = ""
    private var isOnline : Bool = false
//    private var channelId = "6901b42a-0776-41d2-ac76-6cb6f3029d53"
    private var channelId = "f26a33d9-5b2e-4227-a456-eab45924a1d3" //"2ff350ae-bd60-4717-90e8-fb21c0b43fd6" //"f26a33d9-5b2e-4227-a456-eab45924a1d3"
    private var fcmtoken = CustomUserDefaultChat.sheard.getFcmToken()//"6901b42a-0776-41d2-ac76-6cb6f3029d53"
//    private var conversationUuID = "748049b7-5dad-4cb8-8631-844155b73ec6"
    private var conversationUuID = "B578CFED-5D93-4C44-9198-3FD143D88EA5" //"D31CEC65-4705-4E2A-9D2A-119C2FE2D85D" //""//"A653E144-7D6E-4572-98B5-0440DD6131B1"
//    private var conversationUuID = "5803d40c-a013-45cc-bd3b-0e547d819441"
    private var groupId : Int64 = 0
//    private var cusId : Int64 = 154
    private var cusId : Int64 = 0
    private var addedConversationPos : Int = -1
    private var agentId : Int64 = 0
    private var customerEmail = ""
    private var customerMobileNumber = ""
    private var customerCNIC = ""
    private var customerName = ""
    
    private var chatHubConnection: HubConnection?
    private var chatHubConnectionDelegate: HubConnectionDelegate?
    
    private var name = ""
    var messages: String =  ""
    private var filesNames :[FileDataClass] = [FileDataClass]()
    private var arrayList :[FileDataModel] = [FileDataModel]()
    private var uploadFilesData : [UploadNewFilesData] = [UploadNewFilesData]() //:[UploadFilesData] = [UploadFilesData]()
    private var conversationArrayList :[ConversationsByUUID] = [ConversationsByUUID]()
    private var topicsArrayList :[TopicDataModelClass] = [TopicDataModelClass]()
    private var reconnectAlert: UIAlertController?
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var msgTextField: UITextView!
    
    @IBOutlet weak var viewActivityIndicator: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var heightActivityIndicator: NSLayoutConstraint!
    
    
    //used for round corner of view
    var cornnerRadius : CGFloat = 20
    var shadowOfSetWidth : CGFloat = 0
    var shadowOfSetHeight : CGFloat = 5
    var shadowColour : UIColor = UIColor.darkGray
    var shadowOpacity : CGFloat = 1
    
    var dbChatObj = Singleton.sharedInstance.myLocalChatDB
    
    
    //MARK: TableView Pagination
    var isLoading = false
    private var imagePickerMulti : ImagePicker?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        //generate conversationUUid when user open conversation
        if !CustomUserDefaultChat.sheard.getConversationUuID().isEmpty{
            self.conversationUuID = CustomUserDefaultChat.sheard.getConversationUuID();
        }
        self.channelId = CustomUserDefaultChat.sheard.getChannelId()
        self.customerEmail = CustomUserDefaultChat.sheard.getCustomerEmail();
        self.customerMobileNumber = CustomUserDefaultChat.sheard.getCustomerPhoneNumber();
        self.customerCNIC = CustomUserDefaultChat.sheard.getCustomerCnic();
        self.customerName = CustomUserDefaultChat.sheard.getCustomerName();
        self.cusId = CustomUserDefaultChat.sheard.getCustomerID();

        self.msgTextField.delegate = self
        self.chatTableView.estimatedRowHeight = 44.0
        self.chatTableView.rowHeight = UITableView.automaticDimension
        self.chatTableView.delegate = self
        self.chatTableView.dataSource = self
        //self.chatHubConnectionDelegate = ChatHubConnectionDelegate(controller: self)
        self.chatHubConnectionDelegate = ChatHubConnectionDelegate(controller: self)
        self.uiViewImageBg.layer.cornerRadius = 22
        self.uiViewImageBg.clipsToBounds = true
        self.chatTableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        //get locally stored conversation
        getAllConversationLocally()
        //send faild message to server in bulk
        //sendBulkMessagesEvent()
        scheduledTimerForNewChat()
        self.lblCompanyName.text = CustomUserDefaultChat.sheard.getOrganizationName()
        
        //call access token Api
        getAccessToken(isCalledFromReconnect: false,channelId: self.channelId, serverUrl: self.serverUrl)
       
        self.lbl_timedetail.text = "Typically replies in 15 minutes"

        // Initialization code
        self.layoutTypingMain.clipsToBounds = true
        self.layoutTypingMain.layer.cornerRadius = 20
        self.setCardView(view: self.layoutTypingMain)
        
        //register table cells
        self.registerTableViewCells()
        //register collection view
        self.uiCvTopics.dataSource = self
        self.uiCvTopics.delegate = self
//        let bundle = Bundle(for: ChatViewController.self)
//        let nib = UINib(nibName: "TopicsCollectionViewCell", bundle: bundle)
        // Register the NIB
        let bundle = Bundle(for: ChatViewController.self)
        let nib = UINib(nibName: "TopicsCollectionViewCell", bundle: bundle)
        self.uiCvTopics.register(nib, forCellWithReuseIdentifier: "TopicsCollectionViewCell")
        //self.uiCvTopics.register(UINib(nibName: nib, bundle: nil), forCellWithReuseIdentifier: "TopicsCollectionViewCell")
            
        self.intiEventListner()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.callReceiveMessageInBGMode(_:)), name: NSNotification.Name(rawValue: "callReceiveMessageInBG"), object: nil)
        imagePickerMulti = ImagePicker(presentationController: self, delegate: self)

    
    }
    
    
    
    public override func viewWillAppear(_ animated: Bool) {
        CustomUserDefaultChat.sheard.saveConversationCountFromServer(count: "0")
        //SwiftEventBus.post("refreshChatBadgeCount")
    }
    
    @IBAction func topicMenu(_ sender: Any) {
        if !self.topicsArrayList.isEmpty{
            self.uiCvTopics.reloadData()
            self.uiViewTypingAndTopicsLayout.isHidden = true
            self.uiViewTopics.isHidden = false
            //adding message locall
            if (!checkLastMessageTopicSelect(lastMessage: "Please select your desired option from menu to chat with our representative.")){
                self.tempChatIdTopicWelcomeMsg = generateUuID()
                self.addItemIntoListForTopicsSelection(textMessage: "Please select your desired option from menu to chat with our representative.", tempChatId: self.tempChatIdTopicWelcomeMsg, isAddedToDB: false)
            }
        }
        
    }
    
    @objc func callReceiveMessageInBGMode(_ notification: NSNotification) {
        print("Sync Message")
        if let message = notification.userInfo?["Message"] as? RecieveMessage {
            print(message)
            addNewMessage(recieveMessage: message)
        }
    }
    
    func addNewMessage(recieveMessage: RecieveMessage){
        print("Sync Message")
        self.uploadFilesData.removeAll()
        self.fileUploadArrayList.removeAll()
        self.filesNames.removeAll()
        self.sendPrivateMessageResponse(recieveMessage: recieveMessage)
    }

    @objc fileprivate func handlepickPicture() {
        self.isFromCamera = false
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.view.tintColor = .white
        imagePicker.mediaTypes = ["public.image"]
        imagePicker.allowsEditing = false
        imagePicker.navigationBar.barTintColor = .black
        checkPermission()
    }
    
    func showMultipleImagePicker(){
        self.isFromCamera = false
        filesNames.removeAll()
        imagePickerMulti?.presentImagePicker(conversationUuID: self.conversationUuID)
        
//        let imagePicker = ImagePickerController()
//        imagePicker.settings.selection.max = 5
//        imagePicker.settings.theme.selectionStyle = .checked
//        imagePicker.settings.fetch.assets.supportedMediaTypes = [.image]
//        imagePicker.settings.selection.unselectOnReachingMax = true
//
//        let start = Date()
//        self.presentImagePicker(imagePicker, select: { (asset) in
//            print("Selected: \(asset)")
//        }, deselect: { (asset) in
//            print("Deselected: \(asset)")
//        }, cancel: { (assets) in
//            print("Canceled with selections: \(assets)")
//        }, finish: { (assets) in
//            
//            for asset in assets {
//                let imageManager = PHImageManager.default()
//                let requestOptions = PHImageRequestOptions()
//                requestOptions.isSynchronous = true
//                
//                imageManager.requestImageData(for: asset, options: requestOptions) { (data, _, _, _) in
//                    if let imageData = data {
//                        let image = UIImage(data: imageData)
//                        var filename = asset.value(forKey: "filename") as? String ?? "UnknownFileName"
//                        var fileExtension = (filename as NSString).pathExtension
//                        var strFileType = UtilsClassChat.sheard.getImageType(exten: fileExtension)
//                        
//                        var mimetype = ""
//                        if (strFileType == "Unknown" || strFileType == ""){
//                            strFileType = "png"
//                            mimetype = "image/png"
//                        }else {
//                            mimetype = "image/\(strFileType)"
//                        }
//                        
////                        if filename.contains(".HEIC"){
////                            let newName = filename.components(separatedBy: ".")
////                            filename = newName[0] + ".\(strFileType)"
////                            fileExtension = "png"
////
////                        }
//                        if !filename.contains(".") {
//                            strFileType = "\(filename).\(strFileType)"
//                        }else{
//                            strFileType = filename
//                        }
//                        
//                        var base64String : String?
//                        var uploadFilesDataModel : UploadFilesDataModel = UploadFilesDataModel()
//                        // Convert image to Base64
//                        if let imageData = image?.jpegData(compressionQuality: 0.5) {
//                            base64String = imageData.base64EncodedString()
//                            print("Filename: \(filename), Extension: \(fileExtension)")
//                        }
//                        
//                        var tempChatID =  self.generateUuID()
//                    
//                        //creating data model for files array list and send into upload api
//                        uploadFilesDataModel.file = base64String
//                        uploadFilesDataModel.fileName = strFileType //filename
//                        uploadFilesDataModel.contentType = mimetype //"image/png" //mimetype
//                        uploadFilesDataModel.tempChatID = tempChatID
//                        uploadFilesDataModel.conversationUId = self.conversationUuID
//                        uploadFilesDataModel.caption = ""
//                        self.fileUploadArrayList.append(uploadFilesDataModel)
//                        
//                        
//                        var fileDataClass = FileDataClass()
//                        fileDataClass.fileName = filename
//                        fileDataClass.fileSizes = ""
//                        fileDataClass.url = base64String
//                        fileDataClass.tempChatId = tempChatID
//                        fileDataClass.mimeType = mimetype
//                        fileDataClass.fileLocalUri = base64String
//                        self.filesNames.append(fileDataClass)
//                        
//                        
//                    }
//                    
//                }
//            }
//            
//            print("Finished with selections: \(assets)")
//            self.dismiss(animated: true, completion: {
//                //To call or execute function after some time(After 5 sec)
//                DispatchQueue.main.asyncAfter(deadline: .now()) {
//                    let selectedFilePreview = self.storyboard?.instantiateViewController(withIdentifier: "SelectedFilePreview") as! SelectedFilePreview
//                    selectedFilePreview.modalPresentationStyle = .popover
//                    selectedFilePreview.filesNames = self.filesNames
//                    selectedFilePreview.isFromImageSelection = true
//                    selectedFilePreview.delegate = self
//                    self.present(selectedFilePreview, animated: true, completion: nil)
//                }
//            })
//        }, completion: {
//            let finish = Date()
//            print(finish.timeIntervalSince(start))
//        })
    }
    
    func updateReconnection(){
        if Network.isConnectedToNetwork() == true {
            hideAndShowReconnectionLayout(isHide: true)
            reconnectServer()
            
        }else{
            hideAndShowReconnectionLayout(isHide: false)
        }
    }
    
    func registerTableViewCells(){
        
        // Assuming you want to register the nib for a table view cell
//        let nib = UINib(nibName: "ConversationLoginUserTableViewCell", bundle: Bundle.module)
//        tableView.register(nib, forCellReuseIdentifier: "ConversationLoginUserTableViewCell")
            
        let bundle = Bundle(for: ChatViewController.self)
        
        let nib = UINib(nibName: "ConversationTableViewCellNoLoginUser", bundle: bundle)
        self.chatTableView.register(nib, forCellReuseIdentifier: cellReuseIdentifier)
        
        let nib1 = UINib(nibName: "ConversationLoginUserTableViewCell", bundle: bundle)
        self.chatTableView.register(nib1, forCellReuseIdentifier: cellReuseIdentifierLoginUser)
        
        let nib2 = UINib(nibName: "ConversationCellImageNoLoginUser", bundle: bundle)
        self.chatTableView.register(nib2, forCellReuseIdentifier: cellReuseIdentifierForImageNonLogin)
        
        let nib3 = UINib(nibName: "ConversationCellImageLoginUser", bundle: bundle)
        self.chatTableView.register(nib3, forCellReuseIdentifier: cellReuseIdentifierCellImageLoginUser)
        
        let nib4 = UINib(nibName: "ConversationCellFIleForLoginUser", bundle: bundle)
        self.chatTableView.register(nib4, forCellReuseIdentifier: cellReuseIdentifierCellFIleForLoginUser)
        
        let nib5 = UINib(nibName: "ConversationCellFileNonLoginUser", bundle: bundle)
        self.chatTableView.register(nib5, forCellReuseIdentifier: cellReuseIdentifierCellFIleForNonLoginUser)
        
        let nib6 = UINib(nibName: "ActivityLoaderCell", bundle: bundle)
        self.chatTableView.register(nib6, forCellReuseIdentifier: ActivityLoaderCell)
        
        let nib7 = UINib(nibName: "SystemsTVCell", bundle: bundle)
        self.chatTableView.register(nib7, forCellReuseIdentifier: SystemsTVCell)
        
        
        //self.chatTableView.register(UINib(nibName: "ConversationTableViewCellNoLoginUser", bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
        //self.chatTableView.register(UINib(nibName: "ConversationLoginUserTableViewCell", bundle: nil), forCellReuseIdentifier: cellReuseIdentifierLoginUser)
        
        //self.chatTableView.register(UINib(nibName: "ConversationCellImageNoLoginUser", bundle: nil), forCellReuseIdentifier: cellReuseIdentifierForImageNonLogin)
        //self.chatTableView.register(UINib(nibName: "ConversationCellImageLoginUser", bundle: nil), forCellReuseIdentifier: cellReuseIdentifierCellImageLoginUser)
        //self.chatTableView.register(UINib(nibName: "ConversationCellFIleForLoginUser", bundle: nil), forCellReuseIdentifier: cellReuseIdentifierCellFIleForLoginUser)
        //self.chatTableView.register(UINib(nibName: "ConversationCellFileNonLoginUser", bundle: nil), forCellReuseIdentifier: cellReuseIdentifierCellFIleForNonLoginUser)
        
//        self.chatTableView.register(UINib(nibName: "ActivityLoaderCell", bundle: nil), forCellReuseIdentifier: ActivityLoaderCell)
//        self.chatTableView.register(UINib(nibName: "SystemsTVCell", bundle: nil), forCellReuseIdentifier: SystemsTVCell)
        
    }



    func setCardView(view : UIView){
        view.layer.masksToBounds = false
        view.layer.shadowOffset = CGSizeMake(0, 0);
        view.layer.shadowRadius = 0.7;
        view.layer.shadowOpacity = 0.3;

    }
    
    @IBAction func btnCLose(_ sender: Any) {
//        self.timerDatabase.invalidate()
        
        
//        if DashboardVC.isFromChatNotification == true{
//            DashboardVC.isFromChatNotification = false
//            SwiftEventBus.post("switchToHomeVc")
//            self.dismiss(animated: false)
//        }else{
            self.dismiss(animated: false)
//        }
    
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        
//        self.showFeedBackDialogue()
    
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        self.timerDatabase?.invalidate()
        self.timerDatabase = nil
    }
    
    deinit {
        self.timerDatabase?.invalidate()
        
    }
    
    func layoutToCardView(layer :CALayer){
        
        
    }
    
    @IBOutlet weak var btnEmoji: UIButton!
    public override func viewWillDisappear(_ animated: Bool) {
       
    }
    
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func btnKeyBoardClick(_ sender: Any) {
        
    }

    @IBAction func btnAttachFile(_ sender: Any) {
        openSheet()
    }
    @IBAction func btnCameramage(_ sender: Any) {
        openCamera()
    }
    
    @IBAction func btnSend(_ sender: Any) {
       
        //check internet connection
        //if CustomUserDefaultChat.sheard.
        if !self.msgTextField.text.isEmpty {
            if (CustomUserDefaultChat.sheard.getIsResolved() && self.topicsArrayList.isEmpty && !businessHoursMessage.isEmpty){
                
                //generate TempchatID
                isTopicSecondTimeSelect = false
                sendNewChat(type: "welcomeMessage", txtMessage: businessHoursMessage , uploadFilesData: self.uploadFilesData, tempChatIDStr:self.temppChatIdWelcomeMessage, conversationUUID: self.conversationUuID, channelID: self.channelId, mobileToken: self.fcmtoken,isFromWidget: true)
                
                sleep(1)
            }
            self.tempChatId =  self.generateUuID()
            sendNewChat(type: "text", txtMessage: self.msgTextField.text! , uploadFilesData: self.uploadFilesData, tempChatIDStr:self.tempChatId, conversationUUID: self.conversationUuID, channelID: self.channelId, mobileToken: self.fcmtoken,isFromWidget: true)
            self.msgTextField.text = ""
            
        }else{
            showToast(strMessage: "Please type a message")
        }
       
    }
    
    private func appendNewChatMessage(conversationsByUUID: ConversationsByUUID, isAddedToDB : Bool) {
        
        self.dispatchQueue.sync {
            if !self.conversationArrayList.isEmpty{
                if isAddedToDB{
                    dbChatObj.saveChatIntoData(isUpdateById: false, pageNumber: pageNumber, conversation: conversationsByUUID ?? ConversationsByUUID())
                }
                
                self.conversationArrayList.insert(conversationsByUUID, at: 0)
                
                UIView.performWithoutAnimation {
                    self.chatTableView.reloadData()
                }
                scrollToBottom()
            }else{
                if isAddedToDB{
                    dbChatObj.saveChatIntoData(isUpdateById: false, pageNumber: pageNumber, conversation: conversationsByUUID ?? ConversationsByUUID())
                }
                self.conversationArrayList.insert(conversationsByUUID, at: 0)
                UIView.performWithoutAnimation {
                    self.chatTableView.reloadData()
                }
                scrollToBottom()
            }
        }
    }
    
    fileprivate func connectionDidOpen() {
        //toggleUI(isEnabled: true)
        hideAndShowReconnectionLayout(isHide: true)
        // Reset reconnect timer upon successful connection
        reconnectTimer?.invalidate()
    }
    
    fileprivate func connectionDidFailToOpen(error: Error) {
        //blockUI(message: "Connection failed to start.", error: error)
        scheduleReconnect()
    }
    
    fileprivate func connectionDidClose(error: Error?) {
        if let alert = reconnectAlert {
            alert.dismiss(animated: true, completion: nil)
        }
        //blockUI(message: "Connection is closed.", error: error)
        hideAndShowReconnectionLayout(isHide: false)
        scheduleReconnect()
    }
    
    fileprivate func connectionWillReconnect(error: Error?) {
        guard reconnectAlert == nil else {
            print("Alert already present. This is unexpected.")
            return
        }

        hideAndShowReconnectionLayout(isHide: false)
        
    }
    
    
    fileprivate func connectionDidReconnect() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            // invoking a hub method that does not return a result
            self.customerJoined()
            if self.chatHubConnection!.connectionId != nil {
                CustomUserDefaultChat.sheard.saveConnectionId(connectionId: self.chatHubConnection!.connectionId!)
                print("Generate connectionID: \(self.chatHubConnection!.connectionId)")
                
                self.syncDataWhenOnline()
            }
            
        })
        
        
        hideAndShowReconnectionLayout(isHide: true)

    }
    
    func customerJoined(){
        if self.chatHubConnection!.connectionId != nil {
            CustomUserDefaultChat.sheard.saveConnectionId(connectionId: self.chatHubConnection!.connectionId!)
            print("Generate connectionID: \(self.chatHubConnection!.connectionId)")

        }
        self.chatHubConnection?.invoke(method: "CustomerJoinedFromMobile",self.channelId, self.cusId,self.fcmtoken,UtilsClassChat.sheard.callerAppType) { error in
            if let error = error {
                print("error: \(error)")
            } else {
                print("Broadcast invocation completed without errors")
            }
        }
    }
    
    func reconnectServer(){
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            // invoking a hub method that does not return a result
            self.customerJoined()
            if self.chatHubConnection?.connectionId != nil {
                CustomUserDefaultChat.sheard.saveConnectionId(connectionId: self.chatHubConnection?.connectionId!)
                print("Generate connectionID: \(self.chatHubConnection?.connectionId)")
                
                self.syncDataWhenOnline()
            }
            
        })
    }
    
    func syncDataWhenOnline(){
        print("")
        let messageId = CustomUserDefaultChat.sheard.getLastMessageId()
        let cusId = CustomUserDefaultChat.sheard.getCustomerID()
        let connectionId = CustomUserDefaultChat.sheard.getsaveConnectionId()
        self.chatHubConnection?.send(method: "SyncMessages", cusId, messageId , connectionId)
    }
 

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print("")
        return self.conversationArrayList.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            if !self.conversationArrayList.isEmpty{
                if self.conversationArrayList[indexPath.row].type == "system" {
                    
                    let aCell = self.chatTableView.dequeueReusableCell(withIdentifier: self.SystemsTVCell,for: indexPath) as! SystemsTVCell
                    //system view call here
                    aCell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
                    
                    
                    
                    if (conversationArrayList[indexPath.row].content != nil && conversationArrayList[indexPath.row].content != "") {
                        aCell.labelChatStatus.text = conversationArrayList[indexPath.row].content
                                    }

                    if (conversationArrayList[indexPath.row].timestamp != "") {
                        aCell.labelChatDateTime.text = "" + (self.utcToLocal(dateStr: self.conversationArrayList[indexPath.row].timestamp ?? "") ?? "")
                                        
                                    }
                                    if (conversationArrayList[indexPath.row].rating != nil ){
                                        var rating = Double(conversationArrayList[indexPath.row].rating ?? 0)
                                        if(rating != 0 ) {
                                            aCell.stackViewFeedback.isHidden = false
                                            if self.customerName != ""{
                                                aCell.labelUserFirstName.text = self.customerName
                                            }
                                            
                                            if(conversationArrayList[indexPath.row].feedback != nil) {
                                                aCell.labelFeedback.isHidden = false
                                                aCell.labelFeedback.text = conversationArrayList[indexPath.row].feedback
                                                aCell.viewRating.rating = rating
                                            }
                                        }else{
                                            aCell.stackViewFeedback.isHidden = true
                                        }
                                    }
                    
                    
                    
                    
                    
                    return aCell
                }
                else if self.conversationArrayList[indexPath.row].type == "file" {
                    if self.conversationArrayList[indexPath.row].isFromWidget == true && !(self.conversationArrayList[indexPath.row].type?.elementsEqual("system"))!{
                        //this block is for login user for example customer
                        if !self.conversationArrayList.isEmpty{
                            if !self.conversationArrayList[indexPath.row].files!.isEmpty &&
                                !(self.conversationArrayList[indexPath.row].files?[0].url!.isEmpty)! {
                                
                                if self.conversationArrayList[indexPath.row].files?[0].type == "zip" || self.conversationArrayList[indexPath.row].files?[0].type == "application/zip"{
                                    
                                    let aCell = self.chatTableView.dequeueReusableCell(withIdentifier: self.cellReuseIdentifierCellFIleForLoginUser,for: indexPath) as! ConversationCellFIleForLoginUser
                                    aCell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
                                    aCell.ivImageFIleIcon.image = loadImageFromPodBundle(named: "zip")
                                    //aCell.ivImageFIleIcon.image = UIImage(named: "zip")
                                    aCell.lblFileName.text = self.conversationArrayList[indexPath.row].content!
                                    aCell.lblTIme.text = self.utcToLocal(dateStr: self.conversationArrayList[indexPath.row].timestamp ?? "")
                                    if self.conversationArrayList[indexPath.row].caption != "" && self.conversationArrayList[indexPath.row].caption != nil{
                                        aCell.labelCaption.isHidden = false
                                        aCell.labelCaption.text = self.conversationArrayList[indexPath.row].caption ?? ""
                                    }else{
                                        aCell.labelCaption.isHidden = true
                                        aCell.labelCaption.text = ""
                                    }
                                    //self.convertIsoStrigToDate(strDate: self.conversationArrayList[indexPath.row].timestamp!)
                                    
                                    if self.conversationArrayList[indexPath.row].isFailed == true{
                                        aCell.viewFailure.isHidden = false
                                        aCell.activityIndicator.isHidden = true
                                    }else{
                                        aCell.viewFailure.isHidden = true
                                        aCell.activityIndicator.isHidden = true
                                    }
                                    aCell.buttonResend.tag = indexPath.row
                                    aCell.buttonPressed = {
                                        if(Reachability.isConnectedToNetwork()){
                                            aCell.imageFailure.isHidden = true
                                            aCell.activityIndicator.isHidden = false
                                            aCell.activityIndicator.startAnimating()
                                            
                                            self.btnReuploadTapped(sender: aCell.buttonResend)
                                        }else{
                                            self.showToast(strMessage: "No Internet!")
                                        
                                        }
                                    }
                                    
                                    if self.conversationArrayList[indexPath.row].isNotNewChat == true{
                                        if self.conversationArrayList[indexPath.row].isUpdateStatus == true{
                                            if self.conversationArrayList[indexPath.row].isSeen! {
                                                aCell.ivFileStatus.image = loadImageFromPodBundle(named: "read_reciept")
                                                //aCell.ivFileStatus.image = UIImage(named: "read_reciept")
                                            }else{
                                                aCell.ivFileStatus.image = loadImageFromPodBundle(named: "tick")
                                                //aCell.ivFileStatus.image = UIImage(named: "tick")
                                            }
                                        }else{
                                            aCell.ivFileStatus.image = loadImageFromPodBundle(named: "send_messagetime")
                                            //aCell.ivFileStatus.image = UIImage(named: "send_messagetime")
                                        }
                                    }else{
                                        if self.conversationArrayList[indexPath.row].isSeen! {
                                            aCell.ivFileStatus.image = loadImageFromPodBundle(named: "read_reciept")
                                            //aCell.ivFileStatus.image = UIImage(named: "read_reciept")
                                        }else{
                                            //aCell.ivFileStatus.image = UIImage(named: "tick")
                                            aCell.ivFileStatus.image = loadImageFromPodBundle(named: "tick")
                                        }
                                        
                                    }
                                    self.showDownloadIconFileLoginUser(uitableVc: aCell, position: indexPath.row)
                                    return aCell
                                }
                                else if self.conversationArrayList[indexPath.row].files?[0].type == "rar" || self.conversationArrayList[indexPath.row].files?[0].type == "application/rar"{
                                    
                                    let aCell = self.chatTableView.dequeueReusableCell(withIdentifier: self.cellReuseIdentifierCellFIleForLoginUser,for: indexPath) as! ConversationCellFIleForLoginUser
                                    aCell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
                                    aCell.ivImageFIleIcon.image = loadImageFromPodBundle(named: "rar")
                                    //aCell.ivImageFIleIcon.image = UIImage(named: "rar")
                                    aCell.lblFileName.text = self.conversationArrayList[indexPath.row].content!
                                    aCell.lblTIme.text = self.utcToLocal(dateStr: self.conversationArrayList[indexPath.row].timestamp ?? "")
                                    if self.conversationArrayList[indexPath.row].caption != "" && self.conversationArrayList[indexPath.row].caption != nil{
                                        aCell.labelCaption.isHidden = false
                                        aCell.labelCaption.text = self.conversationArrayList[indexPath.row].caption ?? ""
                                    }else{
                                        aCell.labelCaption.isHidden = true
                                        aCell.labelCaption.text = ""
                                    }
                                    //self.convertIsoStrigToDate(strDate: self.conversationArrayList[indexPath.row].timestamp!)
                                    if self.conversationArrayList[indexPath.row].isFailed == true{
                                        aCell.viewFailure.isHidden = false
                                        aCell.activityIndicator.isHidden = true
                                    }else{
                                        aCell.viewFailure.isHidden = true
                                        aCell.activityIndicator.isHidden = true
                                    }
                                    aCell.buttonResend.tag = indexPath.row
                                    aCell.buttonPressed = {
                                        if(Reachability.isConnectedToNetwork()){
                                            aCell.imageFailure.isHidden = true
                                            aCell.activityIndicator.isHidden = false
                                            aCell.activityIndicator.startAnimating()
                                            
                                            self.btnReuploadTapped(sender: aCell.buttonResend)
                                        }else{
                                            self.showToast(strMessage: "No Internet!")
                                        }
                                    }
                                    
                                    if self.conversationArrayList[indexPath.row].isNotNewChat == true{
                                        if self.conversationArrayList[indexPath.row].isUpdateStatus == true{
                                            if self.conversationArrayList[indexPath.row].isSeen! {
                                                //aCell.ivFileStatus.image = UIImage(named: "read_reciept")
                                                aCell.ivFileStatus.image = loadImageFromPodBundle(named: "read_reciept")
                                            }else{
                                                //aCell.ivFileStatus.image = UIImage(named: "tick")
                                                aCell.ivFileStatus.image = loadImageFromPodBundle(named: "tick")
                                            }
                                        }else{
                                            //aCell.ivFileStatus.image = UIImage(named: "send_messagetime")
                                            aCell.ivFileStatus.image = loadImageFromPodBundle(named: "send_messagetime")
                                        }
                                    }else{
                                        if self.conversationArrayList[indexPath.row].isSeen! {
                                            //aCell.ivFileStatus.image = UIImage(named: "read_reciept")
                                            aCell.ivFileStatus.image = loadImageFromPodBundle(named: "read_reciept")
                                        }else{
                                            //aCell.ivFileStatus.image = UIImage(named: "tick")
                                            aCell.ivFileStatus.image = loadImageFromPodBundle(named: "tick")
                                        }
                                        
                                    }
                                    self.showDownloadIconFileLoginUser(uitableVc: aCell, position: indexPath.row)
                                    return aCell
                                    
                                }
                                else if self.conversationArrayList[indexPath.row].files?[0].type == "7z" || self.conversationArrayList[indexPath.row].files?[0].type == "application/7z"{
                                    
                                    
                                    let aCell = self.chatTableView.dequeueReusableCell(withIdentifier: self.cellReuseIdentifierCellFIleForLoginUser,for: indexPath) as! ConversationCellFIleForLoginUser
                                    aCell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
                                    aCell.ivImageFIleIcon.image = loadImageFromPodBundle(named: "sevenz")
                                    //aCell.ivImageFIleIcon.image = UIImage(named: "sevenz")
                                    aCell.lblFileName.text = self.conversationArrayList[indexPath.row].content!
                                    aCell.lblTIme.text = self.utcToLocal(dateStr: self.conversationArrayList[indexPath.row].timestamp ?? "")
                                    if self.conversationArrayList[indexPath.row].caption != "" && self.conversationArrayList[indexPath.row].caption != nil{
                                        aCell.labelCaption.isHidden = false
                                        aCell.labelCaption.text = self.conversationArrayList[indexPath.row].caption ?? ""
                                    }else{
                                        aCell.labelCaption.isHidden = true
                                        aCell.labelCaption.text = ""
                                    }
                                    //self.convertIsoStrigToDate(strDate: self.conversationArrayList[indexPath.row].timestamp!)
                                    if self.conversationArrayList[indexPath.row].isFailed == true{
                                        aCell.viewFailure.isHidden = false
                                        aCell.activityIndicator.isHidden = true
                                    }else{
                                        aCell.viewFailure.isHidden = true
                                        aCell.activityIndicator.isHidden = true
                                    }
                                    aCell.buttonResend.tag = indexPath.row
                                    aCell.buttonPressed = {
                                        if(Reachability.isConnectedToNetwork()){
                                            aCell.imageFailure.isHidden = true
                                            aCell.activityIndicator.isHidden = false
                                            aCell.activityIndicator.startAnimating()
                                            
                                            self.btnReuploadTapped(sender: aCell.buttonResend)
                                        }else{
                                            self.showToast(strMessage: "No Internet!")
                                        }
                                    }
                                    
                                    if self.conversationArrayList[indexPath.row].isNotNewChat == true{
                                        if self.conversationArrayList[indexPath.row].isUpdateStatus == true{
                                            if self.conversationArrayList[indexPath.row].isSeen! {
                                                aCell.ivFileStatus.image = loadImageFromPodBundle(named: "read_reciept")
                                                //aCell.ivFileStatus.image = UIImage(named: "read_reciept")
                                            }else{
                                                //aCell.ivFileStatus.image = UIImage(named: "tick")
                                                aCell.ivFileStatus.image = loadImageFromPodBundle(named: "tick")
                                            }
                                        }else{
                                            //aCell.ivFileStatus.image = UIImage(named: "send_messagetime")
                                            aCell.ivFileStatus.image = loadImageFromPodBundle(named: "send_messagetime")
                                        }
                                    }else{
                                        if self.conversationArrayList[indexPath.row].isSeen! {
                                            aCell.ivFileStatus.image = loadImageFromPodBundle(named: "read_reciept")
                                            //aCell.ivFileStatus.image = UIImage(named: "read_reciept")
                                        }else{
                                            aCell.ivFileStatus.image = loadImageFromPodBundle(named: "tick")
                                            //aCell.ivFileStatus.image = UIImage(named: "tick")
                                        }
                                    }
                                    self.showDownloadIconFileLoginUser(uitableVc: aCell, position: indexPath.row)
                                    return aCell
                                    
                                }
                                else if self.conversationArrayList[indexPath.row].files?[0].type == "txt" || self.conversationArrayList[indexPath.row].files?[0].type == "application/txt"{
                                    
                                    
                                    let aCell = self.chatTableView.dequeueReusableCell(withIdentifier: self.cellReuseIdentifierCellFIleForLoginUser,for: indexPath) as! ConversationCellFIleForLoginUser
                                    aCell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
                                    aCell.ivImageFIleIcon.image = loadImageFromPodBundle(named: "txt")
                                    //aCell.ivImageFIleIcon.image = UIImage(named: "txt")
                                    aCell.lblFileName.text = self.conversationArrayList[indexPath.row].content!
                                    aCell.lblTIme.text = self.utcToLocal(dateStr: self.conversationArrayList[indexPath.row].timestamp ?? "")
                                    if self.conversationArrayList[indexPath.row].caption != "" && self.conversationArrayList[indexPath.row].caption != nil{
                                        aCell.labelCaption.isHidden = false
                                        aCell.labelCaption.text = self.conversationArrayList[indexPath.row].caption ?? ""
                                    }else{
                                        aCell.labelCaption.isHidden = true
                                        aCell.labelCaption.text = ""
                                    }
                                    //self.convertIsoStrigToDate(strDate: self.conversationArrayList[indexPath.row].timestamp!)
                                    if self.conversationArrayList[indexPath.row].isFailed == true{
                                        aCell.viewFailure.isHidden = false
                                        aCell.activityIndicator.isHidden = true
                                    }else{
                                        aCell.viewFailure.isHidden = true
                                        aCell.activityIndicator.isHidden = true
                                    }
                                    aCell.buttonResend.tag = indexPath.row
                                    aCell.buttonPressed = {
                                        if(Reachability.isConnectedToNetwork()){
                                            aCell.imageFailure.isHidden = true
                                            aCell.activityIndicator.isHidden = false
                                            aCell.activityIndicator.startAnimating()
                                            
                                            self.btnReuploadTapped(sender: aCell.buttonResend)
                                        }else{
                                            self.showToast(strMessage: "No Internet!")
                                        }
                                        
                                    }
                                    
                                    if self.conversationArrayList[indexPath.row].isNotNewChat == true{
                                        if self.conversationArrayList[indexPath.row].isUpdateStatus == true{
                                            if self.conversationArrayList[indexPath.row].isSeen! {
                                                aCell.ivFileStatus.image = loadImageFromPodBundle(named: "read_reciept")
                                                aCell.ivFileStatus.image = UIImage(named: "read_reciept")
                                            }else{
                                                //aCell.ivFileStatus.image = UIImage(named: "tick")
                                                aCell.ivFileStatus.image = loadImageFromPodBundle(named: "tick")
                                            }
                                        }else{
                                            //aCell.ivFileStatus.image = UIImage(named: "send_messagetime")
                                            aCell.ivFileStatus.image = loadImageFromPodBundle(named: "send_messagetime")
                                        }
                                    }else{
                                        if self.conversationArrayList[indexPath.row].isSeen! {
                                            //aCell.ivFileStatus.image = UIImage(named: "read_reciept")
                                            aCell.ivFileStatus.image = loadImageFromPodBundle(named: "read_reciept")
                                        }else{
                                            //aCell.ivFileStatus.image = UIImage(named: "tick")
                                            aCell.ivFileStatus.image = loadImageFromPodBundle(named: "tick")
                                        }
                                    }
                                    self.showDownloadIconFileLoginUser(uitableVc: aCell, position: indexPath.row)
                                    return aCell
                                    
                                }
                                else if self.conversationArrayList[indexPath.row].files?[0].type == "pdf" || self.conversationArrayList[indexPath.row].files?[0].type == "application/pdf"{
                                    
                                    let aCell = self.chatTableView.dequeueReusableCell(withIdentifier: self.cellReuseIdentifierCellFIleForLoginUser,for: indexPath) as! ConversationCellFIleForLoginUser
                                    aCell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
                                    aCell.ivImageFIleIcon.image = loadImageFromPodBundle(named: "pdf")
                                    //aCell.ivImageFIleIcon.image = UIImage(named: "pdf")
                                    aCell.lblFileName.text = self.conversationArrayList[indexPath.row].content!
                                    aCell.lblTIme.text = self.utcToLocal(dateStr: self.conversationArrayList[indexPath.row].timestamp ?? "")
                                    if self.conversationArrayList[indexPath.row].caption != "" && self.conversationArrayList[indexPath.row].caption != nil{
                                        aCell.labelCaption.isHidden = false
                                        aCell.labelCaption.text = self.conversationArrayList[indexPath.row].caption ?? ""
                                    }else{
                                        aCell.labelCaption.isHidden = true
                                        aCell.labelCaption.text = ""
                                    }
                                    //self.convertIsoStrigToDate(strDate: self.conversationArrayList[indexPath.row].timestamp!)
                                    if self.conversationArrayList[indexPath.row].isFailed == true{
                                        aCell.viewFailure.isHidden = false
                                        aCell.activityIndicator.isHidden = true
                                    }else{
                                        
                                        aCell.viewFailure.isHidden = true
                                        aCell.activityIndicator.isHidden = true
                                        
                                    }
                                    aCell.buttonResend.tag = indexPath.row
                                    aCell.buttonPressed = {
                                        if(Reachability.isConnectedToNetwork()){
                                            aCell.imageFailure.isHidden = true
                                            aCell.activityIndicator.isHidden = false
                                            aCell.activityIndicator.startAnimating()
                                            
                                            self.btnReuploadTapped(sender: aCell.buttonResend)
                                        }else{
                                            self.showToast(strMessage: "No Internet!")
                                        }
                                    }
                                    
                                    if self.conversationArrayList[indexPath.row].isNotNewChat == true{
                                        if self.conversationArrayList[indexPath.row].isUpdateStatus == true{
                                            if self.conversationArrayList[indexPath.row].isSeen! {
                                                aCell.ivFileStatus.image = loadImageFromPodBundle(named: "read_reciept")
                                                //aCell.ivFileStatus.image = UIImage(named: "read_reciept")
                                            }else{
                                                //aCell.ivFileStatus.image = UIImage(named: "tick")
                                                aCell.ivFileStatus.image = loadImageFromPodBundle(named: "tick")
                                            }
                                        }else{
                                            //aCell.ivFileStatus.image = UIImage(named: "send_messagetime")
                                            aCell.ivFileStatus.image = loadImageFromPodBundle(named: "send_messagetime")
                                        }
                                    }else{
                                        if self.conversationArrayList[indexPath.row].isSeen! {
                                            aCell.ivFileStatus.image = loadImageFromPodBundle(named: "read_reciept")
                                            //aCell.ivFileStatus.image = UIImage(named: "read_reciept")
                                        }else{
                                            //aCell.ivFileStatus.image = UIImage(named: "tick")
                                            aCell.ivFileStatus.image = loadImageFromPodBundle(named: "tick")
                                        }
                                    }
                                    self.showDownloadIconFileLoginUser(uitableVc: aCell, position: indexPath.row)
                                    return aCell
                                }
                                else if self.conversationArrayList[indexPath.row].files?[0].type == "msword" || self.conversationArrayList[indexPath.row].files?[0].type == "application/msword"{
                                    
                                    let aCell = self.chatTableView.dequeueReusableCell(withIdentifier: self.cellReuseIdentifierCellFIleForLoginUser,for: indexPath) as! ConversationCellFIleForLoginUser
                                    aCell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
                                    aCell.ivImageFIleIcon.image = loadImageFromPodBundle(named: "msword_ic")
                                    //aCell.ivImageFIleIcon.image = UIImage(named: "msword_ic")
                                    aCell.lblFileName.text = self.conversationArrayList[indexPath.row].content!
                                    aCell.lblTIme.text = self.utcToLocal(dateStr: self.conversationArrayList[indexPath.row].timestamp ?? "")
                                    if self.conversationArrayList[indexPath.row].caption != "" && self.conversationArrayList[indexPath.row].caption != nil{
                                        aCell.labelCaption.isHidden = false
                                        aCell.labelCaption.text = self.conversationArrayList[indexPath.row].caption ?? ""
                                    }else{
                                        aCell.labelCaption.isHidden = true
                                        aCell.labelCaption.text = ""
                                    }
                                    //self.convertIsoStrigToDate(strDate: self.conversationArrayList[indexPath.row].timestamp!)
                                    if self.conversationArrayList[indexPath.row].isFailed == true{
                                        aCell.viewFailure.isHidden = false
                                        aCell.activityIndicator.isHidden = true
                                    }else{
                                        aCell.viewFailure.isHidden = true
                                        aCell.activityIndicator.isHidden = true
                                    }
                                    aCell.buttonResend.tag = indexPath.row
                                    aCell.buttonPressed = {
                                        if(Reachability.isConnectedToNetwork()){
                                            aCell.imageFailure.isHidden = true
                                            aCell.activityIndicator.isHidden = false
                                            aCell.activityIndicator.startAnimating()
                                            
                                            self.btnReuploadTapped(sender: aCell.buttonResend)
                                        }else{
                                            self.showToast(strMessage: "No Internet!")
                                        }
                                    }
                                    
                                    if self.conversationArrayList[indexPath.row].isNotNewChat == true{
                                        if self.conversationArrayList[indexPath.row].isUpdateStatus == true{
                                            if self.conversationArrayList[indexPath.row].isSeen! {
                                                aCell.ivFileStatus.image = loadImageFromPodBundle(named: "read_reciept")
                                               //aCell.ivFileStatus.image = UIImage(named: "read_reciept")
                                            }else{
                                                //aCell.ivFileStatus.image = UIImage(named: "tick")
                                                aCell.ivFileStatus.image = loadImageFromPodBundle(named: "tick")
                                            }
                                        }else{
                                            //aCell.ivFileStatus.image = UIImage(named: "send_messagetime")
                                            aCell.ivFileStatus.image = loadImageFromPodBundle(named: "send_messagetime")
                                        }
                                    }else{
                                        if self.conversationArrayList[indexPath.row].isSeen! {
                                            aCell.ivFileStatus.image = loadImageFromPodBundle(named: "read_reciept")
                                            //aCell.ivFileStatus.image = UIImage(named: "read_reciept")
                                        }else{
                                            //aCell.ivFileStatus.image = UIImage(named: "tick")
                                            aCell.ivFileStatus.image = loadImageFromPodBundle(named: "tick")
                                        }
                                    }
                                    self.showDownloadIconFileLoginUser(uitableVc: aCell, position: indexPath.row)
                                    return aCell
                                }  else if self.conversationArrayList[indexPath.row].files?[0].type == "docx" || self.conversationArrayList[indexPath.row].files?[0].type == "application/docx"{
                                    
                                    
                                    let aCell = self.chatTableView.dequeueReusableCell(withIdentifier: self.cellReuseIdentifierCellFIleForLoginUser,for: indexPath) as! ConversationCellFIleForLoginUser
                                    aCell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
                                    aCell.ivImageFIleIcon.image = loadImageFromPodBundle(named: "docx_ic")
                                    //aCell.ivImageFIleIcon.image = UIImage(named: "docx_ic")
                                    aCell.lblFileName.text = self.conversationArrayList[indexPath.row].content!
                                    aCell.lblTIme.text = self.utcToLocal(dateStr: self.conversationArrayList[indexPath.row].timestamp ?? "")
                                    if self.conversationArrayList[indexPath.row].caption != "" && self.conversationArrayList[indexPath.row].caption != nil{
                                        aCell.labelCaption.isHidden = false
                                        aCell.labelCaption.text = self.conversationArrayList[indexPath.row].caption ?? ""
                                    }else{
                                        aCell.labelCaption.isHidden = true
                                        aCell.labelCaption.text = ""
                                    }
                                    //self.convertIsoStrigToDate(strDate: self.conversationArrayList[indexPath.row].timestamp!)
                                    if self.conversationArrayList[indexPath.row].isFailed == true{
                                        aCell.viewFailure.isHidden = false
                                        aCell.activityIndicator.isHidden = true
                                    }else{
                                        aCell.viewFailure.isHidden = true
                                        aCell.activityIndicator.isHidden = true
                                    }
                                    aCell.buttonResend.tag = indexPath.row
                                    aCell.buttonPressed = {
                                        if(Reachability.isConnectedToNetwork()){
                                            aCell.imageFailure.isHidden = true
                                            aCell.activityIndicator.isHidden = false
                                            aCell.activityIndicator.startAnimating()
                                            
                                            self.btnReuploadTapped(sender: aCell.buttonResend)
                                        }else{
                                            self.showToast(strMessage: "No Internet!")
                                        }
                                    }
                                    
                                    if self.conversationArrayList[indexPath.row].isNotNewChat == true{
                                        if self.conversationArrayList[indexPath.row].isUpdateStatus == true{
                                            if self.conversationArrayList[indexPath.row].isSeen! {
                                                //aCell.ivFileStatus.image = UIImage(named: "read_reciept")
                                                aCell.ivFileStatus.image = loadImageFromPodBundle(named: "read_reciept")
                                            }else{
                                                //aCell.ivFileStatus.image = UIImage(named: "tick")
                                                aCell.ivFileStatus.image = loadImageFromPodBundle(named: "tick")
                                            }
                                        }else{
                                            //aCell.ivFileStatus.image = UIImage(named: "send_messagetime")
                                            aCell.ivFileStatus.image = loadImageFromPodBundle(named: "send_messagetime")
                                        }
                                    }else{
                                        if self.conversationArrayList[indexPath.row].isSeen! {
                                            aCell.ivFileStatus.image = loadImageFromPodBundle(named: "read_reciept")
                                            //aCell.ivFileStatus.image = UIImage(named: "read_reciept")
                                        }else{
                                            //aCell.ivFileStatus.image = UIImage(named: "tick")
                                            aCell.ivFileStatus.image = loadImageFromPodBundle(named: "tick")
                                        }
                                    }
                                    self.showDownloadIconFileLoginUser(uitableVc: aCell, position: indexPath.row)
                                    return aCell
                                } else if self.conversationArrayList[indexPath.row].files?[0].type == "doc" || self.conversationArrayList[indexPath.row].files?[0].type == "application/doc" || self.conversationArrayList[indexPath.row].files?[0].type == "application/vnd.openxmlformats-officedocument.wordprocessingml.document" {
                                    let aCell = self.chatTableView.dequeueReusableCell(withIdentifier: self.cellReuseIdentifierCellFIleForLoginUser,for: indexPath) as! ConversationCellFIleForLoginUser
                                    aCell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
                                    aCell.ivImageFIleIcon.image = loadImageFromPodBundle(named: "doc")
                                    //aCell.ivImageFIleIcon.image = UIImage(named: "doc")
                                    aCell.lblFileName.text = self.conversationArrayList[indexPath.row].content!
                                    aCell.lblTIme.text = self.utcToLocal(dateStr: self.conversationArrayList[indexPath.row].timestamp ?? "")
                                    if self.conversationArrayList[indexPath.row].caption != "" && self.conversationArrayList[indexPath.row].caption != nil{
                                        aCell.labelCaption.isHidden = false
                                        aCell.labelCaption.text = self.conversationArrayList[indexPath.row].caption ?? ""
                                    }else{
                                        aCell.labelCaption.isHidden = true
                                        aCell.labelCaption.text = ""
                                    }
                                    //self.convertIsoStrigToDate(strDate: self.conversationArrayList[indexPath.row].timestamp!)
                                    if self.conversationArrayList[indexPath.row].isFailed == true{
                                        aCell.viewFailure.isHidden = false
                                        aCell.activityIndicator.isHidden = true
                                    }else{
                                        aCell.viewFailure.isHidden = true
                                        aCell.activityIndicator.isHidden = true
                                    }
                                    aCell.buttonResend.tag = indexPath.row
                                    aCell.buttonPressed = {
                                        if(Reachability.isConnectedToNetwork()){
                                            aCell.imageFailure.isHidden = true
                                            aCell.activityIndicator.isHidden = false
                                            aCell.activityIndicator.startAnimating()
                                            
                                            self.btnReuploadTapped(sender: aCell.buttonResend)
                                        }else{
                                            self.showToast(strMessage: "No Internet!")
                                        }
                                    }
                                    
                                    if self.conversationArrayList[indexPath.row].isNotNewChat == true{
                                        if self.conversationArrayList[indexPath.row].isUpdateStatus == true{
                                            if self.conversationArrayList[indexPath.row].isSeen! {
                                                aCell.ivFileStatus.image = loadImageFromPodBundle(named: "read_reciept")
                                                //aCell.ivFileStatus.image = UIImage(named: "read_reciept")
                                            }else{
                                                //aCell.ivFileStatus.image = UIImage(named: "tick")
                                                aCell.ivFileStatus.image = loadImageFromPodBundle(named: "tick")
                                            }
                                            
                                        }else{
                                            //aCell.ivFileStatus.image = UIImage(named: "send_messagetime")
                                            aCell.ivFileStatus.image = loadImageFromPodBundle(named: "send_messagetime")
                                        }
                                    }else{
                                        if self.conversationArrayList[indexPath.row].isSeen! {
                                            //aCell.ivFileStatus.image = UIImage(named: "read_reciept")
                                            aCell.ivFileStatus.image = loadImageFromPodBundle(named: "read_reciept")
                                        }else{
                                            //aCell.ivFileStatus.image = UIImage(named: "tick")
                                            aCell.ivFileStatus.image = loadImageFromPodBundle(named: "tick")
                                        }
                                    }
                                    self.showDownloadIconFileLoginUser(uitableVc: aCell, position: indexPath.row)
                                    return aCell
                                }
                                else if self.conversationArrayList[indexPath.row].files?[0].type == "xls" || self.conversationArrayList[indexPath.row].files?[0].type == "application/xls"{
                                    
                                    let aCell = self.chatTableView.dequeueReusableCell(withIdentifier: self.cellReuseIdentifierCellFIleForLoginUser,for: indexPath) as! ConversationCellFIleForLoginUser
                                    aCell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
                                    aCell.ivImageFIleIcon.image = loadImageFromPodBundle(named: "xls")
                                    //aCell.ivImageFIleIcon.image = UIImage(named: "xls")
                                    aCell.lblFileName.text = self.conversationArrayList[indexPath.row].content!
                                    aCell.lblTIme.text = self.utcToLocal(dateStr: self.conversationArrayList[indexPath.row].timestamp ?? "")
                                    if self.conversationArrayList[indexPath.row].caption != "" && self.conversationArrayList[indexPath.row].caption != nil{
                                        aCell.labelCaption.isHidden = false
                                        aCell.labelCaption.text = self.conversationArrayList[indexPath.row].caption ?? ""
                                    }else{
                                        aCell.labelCaption.isHidden = true
                                        aCell.labelCaption.text = ""
                                    }
                                    //self.convertIsoStrigToDate(strDate: self.conversationArrayList[indexPath.row].timestamp!)
                                    if self.conversationArrayList[indexPath.row].isFailed == true{
                                        aCell.viewFailure.isHidden = false
                                        aCell.activityIndicator.isHidden = true
                                    }else{
                                        aCell.viewFailure.isHidden = true
                                        aCell.activityIndicator.isHidden = true
                                    }
                                    aCell.buttonResend.tag = indexPath.row
                                    aCell.buttonPressed = {
                                        if(Reachability.isConnectedToNetwork()){
                                            aCell.imageFailure.isHidden = true
                                            aCell.activityIndicator.isHidden = false
                                            aCell.activityIndicator.startAnimating()
                                            
                                            self.btnReuploadTapped(sender: aCell.buttonResend)
                                        }else{
                                            self.showToast(strMessage: "No Internet!")
                                        }
                                    }
                                    
                                    if self.conversationArrayList[indexPath.row].isNotNewChat == true{
                                        if self.conversationArrayList[indexPath.row].isUpdateStatus == true{
                                            if self.conversationArrayList[indexPath.row].isSeen! {
                                                //aCell.ivFileStatus.image = UIImage(named: "read_reciept")
                                                aCell.ivFileStatus.image = loadImageFromPodBundle(named: "read_reciept")
                                            }else{
                                                //aCell.ivFileStatus.image = UIImage(named: "tick")
                                                aCell.ivFileStatus.image = loadImageFromPodBundle(named: "tick")
                                            }
                                        }else{
                                            //aCell.ivFileStatus.image = UIImage(named: "send_messagetime")
                                            aCell.ivFileStatus.image = loadImageFromPodBundle(named: "send_messagetime")
                                        }
                                    }else{
                                        if self.conversationArrayList[indexPath.row].isSeen! {
                                            aCell.ivFileStatus.image = loadImageFromPodBundle(named: "read_reciept")
                                            //aCell.ivFileStatus.image = UIImage(named: "read_reciept")
                                        }else{
                                           // aCell.ivFileStatus.image = UIImage(named: "tick")
                                            aCell.ivFileStatus.image = loadImageFromPodBundle(named: "tick")
                                        }
                                    }
                                    self.showDownloadIconFileLoginUser(uitableVc: aCell, position: indexPath.row)
                                    return aCell
                                }
                                else if self.conversationArrayList[indexPath.row].files?[0].type == "xlsx" || self.conversationArrayList[indexPath.row].files?[0].type == "application/xlsx"{
                                    let aCell = self.chatTableView.dequeueReusableCell(withIdentifier: self.cellReuseIdentifierCellFIleForLoginUser,for: indexPath) as! ConversationCellFIleForLoginUser
                                    aCell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
                                    aCell.ivImageFIleIcon.image = loadImageFromPodBundle(named: "xlsx")
                                    //aCell.ivImageFIleIcon.image = UIImage(named: "xlsx")
                                    aCell.lblFileName.text = self.conversationArrayList[indexPath.row].content!
                                    aCell.lblTIme.text = self.utcToLocal(dateStr: self.conversationArrayList[indexPath.row].timestamp ?? "")
                                    
                                    if self.conversationArrayList[indexPath.row].caption != "" && self.conversationArrayList[indexPath.row].caption != nil{
                                        aCell.labelCaption.isHidden = false
                                        aCell.labelCaption.text = self.conversationArrayList[indexPath.row].caption ?? ""
                                    }else{
                                        aCell.labelCaption.isHidden = true
                                        aCell.labelCaption.text = ""
                                    }
                                    
                                    //self.convertIsoStrigToDate(strDate: self.conversationArrayList[indexPath.row].timestamp!)
                                    if self.conversationArrayList[indexPath.row].isFailed == true{
                                        aCell.viewFailure.isHidden = false
                                        aCell.activityIndicator.isHidden = true
                                    }else{
                                        aCell.viewFailure.isHidden = true
                                        aCell.activityIndicator.isHidden = true
                                    }
                                    aCell.buttonResend.tag = indexPath.row
                                    aCell.buttonPressed = {
                                        if(Reachability.isConnectedToNetwork()){
                                            aCell.imageFailure.isHidden = true
                                            aCell.activityIndicator.isHidden = false
                                            aCell.activityIndicator.startAnimating()
                                            
                                            self.btnReuploadTapped(sender: aCell.buttonResend)
                                        }else{
                                            self.showToast(strMessage: "No Internet!")
                                        }
                                    }
                                    
                                    if self.conversationArrayList[indexPath.row].isNotNewChat == true{
                                        if self.conversationArrayList[indexPath.row].isUpdateStatus == true{
                                            if self.conversationArrayList[indexPath.row].isSeen! {
                                                aCell.ivFileStatus.image = UIImage(named: "read_reciept")
                                                aCell.ivFileStatus.image = loadImageFromPodBundle(named: "read_reciept")
                                            }else{
                                                //aCell.ivFileStatus.image = UIImage(named: "tick")
                                                aCell.ivFileStatus.image = loadImageFromPodBundle(named: "tick")
                                            }
                                        }else{
                                            //aCell.ivFileStatus.image = UIImage(named: "send_messagetime")
                                            aCell.ivFileStatus.image = loadImageFromPodBundle(named: "send_messagetime")
                                        }
                                    }else{
                                        if self.conversationArrayList[indexPath.row].isSeen! {
                                            //aCell.ivFileStatus.image = UIImage(named: "read_reciept")
                                            aCell.ivFileStatus.image = loadImageFromPodBundle(named: "read_reciept")
                                        }else{
                                            //aCell.ivFileStatus.image = UIImage(named: "tick")
                                            aCell.ivFileStatus.image = loadImageFromPodBundle(named: "tick")
                                        }
                                    }
                                    self.showDownloadIconFileLoginUser(uitableVc: aCell, position: indexPath.row)
                                    return aCell
                                    
                                } else if self.conversationArrayList[indexPath.row].files?[0].type == "csv" || self.conversationArrayList[indexPath.row].files?[0].type == "application/csv"{
                                    let aCell = self.chatTableView.dequeueReusableCell(withIdentifier: self.cellReuseIdentifierCellFIleForLoginUser,for: indexPath) as! ConversationCellFIleForLoginUser
                                    aCell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
                                    aCell.ivImageFIleIcon.image = loadImageFromPodBundle(named: "csv")
                                    //aCell.ivImageFIleIcon.image = UIImage(named: "csv")
                                    aCell.lblFileName.text = self.conversationArrayList[indexPath.row].content!
                                    aCell.lblTIme.text = self.utcToLocal(dateStr: self.conversationArrayList[indexPath.row].timestamp ?? "")
                                    if self.conversationArrayList[indexPath.row].caption != "" && self.conversationArrayList[indexPath.row].caption != nil{
                                        aCell.labelCaption.isHidden = false
                                        aCell.labelCaption.text = self.conversationArrayList[indexPath.row].caption ?? ""
                                    }else{
                                        aCell.labelCaption.isHidden = true
                                        aCell.labelCaption.text = ""
                                    }
                                    //self.convertIsoStrigToDate(strDate: self.conversationArrayList[indexPath.row].timestamp!)
                                    if self.conversationArrayList[indexPath.row].isFailed == true{
                                        aCell.viewFailure.isHidden = false
                                        aCell.activityIndicator.isHidden = true
                                    }else{
                                        aCell.viewFailure.isHidden = true
                                        aCell.activityIndicator.isHidden = true
                                    }
                                    aCell.buttonResend.tag = indexPath.row
                                    aCell.buttonPressed = {
                                        if(Reachability.isConnectedToNetwork()){
                                            aCell.imageFailure.isHidden = true
                                            aCell.activityIndicator.isHidden = false
                                            aCell.activityIndicator.startAnimating()
                                            
                                            self.btnReuploadTapped(sender: aCell.buttonResend)
                                        }else{
                                            self.showToast(strMessage: "No Internet!")
                                        }
                                    }
                                    
                                    if self.conversationArrayList[indexPath.row].isNotNewChat == true{
                                        if self.conversationArrayList[indexPath.row].isUpdateStatus == true{
                                            if self.conversationArrayList[indexPath.row].isSeen! {
                                                //aCell.ivFileStatus.image = UIImage(named: "read_reciept")
                                                aCell.ivFileStatus.image = loadImageFromPodBundle(named: "read_reciept")
                                            }else{
                                                //aCell.ivFileStatus.image = UIImage(named: "tick")
                                                aCell.ivFileStatus.image = loadImageFromPodBundle(named: "tick")
                                            }
                                        }else{
                                            //aCell.ivFileStatus.image = UIImage(named: "send_messagetime")
                                            aCell.ivFileStatus.image = loadImageFromPodBundle(named: "send_messagetime")
                                        }
                                    }else{
                                        if self.conversationArrayList[indexPath.row].isSeen! {
                                            aCell.ivFileStatus.image = loadImageFromPodBundle(named: "read_reciept")
                                            //aCell.ivFileStatus.image = UIImage(named: "read_reciept")
                                        }else{
                                            //aCell.ivFileStatus.image = UIImage(named: "tick")
                                            aCell.ivFileStatus.image = loadImageFromPodBundle(named: "tick")
                                        }
                                    }
                                    self.showDownloadIconFileLoginUser(uitableVc: aCell, position: indexPath.row)
                                    return aCell
                                }else {
                                    
                                    let aCell = self.chatTableView.dequeueReusableCell(withIdentifier: self.cellReuseIdentifierCellImageLoginUser,for: indexPath) as! ConversationCellImageLoginUser
                                    aCell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
                                    if self.conversationArrayList[indexPath.row].caption != "" && self.conversationArrayList[indexPath.row].caption != nil{
                                        aCell.labelImageCaption.isHidden = false
                                        aCell.labelImageCaption.text = self.conversationArrayList[indexPath.row].caption ?? ""
                                    }else{
                                        aCell.labelImageCaption.isHidden = true
                                        aCell.labelImageCaption.text = ""
                                    }
                                    if self.conversationArrayList[indexPath.row].files![0].isLocalFile == true {
                                        if !self.conversationArrayList[indexPath.row].files![0].url!.isEmpty{
                                            // Load image asynchronously
                                            DispatchQueue.main.async{
                                                aCell.ivImage.image = UtilsClassChat.sheard.convertBase64StringToImage(imageBase64String: self.conversationArrayList[indexPath.row].files![0].url!)
                                            }
                                        }
                                        
                                    }else{
//                                        aCell.ivImage.setImage(with: self.conversationArrayList[indexPath.row].files![0].url ?? "", placeHolder: UIImage(named: "placeholder"))
                                        DispatchQueue.main.async {
                                            //aCell.ivImage.load.request(with: self.conversationArrayList[indexPath.row].files![0].url ?? "")
                                            let url = URL(string: self.conversationArrayList[indexPath.row].files![0].url ?? "")
                                            aCell.ivImage.kf.setImage(with: url)
                                        }
                                    }
                                    aCell.lblTime.text = self.utcToLocal(dateStr: self.conversationArrayList[indexPath.row].timestamp ?? "")
                                    //self.convertIsoStrigToDate(strDate: self.conversationArrayList[indexPath.row].timestamp!)
                                    if self.conversationArrayList[indexPath.row].isFailed == true{
                                        aCell.viewFailure.isHidden = false
                                        aCell.activityIndicator.isHidden = true
                                    }else{
//                                        if self.conversationArrayList[indexPath.row].isReceived == false{
//                                            aCell.failureStack.isHidden = true
//                                            aCell.activityIndicator.isHidden = false
//                                            aCell.activityIndicator.startAnimating()
//                                        }else{
                                            aCell.viewFailure.isHidden = true
                                            aCell.activityIndicator.isHidden = true
//                                        }
                                        
                                    }
                                    aCell.buttonReupload.tag = indexPath.row
                                    aCell.buttonPressed = {
                                        if(Reachability.isConnectedToNetwork()){
                                            aCell.failureStack.isHidden = true
                                            aCell.activityIndicator.isHidden = false
                                            aCell.activityIndicator.startAnimating()
                                            
                                            self.btnReuploadTapped(sender: aCell.buttonReupload)
                                        }else{
                                            self.showToast(strMessage: "No Internet!")
                                        }
                                    }
//                                    aCell.buttonReupload.addTarget(self, action: #selector(btnReuploadTapped(sender:)), for: .touchUpInside)
                                    
                                    if self.conversationArrayList[indexPath.row].isNotNewChat == true{
                                        if self.conversationArrayList[indexPath.row].isUpdateStatus == true{
                                            if self.conversationArrayList[indexPath.row].isSeen! {
                                                aCell.imgageStatus.image = loadImageFromPodBundle(named: "read_reciept")
                                                //aCell.imgageStatus.image = UIImage(named: "read_reciept")
                                            }else{
                                                //aCell.imgageStatus.image = UIImage(named: "tick")
                                                aCell.imgageStatus.image = loadImageFromPodBundle(named: "tick")
                                            }
                                        }else{
                                            //aCell.imgageStatus.image = UIImage(named: "send_messagetime")
                                            aCell.imgageStatus.image = loadImageFromPodBundle(named: "send_messagetime")
                                        }
                                    }else{
                                        if self.conversationArrayList[indexPath.row].isSeen! {
                                           // aCell.imgageStatus.image = UIImage(named: "read_reciept")
                                            aCell.imgageStatus.image = loadImageFromPodBundle(named: "read_reciept")
                                        }else{
                                            //aCell.imgageStatus.image = UIImage(named: "tick")
                                            aCell.imgageStatus.image = loadImageFromPodBundle(named: "tick")
                                        }
                                    }
                                    self.showDownloadIconImageLoginUser(uitableVc: aCell, position: indexPath.row)
                                    return aCell
                                }
                                
                            }
                        }
                    }else{
                        
                        //this block is for sender for example admin side
                        
                        if !self.conversationArrayList[indexPath.row].files!.isEmpty &&
                            !(self.conversationArrayList[indexPath.row].files?[0].url!.isEmpty)! {
                            
                            if self.conversationArrayList[indexPath.row].files?[0].type == "zip" || self.conversationArrayList[indexPath.row].files?[0].type == "application/zip"{
                                
                                let aCell = self.chatTableView.dequeueReusableCell(withIdentifier: self.cellReuseIdentifierCellFIleForNonLoginUser,for: indexPath) as! ConversationCellFileNonLoginUser
                                aCell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
                                aCell.ivImageIcon.image = loadImageFromPodBundle(named: "zip")
                                //aCell.ivImageIcon.image = UIImage(named: "zip")
                                aCell.lblFileName.text = self.conversationArrayList[indexPath.row].content!
                                aCell.lblTime.text = self.utcToLocal(dateStr: self.conversationArrayList[indexPath.row].timestamp ?? "")
                                if self.conversationArrayList[indexPath.row].caption != "" && self.conversationArrayList[indexPath.row].caption != nil{
                                    aCell.labelCaption.isHidden = false
                                    aCell.labelCaption.text = self.conversationArrayList[indexPath.row].caption ?? ""
                                }else{
                                    aCell.labelCaption.isHidden = true
                                    aCell.labelCaption.text = ""
                                }
                                //self.convertIsoStrigToDate(strDate: self.conversationArrayList[indexPath.row].timestamp!)
                                self.showDownloadIconFileNonLoginUser(uitableVc: aCell, position: indexPath.row)
                                return aCell
                            }
                            else if self.conversationArrayList[indexPath.row].files?[0].type == "rar" || self.conversationArrayList[indexPath.row].files?[0].type == "application/rar" {
                                
                                let aCell = self.chatTableView.dequeueReusableCell(withIdentifier: self.cellReuseIdentifierCellFIleForNonLoginUser,for: indexPath) as! ConversationCellFileNonLoginUser
                                aCell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
                                aCell.ivImageIcon.image = loadImageFromPodBundle(named: "rar")
                                //aCell.ivImageIcon.image = UIImage(named: "rar")
                                aCell.lblFileName.text = self.conversationArrayList[indexPath.row].content!
                                aCell.lblTime.text = self.utcToLocal(dateStr: self.conversationArrayList[indexPath.row].timestamp ?? "")
                                if self.conversationArrayList[indexPath.row].caption != "" && self.conversationArrayList[indexPath.row].caption != nil{
                                    aCell.labelCaption.isHidden = false
                                    aCell.labelCaption.text = self.conversationArrayList[indexPath.row].caption ?? ""
                                }else{
                                    aCell.labelCaption.isHidden = true
                                    aCell.labelCaption.text = ""
                                }
                                //self.convertIsoStrigToDate(strDate: self.conversationArrayList[indexPath.row].timestamp!)
                                self.showDownloadIconFileNonLoginUser(uitableVc: aCell, position: indexPath.row)
                                
                                return aCell
                                
                            }
                            else if self.conversationArrayList[indexPath.row].files?[0].type == "7z" || self.conversationArrayList[indexPath.row].files?[0].type == "application/7z"{
                                
                                let aCell = self.chatTableView.dequeueReusableCell(withIdentifier: self.cellReuseIdentifierCellFIleForNonLoginUser,for: indexPath) as! ConversationCellFileNonLoginUser
                                aCell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
                                aCell.ivImageIcon.image = loadImageFromPodBundle(named: "sevenz")
                                //aCell.ivImageIcon.image = UIImage(named: "sevenz")
                                aCell.lblFileName.text = self.conversationArrayList[indexPath.row].content!
                                aCell.lblTime.text = self.utcToLocal(dateStr: self.conversationArrayList[indexPath.row].timestamp ?? "")
                                if self.conversationArrayList[indexPath.row].caption != "" && self.conversationArrayList[indexPath.row].caption != nil{
                                    aCell.labelCaption.isHidden = false
                                    aCell.labelCaption.text = self.conversationArrayList[indexPath.row].caption ?? ""
                                }else{
                                    aCell.labelCaption.isHidden = true
                                    aCell.labelCaption.text = ""
                                }
                                //self.convertIsoStrigToDate(strDate: self.conversationArrayList[indexPath.row].timestamp!)
                                self.showDownloadIconFileNonLoginUser(uitableVc: aCell, position: indexPath.row)
                                
                                return aCell
                                
                            }
                            else if self.conversationArrayList[indexPath.row].files?[0].type == "txt" || self.conversationArrayList[indexPath.row].files?[0].type == "application/txt"{
                                
                                let aCell = self.chatTableView.dequeueReusableCell(withIdentifier: self.cellReuseIdentifierCellFIleForNonLoginUser,for: indexPath) as! ConversationCellFileNonLoginUser
                                aCell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
                                
                                aCell.ivImageIcon.image = loadImageFromPodBundle(named: "txt_ic")
                                //aCell.ivImageIcon.image = UIImage(named: "txt_ic")
                                aCell.lblFileName.text = self.conversationArrayList[indexPath.row].content!
                                aCell.lblTime.text = self.utcToLocal(dateStr: self.conversationArrayList[indexPath.row].timestamp ?? "")
                                if self.conversationArrayList[indexPath.row].caption != "" && self.conversationArrayList[indexPath.row].caption != nil{
                                    aCell.labelCaption.isHidden = false
                                    aCell.labelCaption.text = self.conversationArrayList[indexPath.row].caption ?? ""
                                }else{
                                    aCell.labelCaption.isHidden = true
                                    aCell.labelCaption.text = ""
                                }
                                //self.convertIsoStrigToDate(strDate: self.conversationArrayList[indexPath.row].timestamp!)
                                self.showDownloadIconFileNonLoginUser(uitableVc: aCell, position: indexPath.row)
                                
                                return aCell
                                
                            }
                            else if self.conversationArrayList[indexPath.row].files?[0].type == "pdf" || self.conversationArrayList[indexPath.row].files?[0].type == "application/pdf"{
                                
                                let aCell = self.chatTableView.dequeueReusableCell(withIdentifier: self.cellReuseIdentifierCellFIleForNonLoginUser,for: indexPath) as! ConversationCellFileNonLoginUser
                                aCell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
                                aCell.ivImageIcon.image = loadImageFromPodBundle(named: "pdf")
                                //aCell.ivImageIcon.image = UIImage(named: "pdf")
                                aCell.lblFileName.text = self.conversationArrayList[indexPath.row].content!
                                aCell.lblTime.text = self.utcToLocal(dateStr: self.conversationArrayList[indexPath.row].timestamp ?? "")
                                if self.conversationArrayList[indexPath.row].caption != "" && self.conversationArrayList[indexPath.row].caption != nil{
                                    aCell.labelCaption.isHidden = false
                                    aCell.labelCaption.text = self.conversationArrayList[indexPath.row].caption ?? ""
                                }else{
                                    aCell.labelCaption.isHidden = true
                                    aCell.labelCaption.text = ""
                                }
                                //self.convertIsoStrigToDate(strDate: self.conversationArrayList[indexPath.row].timestamp!)
                                self.showDownloadIconFileNonLoginUser(uitableVc: aCell, position: indexPath.row)
                                
                                return aCell
                            }
                            else if self.conversationArrayList[indexPath.row].files?[0].type == "msword" || self.conversationArrayList[indexPath.row].files?[0].type == "application/msword"{
                                let aCell = self.chatTableView.dequeueReusableCell(withIdentifier: self.cellReuseIdentifierCellFIleForNonLoginUser,for: indexPath) as! ConversationCellFileNonLoginUser
                                aCell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
                                aCell.ivImageIcon.image = loadImageFromPodBundle(named: "msword_ic")
                                //aCell.ivImageIcon.image = UIImage(named: "msword_ic")
                                aCell.lblFileName.text = self.conversationArrayList[indexPath.row].content!
                                aCell.lblTime.text = self.utcToLocal(dateStr: self.conversationArrayList[indexPath.row].timestamp ?? "")
                                if self.conversationArrayList[indexPath.row].caption != "" && self.conversationArrayList[indexPath.row].caption != nil{
                                    aCell.labelCaption.isHidden = false
                                    aCell.labelCaption.text = self.conversationArrayList[indexPath.row].caption ?? ""
                                }else{
                                    aCell.labelCaption.isHidden = true
                                    aCell.labelCaption.text = ""
                                }
                                //self.convertIsoStrigToDate(strDate: self.conversationArrayList[indexPath.row].timestamp!)
                                self.showDownloadIconFileNonLoginUser(uitableVc: aCell, position: indexPath.row)
                                return aCell
                            }
                            else if self.conversationArrayList[indexPath.row].files?[0].type == "docx" || self.conversationArrayList[indexPath.row].files?[0].type == "application/docx"{
                                
                                let aCell = self.chatTableView.dequeueReusableCell(withIdentifier: self.cellReuseIdentifierCellFIleForNonLoginUser,for: indexPath) as! ConversationCellFileNonLoginUser
                                aCell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
                                aCell.ivImageIcon.image = loadImageFromPodBundle(named: "docx_ic")
                                //aCell.ivImageIcon.image = UIImage(named: "docx_ic")
                                aCell.lblFileName.text = self.conversationArrayList[indexPath.row].content!
                                aCell.lblTime.text = self.utcToLocal(dateStr: self.conversationArrayList[indexPath.row].timestamp ?? "")
                                if self.conversationArrayList[indexPath.row].caption != "" && self.conversationArrayList[indexPath.row].caption != nil{
                                    aCell.labelCaption.isHidden = false
                                    aCell.labelCaption.text = self.conversationArrayList[indexPath.row].caption ?? ""
                                }else{
                                    aCell.labelCaption.isHidden = true
                                    aCell.labelCaption.text = ""
                                }
                                //self.convertIsoStrigToDate(strDate: self.conversationArrayList[indexPath.row].timestamp!)
                                self.showDownloadIconFileNonLoginUser(uitableVc: aCell, position: indexPath.row)
                                return aCell
                            }
                            else if self.conversationArrayList[indexPath.row].files?[0].type == "doc" || self.conversationArrayList[indexPath.row].files?[0].type == "application/doc" ||
                                        self.conversationArrayList[indexPath.row].files?[0].type == "application/vnd.openxmlformats-officedocument.wordprocessingml.document" {
                                let aCell = self.chatTableView.dequeueReusableCell(withIdentifier: self.cellReuseIdentifierCellFIleForNonLoginUser,for: indexPath) as! ConversationCellFileNonLoginUser
                                aCell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
                                aCell.ivImageIcon.image = loadImageFromPodBundle(named: "doc")
                                //aCell.ivImageIcon.image = UIImage(named: "doc")
                                aCell.lblFileName.text = self.conversationArrayList[indexPath.row].content!
                                aCell.lblTime.text = self.utcToLocal(dateStr: self.conversationArrayList[indexPath.row].timestamp ?? "")
                                if self.conversationArrayList[indexPath.row].caption != "" && self.conversationArrayList[indexPath.row].caption != nil{
                                    aCell.labelCaption.isHidden = false
                                    aCell.labelCaption.text = self.conversationArrayList[indexPath.row].caption ?? ""
                                }else{
                                    aCell.labelCaption.isHidden = true
                                    aCell.labelCaption.text = ""
                                }
                                //self.convertIsoStrigToDate(strDate: self.conversationArrayList[indexPath.row].timestamp!)
                                self.showDownloadIconFileNonLoginUser(uitableVc: aCell, position: indexPath.row)
                                return aCell
                            }
                            else if self.conversationArrayList[indexPath.row].files?[0].type == "xls" || self.conversationArrayList[indexPath.row].files?[0].type == "application/xls"{
                                
                                let aCell = self.chatTableView.dequeueReusableCell(withIdentifier: self.cellReuseIdentifierCellFIleForNonLoginUser,for: indexPath) as! ConversationCellFileNonLoginUser
                                aCell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
                                aCell.ivImageIcon.image = loadImageFromPodBundle(named: "xls")
                                //aCell.ivImageIcon.image = UIImage(named: "xls")
                                aCell.lblFileName.text = self.conversationArrayList[indexPath.row].content!
                                aCell.lblTime.text = self.utcToLocal(dateStr: self.conversationArrayList[indexPath.row].timestamp ?? "")
                                if self.conversationArrayList[indexPath.row].caption != "" && self.conversationArrayList[indexPath.row].caption != nil{
                                    aCell.labelCaption.isHidden = false
                                    aCell.labelCaption.text = self.conversationArrayList[indexPath.row].caption ?? ""
                                }else{
                                    aCell.labelCaption.isHidden = true
                                    aCell.labelCaption.text = ""
                                }
                                //self.convertIsoStrigToDate(strDate: self.conversationArrayList[indexPath.row].timestamp!)
                                self.showDownloadIconFileNonLoginUser(uitableVc: aCell, position: indexPath.row)
                                return aCell
                            }
                            else if self.conversationArrayList[indexPath.row].files?[0].type == "xlsx" || self.conversationArrayList[indexPath.row].files?[0].type == "application/xlsx"{
                                let aCell = self.chatTableView.dequeueReusableCell(withIdentifier: self.cellReuseIdentifierCellFIleForNonLoginUser,for: indexPath) as! ConversationCellFileNonLoginUser
                                aCell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
                                aCell.ivImageIcon.image = loadImageFromPodBundle(named: "xlsx")
                                //aCell.ivImageIcon.image = UIImage(named: "xlsx")
                                aCell.lblFileName.text = self.conversationArrayList[indexPath.row].content!
                                aCell.lblTime.text = self.utcToLocal(dateStr: self.conversationArrayList[indexPath.row].timestamp ?? "")
                                if self.conversationArrayList[indexPath.row].caption != "" && self.conversationArrayList[indexPath.row].caption != nil{
                                    aCell.labelCaption.isHidden = false
                                    aCell.labelCaption.text = self.conversationArrayList[indexPath.row].caption ?? ""
                                }else{
                                    aCell.labelCaption.isHidden = true
                                    aCell.labelCaption.text = ""
                                }
                                //self.convertIsoStrigToDate(strDate: self.conversationArrayList[indexPath.row].timestamp!)
                                self.showDownloadIconFileNonLoginUser(uitableVc: aCell, position: indexPath.row)
                                return aCell
                                
                            } else if self.conversationArrayList[indexPath.row].files?[0].type == "csv" || self.conversationArrayList[indexPath.row].files?[0].type == "application/csv"{
                                
                                let aCell = self.chatTableView.dequeueReusableCell(withIdentifier: self.cellReuseIdentifierCellFIleForNonLoginUser,for: indexPath) as! ConversationCellFileNonLoginUser
                                aCell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
                                aCell.ivImageIcon.image = loadImageFromPodBundle(named: "csv")
                                //aCell.ivImageIcon.image = UIImage(named: "csv")
                                aCell.lblFileName.text = self.conversationArrayList[indexPath.row].content!
                                aCell.lblTime.text = self.utcToLocal(dateStr: self.conversationArrayList[indexPath.row].timestamp ?? "")
                                if self.conversationArrayList[indexPath.row].caption != "" && self.conversationArrayList[indexPath.row].caption != nil{
                                    aCell.labelCaption.isHidden = false
                                    aCell.labelCaption.text = self.conversationArrayList[indexPath.row].caption ?? ""
                                }else{
                                    aCell.labelCaption.isHidden = true
                                    aCell.labelCaption.text = ""
                                }
                                //self.convertIsoStrigToDate(strDate: self.conversationArrayList[indexPath.row].timestamp!)
                                self.showDownloadIconFileNonLoginUser(uitableVc: aCell, position: indexPath.row)
                                return aCell
                            }else if self.conversationArrayList[indexPath.row].files?[0].type == "mp4" || self.conversationArrayList[indexPath.row].files?[0].type == "application/mp4" || self.conversationArrayList[indexPath.row].files?[0].type == "mp3" || self.conversationArrayList[indexPath.row].files?[0].type == "application/mp3" || self.conversationArrayList[indexPath.row].files?[0].type == "m4a" || self.conversationArrayList[indexPath.row].files?[0].type == "application/m4a"{//"m4a"
                                //View Audio type view for reciever
                                
                                let aCell = self.chatTableView.dequeueReusableCell(withIdentifier: self.cellReuseIdentifierCellFIleForNonLoginUser,for: indexPath) as! ConversationCellFileNonLoginUser
                                aCell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
                                aCell.ivImageIcon.image = loadImageFromPodBundle(named: "mp3")
                                //aCell.ivImageIcon.image = UIImage(named: "csv")
                                aCell.lblFileName.text = self.conversationArrayList[indexPath.row].content!
                                aCell.lblTime.text = self.utcToLocal(dateStr: self.conversationArrayList[indexPath.row].timestamp ?? "")
                                if self.conversationArrayList[indexPath.row].caption != "" && self.conversationArrayList[indexPath.row].caption != nil{
                                    aCell.labelCaption.isHidden = false
                                    aCell.labelCaption.text = self.conversationArrayList[indexPath.row].caption ?? ""
                                }else{
                                    aCell.labelCaption.isHidden = true
                                    aCell.labelCaption.text = ""
                                }
                                //self.convertIsoStrigToDate(strDate: self.conversationArrayList[indexPath.row].timestamp!)
                                self.showDownloadIconFileNonLoginUser(uitableVc: aCell, position: indexPath.row)
                                return aCell
                            }
                            else {
                                
                                //View image type view for reciever
                                let aCell = self.chatTableView.dequeueReusableCell(withIdentifier: self.cellReuseIdentifierForImageNonLogin,for: indexPath) as! ConversationCellImageNoLoginUser
                                aCell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
                                
                                if self.conversationArrayList[indexPath.row].caption != "" && self.conversationArrayList[indexPath.row].caption != nil{
                                    aCell.labelCaption.isHidden = false
                                    aCell.labelCaption.text = self.conversationArrayList[indexPath.row].caption ?? ""
                                }else{
                                    aCell.labelCaption.isHidden = true
                                    aCell.labelCaption.text = ""
                                }
//                                aCell.ivImageView.setImage(with: self.conversationArrayList[indexPath.row].files![0].url ?? "", placeHolder: UIImage(named: "placeholder"))
                                // Load image asynchronously
                                DispatchQueue.main.async {
                                    //aCell.ivImageView.load.request(with: self.conversationArrayList[indexPath.row].files![0].url ?? "")
                                    let url = URL(string: self.conversationArrayList[indexPath.row].files![0].url ?? "")
                                    aCell.ivImageView.kf.setImage(with: url)
                                }
                                
                                aCell.lbl_time.text = self.utcToLocal(dateStr: self.conversationArrayList[indexPath.row].timestamp ?? "")
                                //self.convertIsoStrigToDate(strDate: self.conversationArrayList[indexPath.row].timestamp!)
                                if self.conversationArrayList[indexPath.row].isDownloading == true{
                                    aCell.downloaduiView.isHidden = false
                                    aCell.ivDownload.isHidden = false
                                    aCell.ivDownload.image = UIImage.gif(name: "cloudnew")
                                }else{
                                    aCell.downloaduiView.isHidden = true
                                    aCell.ivDownload.isHidden = true
                                }
                                self.showDownloadIconImageNonLoginUser(uitableVc: aCell, position: indexPath.row)
                                return aCell
                            }
                            
                        }
                    }
                }
                else if self.conversationArrayList[indexPath.row].isFromWidget == true && !(self.conversationArrayList[indexPath.row].type?.elementsEqual("system"))! &&
                            !(self.conversationArrayList[indexPath.row].type?.elementsEqual("welcomeMessage"))!{
                    //login user view type call here
//                    //login user view type call here
                    let aCell = self.chatTableView.dequeueReusableCell(withIdentifier: self.cellReuseIdentifierLoginUser,for: indexPath) as! ConversationLoginUserTableViewCell
                    aCell.lblMessage.text = self.conversationArrayList[indexPath.row].content!
                    aCell.lblTimeDate.text = self.utcToLocal(dateStr: self.conversationArrayList[indexPath.row].timestamp ?? "")
                    //self.convertIsoStrigToDate(strDate: self.conversationArrayList[indexPath.row].timestamp!)
                    aCell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
                    
                    if self.conversationArrayList[indexPath.row].isNotNewChat == true{
                        if self.conversationArrayList[indexPath.row].isUpdateStatus == true{
                            if self.conversationArrayList[indexPath.row].isSeen! {
                                //aCell.ivStatus.image = UIImage(named: "read_reciept")
                                aCell.ivStatus.image = loadImageFromPodBundle(named: "read_reciept")
                            }else{
                                //aCell.ivStatus.image = UIImage(named: "tick")
                                aCell.ivStatus.image = loadImageFromPodBundle(named: "tick")
                            }
                        }else{
                            //aCell.ivStatus.image = UIImage(named: "send_messagetime")
                            aCell.ivStatus.image = loadImageFromPodBundle(named: "send_messagetime")
                        }
                    }else{
                        if self.conversationArrayList[indexPath.row].isSeen! {
                            aCell.ivStatus.image = loadImageFromPodBundle(named: "read_reciept")
                            //aCell.ivStatus.image = UIImage(named: "read_reciept")
                        }else{
                            //aCell.ivStatus.image = UIImage(named: "tick")
                            aCell.ivStatus.image = loadImageFromPodBundle(named: "tick")
                        }
                        
                    }
                    
                    return aCell
                }else{
                    //reciever view type call here
                    let aCell = self.chatTableView.dequeueReusableCell(withIdentifier: self.cellReuseIdentifier,for: indexPath) as! ConversationTableViewCellNoLoginUser
                    aCell.lblMessage.text = self.conversationArrayList[indexPath.row].content!
                    aCell.lblTimeDate.text = self.utcToLocal(dateStr: self.conversationArrayList[indexPath.row].timestamp ?? "")
                    //self.convertIsoStrigToDate(strDate: self.conversationArrayList[indexPath.row].timestamp!)
                    aCell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
                    
                    if self.conversationArrayList[indexPath.row].isWelcomeMessage == true {
                        aCell.lblName.text = CustomUserDefaultChat.sheard.getOrganizationName()
                        if !CustomUserDefaultChat.sheard.getOrganizationName().isEmpty{
                            aCell.lblNameFirstLetter.text = self.getFirstLetterOfString(username: CustomUserDefaultChat.sheard.getOrganizationName())
                        }
                        
                    }else{
                        if self.conversationArrayList[indexPath.row].type?.elementsEqual("welcomeMessage") == true {
                            aCell.lblName.text = CustomUserDefaultChat.sheard.getOrganizationName()
                            if !CustomUserDefaultChat.sheard.getOrganizationName().isEmpty{
                                aCell.lblNameFirstLetter.text = self.getFirstLetterOfString(username: CustomUserDefaultChat.sheard.getOrganizationName())
                            }
                        }else{
                            aCell.lblName.text = self.conversationArrayList[indexPath.row].sender!
                            aCell.lblNameFirstLetter.text = self.getFirstLetterOfString(username: self.conversationArrayList[indexPath.row].sender!)
                        }
                        
                    }
                    return aCell
                    
                }
            }
            
            let aCell = self.chatTableView.dequeueReusableCell(withIdentifier: self.cellReuseIdentifier,for: indexPath) as! ConversationTableViewCellNoLoginUser
            aCell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
            return aCell
        
        
        return UITableViewCell() //return aCell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if(Reachability.isConnectedToNetwork()){
        if !self.conversationArrayList.isEmpty{
            if self.conversationArrayList[indexPath.row].isFailed == false{
                if self.conversationArrayList[indexPath.row].type == "file" {
                    // view image or file type sender
                    if self.existingFile(fileName: conversationArrayList[indexPath.row].files![0].documentName!) == true {
                        var stringReturn = conversationArrayList[indexPath.row].files![0].documentName!.components(separatedBy: ".")
                        if let filePath = getFilePath(fileName: conversationArrayList[indexPath.row].files![0].documentName!) {
                            self.openFile(base64str: (readDataFromFile(filePath: filePath)?.base64EncodedString())!, fileName: conversationArrayList[indexPath.row].files![0].documentName!)
                            
                        } else {
                            print("File not found")
                        }
                    }else{
                        self.hideAndShowDownloadingIcon(isHide: false, position: indexPath.row)
                        self.fileDownload(urlString: (conversationArrayList[indexPath.row].files?[0].url)!, fileName: conversationArrayList[indexPath.row].files![0].documentName!,position: indexPath.row)
                    }
                }else{
                    print("file not click")
                }
            }
        }
//        }else{
//            showToast(strMessage: "No Internet!")
//        }
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
       
        if indexPath.row == self.conversationArrayList.count - 1 && !isLoading{
            if (self.pageNumber<=self.totalpages){
                self.pageNumber = self.pageNumber + 1
                self.viewActivityIndicator.isHidden = false
                self.activityIndicator.isHidden = false
                self.heightActivityIndicator.constant = 40
                self.activityIndicator.startAnimating()
                //api for all conversations
                isLoading = true
                getCustomerConversationByUUID(pageNumber: self.pageNumber, pageSize: self.pageSize, conversationUId: self.conversationUuID, customerId: self.cusId, email: self.customerEmail)
             
            }
        }else{
//            self.heightActivityIndicator.constant = 0
//            self.viewActivityIndicator.isHidden = true
//            self.activityIndicator.isHidden = true
//            self.activityIndicator.stopAnimating()
        }
    }

    
}
extension ChatViewController{
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//
//        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 50))
//        let activityIndicator = UIActivityIndicatorView(style: .medium)
//        activityIndicator.center = footerView.center
//        footerView.addSubview(activityIndicator)
//
//        if isLoading {
//            activityIndicator.startAnimating()
//        } else {
//            activityIndicator.stopAnimating()
//        }
//
//        return footerView
//    }
//
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 50
//    }
}


class ChatHubConnectionDelegate: HubConnectionDelegate {

    weak var controller: ChatViewController?

    init(controller: ChatViewController) {
        self.controller = controller
    }

    func connectionDidOpen(hubConnection: HubConnection) {
        controller?.connectionDidOpen()
        self.controller?.customerJoined()
    }

    func connectionDidFailToOpen(error: Error) {
        controller?.connectionDidFailToOpen(error: error)
    }

    func connectionDidClose(error: Error?) {
        controller?.connectionDidClose(error: error)
    }

    func connectionWillReconnect(error: Error) {
        controller?.connectionWillReconnect(error: error)
        
        
    }

    func connectionDidReconnect() {
        controller?.connectionDidReconnect()
        
    }
    

}




extension ChatViewController {
    
    // Function to load an image from the pod's bundle
    func loadImageFromPodBundle(named imageName: String, ofType type: String) -> UIImage? {
        let bundle = Bundle(for: ChatViewController.self)
        if let imagePath = bundle.path(forResource: imageName, ofType: type) {
            return UIImage(contentsOfFile: imagePath)
        }
        return nil
    }

    // Alternative function using UIImage(named:in:compatibleWith:) initializer
    func loadImageFromPodBundle(named imageName: String) -> UIImage? {
        let bundle = Bundle(for: ChatViewController.self)
        return UIImage(named: imageName, in: bundle, compatibleWith: nil)
    }

    func hideAndShowReconnectionLayout(isHide: Bool){
        if isHide == true {
            self.lblReconnecting.text = "Connected"
            self.ivReconnectingImage.image = UIImage(named: "wifi_ic")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.uiViewReconnection.isHidden = true
            }
        }else{
            self.uiViewReconnection.isHidden = false //false
            self.lblReconnecting.text = "Reconnecting.."
            //temp lib
            self.ivReconnectingImage.image = UIImage.gif(name: "connecting")
            //self.ivReconnectingImage.loadGIF(named: "connecting")
        }
    }
    
    func readDataFromFile(filePath: String) -> Data? {
        return FileManager.default.contents(atPath: filePath)
    }
    
    func getFilePath(fileName: String) -> String? {
        let fileManager = FileManager.default
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first

        if let documentDirectory = documentDirectory {
            let fileURL = documentDirectory.appendingPathComponent(fileName)
            return fileURL.path
        }
        
        return nil
    }
    
    func existingFile(fileName: String) -> Bool {

        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        if let pathComponent = url.appendingPathComponent("\(fileName)") {
            let filePath = pathComponent.path
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: filePath){

            return true

            } else {

            return false

            }

        } else {

            return false

       }
    }
    
    
    func hideAndShowDownloadingIcon(isHide: Bool,position : Int){
        var conversation : ConversationsByUUID = self.conversationArrayList[position]
        if isHide {
            conversation.isDownloading = false;
        }else{
            conversation.isDownloading = true;
          
        }
        self.conversationArrayList.remove(at: position)
        self.conversationArrayList.insert(conversation, at: position)
        let indexPath = IndexPath(row: position, section: 0) //IndexPath(item: position, section: 0)
        self.chatTableView.reloadRows(at: [indexPath], with: .none)
    }
    
    func showDownloadIconImageLoginUser(uitableVc : ConversationCellImageLoginUser,position : Int){
        if self.conversationArrayList[position].isDownloading == true{
            uitableVc.downloaduiView.isHidden = false
            uitableVc.ivDownload.isHidden = false
            //temp lib
            uitableVc.ivDownload.image = UIImage.gif(name: "cloudnew")
            //uitableVc.ivDownload.loadGIF(named: "cloudnew")
        }else{
            uitableVc.downloaduiView.isHidden = true
            uitableVc.ivDownload.isHidden = true
        }
    }
    
    func showDownloadIconImageNonLoginUser(uitableVc : ConversationCellImageNoLoginUser,position : Int){
        if self.conversationArrayList[position].isDownloading == true{
            uitableVc.downloaduiView.isHidden = false
            uitableVc.ivDownload.isHidden = false
            //temp lib
            uitableVc.ivDownload.image = UIImage.gif(name: "cloudnew")
            //uitableVc.ivDownload.loadGIF(named: "cloudnew")
        }else{
            uitableVc.downloaduiView.isHidden = true
            uitableVc.ivDownload.isHidden = true
        }
    }
    
    func showDownloadIconFileLoginUser(uitableVc : ConversationCellFIleForLoginUser,position : Int){
        if self.conversationArrayList[position].isDownloading == true{
            uitableVc.downloaduiView.isHidden = false
            uitableVc.ivDownload.isHidden = false
            //temp lib
            uitableVc.ivDownload.image = UIImage.gif(name: "cloudnew")
            //uitableVc.ivDownload.loadGIF(named: "cloudnew")
        }else{
            uitableVc.downloaduiView.isHidden = true
            uitableVc.ivDownload.isHidden = true
        }
    }
    
    func showDownloadIconFileNonLoginUser(uitableVc : ConversationCellFileNonLoginUser,position : Int){
        if self.conversationArrayList[position].isDownloading == true{
            uitableVc.downloaduiView.isHidden = false
            uitableVc.ivDownload.isHidden = false
            //temp lib
            uitableVc.ivDownload.image = UIImage.gif(name: "cloudnew")
            //uitableVc.ivDownload.loadGIF(named: "cloudnew")
        }else{
            uitableVc.downloaduiView.isHidden = true
            uitableVc.ivDownload.isHidden = true
        }
    }
    
    // Handle the event
    @objc func handleUnSelectedPreviewEvent(_ notification: Notification) {
        if !self.fileUploadArrayList.isEmpty{
            self.fileUploadArrayList.removeAll()
        }
        if !self.filesNames.isEmpty{
            self.filesNames.removeAll()
        }
    }
    
    // Handle the event
    @objc func handleSelectedPreviewEvent(_ notification: Notification) {
        if !self.fileUploadArrayList.isEmpty{
            for i in 0 ..< self.filesNames.count{
                self.indexCurrent = i
                var messageStr = UserDefaults.standard.value(forKey: "messageStr") as? String ?? ""
                var sendMessageModel : NewChatMessage = NewChatMessage();
                sendMessageModel.agentId = self.agentId;
                sendMessageModel.tempChatId = self.filesNames[i].tempChatId!
                sendMessageModel.conversationUId = self.conversationUuID
                sendMessageModel.connectionId = CustomUserDefaultChat.sheard.getsaveConnectionId()
                sendMessageModel.customerId = self.cusId ;
                sendMessageModel.contactNo = self.customerMobileNumber;
                sendMessageModel.name = self.customerName ;
                sendMessageModel.cnic = self.customerCNIC;
                sendMessageModel.emailaddress = self.customerEmail;
                sendMessageModel.message = self.filesNames[i].fileName ?? ""
                sendMessageModel.documentOrignalname = self.filesNames[i].fileName ?? ""
                sendMessageModel.documentName = self.filesNames[i].fileName ?? ""
                sendMessageModel.documentType = self.filesNames[i].mimeType
                sendMessageModel.fileUri = self.filesNames[i].url ?? ""
                sendMessageModel.source = "Mobile_IOS" ;
                sendMessageModel.isFromWidget = true ;
                sendMessageModel.type = "file";
                sendMessageModel.channelid = self.channelId;
                sendMessageModel.notifyMessage = "";
                sendMessageModel.mobileToken = self.fcmtoken;
                sendMessageModel.caption = self.filesNames[i].message ?? ""
                self.fileUploadArrayList[i].caption = self.filesNames[i].message ?? ""
                
                //                sendMessageModel.createdOn = self.getCurrentDateAndTime()
                sendMessageModel.callerAppType = Int64(UtilsClassChat.sheard.callerAppType)
                self.addTempItemToList(sendMessageModel: sendMessageModel, isAddedToDB: true)
            }
            if(Reachability.isConnectedToNetwork()){
                self.swapCaptionData()
                //self.sendAopData(aopRequest: aopdata)
                //self.uploadFilesToServer(conversationUUId: self.conversationUuID, multipartList: self.fileUploadArrayList,tempChatIdStr: self.filesNames[0].tempChatId!)
            }else{
                for i in 0 ..< self.filesNames.count{
                    if let position = self.conversationArrayList.firstIndex(where: {$0.tempChatId == self.filesNames[i].tempChatId ?? ""}){
                        print(position)
                        self.conversationArrayList[position].isReceived = false
                        self.conversationArrayList[position].isFailed = true
                        self.conversationArrayList[position].isShowLocalFiles = true
                        self.dbChatObj.updateFailedStatus(tempChatId: self.conversationArrayList[position].tempChatId ?? "", isFailed: self.conversationArrayList[position].isFailed ?? false)
                        //self.dbChatObj.saveChatIntoData(isUpdateById: false, pageNumber: self.pageNumber, conversation: self.conversationArrayList[position])
                        self.chatTableView.reloadRows(at: [IndexPath(row: position, section: 0)], with: .none)
                    }
                }
                self.fileUploadArrayList.removeAll()
                self.filesNames.removeAll()
            }
            
            
            
        }
        
    }
    
    func intiEventListner(){
        
        SwiftEventBus.shared.addObserver(self, selector: #selector(handleSelectedPreviewEvent(_:)), eventName: "CalledAfterSelectedPreviewSend")
        SwiftEventBus.shared.addObserver(self, selector: #selector(handleUnSelectedPreviewEvent(_:)), eventName: "CalledAfterSelectedPreviewUnSend")

        
        /*
        SwiftEventBus.onMainThread(self, name: "CalledAfterSelectedPreviewSend") { notification in
            if !self.fileUploadArrayList.isEmpty{
                for i in 0 ..< self.filesNames.count{
                    self.indexCurrent = i
                    var messageStr = UserDefaults.standard.value(forKey: "messageStr") as? String ?? ""
                    var sendMessageModel : NewChatMessage = NewChatMessage();
                    sendMessageModel.agentId = self.agentId;
                    sendMessageModel.tempChatId = self.filesNames[i].tempChatId!
                    sendMessageModel.conversationUId = self.conversationUuID
                    sendMessageModel.connectionId = CustomUserDefaultChat.sheard.getsaveConnectionId()
                    sendMessageModel.customerId = self.cusId ;
                    sendMessageModel.contactNo = self.customerMobileNumber;
                    sendMessageModel.name = self.customerName ;
                    sendMessageModel.cnic = self.customerCNIC;
                    sendMessageModel.emailaddress = self.customerEmail;
                    sendMessageModel.message = self.filesNames[i].fileName ?? ""
                    sendMessageModel.documentOrignalname = self.filesNames[i].fileName ?? ""
                    sendMessageModel.documentName = self.filesNames[i].fileName ?? ""
                    sendMessageModel.documentType = self.filesNames[i].mimeType
                    sendMessageModel.fileUri = self.filesNames[i].url ?? ""
                    sendMessageModel.source = "Mobile_IOS" ;
                    sendMessageModel.isFromWidget = true ;
                    sendMessageModel.type = "file";
                    sendMessageModel.channelid = self.channelId;
                    sendMessageModel.notifyMessage = "";
                    sendMessageModel.mobileToken = self.fcmtoken;
                    sendMessageModel.caption = self.filesNames[i].message ?? ""
                    self.fileUploadArrayList[i].caption = self.filesNames[i].message ?? ""
                    
                    //                sendMessageModel.createdOn = self.getCurrentDateAndTime()
                    sendMessageModel.callerAppType = Int64(UtilsClassChat.sheard.callerAppType)
                    self.addTempItemToList(sendMessageModel: sendMessageModel, isAddedToDB: true)
                }
                if(Reachability.isConnectedToNetwork()){
                    self.swapCaptionData()
                        //self.sendAopData(aopRequest: aopdata)
                    //self.uploadFilesToServer(conversationUUId: self.conversationUuID, multipartList: self.fileUploadArrayList,tempChatIdStr: self.filesNames[0].tempChatId!)
                }else{
                    for i in 0 ..< self.filesNames.count{
                        if let position = self.conversationArrayList.firstIndex(where: {$0.tempChatId == self.filesNames[i].tempChatId ?? ""}){
                            print(position)
                            self.conversationArrayList[position].isReceived = false
                            self.conversationArrayList[position].isFailed = true
                            self.conversationArrayList[position].isShowLocalFiles = true
                            self.dbChatObj.updateFailedStatus(tempChatId: self.conversationArrayList[position].tempChatId ?? "", isFailed: self.conversationArrayList[position].isFailed ?? false)
                            //self.dbChatObj.saveChatIntoData(isUpdateById: false, pageNumber: self.pageNumber, conversation: self.conversationArrayList[position])
                            self.chatTableView.reloadRows(at: [IndexPath(row: position, section: 0)], with: .automatic)
                        }
                    }
                    self.fileUploadArrayList.removeAll()
                    self.filesNames.removeAll()
                }
                
        
                            
            }

        }
        
        SwiftEventBus.onMainThread(self, name: "CalledAfterSelectedPreviewUnSend") { notification in
            if !self.fileUploadArrayList.isEmpty{
                self.fileUploadArrayList.removeAll()
            }
            if !self.filesNames.isEmpty{
                self.filesNames.removeAll()
            }
        }
        */
    }
    
    func connectSignalR(resultToken : String ){
        self.chatHubConnection = HubConnectionBuilder(url: URL(string: serverUrl)!)
            .withLogging(minLogLevel: .debug)
            .withAutoReconnect()
            .withHttpConnectionOptions() { httpConnectionOptions in
                httpConnectionOptions.accessTokenProvider = { return resultToken }
            }
            .withHubConnectionDelegate(delegate: self.chatHubConnectionDelegate!)
            .build()
        
        //set event listener
        self.setHubConnectionEventListner()
        
        // start hub connection afte connected

        self.chatHubConnection!.start()
    
    }
    
    func scheduleReconnect() {
        // Invalidate any existing timer
        reconnectTimer?.invalidate()
        
        // Schedule a reconnection attempt after an interval
        reconnectTimer = Timer.scheduledTimer(withTimeInterval: reconnectInterval, repeats: false) { [weak self] _ in
            self?.chatHubConnection!.start()
        }
    }
    //eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJDaGFubmVsaWQiOiJmMjZhMzNkOS01YjJlLTQyMjctYTQ1Ni1lYWI0NTkyNGExZDMiLCJqdGkiOiIxNTQwODBhMy0wMGIyLTQ1YzUtYmRjNy00ODA1NGRjMGFkNDYiLCJuYmYiOjE3MjE4MDY1MjgsImV4cCI6MTcyMzEwMjUyOCwiaWF0IjoxNzIxODA2NTI4LCJpc3MiOiJlbWxhYWtmaW5hbmNpYWxzLmNvbSIsImF1ZCI6ImVtbGFha2ZpbmFuY2lhbHMuY29tIn0.MKthPjFkybnqXmmKyoey6cZNpXfQDWDVsHQjEMQRogU
    func getAccessToken(isCalledFromReconnect: Bool,channelId:String,serverUrl: String){
        ApiClient.sheard.getAccessTokenByChannelId(channelId:channelId, onSuccess: { [self]
            (sucess) in
            if (sucess.isSuccess!){
                if (sucess.result != nil && !sucess.result!.isEmpty){
                    CustomUserDefaultChat.sheard.saveChatToken(token: sucess.result!)
                    
                    self.tokenResult = sucess.result ?? ""
                    self.connectSignalR(resultToken: sucess.result!)
                    self.getOrganizationData()
                    
                    
                    if isCalledFromReconnect == false{
                        getCustomerConversationByUUID(pageNumber: self.pageNumber, pageSize: self.pageSize, conversationUId: self.conversationUuID, customerId: self.cusId, email: self.customerEmail)
                    }
                    
                }
            }else{
                //                UtilsClassChat.sheard.showToast(controller: self , message: sucess.responseMessage!, seconds: 1.0)
            }
            
        }) { (error) in
            print(error as Any)
            if(error == "Optional(401)"){
                
                
            }else{
                if(error == "nil"){
                    
                }else{
                    
                }
            }
        }
        
    }
    func getOrganizationData(){
        ApiClient.sheard.getOrganizationApi(onSuccess: { [self]
            (sucess) in
            if (sucess.isSuccess!){
                self.lblCompanyName.text = sucess.result?.displayname
                CustomUserDefaultChat.sheard.saveOrganizationName(organizationName: sucess.result?.orgName)
                CustomUserDefaultChat.sheard.saveDisplayName(displayName: sucess.result?.displayname)
              
            }else{

            }
            
        }) { (error) in
            print(error as Any)
            if(error == "Optional(401)"){
                
                
            }else{
                if(error == "nil"){
                    
                }else{
                    
                }
            }
        }
        
    }
    
    func isBusinessHourValidation(utcHours: String ,dayIndex: Int){
        ApiClient.sheard.getIsValidateBusinessHourApi( utcHours: utcHours, dayIndex: dayIndex,onSuccess: { [self]
            (sucess) in
            if (sucess.isSuccess == true){
                self.businessHoursMessage = sucess.result!.message!
                self.isOnline = sucess.result!.isOnline!
                //Temp Comment
                self.getTopicByEmail()
        
            }
            
        }) { (error) in
            print(error as Any)
            if(error == "Optional(401)"){
                
                
            }else{
                if(error == "nil"){
                    
                }else{
                    
                }
            }
        }
        
    }
    
    func checkLastMessageTopicSelect (lastMessage : String) -> Bool{
        if (!self.conversationArrayList.isEmpty) {
            if (self.conversationArrayList.count > 0){
                
                if (self.conversationArrayList[0].content?.caseInsensitiveCompare(lastMessage ?? "") == .orderedSame){
                    return true
                }
                
            }
        }
        return false
    }
    
    func getTopicByEmail(){
        ApiClient.sheard.getTopicByEmail(email:self.customerEmail,onSuccess: { [self]
            (sucess) in
            if (sucess.isSuccess ?? false){
                //store conversation resolve status into the local prefrences
                CustomUserDefaultChat.sheard.saveIsResolved(isResolved: (sucess.result?.status)!)
                if (!sucess.result!.topicList.isEmpty){

                    if sucess.result!.status! && !checkLastMessageIsBusinessHour(lastMessage: businessHoursMessage) {
                        addWelcomeMessage()
                    }
                    self.topicsArrayList = sucess.result!.topicList

                    if sucess.result!.status!{
                        self.uiCvTopics.reloadData()
                        //visible topics layout
                        menuTopicCOnstantWidth.constant = 0
                        btnTopicMenu.isHidden = true
                        ivTopicMenu.isHidden = true
                        self.uiViewTypingAndTopicsLayout.isHidden = true
                        self.uiViewTopics.isHidden = false
                    }else{
                        
                        menuTopicCOnstantWidth.constant = 20
                        btnTopicMenu.isHidden = false
                        ivTopicMenu.isHidden = false
                    }
                    
                
                }else{
                    //hide topics layout
                    menuTopicCOnstantWidth.constant = 0
                    btnTopicMenu.isHidden = true
                    ivTopicMenu.isHidden = true
                    self.uiViewTopics.isHidden = true
                    self.uiViewTypingAndTopicsLayout.isHidden = false
                    if (sucess.result!.status! && !checkLastMessageIsBusinessHour(lastMessage: businessHoursMessage)){
                        addWelcomeMessage()
                    }
                    
                }
            }else{
                if (CustomUserDefaultChat.sheard.getIsResolved() && !checkLastMessageIsBusinessHour(lastMessage: businessHoursMessage)){
                    addWelcomeMessage()
                }
                self.topicsArrayList.removeAll()
            }
            
                                                    
        }) { (error) in
            print(error as Any)
            if(error == "Optional(401)"){
                
                
            }else{
                if(error == "nil"){
                    
                }else{
                    
                }
            }
        }
        
    }
    
    func checkLastMessageIsBusinessHour(lastMessage : String) -> Bool{
        
        if (!dbChatObj.getLastConversationItem(conversationId: self.conversationUuID).isEmpty) {
            if (dbChatObj.getLastConversationItem(conversationId: self.conversationUuID).count > 0){
                let conversation = (dbChatObj.getLastConversationItem(conversationId: self.conversationUuID))
                if (conversation[0].content?.caseInsensitiveCompare(lastMessage ?? "") == .orderedSame){
                    return true
                }
            }
        }
        return false
    }
    
    func addWelcomeMessage(){
        if (!self.businessHoursMessage.isEmpty){
            temppChatIdWelcomeMessage = generateUuID()
            addItemIntoListForTopicsSelection(textMessage: self.businessHoursMessage, tempChatId: self.temppChatIdWelcomeMessage, isAddedToDB: true)
            
        }
        
    }
    
    func getCustomerConversationByUUID(pageNumber:Int,pageSize:Int,conversationUId:String,customerId:Int64, email : String){
        ApiClient.sheard.getCustomerConversationsByEmail(pageNumber: pageNumber, pageSize: pageSize, conversationUId: conversationUId, customerId: customerId, email: email,onSuccess: { [self]
            (sucess) in
            if (sucess.isSuccess!){
                // validate business hours
             
                self.totalpages = sucess.totalPages!
                if (!sucess.result!.isEmpty){
                    self.conversationUuID = sucess.result?[0].conversationUid ?? ""
                    self.cusId = sucess.result?[0].customerId ?? 0
                    CustomUserDefaultChat.sheard.saveCustomerId(customerId: self.cusId)
                    CustomUserDefaultChat.sheard.saveConversationUuID(conversationUuID: self.conversationUuID)
                    
                    if self.pageNumber == 1 {
                        
                        //self.conversationArrayList = sucess.result!
                        for i in 0 ..< (sucess.result?.count ?? 0){
                            
                            dbChatObj.saveChatIntoData(isUpdateById: true, pageNumber: pageNumber, conversation: sucess.result?[i] ?? ConversationsByUUID())
                            
                        }
                       
                    }else{
                        if (self.pageNumber < self.totalpages) {
                            //show loder
                        }else{
                            //hide loader
                        }
                        for i in 0..<sucess.result!.count {
                            dbChatObj.saveChatIntoData(isUpdateById: true, pageNumber: pageNumber, conversation: sucess.result?[i] ?? ConversationsByUUID())
                            //conversationArrayList.append(sucess.result![i])
                        }
                
                    }
                    

                     getAllConversationLocally()
                    
                    
                    
                    if (!self.conversationArrayList.isEmpty){
                        for i in 0...self.conversationArrayList.count-1{
                            if !(self.conversationArrayList[i].isFromWidget ?? false) && !(self.conversationArrayList[i].isSeen ?? false) {
                                readRecieptInvoke(conversationDetailId: self.conversationArrayList[i].id ?? 0)
                            }
                        }
                    }
                
            
                }else{
                    self.heightActivityIndicator.constant = 0
                    self.viewActivityIndicator.isHidden = true
                    self.activityIndicator.isHidden = true
                    self.activityIndicator.stopAnimating()
                
                }
                if self.pageNumber == 1 {
                   
                    self.isBusinessHourValidation(utcHours: UtilsClassChat.sheard.getUTCTime(), dayIndex: UtilsClassChat.sheard.getDayIndex(from: Date()))
                }
    
            }else{
                // validate business hours
                self.isBusinessHourValidation(utcHours: UtilsClassChat.sheard.getUTCTime(), dayIndex: UtilsClassChat.sheard.getDayIndex(from: Date()))
            }
            
        }) { (error) in
            print(error as Any)
            if(error == "Optional(401)"){
                
                
            }else{
                if(error == "nil"){
                    
                }else{
                    
                }
            }
        }
        
    }
    
    func getAllConversationLocally(){
        self.conversationArrayList = self.dbChatObj.getAllConversation(conversationId: self.conversationUuID)

        if !self.conversationArrayList.isEmpty{

            self.heightActivityIndicator.constant = 0
            self.viewActivityIndicator.isHidden = true
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
            isLoading = false
            UIView.performWithoutAnimation {
                self.chatTableView.reloadData()
            }
            
            if (self.pageNumber == 1){
                self.scrollToBottom()
            }
        
      
        }
    }
    
    
    func addItemIntoListForTopicsSelection(textMessage : String ,tempChatId : String, isAddedToDB : Bool){
        var sendMessageModel : NewChatMessage = NewChatMessage()
        sendMessageModel.agentId = 0
        sendMessageModel.tempChatId = tempChatId //self.generateUuID() //""
        sendMessageModel.conversationUId = ""
        sendMessageModel.connectionId = ""
        sendMessageModel.customerId = 0
        sendMessageModel.contactNo = ""
        sendMessageModel.name = CustomUserDefaultChat.sheard.getOrganizationName()
        sendMessageModel.groupId = 0
        sendMessageModel.cnic = ""
        sendMessageModel.emailaddress = ""
        sendMessageModel.message = textMessage
        sendMessageModel.documentName = ""
        sendMessageModel.documentOrignalname = ""
        sendMessageModel.documentType = ""
        sendMessageModel.source = "Mobile_IOS"
        sendMessageModel.isFromWidget = false
        sendMessageModel.type = "welcomeMessage"
        sendMessageModel.channelid = ""
        sendMessageModel.notifyMessage = ""
        sendMessageModel.timezone = UtilsClassChat.sheard.getCurrentLocalTimeZone()
        sendMessageModel.mobileToken = ""
        sendMessageModel.isWelcomeMessage = true
        sendMessageModel.caption = UserDefaults.standard.value(forKey: "messageStr") as? String ?? ""
        addTempItemToList(sendMessageModel: sendMessageModel, isAddedToDB : isAddedToDB)
        
    }
    

    func uploadFilesToServer(conversationUUId:String,multipartList: [UploadFilesDataModel],tempChatIdStr : String){
        
        //let uploadFiles = UploadFilesRequest(conversationUId: conversationUUId, files: multipartList)
        
        ApiClient.sheard.uploadFilesNew(filesNew: multipartList, onSuccess: { [self]
            (sucess) in
            if (sucess.isSuccess!){
                fileUploadArrayList.removeAll()
                filesNames.removeAll()
                if (!sucess.result!.isEmpty){
                    uploadFilesData.removeAll()
                    uploadFilesData = sucess.result!
                    if uploadFilesData.count>0{
                        //send new Chat messaag here
                        sendNewChat(type: "file", txtMessage: self.msgTextField.text, uploadFilesData: uploadFilesData, tempChatIDStr: tempChatIdStr, conversationUUID: self.conversationUuID, channelID: self.channelId, mobileToken: self.fcmtoken,isFromWidget: true)
                        
                    }
                }
            }else{
                print("Failed")
                for i in 0 ..< self.filesNames.count{
                    if let position = self.conversationArrayList.firstIndex(where: {$0.tempChatId == self.filesNames[i].tempChatId}){
                        print(position)
                        self.conversationArrayList[position].isReceived = false
                        self.conversationArrayList[position].isFailed = true
                        self.conversationArrayList[position].isShowLocalFiles = true
                        self.dbChatObj.saveChatIntoData(isUpdateById: false, pageNumber: self.pageNumber, conversation: self.conversationArrayList[position])
                        self.chatTableView.reloadRows(at: [IndexPath(row: position, section: 0)], with: .none)
                    }
                }
                fileUploadArrayList.removeAll()
                filesNames.removeAll()
            }
            
        }) { [self] (error) in
            print("Failed")
            for i in 0 ..< self.filesNames.count{
                if let position = self.conversationArrayList.firstIndex{$0.tempChatId == self.filesNames[i].tempChatId}{
                    print(position)
                    self.conversationArrayList[position].isReceived = false
                    self.conversationArrayList[position].isFailed = true
                    self.conversationArrayList[position].isShowLocalFiles = true
                    self.dbChatObj.saveChatIntoData(isUpdateById: false, pageNumber: self.pageNumber, conversation: self.conversationArrayList[position])
                    self.chatTableView.reloadRows(at: [IndexPath(row: position, section: 0)], with: .none)
                }
            }
            self.fileUploadArrayList.removeAll()
            self.filesNames.removeAll()
            
            print(error as Any)
            if(error == "Optional(401)"){
                
                
            }else{
                if(error == "nil"){
                    
                }else{
                    
                }
            }
        }
        
    }
    
    func registerCustomerJoinedFromMobile(){
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + .seconds(1), execute: {
        
            // invoking a hub method that does not return a result
            self.chatHubConnection!.invoke(method: "CustomerJoinedFromMobile",self.channelId, self.cusId,self.fcmtoken,UtilsClassChat.sheard.callerAppType) { error in
                if let error = error {
                    print("error: \(error)")
                } else {
                    print("Broadcast invocation completed without errors")
                }
            }
            
            if self.chatHubConnection!.connectionId != nil {
                CustomUserDefaultChat.sheard.saveConnectionId(connectionId: self.chatHubConnection!.connectionId!)
                print("Generate connectionID: \(self.chatHubConnection!.connectionId)")

            }
        })
    }
    
    func setHubConnectionEventListner() {
        self.chatHubConnection!.on(method: "ReceiveMessage", callback: {(recieveMessage: RecieveMessage) in
            if recieveMessage != nil{
                print("ReceiveMessage")
                //self.appendMessage(message: "ReceiveMessage Response:\(recieveMessage.content!)")
    
                self.dbChatObj.deleteUnSendNewChatUsingTempId(id: recieveMessage.tempChatId ?? "")
                self.uploadFilesData.removeAll()
                self.fileUploadArrayList.removeAll()
                self.filesNames.removeAll()
                self.sendPrivateMessageResponse(recieveMessage: recieveMessage)

            }
        })
        
        self.chatHubConnection!.on(method: "NewChatReceiver", callback: {(conversations: Conversations) in
            if conversations != nil{
                if conversations.errorCode == "101"{
                    UIApplication.shared.keyWindow?.makeToast("Error: \(conversations.errorCodeDescription)")
                }else if conversations.errorCode == "102"{
                    UIApplication.shared.keyWindow?.makeToast("Error: \(conversations.errorCodeDescription)")
                }else{
                    self.recieveNewChatResponse(conversations: conversations)
                }
            }
        })
        
        self.chatHubConnection!.on(method: "onError", callback: {(recieveMessage: RecieveMessage) in
            //self.appendMessage(message: "onError Response:\(recieveMessage.content!)")
        })
        
        self.chatHubConnection!.on(method: "ReadReceiptListener", callback: {(recieveMessage: ReadReceiptRequest) in
            if recieveMessage != nil {
                if recieveMessage.conversationDetailId != 0 {
                    self.updateReadReciept(readReceiptRequest: recieveMessage)
                    
                }
            }
        })
        
        self.chatHubConnection!.on(method: "TypingIndicatorListener", callback: {(typingIndicatorListenerModel: TypingIndicatorListenerModel) in
            if typingIndicatorListenerModel != nil {
                self.typingIndicatorResponse(typingIndicatorListenerModel: typingIndicatorListenerModel)
            }
        })
        
        self.chatHubConnection!.on(method: "SyncMessagesListener", callback: {( queueConversationModel : QueueConversationModel) in
            if queueConversationModel != nil{
                print(queueConversationModel)
                for i in 0 ..< (queueConversationModel.listConversationVM?.count ?? 0){
                    if !self.conversationArrayList.contains(where: { $0.id == queueConversationModel.listConversationVM?[i].id }) {
                         // found
                        self.dbChatObj.saveChatIntoData(isUpdateById: true, pageNumber: self.pageNumber, conversation: queueConversationModel.listConversationVM?[i] ?? ConversationsByUUID())
                        self.conversationArrayList.insert(queueConversationModel.listConversationVM?[i] ?? ConversationsByUUID(), at:  0)
                        let indexPath = IndexPath(row: 0, section: 0)
                        UIView.performWithoutAnimation {
                            self.chatTableView.reloadData()
                        }
                        self.scrollToBottom()
                        
                    }
                }

            }
        })
        
        self.chatHubConnection!.on(method: "BulkNewChatListener", callback: { [self]( bulkConversationModel : BulkConversationModel) in
            if bulkConversationModel != nil{
                print(bulkConversationModel)
                
                dbChatObj.deleteUnSendNewChats()
                timerDatabase?.invalidate()
                timerDatabase = nil
                for i in 0 ..< bulkConversationModel.conversationVMList.count
                {
                    if !bulkConversationModel.conversationVMList[i].tempChatId!.isEmpty{
                        if isContainConversationByUIdTemp(conversationArrayList: self.conversationArrayList, tempChatId: bulkConversationModel.conversationVMList[i].tempChatId!){
                            
                            var conversationByUID1 = getConversationFromBulkReceiveMsg(recieveMessage: bulkConversationModel.conversationVMList[i])
                            conversationByUID1.isUpdateStatus = true

                            dbChatObj.saveChatIntoData(isUpdateById: false, pageNumber: pageNumber, conversation: bulkConversationModel.conversationVMList[i] ?? ConversationsByUUID())

                            //MARK: Local Chat Work
                            //                            //item status update into list
                            self.conversationArrayList.remove(at: addedConversationPos)
                            self.conversationArrayList.insert(conversationByUID1, at: addedConversationPos)
                            let indexPath = IndexPath(row: addedConversationPos, section: 0)
                            self.chatTableView.reloadRows(at: [indexPath], with: .none)
                            
                        }else{
                            //MARK: Local Chat Work
                            dbChatObj.saveChatIntoData(isUpdateById: true, pageNumber: pageNumber, conversation: bulkConversationModel.conversationVMList[i] ?? ConversationsByUUID())
                            self.conversationArrayList.insert(getConversationFromBulkReceiveMsg(recieveMessage: bulkConversationModel.conversationVMList[i]), at:  0)
                            UIView.performWithoutAnimation {
                                self.chatTableView.reloadData()
                            }
                            scrollToBottom()
                            
                        }
                    }
                }

            }
        })
        
        self.chatHubConnection!.on(method: "ForceLogoutListener", callback: {(recieveMessage: String) in
            if recieveMessage != ""{
                print(recieveMessage)
                let alert = UIAlertController(title: "Logout", message: "\(recieveMessage)", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default, handler: { action in
//                    CustomUserDefault.sheard.logOutChatUser()
                    self.dismiss(animated: true)
                })
                alert.addAction(ok)
                self.present(alert, animated: true)
            }
            //self.appendMessage(message: "onError Response:\(recieveMessage.content!)")
        })
        
        self.callConversationStatusListner()

    }
    
    func callConversationStatusListner(){
        self.chatHubConnection!.on(method: "ConversationStatusListener", callback: { [self]( conversationStatusModel : ConversationStatusListenerDataModel) in
            if conversationStatusModel != nil{
                if (conversationStatusModel.isResolved){
                    showFeedBackDialogue()
                    self.conversationStatusChangeModel = conversationStatusModel
                }
            }
           
        })
    }
    
    func loadResolvedConversationBySkipOrSubmit(feebackText : String ,
                                                    rating : Int,isSkipClicked : Bool ,conversationStatusModel : ConversationStatusListenerDataModel){
        var feedBackRequest : ResolveFeedBackRequest = ResolveFeedBackRequest()
        if(!isSkipClicked){
            feedBackRequest.conversationUid = conversationUuID
            feedBackRequest.isSatisfied = true
            feedBackRequest.callerAppType = 4
            feedBackRequest.feedback = !feebackText.isEmpty ? feebackText : "";
            feedBackRequest.rating = rating
            self.chatHubConnection?.send(method: "ConversationFeedback",feedBackRequest)
        }
        
        CustomUserDefaultChat.sheard.saveIsResolved(isResolved: true)
        
        if conversationStatusModel.isResolved{
            if !self.conversationArrayList.isEmpty{
                self.conversationArrayList.insert(getConversationFromResolveListener(conversationStatusListenerDataModel: conversationStatusModel, feedBackRequest: feedBackRequest, isFeedback: true), at: 0)
                var conversationByUID1 = getConversationFromResolveListener(conversationStatusListenerDataModel: conversationStatusModel, feedBackRequest: feedBackRequest, isFeedback: true)
                dbChatObj.saveChatIntoData(isUpdateById: false, pageNumber: pageNumber, conversation: conversationByUID1 ?? ConversationsByUUID())
                UIView.performWithoutAnimation {
                    self.chatTableView.reloadData()
                }
                
            }
        }
        
    }
    
    func forceLogOut(){
        
    }
    
    func generateUuID()-> String {
        let identifier = UUID()
        return identifier.uuidString
    }
    

    
    func sendNewChat(type : String,txtMessage : String,uploadFilesData:[UploadNewFilesData] ,tempChatIDStr:String,conversationUUID:String,channelID: String,mobileToken: String,isFromWidget : Bool){
        CustomUserDefaultChat.sheard.saveIsResolved(isResolved: false)
        if (type == "file"){
            if(uploadFilesData.count>0){
                for i in 0 ..< uploadFilesData.count{
                    var sendMessageModel : NewChatMessage = NewChatMessage()
                    sendMessageModel.agentId = agentId
                    sendMessageModel.tempChatId = uploadFilesData[i].tempChatId
                    sendMessageModel.conversationUId = conversationUUID
                    sendMessageModel.connectionId = CustomUserDefaultChat.sheard.getsaveConnectionId()
                    sendMessageModel.customerId = cusId
                    sendMessageModel.contactNo = customerMobileNumber
                    sendMessageModel.name = isFromWidget == false ? CustomUserDefaultChat.sheard.getOrganizationName() : customerName
                    sendMessageModel.cnic = customerCNIC
                    sendMessageModel.groupId = self.groupId
                    sendMessageModel.emailaddress = customerEmail;
                    sendMessageModel.message = uploadFilesData[i].documentOrignalName
                    sendMessageModel.documentName = uploadFilesData[i].documentName ?? ""
                    sendMessageModel.documentOrignalname = uploadFilesData[i].documentOrignalName != nil ? uploadFilesData[i].documentOrignalName ?? "" : uploadFilesData[i].documentName ?? ""
                    sendMessageModel.documentType = uploadFilesData[i].documentType!
                    sendMessageModel.source = "Mobile_IOS"
                    sendMessageModel.isResolved = false
                    sendMessageModel.isFromWidget = isFromWidget
                    sendMessageModel.type = type
                    sendMessageModel.channelid = channelID
                    sendMessageModel.notifyMessage = ""
                    sendMessageModel.timezone = UtilsClassChat.sheard.getCurrentLocalTimeZone()
                    sendMessageModel.mobileToken = self.fcmtoken
                    sendMessageModel.caption = uploadFilesData[i].caption //UserDefaults.standard.value(forKey: "messageStr") as? String ?? ""
                    sendMessageModel.isWelcomeMessage = type == "welcomeMessage" ? true : false
                    sendMessageModel.topicId = Int64(topicId)
                    sendMessageModel.topicMessage = topicMessage
                    //                sendMessageModel.createdOn = getCurrentDateAndTime()
                    sendMessageModel.timestamp = getCurretDateTime()
                    sendMessageModel.callerAppType = Int64(UtilsClassChat.sheard.callerAppType)
                    self.chatHubConnection?.send(method: "NewChat",sendMessageModel, true)
                }
            }
        }else{
            var sendMessageModel : NewChatMessage = NewChatMessage()
            sendMessageModel.agentId = agentId
            sendMessageModel.tempChatId = tempChatIDStr
            sendMessageModel.conversationUId = conversationUUID
            sendMessageModel.connectionId = CustomUserDefaultChat.sheard.getsaveConnectionId()
            sendMessageModel.customerId = cusId
            sendMessageModel.contactNo = customerMobileNumber
            sendMessageModel.name = isFromWidget == false ? CustomUserDefaultChat.sheard.getOrganizationName() : customerName
            sendMessageModel.groupId = self.groupId
            sendMessageModel.cnic = customerCNIC
            sendMessageModel.emailaddress = customerEmail
            sendMessageModel.message = txtMessage
            sendMessageModel.documentName = ""
            sendMessageModel.documentOrignalname = ""
            sendMessageModel.documentType = ""
            sendMessageModel.source = "Mobile_IOS"
            sendMessageModel.isResolved = false
            sendMessageModel.isFromWidget = isFromWidget
            sendMessageModel.type = type
            sendMessageModel.channelid = channelID
            sendMessageModel.notifyMessage = ""
            sendMessageModel.timezone = UtilsClassChat.sheard.getCurrentLocalTimeZone()
            sendMessageModel.mobileToken = self.fcmtoken
            sendMessageModel.caption = UserDefaults.standard.value(forKey: "messageStr") as? String ?? ""
            sendMessageModel.isWelcomeMessage = type == "welcomeMessage" ? true : false //true : false
            sendMessageModel.topicId = Int64(topicId)
            sendMessageModel.topicMessage = topicMessage
            sendMessageModel.timestamp = getCurretDateTime()
            sendMessageModel.callerAppType = Int64(UtilsClassChat.sheard.callerAppType)
            let conversation = self.addSendMessageTemp(recieveMessage: sendMessageModel)
            
            if type == "welcomeMessage" {
                sendMessageModel.isWelcomeMessage = true
            }else{
                sendMessageModel.isWelcomeMessage = false
            }
            
            
            self.chatHubConnection?.send(method: "NewChat",sendMessageModel, true)
            if type != "welcomeMessage" {
                self.addTempItemToList(sendMessageModel: sendMessageModel, isAddedToDB: true)
            }
            dbChatObj.saveChatIntoData(isUpdateById: false, pageNumber: pageNumber, conversation: conversation)
            dbChatObj.SaveNewChatTemprory(pageNumber: self.pageNumber, conversation: sendMessageModel)
        }
        self.msgTextField.resignFirstResponder()
        
    }
    
    func sendPrivateMessage(conversation: Conversations,type:String,txtMessage:String, uploadFilesData : [UploadNewFilesData]){
        if (type == "file"){
            if(uploadFilesData.count>0){
                
                var sendMessageModel : SendMessageModel = SendMessageModel();
                sendMessageModel.tempChatId = conversation.tempChatId!
                sendMessageModel.agentId = conversation.agentId!
                sendMessageModel.conversationDetailId = conversation.id ?? 0
                sendMessageModel.conversationUid = conversation.conversationUid!
                sendMessageModel.conversationId = conversation.conversationUid!
                sendMessageModel.customerId = conversation.customerId!
                sendMessageModel.message = conversation.files?[0].documentOriginalName ?? ""
                sendMessageModel.receiverConnectionId =  CustomUserDefaultChat.sheard.getsaveConnectionId()
                sendMessageModel.receiverName = conversation.isFromWidget == false ? CustomUserDefaultChat.sheard.getOrganizationName() :conversation.customerName!
                sendMessageModel.isFromWidget = conversation.isFromWidget!
                sendMessageModel.isResolved = conversation.isFromWidget!
                sendMessageModel.type = type
                sendMessageModel.groupId = conversation.groupId!
                sendMessageModel.conversationType = type == "file" ? "multimedia" : "text"
                sendMessageModel.documentName = conversation.files?[0].documentName
                sendMessageModel.documentOrignalname = conversation.files?[0].documentOriginalName ?? ""
                sendMessageModel.documentType = conversation.files?[0].type
                sendMessageModel.icon = ""
                sendMessageModel.pageId = ""
                sendMessageModel.pageName = ""
                sendMessageModel.timezone = UtilsClassChat.sheard.getCurrentLocalTimeZone()
                sendMessageModel.timestamp = conversation.timestamp //self.timeStamp //getCurretDateTime()
                sendMessageModel.caption = conversation.caption
                    //send message
                self.chatHubConnection?.send(method: "SendPrivateMessage",sendMessageModel, true)
                

            }
            
        }else{
            var sendMessageModel : SendMessageModel = SendMessageModel()
            sendMessageModel.tempChatId = conversation.tempChatId!
            sendMessageModel.agentId = conversation.agentId
            sendMessageModel.conversationDetailId = conversation.id ?? 0
            sendMessageModel.conversationUid = conversation.conversationUid!
            sendMessageModel.conversationId = conversation.conversationUid!
            sendMessageModel.customerId = conversation.customerId!
            sendMessageModel.message = txtMessage
            sendMessageModel.receiverConnectionId =  CustomUserDefaultChat.sheard.getsaveConnectionId()
            sendMessageModel.receiverName = conversation.isFromWidget == false ? CustomUserDefaultChat.sheard.getOrganizationName() :conversation.customerName!
            sendMessageModel.isFromWidget = conversation.isFromWidget!
            sendMessageModel.isResolved = conversation.isFromWidget!
            sendMessageModel.type = type
            sendMessageModel.groupId = conversation.groupId!
            sendMessageModel.conversationType = type == "file" ? "multimedia" : "text"
            sendMessageModel.documentName = ""
            sendMessageModel.documentOrignalname = ""
            sendMessageModel.documentType = ""
            sendMessageModel.icon = ""
            sendMessageModel.pageId = ""
            sendMessageModel.pageName = ""
            sendMessageModel.timezone = UtilsClassChat.sheard.getCurrentLocalTimeZone()
            sendMessageModel.timestamp = conversation.timestamp //self.timeStamp //getCurretDateTime()
            sendMessageModel.caption = UserDefaults.standard.value(forKey: "messageStr") as? String ?? ""
            //send message
            self.chatHubConnection?.send(method: "SendPrivateMessage",sendMessageModel, true)

            
        }
        
    }
    
    func sendWelcomeMessageTopic(){
        if (!self.topicMessage.isEmpty){
            var tempChatId = generateUuID()
            addItemIntoListForTopicsSelection(textMessage: topicMessage, tempChatId: tempChatId, isAddedToDB: true)
            sendNewChat(type: "welcomeMessage", txtMessage: self.topicMessage ?? "" , uploadFilesData: self.uploadFilesData, tempChatIDStr: tempChatId, conversationUUID: self.conversationUuID, channelID: self.channelId, mobileToken: self.fcmtoken,isFromWidget: true)
            self.topicId = "0"
            self.topicMessage = ""
        }
    }
    
    func recieveNewChatResponse(conversations : Conversations){
        dbChatObj.deleteUnSendNewChatUsingTempId(id: conversations.tempChatId ?? "")
        if !(conversations.conversationUid?.isEmpty ?? true){
            self.tempChatId = conversations.tempChatId!
            self.conversationUuID = conversations.conversationUid!
            self.customerName = conversations.customerName!
            self.cusId = conversations.customerId!
//          self.agentId = conversations.agentId!
            self.groupId = conversations.groupId!
            //save customer id to userdefault here
            CustomUserDefaultChat.sheard.saveCustomerId(customerId: conversations.customerId!)
            // send private message
            if !self.uploadFilesData.isEmpty{
                sendPrivateMessage(conversation: conversations, type: "file", txtMessage: conversations.content!, uploadFilesData: self.uploadFilesData)
            }else{
                sendPrivateMessage(conversation: conversations, type:conversations.type!, txtMessage: conversations.content!, uploadFilesData: self.uploadFilesData)
            }

            if (self.isTopicSelect && !self.topicsArrayList.isEmpty){
                self.isTopicSelect = false
                
                if (CustomUserDefaultChat.sheard.getIsResolved() && !checkLastMessageIsBusinessHour(lastMessage: "Please select your desired option from menu to chat with our representative.")){
                    sendNewChat(type: "welcomeMessage", txtMessage: "Please select your desired option from menu to chat with our representative." ?? "" , uploadFilesData: self.uploadFilesData, tempChatIDStr: tempChatIdTopicWelcomeMsg, conversationUUID: self.conversationUuID, channelID: self.channelId, mobileToken: self.fcmtoken,isFromWidget: true)
                    
                }
                
                if (!isTopicSecondTimeSelect){
                    isTopicSecondTimeSelect = false
                    sendNewChat(type: "text", txtMessage: topicsModel.name ?? "" , uploadFilesData: self.uploadFilesData, tempChatIDStr: generateUuID(), conversationUUID: self.conversationUuID, channelID: self.channelId, mobileToken: self.fcmtoken,isFromWidget: true)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                        self.sendWelcomeMessageTopic()
                    })
                    
                }
                else{
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                        self.sendWelcomeMessageTopic()
                    })
                }
            }
            
        }
    }
    
    func sendPrivateMessageResponse(recieveMessage : RecieveMessage){
        //MARK: Convert RecieveMessage To ConversationsByUUID Object
        var conversation : ConversationsByUUID = getConversationFromReceiveMsg(recieveMessage: recieveMessage) //convertReceiveIntoConversationsByUUID(recieveMessage: recieveMessage)
        
        if self.conversationUuID == recieveMessage.conversationUid{
            if recieveMessage.type! !=  "welcomeMessage" {
                if !self.conversationArrayList.isEmpty {
                    
                    if (self.conversationUuID == recieveMessage.conversationUid){
                        if !recieveMessage.tempChatId!.isEmpty{
                            if isContainConversationByUIdTemp(conversationArrayList: self.conversationArrayList, tempChatId: recieveMessage.tempChatId!){
                                var conversationByUID1 = getConversationFromReceiveMsg(recieveMessage: recieveMessage)
                                conversationByUID1.isUpdateStatus = true
                                
                                dbChatObj.saveChatIntoData(isUpdateById: false, pageNumber: pageNumber, conversation: conversationByUID1 ?? ConversationsByUUID())
                                
                                //MARK: Local Chat Work
                                //                            //item status update into list
                                self.conversationArrayList.remove(at: addedConversationPos)
                                self.conversationArrayList.insert(conversationByUID1, at: addedConversationPos)
                                let indexPath = IndexPath(row: addedConversationPos, section: 0)
                                self.chatTableView.reloadRows(at: [indexPath], with: .none)
                                
                            }else{
                                if recieveMessage.content != "We are online"{
                                    //MARK: Local Chat Work
                                    dbChatObj.saveChatIntoData(isUpdateById: true, pageNumber: pageNumber, conversation: getConversationFromReceiveMsg(recieveMessage: recieveMessage) ?? ConversationsByUUID())
                                    self.conversationArrayList.insert(getConversationFromReceiveMsg(recieveMessage: recieveMessage), at:  0)
                                    UIView.performWithoutAnimation {
                                        self.chatTableView.reloadData()
                                    }
                                    scrollToBottom()
                                }
                                
                            }
                        }else{
                            if recieveMessage.content != "We are online"{
                                //MARK: Local Chat Work
                                dbChatObj.saveChatIntoData(isUpdateById: true, pageNumber: pageNumber, conversation: getConversationFromReceiveMsg(recieveMessage: recieveMessage) ?? ConversationsByUUID())
                                
                                self.conversationArrayList.insert(getConversationFromReceiveMsg(recieveMessage: recieveMessage), at: 0)
                                UIView.performWithoutAnimation {
                                    self.chatTableView.reloadData()
                                }
                                scrollToBottom()
                            }
                        }
                    }else{
                        if recieveMessage.content != "We are online"{
                            //MARK: Local Chat Work
                            dbChatObj.saveChatIntoData(isUpdateById: true, pageNumber: pageNumber, conversation: getConversationFromReceiveMsg(recieveMessage: recieveMessage) ?? ConversationsByUUID())
                            
                            self.conversationArrayList.append(getConversationFromReceiveMsg(recieveMessage: recieveMessage))
                            UIView.performWithoutAnimation {
                                self.chatTableView.reloadData()
                            }
                            scrollToBottom()
                        }
                    }
                    
                }else{
                    if recieveMessage.content != "We are online"{
                        //MARK: Local Chat Work
                        dbChatObj.saveChatIntoData(isUpdateById: true, pageNumber: pageNumber, conversation: conversation ?? ConversationsByUUID())
                        
                        self.conversationArrayList.append(getConversationFromReceiveMsg(recieveMessage: recieveMessage))
                        UIView.performWithoutAnimation {
                            self.chatTableView.reloadData()
                        }
                        scrollToBottom()
                    }
                }
                
                if (!(recieveMessage.isFromWidget ?? false) && !(recieveMessage.isSeen ?? false)){
                    readRecieptInvoke(conversationDetailId: recieveMessage.id!);
                }
                
            }else{
                    if recieveMessage.id != 0 {
                        dbChatObj.saveChatIntoData(isUpdateById: true, pageNumber: pageNumber, conversation: getConversationFromReceiveMsg(recieveMessage: recieveMessage))
                    }else{
                        dbChatObj.saveChatIntoData(isUpdateById: false, pageNumber: pageNumber, conversation: getConversationFromReceiveMsg(recieveMessage: recieveMessage))
                    }
                                       
            }
        }
        
    }


    
    func updateReadReciept(readReceiptRequest : ReadReceiptRequest){
        if self.conversationUuID == readReceiptRequest.conversationUId{
            if !self.conversationArrayList.isEmpty {
                if readReceiptRequest.conversationDetailId! != 0{
                    if isContainConversationId(conversationArrayList: self.conversationArrayList, ChatId: readReceiptRequest.conversationDetailId!){
                        var conversationByUID1 = getConversationFromRedReciept(recieveMessage: getConversationById(conversationArrayList: self.conversationArrayList, ChatId: readReceiptRequest.conversationDetailId!))
                        if  conversationByUID1.isFromWidget! && !conversationByUID1.isSeen!{
                            conversationByUID1.isUpdateStatus = true
                            conversationByUID1.isSeen = readReceiptRequest.isSeen
                            self.conversationArrayList.remove(at: addedConversationPos)
                            self.conversationArrayList.insert(conversationByUID1, at: addedConversationPos)
                            dbChatObj.updateSpecifConveration(pageNumber: self.pageNumber, conversation: conversationByUID1)
                            let indexPath = IndexPath(row: addedConversationPos, section: 0)  //IndexPath(item: addedConversationPos, section: 0)
                            self.chatTableView.reloadRows(at: [indexPath], with: .none)
                        }
                        
                    }
                }
            }
        }
    }
    
    func addSendMessageTemp(recieveMessage: NewChatMessage) -> ConversationsByUUID{
        var timeStamp: String = ""
        if  recieveMessage.type == "file"{
            var arrayListFile :[FileDataModel]  = [FileDataModel]()
            var conversation : ConversationsByUUID = ConversationsByUUID()
            conversation.type = recieveMessage.type
            conversation.conversationType = recieveMessage.type == "file" ? "multimedia" : "text"
            conversation.conversationUid = recieveMessage.conversationUId
            conversation.toUserId = 0
            conversation.customerName = recieveMessage.name
            conversation.sender = ""
            conversation.agentId = recieveMessage.agentId
            conversation.customerId = recieveMessage.customerId
            conversation.content = recieveMessage.message
            var filesData : FileDataModel = FileDataModel()
            filesData.url = recieveMessage.fileUri // filesNames[indexCurrent].url
            filesData.type = recieveMessage.documentType //filesNames[indexCurrent].mimeType
            filesData.documentName = recieveMessage.documentName //filesNames[indexCurrent].fileName
            filesData.documentOriginalName = recieveMessage.documentOrignalname
            filesData.fileLocalUri = filesNames[indexCurrent].fileLocalUri
            
            filesData.isLocalFile = true
            arrayListFile.append(filesData)
            conversation.files = arrayListFile
            conversation.fromUserId = 0
            conversation.isFromWidget = recieveMessage.isFromWidget!
            conversation.isPrivate = false
            conversation.groupId = recieveMessage.groupId
            conversation.groupName = ""
            conversation.timestamp = self.getCurretDateTime()
            conversation.receiver = ""
            conversation.pageId = ""
            conversation.pageName = ""
            conversation.tiggerevent = 0
            conversation.tempChatId = recieveMessage.tempChatId
            conversation.caption = recieveMessage.caption
            conversation.fileLocalUri = filesData.fileLocalUri ?? ""
            conversation.isNotNewChat = true
            conversation.isUpdateStatus = false
            conversation.isShowLocalFiles = true
//            conversation.createdOn = self.getCurrentDateAndTime()
            // visible send message iconA
            // hide progress loader place of send message button
            //hide selected files layout view
            
            return conversation
        }else{
            var conversation : ConversationsByUUID = ConversationsByUUID()
            conversation.conversationType = recieveMessage.type == "file" ? "multimedia" : "text"
            conversation.type = recieveMessage.type
            conversation.conversationUid = recieveMessage.conversationUId
            conversation.toUserId = 0
            conversation.customerName = recieveMessage.name
            conversation.sender = ""
            conversation.agentId = recieveMessage.agentId
            conversation.customerId = recieveMessage.customerId
            conversation.content = recieveMessage.message
            conversation.fromUserId = 0
            conversation.isFromWidget = recieveMessage.isFromWidget!
            conversation.isPrivate = false
            conversation.groupId = recieveMessage.groupId
            conversation.groupName = ""
            conversation.timestamp = self.getCurretDateTime()
            conversation.receiver = ""
            conversation.pageId = ""
            conversation.pageName = ""
            conversation.tiggerevent = 0
            conversation.tempChatId = recieveMessage.tempChatId
            conversation.isNotNewChat = true
            conversation.isUpdateStatus = false
            conversation.isShowLocalFiles = false
            conversation.isWelcomeMessage = recieveMessage.isWelcomeMessage
            conversation.caption = recieveMessage.caption
//            conversation.createdOn = self.getCurrentDateAndTime()
            return conversation
        }


    }
    
    func typingIndicatorRequest(){
        var typingIndicatorListenerModel : TypingIndicatorListenerModel = TypingIndicatorListenerModel()
        typingIndicatorListenerModel.id = self.cusId
        typingIndicatorListenerModel.callerAppType = Int64(UtilsClassChat.sheard.callerAppType)
        typingIndicatorListenerModel.conversationUId = self.conversationUuID
        typingIndicatorListenerModel.name = self.customerName
        self.chatHubConnection?.send(method: "IndicateTyping",typingIndicatorListenerModel, true)
    }
    
    func typingIndicatorResponse(typingIndicatorListenerModel : TypingIndicatorListenerModel){
        self.lbl_timedetail.text = "typing..."
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.lbl_timedetail.text = "Typically replies in 15 minutes"
        }
    }

    //used for send message
    func readRecieptInvoke(conversationDetailId: Int64){
        var readRequestModel : ReadReceiptRequest = ReadReceiptRequest()
        readRequestModel.isSeen = true
        readRequestModel.conversationDetailId = conversationDetailId
        readRequestModel.conversationUId = self.conversationUuID
        readRequestModel.callerAppType = Int64(UtilsClassChat.sheard.callerAppType)
        readRequestModel.id = Int64(self.cusId)
        //update list item and also update locally each item which you send in read reciept
        if (self.conversationArrayList != nil && !self.conversationArrayList.isEmpty){
            if (isContainConversationId(conversationArrayList: self.conversationArrayList, ChatId: readRequestModel.conversationDetailId!)){
                var conversationByUID1 = self.conversationArrayList[addedConversationPos];
                if (conversationByUID1 != nil){
                    conversationByUID1.isSeen = true;
                    self.conversationArrayList.remove(at: addedConversationPos)
                    self.conversationArrayList.insert(conversationByUID1, at: addedConversationPos)
                    let indexPath = IndexPath(row: addedConversationPos, section: 0)//IndexPath(item: self.addedConversationPos, section: 0)
                    self.chatTableView.reloadRows(at: [indexPath], with: .none)
                    dbChatObj.saveChatIntoData(isUpdateById: true, pageNumber: 1, conversation: conversationByUID1)
                }
            }
        }
        self.chatHubConnection?.send(method: "ReadReceipt",readRequestModel)
    }
    
    
    //when send private message recieve listner response then we create conversation object for list
    func getConversationFromReceiveMsg(recieveMessage: RecieveMessage)-> ConversationsByUUID{
        var conversationByUID : ConversationsByUUID = ConversationsByUUID()
        conversationByUID.conversationType = recieveMessage.type == "file" ? "multimedia" : "text"
        conversationByUID.type = recieveMessage.type!
        conversationByUID.tempChatId = recieveMessage.tempChatId ?? ""
        conversationByUID.conversationUid = recieveMessage.conversationUid!
        conversationByUID.toUserId = recieveMessage.toUserId!
        conversationByUID.customerName = recieveMessage.customerName!
        conversationByUID.sender = recieveMessage.sender!
        conversationByUID.agentId = recieveMessage.agentId
        conversationByUID.customerId = recieveMessage.customerId!
        conversationByUID.content = recieveMessage.content!
        conversationByUID.files = recieveMessage.files!
        conversationByUID.fromUserId = recieveMessage.fromUserId
        conversationByUID.isFromWidget = recieveMessage.isFromWidget!
        conversationByUID.isPrivate = recieveMessage.isPrivate!
        conversationByUID.groupId = recieveMessage.groupId
        conversationByUID.groupName = recieveMessage.groupName
        conversationByUID.timestamp = recieveMessage.timestamp!
        conversationByUID.receiver = recieveMessage.receiver
        conversationByUID.pageId = recieveMessage.pageId
        conversationByUID.pageName = recieveMessage.pageName
        conversationByUID.tiggerevent = recieveMessage.tiggerevent!
        conversationByUID.id = recieveMessage.id!
        conversationByUID.isUpdateStatus = true
        conversationByUID.isNotNewChat = true
        conversationByUID.isSeen = false
        conversationByUID.caption = recieveMessage.caption ?? ""
        conversationByUID.isFailed = false
        conversationByUID.isReceived = true
        conversationByUID.createdOn = convertTimeStampToDate(recieveMessage.timestamp ?? "")
        return conversationByUID
    }
    
    //when send private message recieve listner response then we create conversation object for list
    func getConversationFromBulkReceiveMsg(recieveMessage: ConversationsByUUID)-> ConversationsByUUID{
        var conversationByUID : ConversationsByUUID = ConversationsByUUID()
        conversationByUID.conversationType = recieveMessage.type == "file" ? "multimedia" : "text"
        conversationByUID.type = recieveMessage.type ?? ""
        conversationByUID.conversationUid = recieveMessage.conversationUid ?? ""
        conversationByUID.toUserId = recieveMessage.toUserId ?? 0
        conversationByUID.customerName = recieveMessage.customerName ?? ""
        conversationByUID.sender = recieveMessage.sender ?? ""
        conversationByUID.agentId = recieveMessage.agentId ?? 0
        conversationByUID.customerId = recieveMessage.customerId ?? 0
        conversationByUID.content = recieveMessage.content ?? ""
        conversationByUID.files = recieveMessage.files ?? [FileDataModel]()
        conversationByUID.fromUserId = recieveMessage.fromUserId ?? 0
        conversationByUID.isFromWidget = recieveMessage.isFromWidget ?? false
        conversationByUID.isPrivate = recieveMessage.isPrivate ?? false
        conversationByUID.groupId = recieveMessage.groupId ?? 0
        conversationByUID.groupName = recieveMessage.groupName ?? ""
        conversationByUID.timestamp = recieveMessage.timestamp ?? ""
        conversationByUID.receiver = recieveMessage.receiver ?? ""
        conversationByUID.pageId = recieveMessage.pageId ?? ""
        conversationByUID.pageName = recieveMessage.pageName ?? ""
        conversationByUID.tiggerevent = recieveMessage.tiggerevent ?? 0
        conversationByUID.id = recieveMessage.id ?? 0
        conversationByUID.isUpdateStatus = true
        conversationByUID.isNotNewChat = true
        conversationByUID.isSeen = false
        conversationByUID.caption = recieveMessage.caption ?? ""
        conversationByUID.isFailed = false
        conversationByUID.isReceived = true
//        conversationByUID.createdOn = convertTimeStampToDate(recieveMessage.timestamp ?? "")
        return conversationByUID
    }

    func getConversationFromRedReciept(recieveMessage: ConversationsByUUID)-> ConversationsByUUID{
        var conversationByUID : ConversationsByUUID = ConversationsByUUID()
        conversationByUID.id = recieveMessage.id
        
        conversationByUID.conversationType = recieveMessage.type == "file" ? "multimedia" : "text"
        conversationByUID.type = recieveMessage.type!
        conversationByUID.conversationUid = recieveMessage.conversationUid!
        conversationByUID.toUserId = recieveMessage.toUserId!
        conversationByUID.customerName = recieveMessage.customerName!
        conversationByUID.sender = recieveMessage.sender!
        conversationByUID.agentId = recieveMessage.agentId
        conversationByUID.customerId = recieveMessage.customerId!
        conversationByUID.content = recieveMessage.content!
        conversationByUID.files = recieveMessage.files!
        conversationByUID.fromUserId = recieveMessage.fromUserId
        conversationByUID.isFromWidget = recieveMessage.isFromWidget!
        conversationByUID.isPrivate = recieveMessage.isPrivate!
        conversationByUID.groupId = recieveMessage.groupId
        conversationByUID.groupName = recieveMessage.groupName
        conversationByUID.timestamp = recieveMessage.timestamp!
        conversationByUID.receiver = recieveMessage.receiver
        conversationByUID.pageId = recieveMessage.pageId
        conversationByUID.pageName = recieveMessage.pageName
        conversationByUID.tiggerevent = recieveMessage.tiggerevent!
        conversationByUID.isUpdateStatus = true
        conversationByUID.isNotNewChat = true
        conversationByUID.isSeen = false
        conversationByUID.caption = recieveMessage.caption ?? ""
        conversationByUID.isFailed = false
        conversationByUID.createdOn = recieveMessage.createdOn
//        conversationByUID.createdOn = convertTimeStampToDate(recieveMessage.timestamp ?? "")
        
        return conversationByUID
    }
    
    //GetConversationFromResolveListener
    func getConversationFromResolveListener(conversationStatusListenerDataModel: ConversationStatusListenerDataModel, feedBackRequest: ResolveFeedBackRequest, isFeedback: Bool) -> ConversationsByUUID {
        var conversationByUID = ConversationsByUUID()
        conversationByUID.conversationType = "text"
        conversationByUID.type = "system"
        conversationByUID.conversationUid = conversationStatusListenerDataModel.conversationUid
        conversationByUID.customerId = self.cusId
        conversationByUID.toUserId = 0
        conversationByUID.customerName = ""
        conversationByUID.sender = ""
        conversationByUID.agentId = 0
        conversationByUID.fromUserId = 0
        conversationByUID.isFromWidget = false
        conversationByUID.isFeedback = isFeedback
        conversationByUID.id = conversationStatusListenerDataModel.conversationId
        conversationByUID.isPrivate = false
        conversationByUID.groupId = -1
        conversationByUID.groupName = ""
        conversationByUID.receiver = ""
        conversationByUID.pageId = ""
        conversationByUID.pageName = ""
        conversationByUID.tiggerevent = 0
        conversationByUID.timestamp = conversationStatusListenerDataModel.timestamp
        conversationByUID.isResolved = conversationStatusListenerDataModel.isResolved
        conversationByUID.rating = (feedBackRequest.rating)
        conversationByUID.feedback = feedBackRequest.feedback

        return conversationByUID
    }

    func isContainConversationByUIdTemp(conversationArrayList : [ConversationsByUUID], tempChatId:String)-> Bool{
        for i in 0...conversationArrayList.count-1{
            if conversationArrayList[i].tempChatId == tempChatId {
                addedConversationPos = i;
                return true;
            }
        }
         return false;
    }
    
    
    func isContainConversationId(conversationArrayList : [ConversationsByUUID], ChatId:Int64)-> Bool{
        for i in 0...conversationArrayList.count-1{
            if conversationArrayList[i].id == ChatId{
                addedConversationPos = i;
                return true;
            }
        }
         return false;
    }
    
    func getConversationById(conversationArrayList : [ConversationsByUUID], ChatId:Int64)-> ConversationsByUUID{
        for i in 0...conversationArrayList.count-1{
            if conversationArrayList[i].id == ChatId{
                addedConversationPos = i
                return conversationArrayList[i]
            }
        }
         return ConversationsByUUID()
    }
    
    func addTempItemToList(sendMessageModel : NewChatMessage, isAddedToDB : Bool){
        //load list view
        appendNewChatMessage(conversationsByUUID: self.addSendMessageTemp(recieveMessage: sendMessageModel), isAddedToDB: isAddedToDB)
        
    }
    
    func convertTimeStampToDate(_ dataDate: String) -> Date? {
        var inputDate: Date?
        
        let utcFormat = DateFormatter()
        utcFormat.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        utcFormat.timeZone = TimeZone(identifier: "UTC")
        
        do {
            inputDate = try utcFormat.date(from: dataDate)
        } catch {
            print(error.localizedDescription)
        }
        
        return inputDate
    }
    
    func getCurretDateTime()-> String{
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss" // ignores time!
        return dateFormatter.string(from: Date())
    }
    


    
     func convertIsoStrigToDate(strDate:String)-> String{
        var strFinalDate = ""
         
        if !strDate.isEmpty{
            
            let isoDateFormatter  = DateFormatter()
            
            isoDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"   // ignores time!
            let returnDate = isoDateFormatter.date(from: strDate)
            
            let dateFormatt = DateFormatter();
            dateFormatt.dateFormat = "hh:mm aa"
            return dateFormatt.string(from: returnDate! as Date)
        }
         
        return strFinalDate
        
    }
    
    func localToUTC(dateStr: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        dateFormatter.calendar = Calendar.current
        dateFormatter.timeZone = TimeZone.current
        
        if let date = dateFormatter.date(from: dateStr) {
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            dateFormatter.dateFormat = "H:mm:ss"
        
            return dateFormatter.string(from: date)
        }
        return nil
    }

    func utcToLocal(dateStr: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        if let date = dateFormatter.date(from: dateStr) {
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.dateFormat = "dd MMM yy h:mm a" //"hh:mm aa"
        
            return dateFormatter.string(from: date)
        }
        return nil
    }
    
    
    func getFirstLetterOfString(username: String)-> String{
        if !username.isEmpty{
            let result = String(username.prefix(1))
            return result
        }
        return ""
    }

    
    func showToast(strMessage : String){
    
        Toast.show(message: strMessage, controller: self)

    }
    
    func scrollToBottom(){
        if conversationArrayList.count>0{
            DispatchQueue.main.async {
                
                let indexPath = IndexPath(row: 0, section: 0)
                self.chatTableView.scrollToRow(at: indexPath, at: .top, animated: false)
            }
        }
    }
}

extension ChatViewController : UITextViewDelegate {
    
    public func textViewDidChange(_ textView: UITextView) {
        self.typingIndicatorRequest()
    }
    
}


extension ChatViewController :  UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIDocumentPickerDelegate{
    
    func openCamera(){
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
            self.isFromCamera = true
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.view.tintColor = .white
            imagePicker.mediaTypes = ["public.image"]
            imagePicker.allowsEditing = false
            imagePicker.navigationBar.barTintColor = .black
            checkPermission()
        }
        else{
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    

    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        if urls.count <= 5{
            var fileExtension = ""
            var fileNameWithoutExtension = ""
            var strBase64 = ""
            var mimeType = ""
            var fileURlStr = ""
            if urls.count > 0 {
                for i in 0..<urls.count {
                    let fileURL = urls[i] as URL
                    //print("The Url is : \(fileURL)")
                    fileExtension = urls[i].pathExtension
                    fileNameWithoutExtension = urls[i].lastPathComponent
                    //print("fileNameWithoutExtension: \(fileNameWithoutExtension)")
                    //print("fileExtension: \(fileExtension)")
                    
                    do {
                        let data = try Data(contentsOf: fileURL)
                        //init model for upload file data model
                        var uploadFilesDataModel : UploadFilesDataModel = UploadFilesDataModel()
                        var fileDataClass = FileDataClass()
                        fileURlStr = fileURL.path
                        
                        if fileExtension == "jpg" || fileExtension == "JPG" || fileExtension == "jpeg" || fileExtension == "JPEG" ||
                            fileExtension == "png" ||
                            fileExtension == "PNG" {
                            mimeType = "image/\(fileExtension)"
                            
                            var tempChatID =  generateUuID()
                            //convert selected file into base64
                            strBase64 = data.base64EncodedString()
                            //creating data model for files array list and send into upload api
                            uploadFilesDataModel.file = strBase64
                            uploadFilesDataModel.fileName = fileNameWithoutExtension
                            uploadFilesDataModel.contentType = "image/\(fileExtension)"
                            uploadFilesDataModel.tempChatID = tempChatID
                            uploadFilesDataModel.conversationUId = self.conversationUuID
                            uploadFilesDataModel.caption = ""
                

                            //storing file data for setting into conversation list
                            fileDataClass.fileName = fileNameWithoutExtension
                            fileDataClass.fileSizes = "\(UtilsClassChat.sheard.fileSize(fromPath: fileURL.path) ?? "")"
                            fileDataClass.url = strBase64
                            fileDataClass.tempChatId = tempChatID
                            fileDataClass.mimeType = mimeType
                            fileDataClass.fileLocalUri = strBase64
                        }else{
                            mimeType = "application/\(fileExtension)"
                            
                            var tempChatID =  generateUuID()
                            //convert selected file into base64
                            strBase64 = data.base64EncodedString()
                            //creating data model for files array list and send into upload api
                            uploadFilesDataModel.file = strBase64
                            uploadFilesDataModel.fileName = fileNameWithoutExtension
                            uploadFilesDataModel.contentType = "application/\(fileExtension)"
                            uploadFilesDataModel.tempChatID = tempChatID
                            uploadFilesDataModel.conversationUId = self.conversationUuID
                            uploadFilesDataModel.caption = ""
                            
                            strBase64 = data.base64EncodedString()
                            
                            //storing file data for setting into conversation list
                            fileDataClass.fileName = fileNameWithoutExtension
                            fileDataClass.fileSizes = "\(UtilsClassChat.sheard.fileSize(fromPath: fileURL.path) ?? "")"
                            fileDataClass.url = fileURL.absoluteString
                            fileDataClass.tempChatId = tempChatID
                            fileDataClass.mimeType = mimeType
                            fileDataClass.fileLocalUri = strBase64
                            
                        }
                        //this for send to upload api
                        fileUploadArrayList.append(uploadFilesDataModel)
                        //this object make for show selected file to detail view controller
                        filesNames.append(fileDataClass)
                        
                        
                        //self.addUriToBase64InLists(strFileName: fileNameWithoutExtension, strFileType: fileExtension, strBase64: data.base64EncodedString())
                    }
                    catch {
                        /* error handling here */
                        
                    }
                }
                
            }
            controller.dismiss(animated: true, completion: {
                //To call or execute function after some time(After 5 sec)
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    let selectedFilePreview = self.storyboard?.instantiateViewController(withIdentifier: "SelectedFilePreview") as! SelectedFilePreview
                    selectedFilePreview.modalPresentationStyle = .popover
                    selectedFilePreview.fileName = fileNameWithoutExtension
                    selectedFilePreview.fileType = mimeType
                    selectedFilePreview.fileSize  = "\(UtilsClassChat.sheard.fileSize(fromPath: fileURlStr) ?? "")"
                    selectedFilePreview.fileUri = strBase64
                    selectedFilePreview.isFromImageSelection = false
                    selectedFilePreview.isFromPDFSelection = true
                    selectedFilePreview.filesNames = self.filesNames
                    selectedFilePreview.delegate = self
                    self.present(selectedFilePreview, animated: true, completion: nil)
                }
            })
            
        }
    }

    func createMultiPartFromUrl(base64 : String, conversationUUId : String, tempChatIdStr : String, type : String ,filename : String){
        if base64 != ""{
            var fileExtension = type
            var fileNameWithoutExtension = filename
            var strBase64 = ""
            var mimeType = ""
            var fileURlStr = ""
            var tempChatID = ""
            do {
                
                let data = Data(base64Encoded: base64, options: .ignoreUnknownCharacters)
                var uploadFilesDataModel : UploadFilesDataModel = UploadFilesDataModel()
                var fileDataClass = FileDataClass()
                //fileURlStr = fileURL.path
                
                if fileExtension == "image/jpg" || fileExtension == "image/JPG" || fileExtension == "image/jpeg" || fileExtension == "image/JPEG" ||
                    fileExtension == "image/png" ||
                    fileExtension == "image/PNG" {
                    mimeType = "\(fileExtension)"
                    
                    if tempChatIdStr == ""{
                        tempChatID =  generateUuID()
                    }else{
                        tempChatID = tempChatIdStr
                    }
                    //convert selected file into base64
                    strBase64 = data?.base64EncodedString() ?? ""
                    //creating data model for files array list and send into upload api
                    uploadFilesDataModel.file = strBase64
                    uploadFilesDataModel.fileName = fileNameWithoutExtension
                    uploadFilesDataModel.contentType = "image/\(fileExtension)"
                    uploadFilesDataModel.tempChatID = tempChatID
                    uploadFilesDataModel.conversationUId = conversationUUId
                    uploadFilesDataModel.caption = ""
                    
                    
                    fileDataClass.fileName = fileNameWithoutExtension
                    //fileDataClass.fileSizes = "\(UtilsClassChat.sheard.fileSize(fromPath: fileURL.path) ?? "")"
                    fileDataClass.url = strBase64
                    fileDataClass.tempChatId = tempChatID
                    fileDataClass.mimeType = mimeType
                    
                    
                    
                    
                }else{
                    mimeType = "\(fileExtension)"
                    
                    if tempChatIdStr == ""{
                        tempChatID =  generateUuID()
                    }else{
                        tempChatID = tempChatIdStr
                    }
                    //convert selected file into base64
                    strBase64 = data?.base64EncodedString() ?? ""
                    //creating data model for files array list and send into upload api
                    uploadFilesDataModel.file = strBase64
                    uploadFilesDataModel.fileName = fileNameWithoutExtension
                    uploadFilesDataModel.contentType = "\(fileExtension)"
                    uploadFilesDataModel.tempChatID = tempChatID
                    uploadFilesDataModel.conversationUId = conversationUUId
                    uploadFilesDataModel.caption = ""
                    
                    
                    fileDataClass.fileName = fileNameWithoutExtension
                    //fileDataClass.fileSizes = "\(UtilsClassChat.sheard.fileSize(fromPath: fileURL.path) ?? "")"
                    fileDataClass.url = strBase64
                    fileDataClass.tempChatId = tempChatID
                    fileDataClass.mimeType = mimeType
                    
                }
                //this for send to upload api
                fileUploadArrayList.append(uploadFilesDataModel)
                //this object make for show selected file to detail view controller
                filesNames.append(fileDataClass)
                
                print(fileUploadArrayList)
                
                self.uploadFilesToServer(conversationUUId: conversationUuID, multipartList: self.fileUploadArrayList,tempChatIdStr: tempChatIdStr)
                
                //self.addUriToBase64InLists(strFileName: fileNameWithoutExtension, strFileType: fileExtension, strBase64: data.base64EncodedString())
            }
            catch {
                /* error handling here */
                print("No File")
            }
            //}
            
            }
        
    }
    
    private func checkPermission() {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        case .authorized:
            print("Add Photo")
            if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
                print("Access is granted by user")
                self.present(imagePicker, animated: true, completion: nil)
            }
            print("Access is granted by user")
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({
                (newStatus) in
                print("status is \(newStatus)")
                if newStatus ==  PHAuthorizationStatus.authorized {
                    /* do stuff here */
                    DispatchQueue.main.async {
                        self.present(self.imagePicker, animated: true, completion: nil)
                    }
                    print("success")
                }
            })
            print("It is not determined until now")
        case .restricted:
            // same same
            print("User do not have access to photo album.")
            goToSetting()
        case .denied:
            // same same
            print("Text tapped...")
            goToSetting()
            print("User has denied the permission.")
        case .limited:
            goToSetting() // the function show an alert to enable Authorization manually
            print("User has denied the permission.")
        @unknown default:
            fatalError()
        }
    }
    private func goToSetting() {
        let title = "Oooooops!"
        let message = "To use this App press Go To settings and enabled access to Pohto Gallery... Check read and write option and relaunch the App!"
        
        let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
        
        let subview = (alertController.view.subviews.first?.subviews.first?.subviews.first!)! as UIView
        subview.backgroundColor = UIColor(white: 0, alpha: 0.2)
        
        alertController.setValue(NSAttributedString(string: title, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18, weight: .heavy),NSAttributedString.Key.foregroundColor : UIColor.red]), forKey: "attributedTitle")
        alertController.setValue(NSAttributedString(string: message, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14, weight: .regular),NSAttributedString.Key.foregroundColor : UIColor.white]), forKey: "attributedMessage")
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (_) in
            print("Action cancelled")
        }
        
        let goToSettingPermission = UIAlertAction(title: "Go To setting", style: .default) { (action) in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
        }
        
        alertController.addAction(goToSettingPermission)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: {
        })
    }
    
    func openDocumentPicker() {
        self.isFromCamera = false
        let documentPicker = UIDocumentPickerViewController(documentTypes: UtilsClassChat.sheard.types, in: .import)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = true
        documentPicker.modalPresentationStyle = .formSheet
        self.present(documentPicker, animated: true, completion: nil)
        
    }
    
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        let img:UIImage = (info[UIImagePickerController.InfoKey.originalImage] as? UIImage)!
        let imageURL = (info[UIImagePickerController.InfoKey.imageURL] as? URL)
        let imageData = UtilsClassChat.sheard.compressImageFromUIImage(img: img)
        var strFileType = UtilsClassChat.sheard.getImageType(info: info)
        let strFileName = UtilsClassChat.sheard.getFileName(info: info)
        let base64String = UtilsClassChat.sheard.convertImageToBase64String(img:imageData)
       
        var strBase64 = ""
        var mimetype = ""
        if (strFileType == "Unknown" || strFileType == ""){
            strFileType = "png"
            mimetype = "image/png"
        }else {
            mimetype = "image/\(strFileType)"
        }
        if !strFileName.contains(".") {
            strFileType = "\(strFileName).\(strFileType)"
        }else{
            strFileType = strFileName
        }
        
        
        do {
            
            
            var tempChatId =  generateUuID()
            var uploadFilesDataModel : UploadFilesDataModel = UploadFilesDataModel()
            uploadFilesDataModel.file = base64String //imageData.jpegData(compressionQuality: 0.1)!
            uploadFilesDataModel.fileName = strFileName
            uploadFilesDataModel.contentType = mimetype
            uploadFilesDataModel.tempChatID = tempChatId
            uploadFilesDataModel.conversationUId = self.conversationUuID
            uploadFilesDataModel.caption = ""
            //this for send to upload api
            fileUploadArrayList.append(uploadFilesDataModel)
            
            var fileDataClass = FileDataClass()
            fileDataClass.fileName = strFileName
            fileDataClass.fileSizes = ""
            fileDataClass.url = base64String
            fileDataClass.tempChatId = tempChatId
            fileDataClass.mimeType = mimetype
            fileDataClass.fileLocalUri = base64String
//
            //this object make for show selected file to detail view controller
            filesNames.append(fileDataClass)
                        
        }catch{
            print("The wayo")
        }
        
        dismiss(animated: true, completion: {
            //To call or execute function after some time(After 5 sec)
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                let selectedFilePreview = self.storyboard?.instantiateViewController(withIdentifier: "SelectedFilePreview") as! SelectedFilePreview
                selectedFilePreview.modalPresentationStyle = .popover
                selectedFilePreview.fileName = strFileType
                selectedFilePreview.fileType = mimetype
                selectedFilePreview.fileSize = ""
                selectedFilePreview.fileUri = base64String
                selectedFilePreview.filesNames = self.filesNames
                selectedFilePreview.isFromImageSelection = true
                selectedFilePreview.delegate = self
                self.present(selectedFilePreview, animated: true, completion: nil)
            }
        })

    }
     
    
    public func imagePickerControllerDidCancel(_ picker:
                                            UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

}

extension ChatViewController : UIActionSheetDelegate{
    
    func openSheet(){
        let alertController = UIAlertController(title: "Choose option", message: "What would you like to upload?", preferredStyle: .actionSheet)
        
        let sendButton = UIAlertAction(title: "Documents", style: .default, handler: { (action) -> Void in
            self.openDocumentPicker()
        })
        
        let  deleteButton = UIAlertAction(title: "Photos", style: .default, handler: { (action) -> Void in
            //self.handlepickPicture()
            self.showMultipleImagePicker()
        })
        
        let  cameraBtn = UIAlertAction(title: "Camera", style: .default, handler: { (action) -> Void in
            self.openCamera()
        })
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
            print("Cancel button tapped")
        })
        
        
        alertController.addAction(sendButton)
        alertController.addAction(deleteButton)
        alertController.addAction(cameraBtn)
        alertController.addAction(cancelButton)
        
//        self.navigationController!.present(alertController, animated: true, completion: nil)
        self.present(alertController, animated: true, completion: nil)

        
    }
    
    func getFolderSize(url : String)-> Double{
        var fileSize : Double = 0.0
                do {
          let attribute = try FileManager.default.attributesOfItem(atPath: url)
          if let size = attribute[FileAttributeKey.size] as? NSNumber {
          let sizeInMB = size.doubleValue / 1000000.0
          fileSize = sizeInMB
          }
        } catch {
          print("Error: \(error)")
        }
        
        return fileSize
    }
}


//used for previews the files
extension ChatViewController : QLPreviewControllerDataSource{
    
    func fileDownload(urlString:String, fileName:String,position: Int) {
        
        DispatchQueue.global(qos: .background).async {
            
            let url = URL(string: urlString)
            let pdfData = try? Data.init(contentsOf: url!)
            let resourceDocPath = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last! as URL
            let pdfNameFromUrl = fileName
            let actualPath = resourceDocPath.appendingPathComponent(pdfNameFromUrl)
            DispatchQueue.main.async {
                
                do {
                    self.hideAndShowDownloadingIcon(isHide: true, position: position)
                    try pdfData?.write(to: actualPath, options: .atomic)
                    print("File download successfully")
                    self.openFile(base64str: (pdfData?.base64EncodedString())!, fileName: fileName)
                    
                    
                    //file is downloaded in app data container, I can find file from x code > devices > MyApp > download Container >This container has the file
                } catch {
                    print("File now download")
                }
            }
            
        }
    }
    
    func openFile(base64str: String,fileName: String) {
    if let data = try Data(base64Encoded: base64str,options: .ignoreUnknownCharacters){

       //print("data=\(data)")
      // get the documents directory url
      let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
      // choose a name for your image
      let fileName = fileName
      // create the destination file url to save your image
      let fileURL = documentsDirectory.appendingPathComponent(fileName)
      if !FileManager.default.fileExists(atPath: fileURL.path) {
          do {
              // writes the image data to disk
              try data.write(to: fileURL)
              self.previewItem = fileURL as NSURL
                              // Display file
                              let previewController = QLPreviewController()
                              previewController.dataSource = self
                              self.present(previewController, animated: true, completion: nil)
              
          }catch {
              print("error saving file:", error)
          }
      }else{
          self.previewItem = fileURL as NSURL
          // Display file
          let previewController = QLPreviewController()
          previewController.dataSource = self
          self.present(previewController, animated: true, completion: nil)
      
    }
  }
        
}
    public func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
     return 1
 }
 
    public func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
     return self.previewItem as QLPreviewItem
 }
    
}


extension ChatViewController : UICollectionViewDelegate,UICollectionViewDataSource{
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count = 0
        if collectionView == self.uiCvTopics{
            count = self.topicsArrayList.count
        }
        return count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        if collectionView == uiCvTopics{
            let cell = self.uiCvTopics.dequeueReusableCell(withReuseIdentifier: "TopicsCollectionViewCell", for: indexPath) as! TopicsCollectionViewCell
            cell.lblTopicName.text = self.topicsArrayList[indexPath.row].name
            self.collectionTopicHeight.constant = self.uiCvTopics.contentSize.height
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        if collectionView == self.uiCvTopics{
            
            self.isTopicSelect = true
            topicsModel = self.topicsArrayList[indexPath.row]
            self.uiViewTopics.isHidden = true
            self.uiViewTypingAndTopicsLayout.isHidden = false
            menuTopicCOnstantWidth.constant = 20
            btnTopicMenu.isHidden = false
            ivTopicMenu.isHidden = false
            self.topicMessage = topicsModel.message ?? ""
            self.topicId = String(topicsModel.topicId ?? 0)
            if topicsModel.isGroupAssigned == true {
                self.groupId = topicsModel.groupId!
            }else{
                self.groupId = 0
            }
            if !topicsModel.customText!.isEmpty{
                self.lbl_timedetail.text = topicsModel.customText!
            }else{
                self.lbl_timedetail.text = "Typically replies in 15 minutes"
            }
            
            if CustomUserDefaultChat.sheard.getIsResolved() == true{
                self.isTopicSecondTimeSelect = false
                
                sendNewChat(type: "welcomeMessage", txtMessage: self.businessHoursMessage , uploadFilesData: self.uploadFilesData, tempChatIDStr: self.temppChatIdWelcomeMessage, conversationUUID: self.conversationUuID, channelID: self.channelId, mobileToken: self.fcmtoken,isFromWidget: true)

                
            }else{
                self.isTopicSecondTimeSelect = true
                sendNewChat(type: "text", txtMessage: topicsModel.name! , uploadFilesData: self.uploadFilesData, tempChatIDStr:self.generateUuID(), conversationUUID: self.conversationUuID, channelID: self.channelId, mobileToken: self.fcmtoken,isFromWidget: true)
                
            }

        }
        
    }
    
  }



extension ChatViewController : UICollectionViewDelegateFlowLayout{
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width : CGFloat = 0
        var height : CGFloat = 0
        if collectionView == self.uiCvTopics{
            let cell = self.uiCvTopics.dequeueReusableCell(withReuseIdentifier: "TopicsCollectionViewCell", for: indexPath) as! TopicsCollectionViewCell
            cell.lblTopicName.text = self.topicsArrayList[indexPath.row].name
            cell.lblTopicName.sizeToFit()
            width = cell.lblTopicName.frame.width + 30
            height = 30

        }
        
        return CGSize(width: width, height: height)
    }


}
extension ChatViewController{
    
    @objc func btnReuploadTapped(sender: UIButton){
        
        let buttonTag = sender.tag
        
        let base64 = self.conversationArrayList[buttonTag].fileLocalUri ?? ""
        if base64 != ""{
//            self.conversationArrayList[sender.tag].isReceived = false
//            self.conversationArrayList[sender.tag].isFailed = false
//            self.conversationArrayList[sender.tag].isShowLocalFiles = true
//            //self.chatTableView.reloadData()
//            self.chatTableView.reloadRows(at: [IndexPath(row: sender.tag, section: 0)], with: .automatic)
            self.createMultiPartFromUrl(base64: base64, conversationUUId: self.conversationArrayList[buttonTag].conversationUid ?? "", tempChatIdStr: self.conversationArrayList[buttonTag].tempChatId ?? "", type: self.conversationArrayList[buttonTag].files?[0].type ?? "", filename: self.conversationArrayList[buttonTag].files?[0].documentName ?? "" )
        }
        
        
        
    }
    
    func convertReceiveIntoConversationsByUUID(recieveMessage : RecieveMessage) -> ConversationsByUUID{
        
        var conversation : ConversationsByUUID = ConversationsByUUID(id: recieveMessage.id ?? 0, customerId: recieveMessage.customerId, customerConnectionId: "", customerEmail: "", toUserId: recieveMessage.toUserId, agentId: recieveMessage.agentId, status: 0, tempChatId: recieveMessage.tempChatId, fromUserId: recieveMessage.fromUserId, groupId: recieveMessage.groupId, conversationId: 0, content: recieveMessage.content, timestamp: recieveMessage.timestamp, sender: recieveMessage.sender, receiver: recieveMessage.receiver, type: recieveMessage.type, source: "", groupName: recieveMessage.groupName, forwardedTo: recieveMessage.forwardedTo, tiggerevent: recieveMessage.tiggerevent, customerName: recieveMessage.customerName, conversationUid: recieveMessage.conversationUid, isAgentReplied: false, isResolved: false, isFromWidget: recieveMessage.isFromWidget, isPrivate: recieveMessage.isPrivate, childConversationCount: 0, conversationType: "", pageId: recieveMessage.pageId, pageName: recieveMessage.pageName, base64Image: "", fileLocalUri: "", isRecordUpdated: false, isNewMessageReceive: false, isDownloading: false, isSeen: recieveMessage.isSeen, isUpdateStatus: false, isShowLocalFiles: false, isNotNewChat: false, isWelcomeMessage: false, caption: recieveMessage.caption, isFailed: false, isReceived: true, files: recieveMessage.files)
        
        return conversation
    }
    
    func convertConversationsIntoConversationsByUUID(recieveMessage : Conversations) -> ConversationsByUUID{
        
        var conversation : ConversationsByUUID = ConversationsByUUID(id: 0, customerId: recieveMessage.customerId, customerConnectionId: recieveMessage.customerConnectionId, customerEmail: recieveMessage.customerEmail, toUserId: recieveMessage.toUserId, agentId: recieveMessage.agentId, status: Int64(recieveMessage.status ?? 0), tempChatId: recieveMessage.tempChatId, fromUserId: recieveMessage.fromUserId, groupId: recieveMessage.groupId, conversationId: recieveMessage.conversationId, content: recieveMessage.content, timestamp: recieveMessage.timestamp, sender: recieveMessage.sender, receiver: recieveMessage.receiver, type: recieveMessage.type, source: recieveMessage.source, groupName: recieveMessage.groupName, forwardedTo: recieveMessage.forwardedTo, tiggerevent: 0, customerName: recieveMessage.customerName, conversationUid: recieveMessage.conversationUid, isAgentReplied: false, isResolved: false, isFromWidget: recieveMessage.isFromWidget, isPrivate: false, childConversationCount: 0, conversationType: recieveMessage.conversationType, pageId: "", pageName: "", base64Image: "", fileLocalUri: "", isRecordUpdated: false, isNewMessageReceive: false, isDownloading: false, isSeen: false, isUpdateStatus: false, isShowLocalFiles: false, isNotNewChat: false, isWelcomeMessage: false, caption: recieveMessage.caption, files: recieveMessage.files)
        
        return conversation
    }
    
//    func convertReceiveIntoConversationsByUUID(recieveMessage : RecieveMessage) -> ConversationsByUUID{
//        
//        var conversation : ConversationsByUUID = ConversationsByUUID(id: recieveMessage.id ?? 0, customerId: recieveMessage.customerId, customerConnectionId: "", customerEmail: "", toUserId: recieveMessage.toUserId, agentId: recieveMessage.agentId, status: 0, tempChatId: recieveMessage.tempChatId, fromUserId: recieveMessage.fromUserId, groupId: recieveMessage.groupId, conversationId: 0, content: recieveMessage.content, timestamp: recieveMessage.timestamp, sender: recieveMessage.sender, receiver: recieveMessage.receiver, type: recieveMessage.type, source: "", groupName: recieveMessage.groupName, forwardedTo: recieveMessage.forwardedTo, tiggerevent: recieveMessage.tiggerevent, customerName: recieveMessage.customerName, conversationUid: recieveMessage.conversationUid, isAgentReplied: false, isResolved: false, isFromWidget: recieveMessage.isFromWidget, isPrivate: recieveMessage.isPrivate, childConversationCount: 0, conversationType: "", pageId: recieveMessage.pageId, pageName: recieveMessage.pageName, base64Image: "", fileLocalUri: "", isRecordUpdated: false, isNewMessageReceive: false, isDownloading: false, isSeen: recieveMessage.isSeen, isUpdateStatus: false, isShowLocalFiles: false, isNotNewChat: false, isWelcomeMessage: false, caption: recieveMessage.caption, isFailed: false, isReceived: true, files: recieveMessage.files)
//        
//        return conversation
//    }
//    
//    func convertConversationsIntoConversationsByUUID(recieveMessage : Conversations) -> ConversationsByUUID{
//        
//        var conversation : ConversationsByUUID = ConversationsByUUID(id: 0, customerId: recieveMessage.customerId, customerConnectionId: recieveMessage.customerConnectionId, customerEmail: recieveMessage.customerEmail, toUserId: recieveMessage.toUserId, agentId: recieveMessage.agentId, status: recieveMessage.status, tempChatId: recieveMessage.tempChatId, fromUserId: recieveMessage.fromUserId, groupId: recieveMessage.groupId, conversationId: recieveMessage.conversationId, content: recieveMessage.content, timestamp: recieveMessage.timestamp, sender: recieveMessage.sender, receiver: recieveMessage.receiver, type: recieveMessage.type, source: recieveMessage.source, groupName: recieveMessage.groupName, forwardedTo: recieveMessage.forwardedTo, tiggerevent: 0, customerName: recieveMessage.customerName, conversationUid: recieveMessage.conversationUid, isAgentReplied: false, isResolved: false, isFromWidget: recieveMessage.isFromWidget, isPrivate: false, childConversationCount: 0, conversationType: recieveMessage.conversationType, pageId: "", pageName: "", base64Image: "", fileLocalUri: "", isRecordUpdated: false, isNewMessageReceive: false, isDownloading: false, isSeen: false, isUpdateStatus: false, isShowLocalFiles: false, isNotNewChat: false, isWelcomeMessage: false, caption: recieveMessage.caption, files: recieveMessage.files)
//        
//        return conversation
//    }
    
    func scheduledTimerForNewChat(){
        //self.timerDatabase.invalidate()
        //self.timerDatabase = nil
        timerDatabase = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.sendBulkMessagesEvent), userInfo: nil, repeats: true)
    }
    
    @objc func sendBulkMessagesEvent(){
        //timerDatabase.invalidate()
        //DispatchQueue.global(qos: .background).async { [self] in
            print("This is run on the background queue")
            var sendMessageModel : [NewChatMessage] = dbChatObj.getAllUnSendNewChats()
            if sendMessageModel.count > 0{
                sendChatToServer(sendMessageModel: sendMessageModel)
            }else{
//                timerDatabase?.invalidate()
//                timerDatabase = nil
            }
            
            DispatchQueue.main.async {
                print("This is run on the main queue, after the previous code in outer block")
            }
        //}
    }
    
    func sendChatToServer(sendMessageModel : [NewChatMessage]){
        
        self.chatHubConnection?.send(method: "BulkNewChat", sendMessageModel)
        
    }
    
    /*
     public void resendSchedulerStart(){
            handlerResend = new Handler();
            handlerResend.postDelayed(this::sendBulkMessagesEvent,
                    10000);
        }
        public void resendSchedulerStop(){
            if (handlerResend!=null){
                Log.d("checkresendmessage", "resendSchedulerStop:");
                // When you need to cancel all your posted runnables just use:
                handlerResend.removeCallbacksAndMessages(null);
            }
        }

       public void sendBulkMessagesEvent(){
            Log.d("checkresendmessage", "get from db:");
            if (dbchat!=null){
                MainActivityChat.isPause = false;
                if (!dbchat.conversationDetailDao().getAllUnSendChat(common.getConversationUUId(mContext),false).isEmpty()){
                    EventBus.getDefault().post(new SendBulkChatEvent(getNewChatLocally(),"SendBulkChatMessages"));
                }
            }
        }

                                hubConnection.send("BulkNewChat",event.newChatModels);
     */
    
    
//    func convertNewMessageIntoConversationsByUUID(sendMessageModel : NewChatMessage, uploadFilesData:[UploadFilesData]) -> ConversationsByUUID{
        
//        var conversation : ConversationsByUUID = ConversationsByUUID(id: nil, customerId: sendMessageModel.customerId, customerConnectionId: "", customerEmail: sendMessageModel.emailaddress, toUserId: 0, agentId: sendMessageModel.agentId, status: "", tempChatId: sendMessageModel.tempChatId, fromUserId: 0, groupId: sendMessageModel.groupId, conversationId: 0, content: sendMessageModel.message, timestamp: nil, sender: sendMessageModel.sender, receiver: "", type: sendMessageModel.type, source: sendMessageModel.source, groupName: sendMessageModel.groupName, forwardedTo: sendMessageModel.forwardedTo, tiggerevent: 0, customerName: sendMessageModel.customerName, conversationUid: sendMessageModel.conversationUid, isAgentReplied: false, isResolved: sendMessageModel.isResolved, isFromWidget: sendMessageModel.isFromWidget, isPrivate: false, childConversationCount: 0, conversationType: sendMessageModel.conversationType, pageId: "", pageName: "", base64Image: "", fileLocalUri: "", isRecordUpdated: false, isNewMessageReceive: false, isDownloading: false, isSeen: false, isUpdateStatus: false, isShowLocalFiles: false, isNotNewChat: false, isWelcomeMessage: false, caption: sendMessageModel.caption, files: uploadFilesData ?? [UploadFilesData]())
        //return conversation
        
//    }
        /**
         var tempChatId : String?
         var customerId : Int64?
         var name : String?
         var cnic : String?
         var contactNo : String?
         var emailaddress : String?
         var sender : String?
         var agentId : Int64?
         var groupId : Int64?
         var message : String?
         var source : String?
         var conversationUId : String?
         var isResolved : Bool?
         var isWelcomeMessage : Bool?
         var connectionId : String?
         var isFromWidget : Bool?
         var ipAddress : String?
         var notifyMessage : String?
         var channelid : String?
         var type : String?
         var documentOrignalname : String?
         var documentName : String?
         var documentType : String?
         var mobileToken : String?
         var timezone : String?
         var caption : String?
         */
        
        
    
}
extension ChatViewController : SendUpdateSelectedFiles,ImagePickerDelegate{
    func didSelectImages(_ images: [UIImage], withFileData fileData: [FileDataClass], fileUploadArrayList: [UploadFilesDataModel]) {
        self.filesNames = fileData
        self.fileUploadArrayList = fileUploadArrayList
        
        DispatchQueue.main.async {
            let selectedFilePreview = self.storyboard?.instantiateViewController(withIdentifier: "SelectedFilePreview") as! SelectedFilePreview
            selectedFilePreview.modalPresentationStyle = .popover
            selectedFilePreview.filesNames = self.filesNames
            selectedFilePreview.isFromImageSelection = true
            selectedFilePreview.delegate = self
            self.present(selectedFilePreview, animated: true, completion: nil)
        }
        
    }
    
    func setUpdatedSelectedFiles(filesNames: [FileDataClass]) {
        self.filesNames = filesNames
    }
    
    func swapCaptionData(){
        for i in 0 ..< self.filesNames.count{
            if let position = self.fileUploadArrayList.firstIndex(where: {$0.tempChatID == self.filesNames[i].tempChatId ?? ""}){
                self.fileUploadArrayList[position].caption = self.filesNames[i].message
                print(self.fileUploadArrayList[position].caption)
            }
        }
        self.uploadFilesToServer(conversationUUId: self.conversationUuID, multipartList: self.fileUploadArrayList,tempChatIdStr: self.filesNames[0].tempChatId!)
    }
    
    func showFeedBackDialogue(){
        let storyBoard : UIStoryboard = UIStoryboard(name: "MainChat", bundle:nil) /// <- Different storyboard!
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "RateUsVC") as! RateUsVC
        nextViewController.delegate = self
        self.present(nextViewController, animated:true, completion:nil)
    }
    
}
extension ChatViewController : SendFeedbackProtocol{
    func sendFeedbackData(rating: Int, feedback: String, isSkipped: Bool) {
        print("")
    
        self.loadResolvedConversationBySkipOrSubmit(feebackText: feedback, rating: rating, isSkipClicked: isSkipped, conversationStatusModel: self.conversationStatusChangeModel)
        
    }
    
    
}

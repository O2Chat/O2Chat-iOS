

import Alamofire
import SwiftyJSON



typealias ResponseClosure = (_ response:Any?, _ statusCode:Int)->Void
class ApiClient{
    
    //MARK: NEW WORK Chat Module
    
    //MARK:- NEW AWS URL
    let baseURL_sttaus_api = "https://secure.befiler.com/befiler_status/befiler_services"
//    let baseURL = "https://secure.befiler.com/befiler_services_prod"
    let baseURL_sttaus_api_qa = "https://secure.befiler.com/befiler_services_prod_aws"
    
    //MARK:- Old URLS
    let baseURL = "https://qa.arittek.com:8443/befiler_services_dev" //8443 //https
//    let baseURL = "http://192.168.10.135:8080/befiler_services_dev"
//    let baseURL = "https://qa.arittek.com:8443/befiler_services_dev" //8443
//    let baseURL = "http://175.107.240.74:8080/befiler_services_dev"
//    let baseURL = "https://secure.arittek.com/befiler_services_prod"
    let blogUrl = "https://blog.befiler.com/"
    let blogBaseUrl = "https://blog.befiler.com"
    let blogNewBaseUrl = "https://www.befiler.com/wordpress"
    
    
    let deviceID = UIDevice.current.identifierForVendor?.uuidString
    static var sheard = ApiClient()
   
    private let tokenstr = "token"
    private let loginApi = "/auth"
    private let appConfig = "/config"
    private let signUpApi = "/individual/sign-up"
    private let profileApi = "/individual/sign-up/profile"
    private let salaryTaxCalculator = "/salary/tax/calculator"
    private let taxYearsApi = "/tax-form/year/individual"
    private let ntndetailFinderApi = "/fbr/ntn/inquiry"
    private let taxProfileApi = "/tax-profile"
    private let suggestUsApi = "/suggestUs"
    private let promocodeapi = "/payment/cart"
    private let paymentApi = "/payment/cart"
    private let getCartCountApi = "/count"
    private let getnotificationApi = "/notification"
    private let getPaymentHistoryApi = "/payment/history"
    private let socialLogin = "/auth/social"
    private let forgorPassword = "/users/forgot-password"
    private let allRecentBlogs = "/wp-json/wp/v2/posts?_embed&page=1&per_page=100"
    private let mostRecentBlogs = "/wp-json/wp/v2/posts?_embed&per_page=5"
    private let newBlogsApi = "https://www.befiler.com/wordpress/wp-json/wp/v2/posts?_embed&per_page=5&page=1"
    private let categoryFilterBlogs = "/wp-json/wp/v2/posts?_embed"
    private let getAllCategory = "/wp-json/wp/v2/categories?_fields=name,slug,id"
    private let getAllYoutubeVideo = "/youtube"
    private let getAllYoutubeCategory = "/youtube/category"
    private let sendAnalytics = "/user/activity/details"
    private let alertNotificationBanner = "/alert-notification/befiler"
    private let userAgentApi = "/user/agent/tag"
    private let taxFormApi = "/tax-form"
    private let settingApi = "/setting"
    private let personalInformationApi = "/personal"
    
    //MARK: Reset Password
    private let resetPasswordApi = "/users/createPassword"
    
    //MARK:- Update Setting
    private let profileUpdateApi = "/users"
    private let profileUpdateSettingApi = "/setting/user"
    private let passwordUpdateApi = "/users/changePassword"
    
    private let removeCartItem = "/payment/cart/remove"
    private let atl_finder = "/fbr/atl/inquiry"
    private let documentDownloadApi = "/download/document"
    
    //Income Menu Apis
    let incomeTaxApi = "/income-tax"
    let propertyCheckUncheckApi = "/income-tax/property"
    let agricultureApi = "/income-tax/agricultural"
    let pensionApi = "/income-tax/pension"
    let commissionApi = "/income-tax/commission"
    let professionalApi = "/income-tax/professional"
    let businessApi = "/income-tax/business"
    let aopApi = "/income-tax/aop"
    let profitOnSavingApi = "/income-tax/profit-on-savings"
    let dividendApi = "/income-tax/dividend"
    let gainApi = "/income-tax/capital-gain"
    let propertyCapitalGain = "/income-tax/property-capital-gain"
//    let otherIncomeApi = "/income-tax/other-inflow"
    let freelancerApi = "/income-tax/freelancer"
    let calculatedTaxApi = "/salary/tax/calculator"
    let salaryApi = "/salary"
    let getntnRegistration = "/ntn-registration"
    let aopPartnershipRegistration = "/ntn/aop-registration"
    let soleProperietorRegistration = "/ntn/sole-proprietor"
    let addBusinessRegistration = "/ntn/add-business"
    let removeBusinessRegistration = "/ntn/remove-business"
    //MARK:- Bussiness Menu Api
    let traderTaxApi = "/income-tax/trader"
    let dealerTaxApi = "/income-tax/dealer"
    let wholeSalerTaxApi = "/income-tax/wholesaler"
    let manufacturerTaxApi = "/income-tax/manufacturer"
    let importerTaxApi = "/income-tax/importer"
    let exporterTaxApi = "/income-tax/exporter"
    let freelancerTaxApi = "/income-tax/freelancer"
    let professionalTaxApi = "/income-tax/professional"
    let pensionTaxApi = "/income-tax/pension"
    let agriculturalTaxApi = "/income-tax/agricultural"
    let commissionTaxApi = "/income-tax/commission"
    let propertyRentApi = "/income-tax/property-rent"
    let profitSavingBehboodApi = "/income-tax/behbood"
    let profitSavingPensionerBenefitApi = "/income-tax/pensioner-benefit"
    let profitSavingBankDepositApi = "/income-tax/profit-on-bank-deposit"
    let profitSavingGovtSchemeApi = "/income-tax/govt-scheme"
    let investmentApi = "/income-tax/investment"
    let investmentDividendApi = "/income-tax/dividend"
    let investmentCapitalGainApi = "/income-tax/capital-gain"
    let investmentBonusApi = "/income-tax/bonus"
    let otherIncomeFlowApi = "/income-tax/other-inflow"
    //payment APIS
    let apiIPGCardPayment = "/ipg/register"
    //payfast
    let payFastSettingApi = "/payment/cart/setting"
    let payFastCUsomerValidationApi = "/pay-fast/customer/validation"
    let payFastInitializeApi = "/pay-fast/payment/initialize"
    let ipgPaymentApi = "/ipg/register"
    let easyPaisaApi = "/easy-paisa/initiate/transaction"
    let ibftApi = "/ibft/request"
    let foreeInitialize = "/payment/foree/initialize"
    let foreeFinalize = "/payment/foree/finalize"

    //TAXCREDIT
    let taxCreditApi = "/tax-credit"
    let taxDeductedApi = "/tax-deducted"
    let taxDeductedBankTransactionApi = "/tax-deducted/bank-transaction"
    let taxDeductedVehicleApi = "/tax-deducted/vehicle"
    let taxDeductedUtilitiesApi = "/tax-deducted/utilities"
    let taxDeductedOthersApi = "/tax-deducted/other"
    
    //MARK:- WEATLH STATEMENT
    let openingWealthApi = "/opening-wealth"
    let wealthStatementApi = "/wealth-statement"
    let wealthStatementPropertyApi = "/wealth-statement/property"
    let wealthStatementBankAssetApi = "/wealth-statement/bank-account"
    let wealthStatementVehicleApi = "/wealth-statement/vehicle"
    let wealthStatementInsuranceApi = "/wealth-statement/insurance"
    let wealthStatementPossessionsApi = "/wealth-statement/personal-possessions"
    let wealthStatementForeignAssetApi = "/wealth-statement/foreign-assets"
    let wealthStatementCashAssetApi = "/wealth-statement/cash-assets"
    let wealthStatementOtherAssetsApi = "/wealth-statement/other-assets"
    let wealthStatementBankLoanApi = "/wealth-statement/bank-loan"
    let wealthStatementOtherLiabilitiesApi = "/wealth-statement/other-liabilities"
    let expenseModuleApi = "/expense"
    let reconciliationModuleApi = "/reconciliation"
    let termsAndConditionsApi = "/termsAndConditions"
    let taxFormAgreeApi = "/taxform"
    let pieChartDataApi = "/taxform"
    let pieChartApi = "/expense/pie-chart"
    
    let nccplApi = "/nccpl/request"
    
    let removeNtnRegistered = "/ntn-registration/registered"
    
    let logOut = "/log-out"
    
    let taxCalculatorYearApi = "/salary/tax/calculator/years"
    
    //MARK: BUSINESS TAX RETURN
    private let businessTaxYearsApi = "/business/tax-form/year"
    let taxFormBusinessApi = "/business/tax-form/"
    let taxFormBusinessApiGet = "/business/tax-form"
    let businessTermsConditonApi = "/terms-and-condition"
    
    //MARK: Family Relation
    let familyRelations = "/user/profile/setting"
    let addNewAccountApi = "/user/profile"
    
    //MARK: USA SERVICES
    let usaServiceApi = "/usa-services"
    let companyRegistrationApi = "/company-registration"
    let einRegistrationApi = "/ein"
    let bankAccountApi = "/bank-account"
    let completeFormationApi = "/complete-company-formation"
    let registrationITINApi = "/itin-registration"
    let taxFilingStateApi = "/tax-filing-state"
    let taxFilingFederalApi = "/tax-filing-federal"
    let trademarkRegistrationApi = "/trademark-registration"
    
    //MARK: GENERAL SALES TAX
    let generalSaleTaxApi = "/sales/tax/registration"
    let salesTaxRegistrationSettingApi = "/sales/tax/registration/setting"
    
    //MARK: BEFILER SERVICE CHARGES
    let befilerServiceChargesApi = "/befiler-services"
    
    //MARK: ACCOUNT DELETION
    let accountDeletionApi = "/setting/user"
    
    //MARK: REQUEST FOR CALL
    let requestForCallApi = "/suggestUs"
    
    public func getBaseUrl(url : String) -> String{
        let finalUrl = baseURL+url
        
        return finalUrl
    }
     func getIndividualSetting(taxformId: String) -> String {
          return  "/tax-form/\(taxformId)/setting"
     }
    
    func deleteNotificationApi(notificationId: String) -> String {
         return  "/notification/\(notificationId)/delete"
    }
    func readNotificationApi(notificationId: String) -> String {
         return  "/notification/\(notificationId)/read"
    }
    func favouriteUserAccount(id: String) -> String {
         return  "/user/profile/\(id)/favourite"
    }
    func switchUserAccount(id: String) -> String {
         return  "/profile/switch/\(id)"
    }
    
    func deatchProfile(id: Int) -> String {
         return  "/user/profile/\(id)/detach"
    }
    
    func deatchAuthorizer(id: Int) -> String {
         return  "/user/authorizer/\(id)/detach"
    }
    
    //MARK: Load USER PROFILE LIST
    let loadUSerProfile = "/user/profile"
    //MARK: Attach PROFILE VERIFY
    let attachProfileVerify = "/user/profile/attach"
    
    //MARK: Attach PROFILE
    let attachProfile = "/user/profile/code"
    
    //MARK: Attach PROFILE
    let getAllAuthorizerApi = "/user/authorizer/setting"
    
    //MARK: Expense manager home setuo api for get
    let getEmSetup = "/em/setup"
    let syncEMData = "/em/syncData"
    
    
    
    //MARK: Chat Module api & BaseUrl
    let userChatSetting = "/user/chat/setting"
    let baseURLChat = "\(UtilsClassChat.sheard.baseUrlChat)api"
    private let accessTokenByChannelId = "/ChatHub/GetAccessToken"
    private let customerConversationsByEmail = "/Chat/GetCustomerConversationsByEmail" //"/Chat/GetCustomerConversationsByUId"
    private let uploadFilesApi = "/Chat/UploadFiles_IOS"
    private let TopicByEmail = "/Topic/GetTopicsByEmail"
    private let getOrganizationApi = "/Organization/GetOrganization"//"/Organization/GetOrganizations"
    private let validateBusinessHours = "/BusinessHours/IsValidBusinessHour"
    private let uploadFilesNew = "/Chat/UploadFilesNew"
    

 
//    //ntn detail finder
//    // MARK: Constant
//    func getAppConfig(appConfigRequest: AppConfigRequest,onSuccess: @escaping (AppConfigResponse) -> Void, onFailure: @escaping(String?) -> Void) {
//        let headers: HTTPHeaders = [
////            "Authorization": UserDefaults.standard.string(forKey: tokenstr) ?? "",
//            "Content-Type": "application/json; charset=UTF-8"
//        ]
////      SVProgressHUD.show()
//        guard let url = URL(string: baseURL+appConfig) else {
//            onFailure("Please check your internet connection")
//            SVProgressHUD.dismiss()
//            return
//        }
//        //print(url)
//    
//        let encoder = JSONEncoder()
//        do {
//            let jsonData = try encoder.encode(appConfigRequest)
//            let jsonString = String(data: jsonData, encoding: .utf8)!
//
//            print(jsonString)
//            AF.request(url, method: .post, parameters: jsonToDictionary(from: jsonString),encoding: JSONEncoding.default,headers: headers).responseJSON { response in
//                switch (response.result) {
//                case .success:
//                    guard let data = response.data else {return}
//                    do {
//                        let appConfigResponseData = try JSONDecoder().decode(AppConfigResponse.self, from: data)
//                        //print(appConfigResponseData)
//                        if(response.response?.statusCode == 401){
//                            onFailure("\(String(describing: response.response?.statusCode))")
//                        }else{
//                            onSuccess(appConfigResponseData)
//                        }
//                    } catch {
//                        onFailure(response.error.debugDescription)
//                        print("error")
//                    }
//                case .failure:
//                    onFailure("\(String(describing: response.response?.statusCode))")
//                    print(Error.self)
//                }
//            }
//            
//        } catch _ as NSError {
//
//        }
//    }

   
    
   
    
    
    func jsonToDictionary(from text: String) -> [String: Any]? {
        guard let data = text.data(using: .utf8) else { return nil }
        let anyResult = try? JSONSerialization.jsonObject(with: data, options: [])
        return anyResult as? [String: Any]
    }
    
    func jsonToDictionaryArray(from text: String) -> [[String: Any]]? {
        guard let data = text.data(using: .utf8) else { return nil }
        let anyResult = try? JSONSerialization.jsonObject(with: data, options: [[]])
        return anyResult as? [[String: Any]]
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                
                 let array = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] ?? []
                 var dictionary = [String:Any]()
                 //Loop through array and set object in dictionary
                 for (index,item) in array.enumerated() {
                     let uniqueID = "\(index)" //Or generate uniqued Int id
                     dictionary[uniqueID] = item
                 }
                return dictionary
            }
            catch {}
        }
        return nil
    }
    
   
   
    
    //MARK: CHAT MODULE
    func sendChatSetting(userChatSettingModel: UserChatSettingModel,onSuccess: @escaping (WebResponnse) -> Void, onFailure: @escaping(String?) -> Void) {
        let headers: HTTPHeaders = [
            "Authorization": UserDefaults.standard.string(forKey: tokenstr) ?? "",
            "Content-Type": "application/json; charset=UTF-8"
        ]
        //
        guard let url = URL(string: baseURL+userChatSetting) else {
            onFailure("Please check your internet connection")
            
            return
        }
        //print(url)
        
        let encoder = JSONEncoder()
        do {
            let jsonData = try encoder.encode(userChatSettingModel)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            
            print(jsonString)
            AF.request(url, method: .post, parameters: jsonToDictionary(from: jsonString),encoding: JSONEncoding.default,headers: headers).responseJSON { response in
                switch (response.result) {
                case .success:
                    guard let data = response.data else {return}
                    do {
                        let appConfigResponseData = try JSONDecoder().decode(WebResponnse.self, from: data)
                        //print(appConfigResponseData)
                        if(response.response?.statusCode == 401){
                            onFailure("\(String(describing: response.response?.statusCode))")
                        }else{
                            onSuccess(appConfigResponseData)
                        }
                    } catch {
                        onFailure(response.error.debugDescription)
                        print("error")
                    }
                case .failure:
                    onFailure("\(String(describing: response.response?.statusCode))")
                    print(Error.self)
                }
            }
            
        } catch _ as NSError {
            
        }
    }
    
    // MARK: Constant
    func getUserChatSetting(onSuccess: @escaping (UserChatSettingWebresponse) -> Void, onFailure: @escaping(String?) -> Void) {
        let headers: HTTPHeaders = [
            "Authorization": UserDefaults.standard.string(forKey: tokenstr) ?? "",
            "Content-Type": "application/json; charset=UTF-8"
        ]
        //
        guard let url = URL(string: baseURL+userChatSetting) else {
            onFailure("Please check your internet connection")
            
            return
        }
        //print(url)
        do {
            AF.request(url, method: .get,encoding: JSONEncoding.default,headers: headers).responseJSON { response in
                switch (response.result) {
                case .success:
                    guard let data = response.data else {return}
                    do {
                        let appConfigResponseData = try JSONDecoder().decode(UserChatSettingWebresponse.self, from: data)
                        if(response.response?.statusCode == 401){
                            onFailure("\(String(describing: response.response?.statusCode))")
                        }else{
                            onSuccess(appConfigResponseData)
                        }
                    } catch {
                        onFailure(response.error.debugDescription)
                        print("error")
                    }
                case .failure:
                    onFailure("\(String(describing: response.response?.statusCode))")
                    print(Error.self)
                }
            }
            
        } catch _ as NSError {
            
        }
    }
    
    // MARK: Constant
    func getAccessTokenByChannelId(channelId: String, onSuccess: @escaping (WebResponnse) -> Void, onFailure: @escaping(String?) -> Void) {
        let headers: HTTPHeaders = [
            //            "Authorization": UserDefaults.standard.string(forKey: tokenstr) ?? "",
            "Content-Type": "application/json; charset=utf-8"
        ]
        guard let url = URL(string: baseURLChat+accessTokenByChannelId) else {
            onFailure("Please check your internet connection")
            return
        }
        print(url)
        let paramet: Parameters = ["ChannelId":channelId]
        AF.request(url, method: .get, parameters: paramet, encoding: URLEncoding(destination: .queryString)).responseString { response in
            switch response.result {
            case .success(let json):
                print(json)
                let data = Data(json.utf8)
                do {
                    let webResponnse = try JSONDecoder().decode(WebResponnse.self, from: data)
                    if(!webResponnse.isSuccess!){
                        onFailure("\(String(describing: response.response?.statusCode))")
                    }else{
                        onSuccess(webResponnse)
                    }
                    
                } catch {
                    onFailure(response.error.debugDescription)
                    print(error)
                }
                
            case .failure(let error):
                onFailure("\(String(describing: response.response?.statusCode))")
                print(Error.self)
            }
        }
        
    }
    
    // MARK: Constant
    func getCustomerConversationsByEmail(pageNumber: Int,pageSize: Int,conversationUId: String,customerId: Int64, email : String, onSuccess: @escaping (WebResponseConversationByUUID) -> Void, onFailure: @escaping(String?) -> Void) {
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(CustomUserDefaultChat.sheard.getChatToken())" ,
            "Content-Type": "application/json; charset=utf-8"
        ]
        guard let url = URL(string: baseURLChat+customerConversationsByEmail) else {
            onFailure("Please check your internet connection")
            return
        }
        print(url)
        
        let paramet: Parameters = ["pageNumber":pageNumber,"pageSize":pageSize,"customerId":customerId, "conversationUId":conversationUId, "Email" : email] //"conversationUId":conversationUId,
        AF.request(url, method: .get, parameters: paramet, encoding: URLEncoding(destination: .queryString),headers: headers).responseString { response in
            switch response.result {
            case .success(let json):
                print(json)
                let data = Data(json.utf8)
                do {
                    let webResponnse = try JSONDecoder().decode(WebResponseConversationByUUID.self, from: data)
                    if(!webResponnse.isSuccess!){
                        onFailure("\(String(describing: response.response?.statusCode))")
                    }else{
                        onSuccess(webResponnse)
                    }
                    
                } catch {
                    onFailure(response.error.debugDescription)
                    print(error)
                }
                
            case .failure(let error):
                onFailure("\(String(describing: response.response?.statusCode))")
                print(Error.self)
            }
        }
        
    }
    
    
    // MARK: Constant
    func getTopicByEmail(email: String,onSuccess: @escaping (WebResponseForTopics) -> Void, onFailure: @escaping(String?) -> Void) {
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(CustomUserDefaultChat.sheard.getChatToken())" ,
            "Content-Type": "application/json; charset=utf-8"
        ]
        guard let url = URL(string: baseURLChat+TopicByEmail) else {
            onFailure("Please check your internet connection")
            return
        }
        print(url)
        let paramet: Parameters = ["Email":email]
        AF.request(url, method: .get, parameters: paramet, encoding: URLEncoding(destination: .queryString),headers: headers).responseString { response in
            switch response.result {
            case .success(let json):
                print(json)
                let data = Data(json.utf8)
                do {
                    let webResponnse = try JSONDecoder().decode(WebResponseForTopics.self, from: data)
                    if(!(webResponnse.isSuccess ?? false)){
                        onFailure("\(String(describing: response.response?.statusCode))")
                    }else{
                        onSuccess(webResponnse)
                    }
                    
                } catch {
                    onFailure(response.error.debugDescription)
                    print(error)
                }
                
            case .failure(let error):
                onFailure("\(String(describing: response.response?.statusCode))")
                print(Error.self)
            }
        }
        
    }
    
    
    func getOrganizationApi(onSuccess: @escaping (WebResponseForOrganization) -> Void, onFailure: @escaping(String?) -> Void) {
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(CustomUserDefaultChat.sheard.getChatToken())" ,
            "Content-Type": "application/json; charset=utf-8"
        ]
        guard let url = URL(string: baseURLChat+getOrganizationApi) else {
            onFailure("Please check your internet connection")
            return
        }
        AF.request(url, method: .get, encoding: URLEncoding(destination: .queryString),headers: headers).responseString { response in
            switch response.result {
            case .success(let json):
                print(json)
                let data = Data(json.utf8)
                do {
                    let webResponnse = try JSONDecoder().decode(WebResponseForOrganization.self, from: data)
                    if(!webResponnse.isSuccess!){
                        onFailure("\(String(describing: response.response?.statusCode))")
                    }else{
                        onSuccess(webResponnse)
                    }
                    
                } catch {
                    onFailure(response.error.debugDescription)
                    print(error)
                }
                
            case .failure(let error):
                onFailure("\(String(describing: response.response?.statusCode))")
                print(Error.self)
            }
        }
        
    }
    
    
    func getIsValidateBusinessHourApi(utcHours: String,dayIndex : Int,onSuccess: @escaping (WebResponseBusinessHours) -> Void, onFailure: @escaping(String?) -> Void) {
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(CustomUserDefaultChat.sheard.getChatToken())" ,
            "Content-Type": "application/json; charset=utf-8"
        ]
        guard let url = URL(string: baseURLChat+validateBusinessHours) else {
            onFailure("Please check your internet connection")
            return
        }
        let paramet: Parameters = ["utcTimeDate":utcHours,"dayIndex":dayIndex]
        AF.request(url, method: .get,parameters: paramet, encoding: URLEncoding(destination: .queryString),headers: headers).responseString { response in
            switch response.result {
            case .success(let json):
                print(json)
                let data = Data(json.utf8)
                do {
                    let webResponnse = try JSONDecoder().decode(WebResponseBusinessHours.self, from: data)
                    if(webResponnse.isSuccess == false){
                        onFailure("\(String(describing: response.response?.statusCode))")
                    }else{
                        onSuccess(webResponnse)
                    }
                    
                } catch {
                    onFailure(response.error.debugDescription)
                    print(error)
                }
                
            case .failure(let error):
                onFailure("\(String(describing: response.response?.statusCode))")
                print(Error.self)
            }
        }
        
    }
    
    // MARK: Constant
    func uplaodFiles(conversationUdId: String ,multipartList : [UploadFilesDataModel], onSuccess: @escaping (WebResonseUploadFile) -> Void, onFailure: @escaping(String?) -> Void) {
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(CustomUserDefaultChat.sheard.getChatToken())" ,
            "conversationUId": conversationUdId ,
            "Content-type": "multipart/form-data"
        ]
        guard let url = URL(string: baseURLChat+uploadFilesApi) else {
            onFailure("Please check your internet connection")
            return
        }
        AF.upload(multipartFormData: { files in
            for imageData in multipartList {
                //files.append(imageData.data!, withName:imageData.withName!, fileName: imageData.fileName!, mimeType: imageData.mimeType!)
            }
        }, to: url,method: .post,headers: headers)
        .responseString { response in
            switch response.result {
            case .success(let json):
                print(json)
                let data = Data(json.utf8)
                do {
                    let webResponnse = try JSONDecoder().decode(WebResonseUploadFile.self, from: data)
                    if(!webResponnse.isSuccess!){
                        onFailure("\(String(describing: response.response?.statusCode))")
                    }else{
                        onSuccess(webResponnse)
                    }
                    
                } catch {
                    onFailure(response.error.debugDescription)
                    print(error)
                }
                
            case .failure(let error):
                onFailure("\(String(describing: response.response?.statusCode))")
                print(Error.self)
            }
        }
        
    }
    
    //MARK: CHAT MODULE
    func uploadFilesNew(filesNew : [UploadFilesDataModel] ,onSuccess: @escaping (MultiFilesResponseModel) -> Void, onFailure: @escaping(String?) -> Void) {
//        let headers: HTTPHeaders = [
//            "Authorization": "Bearer \(CustomUserDefaultChat.sheard.getChatToken())" ,
//            "Content-Type": "application/json; charset=utf-8"
//        ]
        
        guard let url = URL(string: baseURLChat+uploadFilesNew) else {
            onFailure("Please check your internet connection")
            
            return
        }
        
        
        // Convert the array to Data
        do {
            let jsonData = try JSONEncoder().encode(filesNew)

            // Your Alamofire request
            
            
            let headers: HTTPHeaders = [
                "Authorization": "Bearer \(CustomUserDefaultChat.sheard.getChatToken())" ,
                "Content-Type": "application/json; charset=utf-8"
            ]

            AF.upload(jsonData, to: url, method: .post, headers: headers)
                    .responseJSON { response in
                        switch response.result {
                        case .success(let value):
                            print("Response: \(value)")
                            
                            guard let data = response.data else {return}
                            do {
                                let appConfigResponseData = try JSONDecoder().decode(MultiFilesResponseModel.self, from: data)
                                let filesResult = appConfigResponseData.result
                                //print(appConfigResponseData)
                                if(response.response?.statusCode == 401){
                                    onFailure("\(String(describing: response.response?.statusCode))")
                                }else{
                                    onSuccess(appConfigResponseData)
                                }
                            } catch {
                                onFailure(response.error.debugDescription)
                                print("error")
                            }
                        case .failure:
                            onFailure("\(String(describing: response.response?.statusCode))")
                            print(Error.self)
                            
                        }
                    }
            
        } catch {
            print("Error encoding JSON: \(error)")
        }
        
        
        // Convert the array to Data
        
//        let encoder = JSONEncoder()
//        do {
//            let jsonData = try encoder.encode(filesNew)
//            let jsonString = String(data: jsonData, encoding: .utf8)!
//            
//            
//            let parameter : [String: Any]  = ["files":filesNew]
//        
//            
//
//            
//            AF.request(url, method: .post, parameters: parameter , encoding: JSONEncoding.default, headers: headers).responseJSON { response in
//                switch (response.result) {
//                case .success:
//                    guard let data = response.data else {return}
//                    do {
//                        let appConfigResponseData = try JSONDecoder().decode(UploadFilesDataNew.self, from: data)
//                        //print(appConfigResponseData)
//                        if(response.response?.statusCode == 401){
//                            onFailure("\(String(describing: response.response?.statusCode))")
//                        }else{
//                            onSuccess(appConfigResponseData)
//                        }
//                    } catch {
//                        onFailure(response.error.debugDescription)
//                        print("error")
//                    }
//                case .failure:
//                    onFailure("\(String(describing: response.response?.statusCode))")
//                    print(Error.self)
//                }
//            }
//            
//        } catch _ as NSError {
//            
//        }
    }
    
}

struct CustomJSONEncoding: ParameterEncoder {
    func encode<Parameters>(_ parameters: Parameters?, into request: URLRequest) throws -> URLRequest where Parameters : Encodable {
        var request = try request.asURLRequest()
        
        guard let parameters = parameters else { return request }

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            request.httpBody = jsonData
        } catch {
            throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
        }

        if request.value(forHTTPHeaderField: "Content-Type") == nil {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }

        return request
    }
    
}
extension MultiFilesResponseModel {
    static func fromJSON(_ jsonString: String) -> MultiFilesResponseModel? {
        guard let jsonData = jsonString.data(using: .utf8) else {
            return nil
        }

        do {
            let decoder = JSONDecoder()
            let response = try decoder.decode(MultiFilesResponseModel.self, from: jsonData)
            return response
        } catch {
            print("Error decoding JSON: \(error)")
            return nil
        }
    }
}

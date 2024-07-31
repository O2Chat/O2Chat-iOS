//
//  CustomUserDefault.swift
//  ConnectMateCustomer
//
//  Created by macbook on 15/05/2023.
//

import Foundation


import UIKit
class CustomUserDefaultChat {
    
    
    static var sheard = CustomUserDefaultChat()
    var dbChatObj = Singleton.sharedInstance.myLocalChatDB
    func getCustomerID() -> Int64{
        UserDefaults.standard.value(forKey: "customerID") as? Int64 ?? 0
    }
    
    //MARK:- SET HOME BANNER FOR FIRST TIME
    func saveCustomerId(customerId: Int64?) {
        UserDefaults.standard.set(customerId, forKey: "customerID")
        UserDefaults.standard.synchronize()
    }
    
    func getsaveConnectionId() -> String{
        UserDefaults.standard.value(forKey: "saveConnectionId") as? String ?? ""
    }
    
    func getCustomerEmail() -> String{
        UserDefaults.standard.value(forKey: "CustomerEmailPref") as? String ?? ""
    }
    
    func getCustomerName() -> String{
        UserDefaults.standard.value(forKey: "CustomerNamePref") as? String ?? ""
    }
    
    
    func getCustomerPhoneNumber() -> String{
        UserDefaults.standard.value(forKey: "CustomerPhoneNumberPref") as? String ?? ""
    }
    func getCustomerCnic() -> String{
        UserDefaults.standard.value(forKey: "CustomerCnicPref") as? String ?? ""
    }
    
    func saveConnectionId(connectionId: String?) {
        UserDefaults.standard.set(connectionId, forKey: "saveConnectionId")
        UserDefaults.standard.synchronize()
    }
    
    func saveToken(token: String?) {
        UserDefaults.standard.set(token, forKey: "token")
        UserDefaults.standard.synchronize()
    }
    func saveChatToken(token: String?) {
        UserDefaults.standard.set(token, forKey: "tokenchat")
        UserDefaults.standard.synchronize()
    }
    
    func getToken() -> String{
        UserDefaults.standard.value(forKey: "token") as? String ?? ""
    }
    
    func getChatToken() -> String{
        UserDefaults.standard.value(forKey: "tokenchat") as? String ?? ""
    }
    
   
    func getConversationUuID() -> String{
        UserDefaults.standard.value(forKey: "saveConversationUuID") as? String ?? ""
    }
//    "5803d40c-a013-45cc-bd3b-0e547d819441"
    
    func saveConversationUuID(conversationUuID: String?) {
        UserDefaults.standard.set(conversationUuID, forKey: "saveConversationUuID")
        UserDefaults.standard.synchronize()
    }
    
    func getChannelId() -> String{
        UserDefaults.standard.value(forKey: "saveChannelID") as? String ?? ""
    }
//    "5803d40c-a013-45cc-bd3b-0e547d819441"
    
    func saveChannelId(channelId : String?) {
        UserDefaults.standard.set(channelId, forKey: "saveChannelID")
        UserDefaults.standard.synchronize()
    }
    
    func saveCustomerEmail(CustomerEmail: String?) {
        UserDefaults.standard.set(CustomerEmail, forKey: "CustomerEmailPref")
        UserDefaults.standard.synchronize()
    }
    
    func saveCustomerCnic(customerCnic: String?) {
        UserDefaults.standard.set(customerCnic, forKey: "CustomerCnicPref")
        UserDefaults.standard.synchronize()
    }
    func saveCustomerPhoneNumber(customerPhoneNumber: String?) {
        UserDefaults.standard.set(customerPhoneNumber, forKey: "CustomerPhoneNumberPref")
        UserDefaults.standard.synchronize()
    }
    func saveCustomerName(customerName: String?) {
        UserDefaults.standard.set(customerName, forKey: "CustomerNamePref")
        UserDefaults.standard.synchronize()
    }
    
    func saveDisplayName(displayName: String?) {
        UserDefaults.standard.set(displayName, forKey: "OrgnizationDisplayName")
        UserDefaults.standard.synchronize()
    }
    
    func getFcmToken() -> String {
        UserDefaults.standard.string(forKey:"fcmToken") ?? ""
    }
    
    func setFcmToken(token: String){
        UserDefaults.standard.set(token, forKey: "fcmToken")
        UserDefaults.standard.synchronize()
    }
    
    func getDisplayName() -> String{
        UserDefaults.standard.value(forKey: "OrgnizationDisplayName") as? String ?? ""
    }
    func saveOrganizationName(organizationName: String?) {
        UserDefaults.standard.set(organizationName, forKey: "organizationName")
        UserDefaults.standard.synchronize()
    }
    
    
    func getOrganizationName() -> String{
        UserDefaults.standard.value(forKey: "organizationName") as? String ?? ""
    }
    
    func saveCustomerUidFromServer(id : String){
        UserDefaults.standard.set(id, forKey: "CustomerUidFromServer")
    }
   
    func getCustomerUidFromServer() -> String{
        UserDefaults.standard.value(forKey: "CustomerUidFromServer") as? String ?? ""
    }
    
    func saveConversationCountFromServer(count : String){
        UserDefaults.standard.set(count, forKey: "ConversationCountFromServer")
    }
    
    func getConversationCountFromServer() -> String{
        UserDefaults.standard.value(forKey: "ConversationCountFromServer") as? String ?? "0"
    }
    
    func saveIsResolved(isResolved: Bool){
          UserDefaults.standard.set(isResolved, forKey: "saveIsResolved")
          UserDefaults.standard.synchronize()
    }
    
    func getIsResolved() -> Bool {
        UserDefaults.standard.bool(forKey:"saveIsResolved") ?? false
    }
    
    //MARK:- SAVE NOTIFICATION
    func setChatNotificationBool(value : Bool){
        UserDefaults.standard.setValue(value, forKey: "NotificationChatBoolean")
    }
    
    func getChatNotificationBool() -> Bool{
        UserDefaults.standard.value(forKey: "NotificationChatBoolean") as? Bool ?? false
    }
    
    //MARK:- SAVE LAST MESSAGE ID
    func setLastMessageId(id : Int64){
        UserDefaults.standard.setValue(id, forKey: "LastMessageId")
    }
    
    func getLastMessageId() -> Int64{
        UserDefaults.standard.value(forKey: "LastMessageId") as? Int64 ?? 0
    }
    
    //MARK:- SAVE FirstTime Welcome Message
    func checkFirstTimeWelcomeMessageBool(value : Bool){
        UserDefaults.standard.setValue(value, forKey: "FirstTimeWelcomeMessage")
    }
    
    func getFirstTimeWelcomeMessageBool() -> Bool{
        UserDefaults.standard.value(forKey: "FirstTimeWelcomeMessage") as? Bool ?? false
    }
    
    func saveWelcomeMsgBusinessHourFirstTime(){
        UserDefaults.standard.setValue(true, forKey: "WelcomeMsgBusinessHour")
    }
    
    func getWelcomeMsgBusinessHourFirstTime() -> Bool{
        UserDefaults.standard.value(forKey: "WelcomeMsgBusinessHour") as? Bool ?? false
    }
    
    //MARK:- SAVE NOTIFICATION
    func setNotificationBool(value : Bool){
        UserDefaults.standard.setValue(value, forKey: "NotificationBoolean")
    }
    
    func getNotificationBool() -> Bool{
        UserDefaults.standard.value(forKey: "NotificationBoolean") as? Bool ?? false
    }
    
    func setNotificationData(notificationData : NotificationData){
        UserDefaults.standard.set(try? PropertyListEncoder().encode(notificationData), forKey:"NotificationData")
    }
    
    func getNotificationData() -> NotificationData?{
        var dataNotify : NotificationData?
        
        if let data = UserDefaults.standard.value(forKey:"NotificationData") as? Data {
            dataNotify = try! PropertyListDecoder().decode(NotificationData.self, from: data)

        }
        return dataNotify //?? BusinessResponse()

    }
    
    func generateUuID()-> String {
        let identifier = UUID()
        return identifier.uuidString
    }
    
    func emptyUserDefaultsChat() {
        //empty Chat logout defualts
        UserDefaults.standard.removeObject(forKey: "customerID")
        UserDefaults.standard.removeObject(forKey: "saveConnectionId")
        UserDefaults.standard.removeObject(forKey: "CustomerEmailPref")
        UserDefaults.standard.removeObject(forKey: "CustomerPhoneNumberPref")
        UserDefaults.standard.removeObject(forKey: "CustomerNamePref")
        UserDefaults.standard.removeObject(forKey: "CustomerCnicPref")
        UserDefaults.standard.removeObject(forKey: "saveConnectionId")
        UserDefaults.standard.removeObject(forKey: "token")
        UserDefaults.standard.removeObject(forKey: "tokenchat")
        UserDefaults.standard.removeObject(forKey: "OrgnizationDisplayName")
        UserDefaults.standard.removeObject(forKey: "organizationName")
        UserDefaults.standard.removeObject(forKey: "CustomerUidFromServer")
        UserDefaults.standard.removeObject(forKey: "ConversationCountFromServer")
        UserDefaults.standard.removeObject(forKey: "NotificationChatBoolean")
        UserDefaults.standard.removeObject(forKey: "LastMessageId")
        UserDefaults.standard.removeObject(forKey: "FirstTimeWelcomeMessage")
        UserDefaults.standard.removeObject(forKey: "saveConversationUuID")
        UserDefaults.standard.removeObject(forKey: "WelcomeMsgBusinessHour") //saveChannelID
        UserDefaults.standard.removeObject(forKey: "saveChannelID") //saveChannelID
        UserDefaults.standard.removeObject(forKey: "NotificationBoolean") //saveChannelID
        UserDefaults.standard.removeObject(forKey: "NotificationData") //saveChannelID
        
    }
    
    func deleteChatDataBase(){
        var databasePath = String()
        let filemgr = FileManager.default
        let dirPaths =
        NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                            .userDomainMask, true).first as String?

        databasePath = (dirPaths! as NSString).appendingPathComponent("O2Chat.db")
        print(databasePath)

        if filemgr.fileExists(atPath: databasePath as String) {
            do {
                try filemgr.removeItem(atPath: databasePath as String)
            } catch  {
                print("no database to delete")
            }

        }

        dbChatObj.CreateChatDatabase()
        
    }
    
    func logOutChatUser()
    {
        deleteChatDataBase()
        emptyUserDefaultsChat()
    }
    
}

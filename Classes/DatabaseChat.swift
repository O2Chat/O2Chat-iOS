//
//  DatabaseChat.swift
//  Befiler
//
//  Created by Sanjay Kumar on 04/08/2023.
//  Copyright © 2023 Haseeb. All rights reserved.
//

import Foundation
import Foundation
import FMDB
import UIKit
//import SQLCipher

class DatabaseChat
{
    
    var databasePath = String()
    let passphrase = "Arittek1"
    //MARK:- CREATE DATABASE
    func CreateChatDatabase()
    {
        let filemgr = FileManager.default
        let dirPaths =
        NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                            .userDomainMask, true).first as String?
        
        databasePath = (dirPaths! as NSString).appendingPathComponent("O2Chat.db")
        print(databasePath)
        
        
        if !filemgr.fileExists(atPath: databasePath as String) {
            
            let contactDB = FMDatabase(path: databasePath as String)
            
            if contactDB == nil {
                print("Error: \(contactDB.lastErrorMessage())")
            }
            contactDB.setKey(passphrase)
            if contactDB.open() {
                
                if !contactDB.executeStatements(QueriesChat.string.ChatModel) {
                    print("Error: \(contactDB.lastErrorMessage())")
                }
                
                if !contactDB.executeStatements(QueriesChat.string.ChatFilesModel) {
                    print("Error: \(contactDB.lastErrorMessage())")
                }
                
                //MARK: - Temp message table
                if !contactDB.executeStatements(QueriesChat.string.UnSendNewChatMessage) {
                    print("Error: \(contactDB.lastErrorMessage())")
                }
                
                //UIApplication.shared.keyWindow?.makeToast("Database Created Successfully!")
                print("Success")
                contactDB.close()
            } else {
                print("Error: \(contactDB.lastErrorMessage())")
                //UIApplication.shared.keyWindow?.makeToast("Error: \(contactDB.lastErrorMessage())")
            }
        }
    }
    
    func saveChatData(pageNumber : Int, conversation : ConversationsByUUID)
    {
        let contactDB = FMDatabase(path: databasePath as String)
        
        if contactDB.open()
        {
            do
            {
                try contactDB.executeUpdate(QueriesChat.string.SaveChatData, values: [conversation.id, conversation.customerId, conversation.customerConnectionId, conversation.customerEmail, conversation.toUserId, conversation.agentId, conversation.status, conversation.tempChatId, conversation.fromUserId, conversation.groupId, conversation.conversationId, conversation.content, conversation.timestamp, conversation.sender, conversation.receiver, conversation.type, conversation.source, conversation.groupName, conversation.forwardedTo, conversation.tiggerevent, conversation.customerName, conversation.conversationUid, conversation.isAgentReplied, conversation.isResolved, conversation.isFromWidget, conversation.isPrivate, conversation.childConversationCount, conversation.conversationType, conversation.pageId, conversation.pageName, conversation.base64Image, conversation.fileLocalUri, conversation.isRecordUpdated, conversation.isNewMessageReceive, conversation.isDownloading, conversation.isSeen, conversation.isUpdateStatus, conversation.isShowLocalFiles, conversation.isNotNewChat, conversation.isWelcomeMessage, conversation.caption,conversation.isFailed, conversation.isReceived, conversation.rating, conversation.feedback, conversation.isFeedback , conversation.createdOn])
                //UIApplication.shared.keyWindow?.makeToast("Login Data Saved Successfully!")
            }catch
            {
                print(error)
            }
            
        }
        
    }
    
    func saveChatIntoData(isUpdateById : Bool ,pageNumber : Int, conversation : ConversationsByUUID)
    {
        var conversationModel : ConversationsByUUID = ConversationsByUUID()
        if ((conversationModel.timestamp?.isEmpty) == nil) || conversationModel.timestamp == nil{
            conversationModel = conversation
            conversationModel.createdOn = UtilsClassChat.sheard.convertTimeStampToDate(conversation.timestamp ?? "")
        }else{
            conversationModel = conversation
            conversationModel.createdOn = UtilsClassChat.sheard.convertTimeStampToDate(conversation.timestamp ?? "")
        }
        
        let contactDB = FMDatabase(path: databasePath as String)
        
        if contactDB.open(){
            
            do
            {
                
                if isUpdateById{
                    
                    if self.chechIfMessageExistWithTempId(id: conversationModel.tempChatId ?? "0"){
                        if conversationModel.id != 0{
                            CustomUserDefaultChat.sheard.setLastMessageId(id: conversationModel.id ?? 0)
                        }
                        
                        self.updateConversationByTempId(pageNumber: pageNumber, conversation: conversationModel ?? ConversationsByUUID())
                        if conversationModel.type == "file"{
                            if self.chechIfMessageFilesExistWithTempId(id: conversationModel.tempChatId ?? "0"){
                                for j in 0 ..< (conversationModel.files?.count ?? 0){
                                    self.updateChatFilesData(pageNumber: pageNumber, conversationFiles: conversationModel.files?[j] ?? FileDataModel(), fid: conversationModel.id ?? 0, customerId: conversationModel.customerId ?? 0, tempChatId: conversationModel.tempChatId ?? "" ?? "0", conversationId: conversationModel.conversationUid ?? "0")
                                }
                            }
                        }
                    }else if !self.chechIfMessageExist(id: conversationModel.id ?? 0){
                        if conversationModel.id != 0{
                            CustomUserDefaultChat.sheard.setLastMessageId(id: conversationModel.id ?? 0)
                        }
                        self.saveChatData(pageNumber: pageNumber, conversation: conversationModel ?? ConversationsByUUID())
                        if conversationModel.type == "file"{
                            if !self.chechIfMessageFilesExist(id: conversationModel.id ?? 0){
                                for j in 0 ..< (conversationModel.files?.count ?? 0){
                                    self.saveChatFilesData(pageNumber: pageNumber, conversationFiles: conversationModel.files?[j] ?? FileDataModel(), fid: conversationModel.id ?? 0, customerId: conversationModel.customerId ?? 0, tempChatId: conversationModel.tempChatId ?? "", conversationId: conversationModel.conversationUid ?? "0")
                                }
                            }
                        }
                    }else{
                        if conversationModel.id != 0{
                            CustomUserDefaultChat.sheard.setLastMessageId(id: conversationModel.id ?? 0)
                        }
                        
                        self.updateConversationByTempId(pageNumber: pageNumber, conversation: conversationModel ?? ConversationsByUUID())
                        if conversationModel.type == "file"{
                            
                            if self.chechIfMessageFilesExistWithTempId(id: conversationModel.tempChatId ?? "0"){
                                for j in 0 ..< (conversationModel.files?.count ?? 0){
                                    self.updateChatFilesData(pageNumber: pageNumber, conversationFiles: conversationModel.files?[j] ?? FileDataModel(), fid: conversationModel.id ?? 0, customerId: conversationModel.customerId ?? 0, tempChatId: conversationModel.tempChatId ?? "" ?? "0", conversationId: conversationModel.conversationUid ?? "0")
                                }
                            }
                        }
                    }
                }else{
                    
                    if self.chechIfMessageExistWithTempId(id: conversationModel.tempChatId ?? "0"){
                        if conversationModel.id != 0{
                            CustomUserDefaultChat.sheard.setLastMessageId(id: conversationModel.id ?? 0)
                        }
                        
                        self.updateConversationByTempId(pageNumber: pageNumber, conversation: conversationModel ?? ConversationsByUUID())
                        if conversationModel.type == "file"{
                            
                            if self.chechIfMessageFilesExistWithTempId(id: conversationModel.tempChatId ?? "0"){
                                for j in 0 ..< (conversationModel.files?.count ?? 0){
                                    self.updateChatFilesData(pageNumber: pageNumber, conversationFiles: conversationModel.files?[j] ?? FileDataModel(), fid: conversationModel.id ?? 0, customerId: conversationModel.customerId ?? 0, tempChatId: conversationModel.tempChatId ?? "" ?? "0", conversationId: conversationModel.conversationUid ?? "0")
                                }
                            }
                        }
                        
                        
                    }else{
                        if !self.chechIfMessageExist(id: conversationModel.id ?? 0){
                            if conversationModel.id != 0{
                                CustomUserDefaultChat.sheard.setLastMessageId(id: conversationModel.id ?? 0)
                            }
                            self.saveChatData(pageNumber: pageNumber, conversation: conversationModel ?? ConversationsByUUID())
                            if conversationModel.type == "file"{
                                if !self.chechIfMessageFilesExist(id: conversationModel.id ?? 0){
                                    for j in 0 ..< (conversationModel.files?.count ?? 0){
                                        self.saveChatFilesData(pageNumber: pageNumber, conversationFiles: conversationModel.files?[j] ?? FileDataModel(), fid: conversationModel.id ?? 0, customerId: conversationModel.customerId ?? 0, tempChatId: conversationModel.tempChatId ?? "", conversationId: conversationModel.conversationUid ?? "0")
                                    }
                                }
                            }
                        }
                        else if !self.chechIfMessageExistWithTempId(id: conversationModel.tempChatId ?? "0"){
                            if conversationModel.id != 0{
                                CustomUserDefaultChat.sheard.setLastMessageId(id: conversationModel.id ?? 0)
                            }
                            self.saveChatData(pageNumber: pageNumber, conversation: conversationModel ?? ConversationsByUUID())
                            if conversationModel.type == "file"{
                                if !self.chechIfMessageFilesExistWithTempId(id: conversationModel.tempChatId ?? "0"){
                                    for j in 0 ..< (conversationModel.files?.count ?? 0){
                                        self.saveChatFilesData(pageNumber: pageNumber, conversationFiles: conversationModel.files?[j] ?? FileDataModel(), fid: conversationModel.id ?? 0, customerId: conversationModel.customerId ?? 0, tempChatId: conversationModel.tempChatId ?? "", conversationId: conversationModel.conversationUid ?? "0")
                                    }
                                }
                            }
                        }
                    }
                }
                
                
                //UIApplication.shared.keyWindow?.makeToast("Login Data Saved Successfully!")
            }catch
            {
                print(error)
            }
            
        }
        
    }
    
    func saveChatFilesData(pageNumber : Int, conversationFiles : FileDataModel, fid : Int64, customerId : Int64, tempChatId : String,conversationId : String)
    {
        let contactDB = FMDatabase(path: databasePath as String)
        
        if contactDB.open()
        {
            do
            {
                try contactDB.executeUpdate(QueriesChat.string.SaveChatFilesData, values: [fid, customerId, conversationId, conversationFiles.url, conversationFiles.type, conversationFiles.icon, conversationFiles.documentName, tempChatId, conversationFiles.isLocalFile])
                //UIApplication.shared.keyWindow?.makeToast("Login Data Saved Successfully!")
            }catch
            {
                print(error)
            }
            
        }
        
    }
    
    func chechIfMessageExist(id : Int64) -> Bool {
        let contactDB = FMDatabase(path: databasePath as String)
        var isExist : Bool = false
        
        if contactDB.open() {
            do {
                //CUSTOMERCONVERSATIONS
                let queryString = "SELECT COUNT(*) FROM CUSTOMERCONVERSATIONS WHERE cid = ?"
                let resultSet = try contactDB.executeQuery(queryString, values: [id])
                if resultSet.next() {
                    let count = resultSet.int(forColumnIndex: 0)
                    isExist = count > 0
                }
                print("Load Data")
                
            } catch {
                print(error)
            }
            
        }
        
        contactDB.close()
        return isExist
    }
    
    func chechIfMessageFilesExist(id : Int64) -> Bool {
        let contactDB = FMDatabase(path: databasePath as String)
        var isExist : Bool = false
        
        if contactDB.open() {
            do {
                //CUSTOMERCONVERSATIONFILES
                let queryString = "SELECT COUNT(*) FROM CUSTOMERCONVERSATIONFILES WHERE fid = ?"
                let resultSet = try contactDB.executeQuery(queryString, values: [id])
                if resultSet.next() {
                    let count = resultSet.int(forColumnIndex: 0)
                    isExist = count > 0
                }
                print("Load Data")
                
            } catch {
                print(error)
            }
            
        }
        
        contactDB.close()
        return isExist
        
        
    }
    
    //MARK: Temp Message Check
    func chechIfMessageExistWithTempId(id : String) -> Bool {
        let contactDB = FMDatabase(path: databasePath as String)
        var isExist : Bool = false
        
        if contactDB.open() {
            do {
                //CUSTOMERCONVERSATIONS
                let queryString = "SELECT COUNT(*) FROM CUSTOMERCONVERSATIONS WHERE tempChatId = ?"
                let resultSet = try contactDB.executeQuery(queryString, values: [id])
                if resultSet.next() {
                    let count = resultSet.int(forColumnIndex: 0)
                    isExist = count > 0
                }
                print("Load Data")
                
            } catch {
                print(error)
            }
            
        }
        
        contactDB.close()
        return isExist
    }
    
    func chechIfMessageFilesExistWithTempId(id : String) -> Bool {
        let contactDB = FMDatabase(path: databasePath as String)
        var isExist : Bool = false
        
        if contactDB.open() {
            do {
                //CUSTOMERCONVERSATIONFILES
                let queryString = "SELECT COUNT(*) FROM CUSTOMERCONVERSATIONFILES WHERE tempChatId = ?"
                let resultSet = try contactDB.executeQuery(queryString, values: [id])
                if resultSet.next() {
                    let count = resultSet.int(forColumnIndex: 0)
                    isExist = count > 0
                }
                print("Load Data")
                
            } catch {
                print(error)
            }
            
        }
        
        contactDB.close()
        return isExist
        
        
    }
    
    func getAllConversation(conversationId : String) -> [ConversationsByUUID]{
        let contactDB = FMDatabase(path: databasePath as String)
        var customerConversation = [ConversationsByUUID]()
        conversationByZeroId = [ConversationsByUUID]()
        if contactDB.open() {
            do {
                
                let resultConversation = try contactDB.executeQuery(QueriesChat.string.GetAllConversation, values: [conversationId]) //conversationId, customerId
                
                
                while resultConversation.next() == true {
                    let id = (resultConversation.int(forColumn: "cid"))
                    let customerId = (resultConversation.int(forColumn: "customerId"))
                    let customerConnectionId = (resultConversation.string(forColumn: "customerConnectionId"))
                    let customerEmail = (resultConversation.string(forColumn: "customerEmail"))
                    let toUserId = (resultConversation.int(forColumn: "toUserId"))
                    let agentId = (resultConversation.int(forColumn: "agentId"))
                    let status = (resultConversation.string(forColumn: "status")) ?? "0"
                    let tempChatId = String(resultConversation.string(forColumn: "tempChatId") ?? "")
                    let fromUserId = (resultConversation.int(forColumn: "fromUserId"))
                    let groupId = (resultConversation.int(forColumn: "groupId"))
                    let conversationId = (resultConversation.int(forColumn: "conversationId"))
                    let content = (resultConversation.string(forColumn: "content"))
                    let timestamp = (resultConversation.string(forColumn: "timestamp"))
                    let sender = (resultConversation.string(forColumn: "sender"))
                    let receiver = (resultConversation.string(forColumn: "receiver"))
                    let type = (resultConversation.string(forColumn: "type"))
                    let source = (resultConversation.string(forColumn: "source"))
                    let groupName = (resultConversation.string(forColumn: "groupName"))
                    let forwardedTo = (resultConversation.int(forColumn: "forwardedTo"))
                    let tiggerevent = (resultConversation.int(forColumn: "tiggerevent"))
                    let customerName = (resultConversation.string(forColumn: "customerName"))
                    let conversationUid = (resultConversation.string(forColumn: "conversationUid"))
                    let isAgentReplied = (resultConversation.bool(forColumn: "isAgentReplied"))
                    let isResolved = (resultConversation.bool(forColumn: "isResolved"))
                    let isFromWidget = (resultConversation.bool(forColumn: "isFromWidget"))
                    let isPrivate = (resultConversation.bool(forColumn: "isPrivate"))
                    let childConversationCount = (resultConversation.int(forColumn: "childConversationCount"))
                    let conversationType = (resultConversation.string(forColumn: "conversationType"))
                    let pageId = (resultConversation.string(forColumn: "pageId"))
                    let pageName = (resultConversation.string(forColumn: "pageName"))
                    let base64Image = (resultConversation.string(forColumn: "base64Image"))
                    let fileLocalUri = (resultConversation.string(forColumn: "fileLocalUri"))
                    let isRecordUpdated = (resultConversation.bool(forColumn: "isRecordUpdated"))
                    let isNewMessageReceive = (resultConversation.bool(forColumn: "isNewMessageReceive"))
                    let isDownloading = (resultConversation.bool(forColumn: "isDownloading"))
                    let isSeen = (resultConversation.bool(forColumn: "isSeen"))
                    let isUpdateStatus = (resultConversation.bool(forColumn: "isUpdateStatus"))
                    let isShowLocalFiles = (resultConversation.bool(forColumn: "isShowLocalFiles"))
                    let isNotNewChat = (resultConversation.bool(forColumn: "isNotNewChat"))
                    let isWelcomeMessage = (resultConversation.bool(forColumn: "isWelcomeMessage"))
                    let caption = (resultConversation.string(forColumn: "caption"))
                    let isFailed = (resultConversation.bool(forColumn: "isFailed"))
                    let rating = (resultConversation.int(forColumn: "rating"))
                    let feedback = (resultConversation.string(forColumn: "feedback"))
                    var files : [FileDataModel] = [FileDataModel]()
                    if type == "file"{
                        var resultDocument: FMResultSet!
                        if id != 0{
                            resultDocument = try contactDB.executeQuery(QueriesChat.string.GetConversationFilesData, values: [conversationId, customerId, id])
                            
                        }else{
                            resultDocument = try contactDB.executeQuery(QueriesChat.string.GetConversationFilesDataByTempId, values: [conversationId, customerId, tempChatId])
                        }
                        while resultDocument.next() == true {
                            //fid, customerId, url, type, icon, documentName, isLocalFile
                            let fid = (resultDocument.int(forColumn: "fid"))
                            let customerId = (resultDocument.int(forColumn: "customerId"))
                            let conversationId = (resultDocument.string(forColumn: "conversationId"))
                            let url = (resultDocument.string(forColumn: "url"))
                            let type = (resultDocument.string(forColumn: "type"))
                            let icon = (resultDocument.string(forColumn: "icon"))
                            let documentName = (resultDocument.string(forColumn: "documentName"))
                            let isLocalFile = (resultDocument.bool(forColumn: "isLocalFile"))
                            
                            let filesData = FileDataModel(url: url, type: type, icon: icon, documentName: documentName, isLocalFile: isLocalFile)
                            files.append(filesData)
                            
                        }
                    }
                    
                    let conversation = ConversationsByUUID(id: Int64(id), customerId: Int64(customerId), customerConnectionId: customerConnectionId, customerEmail: customerEmail, toUserId: Int64(toUserId), agentId: Int64(agentId), status: Int64(status), tempChatId: tempChatId, fromUserId: Int64(fromUserId), groupId: Int64(groupId), conversationId: Int64(conversationId), content: content, timestamp: timestamp, sender: sender, receiver: receiver, type: type, source: source, groupName: groupName, forwardedTo: Int64(forwardedTo), tiggerevent: Int64(tiggerevent), customerName: customerName, conversationUid: conversationUid, isAgentReplied: isAgentReplied, isResolved: isResolved, isFromWidget: isFromWidget, isPrivate: isPrivate, childConversationCount: Int64(childConversationCount), conversationType: conversationType, pageId: pageId, pageName: pageName, base64Image: base64Image, fileLocalUri: fileLocalUri, isRecordUpdated: isRecordUpdated, isNewMessageReceive: isNewMessageReceive, isDownloading: isDownloading, isSeen: isSeen, isUpdateStatus: isUpdateStatus, isShowLocalFiles: isShowLocalFiles, isNotNewChat: isNotNewChat, isWelcomeMessage: isWelcomeMessage, caption: caption, isFailed: isFailed, rating: Int(rating), feedback: feedback, files: files)
//                    if conversation.id == 0 && conversation.isFailed == true{
//                        conversationByZeroId.append(conversation)
//                    }else{
                        customerConversation.append(conversation)
                        
//                    }
                    
                    print("Load Data")
                }
                print("Load Data")
                
            } catch {
                print(error)
            }
            
        }
        
        contactDB.close()
        return customerConversation
        
        
    }
    
    func getLastConversationItem(conversationId : String) -> [ConversationsByUUID]{
        let contactDB = FMDatabase(path: databasePath as String)
        var customerConversation = [ConversationsByUUID]()
        conversationByZeroId = [ConversationsByUUID]()
        if contactDB.open() {
            do {
                
                let resultConversation = try contactDB.executeQuery("SELECT * FROM CUSTOMERCONVERSATIONS WHERE (conversationUid = '\(conversationId)') ORDER BY cid DESC", values: []) //conversationId, customerId
                
                
                while resultConversation.next() == true {
                    let id = (resultConversation.int(forColumn: "cid"))
                    let customerId = (resultConversation.int(forColumn: "customerId"))
                    let customerConnectionId = (resultConversation.string(forColumn: "customerConnectionId"))
                    let customerEmail = (resultConversation.string(forColumn: "customerEmail"))
                    let toUserId = (resultConversation.int(forColumn: "toUserId"))
                    let agentId = (resultConversation.int(forColumn: "agentId"))
                    let status = (resultConversation.string(forColumn: "status")) ?? "0"
                    let tempChatId = String(resultConversation.string(forColumn: "tempChatId") ?? "")
                    let fromUserId = (resultConversation.int(forColumn: "fromUserId"))
                    let groupId = (resultConversation.int(forColumn: "groupId"))
                    let conversationId = (resultConversation.int(forColumn: "conversationId"))
                    let content = (resultConversation.string(forColumn: "content"))
                    let timestamp = (resultConversation.string(forColumn: "timestamp"))
                    let sender = (resultConversation.string(forColumn: "sender"))
                    let receiver = (resultConversation.string(forColumn: "receiver"))
                    let type = (resultConversation.string(forColumn: "type"))
                    let source = (resultConversation.string(forColumn: "source"))
                    let groupName = (resultConversation.string(forColumn: "groupName"))
                    let forwardedTo = (resultConversation.int(forColumn: "forwardedTo"))
                    let tiggerevent = (resultConversation.int(forColumn: "tiggerevent"))
                    let customerName = (resultConversation.string(forColumn: "customerName"))
                    let conversationUid = (resultConversation.string(forColumn: "conversationUid"))
                    let isAgentReplied = (resultConversation.bool(forColumn: "isAgentReplied"))
                    let isResolved = (resultConversation.bool(forColumn: "isResolved"))
                    let isFromWidget = (resultConversation.bool(forColumn: "isFromWidget"))
                    let isPrivate = (resultConversation.bool(forColumn: "isPrivate"))
                    let childConversationCount = (resultConversation.int(forColumn: "childConversationCount"))
                    let conversationType = (resultConversation.string(forColumn: "conversationType"))
                    let pageId = (resultConversation.string(forColumn: "pageId"))
                    let pageName = (resultConversation.string(forColumn: "pageName"))
                    let base64Image = (resultConversation.string(forColumn: "base64Image"))
                    let fileLocalUri = (resultConversation.string(forColumn: "fileLocalUri"))
                    let isRecordUpdated = (resultConversation.bool(forColumn: "isRecordUpdated"))
                    let isNewMessageReceive = (resultConversation.bool(forColumn: "isNewMessageReceive"))
                    let isDownloading = (resultConversation.bool(forColumn: "isDownloading"))
                    let isSeen = (resultConversation.bool(forColumn: "isSeen"))
                    let isUpdateStatus = (resultConversation.bool(forColumn: "isUpdateStatus"))
                    let isShowLocalFiles = (resultConversation.bool(forColumn: "isShowLocalFiles"))
                    let isNotNewChat = (resultConversation.bool(forColumn: "isNotNewChat"))
                    let isWelcomeMessage = (resultConversation.bool(forColumn: "isWelcomeMessage"))
                    let caption = (resultConversation.string(forColumn: "caption"))
                    let isFailed = (resultConversation.bool(forColumn: "isFailed"))
                    let createdOn = (resultConversation.date(forColumn: "createdOn"))
                    var files : [FileDataModel] = [FileDataModel]()
                    if type == "file"{
                        var resultDocument: FMResultSet!
                        if id != 0{
                            resultDocument = try contactDB.executeQuery(QueriesChat.string.GetConversationFilesData, values: [conversationId, customerId, id])
                            
                        }else{
                            resultDocument = try contactDB.executeQuery(QueriesChat.string.GetConversationFilesDataByTempId, values: [conversationId, customerId, tempChatId])
                        }
                        while resultDocument.next() == true {
                            //fid, customerId, url, type, icon, documentName, isLocalFile
                            let fid = (resultDocument.int(forColumn: "fid"))
                            let customerId = (resultDocument.int(forColumn: "customerId"))
                            let conversationId = (resultDocument.string(forColumn: "conversationId"))
                            let url = (resultDocument.string(forColumn: "url"))
                            let type = (resultDocument.string(forColumn: "type"))
                            let icon = (resultDocument.string(forColumn: "icon"))
                            let documentName = (resultDocument.string(forColumn: "documentName"))
                            let isLocalFile = (resultDocument.bool(forColumn: "isLocalFile"))
                            
                            let filesData = FileDataModel(url: url, type: type, icon: icon, documentName: documentName, isLocalFile: isLocalFile)
                            files.append(filesData)
                            
                        }
                    }
                    
                    let conversation = ConversationsByUUID(id: Int64(id), customerId: Int64(customerId), customerConnectionId: customerConnectionId, customerEmail: customerEmail, toUserId: Int64(toUserId), agentId: Int64(agentId), status: Int64(status), tempChatId: tempChatId, fromUserId: Int64(fromUserId), groupId: Int64(groupId), conversationId: Int64(conversationId), content: content, timestamp: timestamp, sender: sender, receiver: receiver, type: type, source: source, groupName: groupName, forwardedTo: Int64(forwardedTo), tiggerevent: Int64(tiggerevent), customerName: customerName, conversationUid: conversationUid, isAgentReplied: isAgentReplied, isResolved: isResolved, isFromWidget: isFromWidget, isPrivate: isPrivate, childConversationCount: Int64(childConversationCount), conversationType: conversationType, pageId: pageId, pageName: pageName, base64Image: base64Image, fileLocalUri: fileLocalUri, isRecordUpdated: isRecordUpdated, isNewMessageReceive: isNewMessageReceive, isDownloading: isDownloading, isSeen: isSeen, isUpdateStatus: isUpdateStatus, isShowLocalFiles: isShowLocalFiles, isNotNewChat: isNotNewChat, isWelcomeMessage: isWelcomeMessage, caption: caption, isFailed: isFailed, createdOn: createdOn, files: files)
                    if conversation.id == 0 && conversation.isFailed == true{
                        conversationByZeroId.append(conversation)
                    }else{
                        customerConversation.append(conversation)
                        
                    }
                    
                    print("Load Data")
                }
                print("Load Data")
                
            } catch {
                print(error)
            }
            
        }
        
        contactDB.close()
        return customerConversation
        
        
    }
    
    
    
    //MARK: Update Queries
    func updateConversationByTempId(pageNumber : Int, conversation : ConversationsByUUID){
        let contactDB = FMDatabase(path: databasePath as String)
        if contactDB.open()
        {
            do
            {
                try contactDB.executeUpdate(QueriesChat.string.updateChatData, values: [conversation.id, conversation.customerId, conversation.customerConnectionId, conversation.customerEmail, conversation.toUserId, conversation.agentId, conversation.status, conversation.tempChatId, conversation.fromUserId, conversation.groupId, conversation.conversationId, conversation.content, conversation.timestamp, conversation.sender, conversation.receiver, conversation.type, conversation.source, conversation.groupName, conversation.forwardedTo, conversation.tiggerevent, conversation.customerName, conversation.conversationUid, conversation.isAgentReplied, conversation.isResolved, conversation.isFromWidget, conversation.isPrivate, conversation.childConversationCount, conversation.conversationType, conversation.pageId, conversation.pageName, conversation.base64Image, conversation.fileLocalUri, conversation.isRecordUpdated, conversation.isNewMessageReceive, conversation.isDownloading, conversation.isSeen, conversation.isUpdateStatus, conversation.isShowLocalFiles, conversation.isNotNewChat, conversation.isWelcomeMessage, conversation.caption, conversation.isFailed, conversation.isReceived, conversation.rating, conversation.feedback, conversation.isFeedback, conversation.createdOn, conversation.tempChatId ])//, conversation.conversationUid
                
                
                
                //UIApplication.shared.keyWindow?.makeToast("Login Data Saved Successfully!")
                
            }catch
            {
                print(error)
            }
            
        }
        
    }
    
    func updateChatFilesData(pageNumber : Int, conversationFiles : FileDataModel, fid : Int64, customerId : Int64, tempChatId : String, conversationId : String)
    {
        let contactDB = FMDatabase(path: databasePath as String)
        
        if contactDB.open()
        {
            do
            {
                try contactDB.executeUpdate(QueriesChat.string.updateChatFiles, values: [fid, customerId, conversationId, conversationFiles.url, conversationFiles.type, conversationFiles.icon, conversationFiles.documentName, "", conversationFiles.isLocalFile, tempChatId])
                //UIApplication.shared.keyWindow?.makeToast("Login Data Saved Successfully!")
            }catch
            {
                print(error)
            }
            
        }
        
    }
    
    
    func updateSpecifConveration(pageNumber : Int, conversation : ConversationsByUUID){
        if self.chechIfMessageExist(id: conversation.id ?? 0){
            self.updateConversationById(pageNumber: pageNumber, conversation: conversation ?? ConversationsByUUID())
            if conversation.type == "file"{
                if self.chechIfMessageFilesExist(id: conversation.id ?? 0){
                    for j in 0 ..< (conversation.files?.count ?? 0){
                        self.updateChatFilesDataById(pageNumber: pageNumber, conversationFiles: conversation.files?[j] ?? FileDataModel(), fid: conversation.id ?? 0, customerId: conversation.customerId ?? 0, tempChatId: conversation.tempChatId ?? "", conversationId: conversation.conversationUid ?? "0")
                    }
                }
            }
        }
        
    }
    
    //MARK: Update Queries
    func updateConversationById(pageNumber : Int, conversation : ConversationsByUUID){
        let contactDB = FMDatabase(path: databasePath as String)
        if contactDB.open()
        {
            do
            {
                try contactDB.executeUpdate(QueriesChat.string.updateChatDataById, values: [conversation.id, conversation.customerId, conversation.customerConnectionId, conversation.customerEmail, conversation.toUserId, conversation.agentId, conversation.status, conversation.tempChatId, conversation.fromUserId, conversation.groupId, conversation.conversationId, conversation.content, conversation.timestamp, conversation.sender, conversation.receiver, conversation.type, conversation.source, conversation.groupName, conversation.forwardedTo, conversation.tiggerevent, conversation.customerName, conversation.conversationUid, conversation.isAgentReplied, conversation.isResolved, conversation.isFromWidget, conversation.isPrivate, conversation.childConversationCount, conversation.conversationType, conversation.pageId, conversation.pageName, conversation.base64Image, conversation.fileLocalUri, conversation.isRecordUpdated, conversation.isNewMessageReceive, conversation.isDownloading, conversation.isSeen, conversation.isUpdateStatus, conversation.isShowLocalFiles, conversation.isNotNewChat, conversation.isWelcomeMessage, conversation.caption, conversation.isFailed,conversation.isReceived, conversation.rating, conversation.feedback , conversation.isFeedback, conversation.createdOn, conversation.id])//conversation.conversationUid
                
                
                
                //UIApplication.shared.keyWindow?.makeToast("Login Data Saved Successfully!")
                
            }catch
            {
                print(error)
            }
            
        }
        
    }
    
    func updateChatFilesDataById(pageNumber : Int, conversationFiles : FileDataModel, fid : Int64, customerId : Int64, tempChatId : String, conversationId : String)
    {
        let contactDB = FMDatabase(path: databasePath as String)
        
        if contactDB.open()
        {
            do
            {
                try contactDB.executeUpdate(QueriesChat.string.updateChatFilesById, values: [fid, customerId, conversationId, conversationFiles.url, conversationFiles.type, conversationFiles.icon, conversationFiles.documentName, "", conversationFiles.isLocalFile, fid])
                //UIApplication.shared.keyWindow?.makeToast("Login Data Saved Successfully!")
            }catch
            {
                print(error)
            }
            
        }
        
    }

    func updateFailedStatus(tempChatId : String, isFailed : Bool)
    {
        let contactDB = FMDatabase(path: databasePath as String)
        if contactDB.open()
        {
            do
            {
                
                try contactDB.executeUpdate("UPDATE CUSTOMERCONVERSATIONS SET isFailed = ? WHERE (tempChatId = '\(tempChatId)')", values: [isFailed])
                //UIApplication.shared.keyWindow?.makeToast("Transaction Data Updated Successfully!")
                
            }catch
            {
                print(error)
            }
            
        }
        
    }
    
    func SaveNewChatTemprory(pageNumber : Int, conversation : NewChatMessage){
        if !self.chechIfNewMessageExistWithTempId(id: conversation.tempChatId ?? "0"){
            saveNewChatIntoTempDB(pageNumber: pageNumber, conversation: conversation)
        }
    }
    
    func saveNewChatIntoTempDB(pageNumber : Int, conversation : NewChatMessage)
    {
        let contactDB = FMDatabase(path: databasePath as String)
        
        if contactDB.open()
        {
            do
            {
                
                try contactDB.executeUpdate(QueriesChat.string.SaveUnSendNewChatMessage, values: [conversation.tempChatId, conversation.customerId, conversation.name, conversation.cnic, conversation.contactNo, conversation.emailaddress, conversation.sender, conversation.agentId, conversation.groupId, conversation.message, conversation.source, conversation.conversationUId, conversation.isResolved, conversation.isWelcomeMessage, conversation.connectionId, conversation.isFromWidget, conversation.ipAddress, conversation.notifyMessage, conversation.channelid, conversation.type, conversation.documentOrignalname, conversation.documentName, conversation.documentType, conversation.mobileToken, conversation.timezone, conversation.timestamp, conversation.topicId, conversation.topicMessage, conversation.caption, false, 0, ""])
                
                //UIApplication.shared.keyWindow?.makeToast("Login Data Saved Successfully!")
            }catch
            {
                print(error)
            }
            
        }
        
    }
    
    //MARK: Temp Message Check In Temp DB
    func chechIfNewMessageExistWithTempId(id : String) -> Bool {
        let contactDB = FMDatabase(path: databasePath as String)
        var isExist : Bool = false
        
        if contactDB.open() {
            do {
                //CUSTOMERCONVERSATIONS
                let queryString = "SELECT COUNT(*) FROM UNSENDNEWCHATMESSAGE WHERE tempChatId = ?"
                let resultSet = try contactDB.executeQuery(queryString, values: [id])
                if resultSet.next() {
                    let count = resultSet.int(forColumnIndex: 0)
                    isExist = count > 0
                }
                print("Load Data")
                
            } catch {
                print(error)
            }
            
        }
        
        contactDB.close()
        return isExist
    }
    
    //MARK: Temp Message Check In Temp DB
    func deleteUnSendNewChatUsingTempId(id : String) -> Bool {
        let contactDB = FMDatabase(path: databasePath as String)
        var isExist : Bool = false
        
        if contactDB.open() {
            do {
                //CUSTOMERCONVERSATIONS
                let queryString = "DELETE FROM UNSENDNEWCHATMESSAGE WHERE tempChatId = ?"
                let resultSet = try contactDB.executeUpdate(queryString, values: [id])
        
                print("Load Data")
                
            } catch {
                print(error)
            }
            
        }
        
        contactDB.close()
        return isExist
    }
    
    //MARK: Temp Message Check In Temp DB
    func deleteUnSendNewChats() -> Bool {
        let contactDB = FMDatabase(path: databasePath as String)
        var isExist : Bool = false
        
        if contactDB.open() {
            do {
                //CUSTOMERCONVERSATIONS
                let queryString = "DELETE FROM UNSENDNEWCHATMESSAGE"
                let resultSet = try contactDB.executeUpdate(queryString, values: [])
        
                print("Load Data")
                
            } catch {
                print(error)
            }
            
        }
        
        contactDB.close()
        return isExist
    }
    
    
    func getAllUnSendNewChats() -> [NewChatMessage]{
        
        let contactDB = FMDatabase(path: databasePath as String)
        var NewChat = [NewChatMessage]()
        
        if contactDB.open() {
            do {
                
                let resultConversation = try contactDB.executeQuery(QueriesChat.string.GetAllUnSendNewChats, values: [])
                
                while resultConversation.next() == true {
                    let tempChatId = (resultConversation.string(forColumn: "tempChatId"))
                    let customerId = (resultConversation.int(forColumn: "customerId"))
                    let name = (resultConversation.string(forColumn: "name"))
                    let cnic = (resultConversation.string(forColumn: "cnic"))
                    let contactNo = (resultConversation.string(forColumn: "contactNo"))
                    let emailaddress = (resultConversation.string(forColumn: "emailaddress"))
                    let sender = (resultConversation.string(forColumn: "sender"))
                    let agentId = (resultConversation.int(forColumn: "agentId"))
                    let groupId = (resultConversation.int(forColumn: "groupId"))
                    let message = (resultConversation.string(forColumn: "message"))
                    let source = (resultConversation.string(forColumn: "source"))
                    let conversationUId = (resultConversation.string(forColumn: "conversationUId"))
                    let isResolved = (resultConversation.bool(forColumn: "isResolved"))
                    let isWelcomeMessage = (resultConversation.bool(forColumn: "isWelcomeMessage"))
                    let connectionId = (resultConversation.string(forColumn: "connectionId"))
                    let isFromWidget = (resultConversation.bool(forColumn: "isFromWidget"))
                    let ipAddress = (resultConversation.string(forColumn: "ipAddress"))
                    let notifyMessage = (resultConversation.string(forColumn: "notifyMessage"))
                    let channelid = (resultConversation.string(forColumn: "channelid"))
                    let type = (resultConversation.string(forColumn: "type"))
                    let documentOrignalname = (resultConversation.string(forColumn: "documentOrignalname"))
                    let documentName = (resultConversation.string(forColumn: "documentName"))
                    let documentType = (resultConversation.string(forColumn: "documentType"))
                    let mobileToken = (resultConversation.string(forColumn: "mobileToken"))
                    let timezone = (resultConversation.string(forColumn: "timezone"))
                    let timestamp = (resultConversation.string(forColumn: "timestamp"))
                    let caption = (resultConversation.string(forColumn: "caption"))
                    let topicId = (resultConversation.string(forColumn: "topicId")) ?? "0"
                    let topicMessage = (resultConversation.string(forColumn: "topicMessage"))
                    
                    
                    let chat = NewChatMessage(tempChatId: tempChatId, customerId: Int64(customerId), name: name, cnic: cnic, contactNo: contactNo, emailaddress: emailaddress, sender: sender, agentId: Int64(agentId), groupId: Int64(groupId), message: message, source: source, conversationUId: conversationUId, isResolved: isResolved, isWelcomeMessage: isWelcomeMessage, connectionId: connectionId, isFromWidget: isFromWidget, ipAddress: ipAddress, notifyMessage: notifyMessage, channelid: channelid, type: type, documentOrignalname: documentOrignalname, documentName: documentName, documentType: documentType, mobileToken: mobileToken, timezone: timezone, caption: caption, topicId : Int64(topicId), topicMessage : topicMessage, timestamp: timestamp)
                    
                    NewChat.append(chat)
                    
                    print("Load Data")
                }
                print("Load Data")
                
            } catch {
                print(error)
            }
            
        }
        
        contactDB.close()
        return NewChat
        
    }
    
    
}


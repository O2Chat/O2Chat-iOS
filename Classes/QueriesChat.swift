//
//  QueriesChat.swift
//  Befiler
//
//  Created by Sanjay Kumar on 03/08/2023.
//  Copyright © 2023 Haseeb. All rights reserved.
//

import Foundation
import Foundation
struct QueriesChat {
    
    static let string = QueriesChat()
    
    let ChatModel = "CREATE TABLE IF NOT EXISTS CUSTOMERCONVERSATIONS (ID INTEGER PRIMARY KEY AUTOINCREMENT, cid INTEGER, customerId INTEGER, customerConnectionId TEXT, customerEmail TEXT, toUserId INTEGER, agentId INTEGER, status TEXT, tempChatId TEXT, fromUserId INTEGER, groupId INTEGER, conversationId INTEGER, content TEXT, timestamp TEXT, sender TEXT, receiver TEXT, type TEXT, source TEXT, groupName TEXT, forwardedTo INTEGER, tiggerevent INTEGER, customerName TEXT, conversationUid TEXT, isAgentReplied BOOL, isResolved Bool, isFromWidget BOOL, isPrivate BOOL, childConversationCount INTEGER, conversationType TEXT, pageId TEXT, pageName TEXT, base64Image TEXT, fileLocalUri TEXT, isRecordUpdated BOOL, isNewMessageReceive BOOL, isDownloading BOOL, isSeen BOOL, isUpdateStatus BOOL, isShowLocalFiles BOOL, isNotNewChat BOOL, isWelcomeMessage BOOL, caption TEXT, isFailed BOOL, isReceived BOOL, rating INTEGER, feedback TEXT, isFeedback BOOL, createdOn DATE)"
    
    let SaveChatData = "INSERT INTO CUSTOMERCONVERSATIONS (cid, customerId, customerConnectionId, customerEmail, toUserId, agentId, status, tempChatId, fromUserId, groupId, conversationId, content, timestamp, sender, receiver, type, source, groupName, forwardedTo, tiggerevent, customerName, conversationUid, isAgentReplied, isResolved, isFromWidget, isPrivate, childConversationCount, conversationType, pageId, pageName, base64Image, fileLocalUri, isRecordUpdated, isNewMessageReceive, isDownloading, isSeen, isUpdateStatus, isShowLocalFiles, isNotNewChat, isWelcomeMessage, caption, isFailed, isReceived, rating, feedback,isFeedback, createdOn) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"
    
    let ChatFilesModel = "CREATE TABLE IF NOT EXISTS CUSTOMERCONVERSATIONFILES (ID INTEGER PRIMARY KEY AUTOINCREMENT, fid INTEGER, customerId INTEGER, conversationUid TEXT, url TEXT, type TEXT, icon TEXT, documentName TEXT, tempChatId TEXT, isLocalFile BOOL)"
    let SaveChatFilesData = "INSERT INTO CUSTOMERCONVERSATIONFILES (fid, customerId, conversationUid, url, type, icon, documentName, tempChatId, isLocalFile) VALUES (?,?,?,?,?,?,?,?,?)"

    
    
    let GetAllConversation = "SELECT * FROM CUSTOMERCONVERSATIONS WHERE conversationUid = ? ORDER BY createdOn DESC"

    let GetConversationFilesData = "SELECT * FROM CUSTOMERCONVERSATIONFILES WHERE conversationUid = ? OR customerId = ? AND fid = ?"
    let GetConversationFilesDataByTempId = "SELECT * FROM CUSTOMERCONVERSATIONFILES WHERE conversationUid = ? OR customerId = ? AND tempChatId = ?"
    
    let GetLastConversation = "SELECT * FROM CUSTOMERCONVERSATIONS ORDER BY cid DESC"
    
    let updateChatData = "UPDATE CUSTOMERCONVERSATIONS SET cid = ?, customerId = ?, customerConnectionId = ?, customerEmail = ?, toUserId = ?, agentId = ?, status = ?, tempChatId = ?, fromUserId = ?, groupId = ?, conversationId = ?, content = ?, timestamp = ?, sender = ?, receiver = ?, type = ?, source = ?, groupName = ?, forwardedTo = ?, tiggerevent = ?, customerName = ?, conversationUid = ?, isAgentReplied = ?, isResolved = ?, isFromWidget = ?, isPrivate = ?, childConversationCount = ?, conversationType = ?, pageId = ?, pageName = ?, base64Image = ?, fileLocalUri = ?, isRecordUpdated = ?, isNewMessageReceive = ?, isDownloading = ?, isSeen = ?, isUpdateStatus = ?, isShowLocalFiles = ?, isNotNewChat = ?, isWelcomeMessage = ?, caption = ? , isFailed = ?, isReceived = ? , rating = ?, feedback = ?, isFeedback = ?, createdOn = ? WHERE (tempChatId = ?)" //AND conversationUid = ?
    let updateChatFiles = "UPDATE CUSTOMERCONVERSATIONFILES SET fid = ?, customerId = ?, conversationUid = ?, url = ?, type = ?, icon = ?, documentName = ?, tempChatId = ?, isLocalFile = ? WHERE (tempChatId = ?)"
    
    let updateChatDataById = "UPDATE CUSTOMERCONVERSATIONS SET cid = ?, customerId = ?, customerConnectionId = ?, customerEmail = ?, toUserId = ?, agentId = ?, status = ?, tempChatId = ?, fromUserId = ?, groupId = ?, conversationId = ?, content = ?, timestamp = ?, sender = ?, receiver = ?, type = ?, source = ?, groupName = ?, forwardedTo = ?, tiggerevent = ?, customerName = ?, conversationUid = ?, isAgentReplied = ?, isResolved = ?, isFromWidget = ?, isPrivate = ?, childConversationCount = ?, conversationType = ?, pageId = ?, pageName = ?, base64Image = ?, fileLocalUri = ?, isRecordUpdated = ?, isNewMessageReceive = ?, isDownloading = ?, isSeen = ?, isUpdateStatus = ?, isShowLocalFiles = ?, isNotNewChat = ?, isWelcomeMessage = ?, caption = ?, isFailed = ?, isReceived = ?, rating = ?, feedback = ?, isFeedback = ?, createdOn = ? WHERE (cid = ?)" // AND conversationUid = ?
    let updateChatFilesById = "UPDATE CUSTOMERCONVERSATIONFILES SET fid = ?, customerId = ?, conversationUid = ?, url = ?, type = ?, icon = ?, documentName = ?, tempChatId = ?, isLocalFile = ? WHERE (fid = ?)"
    
    
    let UnSendNewChatMessage = "CREATE TABLE IF NOT EXISTS UNSENDNEWCHATMESSAGE (ID INTEGER PRIMARY KEY AUTOINCREMENT, tempChatId TEXT, customerId INTEGER, name TEXT, cnic TEXT, contactNo TEXT, emailaddress TEXT, sender TEXT, agentId INTEGER, groupId INTEGER, message TEXT, source TEXT, conversationUId TEXT, isResolved BOOL, isWelcomeMessage BOOL, connectionId TEXT, isFromWidget BOOL, ipAddress TEXT, notifyMessage TEXT, channelid TEXT, type TEXT, documentOrignalname TEXT, documentName TEXT, documentType TEXT, mobileToken TEXT, timezone TEXT, timestamp TEXT, topicId TEXT, topicMessage TEXT, caption TEXT, isReceived BOOL ,rating INTEGER, feedback TEXT)"
    
    let SaveUnSendNewChatMessage = "INSERT INTO UNSENDNEWCHATMESSAGE (tempChatId, customerId, name, cnic, contactNo, emailaddress, sender, agentId, groupId, message, source, conversationUId, isResolved, isWelcomeMessage, connectionId, isFromWidget, ipAddress, notifyMessage, channelid, type, documentOrignalname, documentName, documentType, mobileToken, timezone, timestamp, topicId, topicMessage, caption, isReceived ,rating, feedback) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"
    
    let GetAllUnSendNewChats = "SELECT * FROM UNSENDNEWCHATMESSAGE WHERE (isReceived = false)"
    
}



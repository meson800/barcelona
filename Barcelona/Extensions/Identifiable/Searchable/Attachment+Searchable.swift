//
//  Attachment+Searchable.swift
//  CoreBarcelona
//
//  Created by Eric Rabil on 9/14/20.
//  Copyright © 2020 Eric Rabil. All rights reserved.
//

import Foundation

public struct AttachmentSearchParameters: QueryParameters, QueryParametersChatNarrowable {
    /// mime and likeMIME are mutually exclusive
    public var mime: [String]?
    public var likeMIME: String?
    /// uti and likeUTI are mutually exclusive
    public var uti: [String]?
    public var likeUTI: String?
    
    public var name: String?
    public var chats: [String]?
    public var limit: Int?
    public var page: Int?
}

extension Attachment: Searchable {
    public static func resolve(withParameters parameters: AttachmentSearchParameters) -> Promise<[Attachment]> {
        DBReader.shared.attachments(matchingParameters: parameters).map(\.attachment)
    }
}

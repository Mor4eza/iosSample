//
//	NewsDetailsList.swift
//
//	Create by Morteza Gharedaghi on 10/9/2016
//	Copyright © 2016. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

//	The "Swift - Struct - Gloss" support has been made available by CodeEagle
//	More about him/her can be found at his/her website: https://github.com/CodeEagle

import Foundation
import Gloss

//MARK: - NewsDetailsList
public struct BourseNewsDetailsList: Glossy {

	public let categoryId : Int!
	public let createdAt : String!
	public let descriptionField : String!
	public let id : Int!
	public let imageBg : AnyObject!
	public let imageSmall : AnyObject!
	public let published : Int!
	public let pushed : Int!
	public let reference : String!
	public let state : Int!
	public let title : String!
	public let updatedAt : String!
	public let userId : Int!

	//MARK: Decodable
	public init?(json: JSON){
		categoryId = "category_id" <~~ json
		createdAt = "created_at" <~~ json
		descriptionField = "description" <~~ json
		id = "id" <~~ json
		imageBg = "image_bg" <~~ json
		imageSmall = "image_small" <~~ json
		published = "published" <~~ json
		pushed = "pushed" <~~ json
		reference = "reference" <~~ json
		state = "state" <~~ json
		title = "title" <~~ json
		updatedAt = "updated_at" <~~ json
		userId = "user_id" <~~ json
	}

	//MARK: Encodable
	public func toJSON() -> JSON? {
		return jsonify([
		"category_id" ~~> categoryId,
		"created_at" ~~> createdAt,
		"description" ~~> descriptionField,
		"id" ~~> id,
		"image_bg" ~~> imageBg,
		"image_small" ~~> imageSmall,
		"published" ~~> published,
		"pushed" ~~> pushed,
		"reference" ~~> reference,
		"state" ~~> state,
		"title" ~~> title,
		"updated_at" ~~> updatedAt,
		"user_id" ~~> userId,
		])
	}

}

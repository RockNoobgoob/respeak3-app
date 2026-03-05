//
//  Supabasemanager.swift
//  ReSpeak
//
//  Created by Noah Hova on 3/5/26.
//

import Foundation
import Supabase

enum SupabaseManager {
    static let client: SupabaseClient = {
        guard
            let urlString = Bundle.main.object(forInfoDictionaryKey: "SUPABASE_URL") as? String,
            let anonKey = Bundle.main.object(forInfoDictionaryKey: "SUPABASE_ANON_KEY") as? String,
            let url = URL(string: urlString)
        else {
            fatalError("Missing SUPABASE_URL or SUPABASE_ANON_KEY. Check Info tab + Config.xcconfig.")
        }

        return SupabaseClient(supabaseURL: url, supabaseKey: anonKey)
    }()
}

#!/usr/bin/ruby

file_content = <<-CREDS_FILE_STRING
protocol EnvironmentProtocol {
    var baseURL: String { get }
    var apiKey: String { get }
}

struct ExternalCredentials {
    static let crashlyticsKey = "#{ENV['ONZ_CRASHLYTICS_API_KEY']}"
    struct DevEnv: EnvironmentProtocol {
    	let baseURL = "#{ENV['ONZ_DEV_BASE_URL']}"
    	let apiKey = "#{ENV['ONZ_DEV_BASE_URL_API_KEY']}"
    }
    
    struct TestEnv: EnvironmentProtocol {
        let baseURL = "#{ENV['ONZ_TEST_BASE_URL']}"
        let apiKey = "#{ENV['ONZ_TEST_BASE_URL_API_KEY']}"
    }
    
    struct PreProdEnv: EnvironmentProtocol {
		let baseURL = "#{ENV['ONZ_PREPROD_BASE_URL']}"
		let apiKey = "#{ENV['ONZ_PREPROD_BASE_URL_API_KEY']}"
	}
	
	struct ProdEnv: EnvironmentProtocol {
		let baseURL = "#{ENV['ONZ_PROD_BASE_URL']}"
		let apiKey = "#{ENV['ONZ_PROD_BASE_URL_API_KEY']}"
	}
}
CREDS_FILE_STRING

file = File.new("ONZ/SBC/ExternalCredentials.swift", "w")
file.puts(file_content)
file.close

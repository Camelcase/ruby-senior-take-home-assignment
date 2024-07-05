require 'json'
require 'uri'
require 'net/http'

module Vandelay
 module Integrations
   class Base

     attr_reader :base_url, :auth_token, :auth_id, :auth_path, :records_path,:record_path,:token_ident

     def initialize
       @auth_path =  ""
       @auth_id =  ""
       @records_path = ""
       @record_path = ""
       @base_url =  ""
       @token_ident =  ""
       @auth_token = fetch_auth_token
     end

     def fetch_auth_token
       uri = URI("http://#{base_url}#{auth_path}/#{auth_id}")

       begin
         response = Net::HTTP.get_response(uri)
         token = JSON.parse(response.body)[@token_ident]
         token
       rescue StandardError => e
         raise HttpRequestError.new(response), "Auth request failed: #{e.message}"
       end
     end

     def get_auth_headers
       headers = {}
       headers['Authorization'] = "Bearer #{@auth_token}" unless @auth_token.nil? || @auth_token.empty?
       headers
     end

     def get_record(id)
       uri = URI("http://#{base_url}#{records_path}#{id}")
       begin
         response = Net::HTTP.get_response(uri, get_auth_headers)
         JSON.parse(response.body)
       rescue StandardError => e
         raise HttpRequestError.new(response), "request failed: #{e.message}"
       end
     end

     def get_mapped_record(id)
      data=self.get_record(id)
      {}
     end

     def get_all_records
       uri = URI("http://#{base_url}#{record_path}")
       begin
         response = Net::HTTP.get_response(uri, get_auth_headers)
         JSON.parse(response.body)
       rescue StandardError => e
         raise HttpRequestError.new(response), "request failed: #{e.message}"
       end
     end
   end
 end
end
module Request
  module JsonHelpers
    def json_response
        if response.body == "true"
          true
        elsif response.body == "false"
          false
        else
          puts JSON.parse(response.body, symbolize_names: true)
          @json_response ||= JSON.parse(response.body, symbolize_names: true)
        end
    end
  end

  module HeadersHelpers
    def api_header(version = 1)
      request.headers['Accept'] = "application/vnd.estudent_api.v#{version}"
    end

    def api_response_format(format = Mime::JSON)
      request.headers['Accept'] = "#{request.headers['Accept']},#{format}"
      request.headers['Content-Type'] = format.to_s
    end

    def api_authorization_header(token)
      request.headers['Authorization'] =  token
    end

    def include_default_accept_headers
      api_header
      api_response_format      
    end
  end
end
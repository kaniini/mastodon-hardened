# frozen_string_literal: true

class ProviderDiscovery < OEmbed::ProviderDiscovery
  class << self
    def discover_provider(url, options = {})
      res    = Request.new(:get, url).perform
      format = options[:format]

      raise OEmbed::NotFound, url if res.code != 200 || res.mime_type != 'text/html'

      html = Nokogiri::HTML(res.to_s)

      if format.nil? || format == :json
        provider_endpoint ||= html.at_xpath('//link[@type="application/json+oembed"]')&.attribute('href')&.value
        format ||= :json if provider_endpoint
      end

      if format.nil? || format == :xml
        provider_endpoint ||= html.at_xpath('//link[@type="application/xml+oembed"]')&.attribute('href')&.value
        format ||= :xml if provider_endpoint
      end

      raise OEmbed::NotFound, url if provider_endpoint.nil?
      begin
        provider_endpoint = Addressable::URI.parse(provider_endpoint)
        provider_endpoint.query = nil
        provider_endpoint = provider_endpoint.to_s
      rescue Addressable::URI::InvalidURIError
        raise OEmbed::NotFound, url
      end

      OEmbed::Provider.new(provider_endpoint, format)
    end
  end
end

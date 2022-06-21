# frozen_string_literal: true

require_relative 'ipgeobase/version'
require 'happymapper'
require 'net/http'
require 'addressable'

module Ipgeobase
  def self.lookup(ip_address)
    # сформировать адресс для запроса на ip-api
    uri = Addressable::Template.new('http://ip-api.com/xml/{segment}')
                               .expand({ 'segment' => ip_address })

    # получить данные от ip-api с помощью запроса
    response = Net::HTTP.get(uri)

    # вытащить метаданные из ответа
    ip_metadata = IpMetadata.parse_from_xml(response)

    # возврат объекта с метаданными
    IpMetadata.new(ip_metadata)
  end

  class IpMetadata
    attr_reader :city, :country, :country_code, :lat, :lon

    def initialize(ip_metadata)
      @country_code = ip_metadata[:country_code]
      @country      = ip_metadata[:country]
      @city         = ip_metadata[:city]
      @lat          = ip_metadata[:lat]
      @lon          = ip_metadata[:lon]
    end

    def self.parse_from_xml(xml)
      ip_metadata = HappyMapper.parse(xml)
      { city: ip_metadata.city, country: ip_metadata.country, lat: ip_metadata.lat,
        country_code: ip_metadata.country_code, lon: ip_metadata.lon }
    end
  end
end

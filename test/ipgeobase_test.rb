# frozen_string_literal: true

require "test_helper"

class IpgeobaseTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Ipgeobase::VERSION
  end

  def test_lookup
    response   = "<query>\n"\
    "  <status>success</status>\n"\
    "  <country>United States</country>\n"\
    "  <countryCode>US</countryCode>\n"\
    "  <region>VA</region>\n"\
    "  <regionName>Virginia</regionName>\n"\
    "  <city>Ashburn</city>\n"\
    "  <zip>20149</zip>\n"\
    "  <lat>39.03</lat>\n"\
    "  <lon>-77.5</lon>\n"\
    "  <timezone>America/New_York</timezone>\n"\
    "  <isp>Google LLC</isp>\n"\
    "  <org>Google Public DNS</org>\n"\
    "  <as>AS15169 Google LLC</as>\n"\
    "  <query>8.8.8.8</query>\n"\
    "</query>"
    stub_request(:any, "http://ip-api.com").to_return(body: response, status: 200)
    
    ip_address = '8.8.8.8'

    expected_city        = 'Ashburn'
    expected_country     = 'United States'
    expected_country_code = 'US'
    expected_lat         = '39.03'
    expected_lon         = '-77.5'

    result = Ipgeobase.lookup('8.8.8.8')

    assert { result.city        == expected_city }
    assert { result.country     == expected_country }
    assert { result.country_code == expected_country_code }
    assert { result.lat         == expected_lat }
    assert { result.lon         == expected_lon }
  end
end

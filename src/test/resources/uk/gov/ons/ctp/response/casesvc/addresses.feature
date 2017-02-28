# Author: Philippe Brossier 03/02/2016
#
# Keywords Summary : This feature file contains the scenario tests for the case frame - addresses - details are in the swagger spec
#										 https://github.com/ONSdigital/response-management-service/blob/master/casesvc-api/swagger.yml
#										 Note: Assumption that the DB has been loaded with seed data.
#
# Feature: List of Address scenarios: Get addresses by valid UPRN
#																			Get addresses by invalid UPRN
#																			Get addresses by valid Postcode
#																			Get addresses by invalid Postcode
# Feature Tags: @casesvc
#							  @frame
#
# Scenario Tags: @addresses

@casesvc @frame
Feature: Validating Addresses requests

  # GET /addresses/{uprnCode}
	# 200
  @addresses
  Scenario: Get request to the addresses endpoint for a specific UPRN
    When I make the GET call to the frameservice addresses endpoint for uprn "10090449474"
    Then the response status should be 200
    And the response should contain the field "uprn" with a long value of 10090449474
    And the response should contain the field "type" with value "HH"
    And the response should contain the field "estabType" with value "RD03"
    And the response should contain the field "category" with a null value
    And the response should contain the field "locality" with value "KETLEY"
    And the response should contain the field "organisationName" with a null value
    And the response should contain the field "line1" with value "9 GLEN COTTAGES"
    And the response should contain the field "line2" with value "BRICKHILL LANE"
    And the response should contain the field "townName" with value "TELFORD"
    And the response should contain the field "postcode" with value "TF1 5GJ"
    And the response should contain the field "outputArea" with value "E00071427"
    And the response should contain the field "lsoaArea" with value "E01014141"
    And the response should contain the field "msoaArea" with value "E02002936"
    And the response should contain the field "ladCode" with value "E06000020"
    And the response should contain the field "regionCode" with value "E12000005"
    And the response should contain the field "htc" with a null value
    And the response should contain the field "latitude" with a double value of 52.6973761348034
    And the response should contain the field "longitude" with a double value of -2.4699878314844

	# 404
  @addresses
  Scenario: Get request to the addresses endpoint for a non existing UPRN
    When I make the GET call to the frameservice addresses endpoint for uprn "1001"
    Then the response status should be 404
    And the response should contain the field "error.code" with value "RESOURCE_NOT_FOUND"
    And the response should contain the field "error.message" with value "No addresses found for uprn 1001"
    And the response should contain the field "error.timestamp"


	# GET /addresses/postcode/{postcode}
	# 200
  @addresses
  Scenario: Get request to the addresses endpoint for a specific postcode
    When I make the GET call to the frameservice addresses endpoint for postcode "TF13JD"
    Then the response status should be 200
    And the response should contain a JSON array of size 10
    And one element of the JSON array must be {"uprn":452079416,"type":"HH","estabType":"RD","category":null,"locality":"DOTHILL","organisationName":null,"line1":null,"line2":"17 THE SAVANNAHS","townName":"TELFORD","postcode":"TF1 3JD","outputArea":"E00071355","lsoaArea":"E01014130","msoaArea":"E02002933","ladCode":"E06000020","regionCode":"E12000005","htc":null,"latitude":52.7130078274703,"longitude":-2.52026879423693}
		And one element of the JSON array must be {"uprn":452079417,"type":"HH","estabType":"RD","category":null,"locality":"DOTHILL","organisationName":null,"line1":null,"line2":"18 THE SAVANNAHS","townName":"TELFORD","postcode":"TF1 3JD","outputArea":"E00071355","lsoaArea":"E01014130","msoaArea":"E02002933","ladCode":"E06000020","regionCode":"E12000005","htc":null,"latitude":52.7131876974839,"longitude":-2.52025612954124}
		And one element of the JSON array must be {"uprn":452079418,"type":"HH","estabType":"RD","category":null,"locality":"DOTHILL","organisationName":null,"line1":null,"line2":"19 THE SAVANNAHS","townName":"TELFORD","postcode":"TF1 3JD","outputArea":"E00071355","lsoaArea":"E01014130","msoaArea":"E02002933","ladCode":"E06000020","regionCode":"E12000005","htc":null,"latitude":52.7132237234453,"longitude":-2.52024175359439}
		And one element of the JSON array must be {"uprn":452079420,"type":"HH","estabType":"RD","category":null,"locality":"DOTHILL","organisationName":null,"line1":null,"line2":"20 THE SAVANNAHS","townName":"TELFORD","postcode":"TF1 3JD","outputArea":"E00071355","lsoaArea":"E01014130","msoaArea":"E02002933","ladCode":"E06000020","regionCode":"E12000005","htc":null,"latitude":52.7132687396577,"longitude":-2.52022748456782}
		And one element of the JSON array must be {"uprn":452079421,"type":"HH","estabType":"RD","category":null,"locality":"DOTHILL","organisationName":null,"line1":null,"line2":"21 THE SAVANNAHS","townName":"TELFORD","postcode":"TF1 3JD","outputArea":"E00071355","lsoaArea":"E01014130","msoaArea":"E02002933","ladCode":"E06000020","regionCode":"E12000005","htc":null,"latitude":52.7132956454685,"longitude":-2.52024260916862}
		And one element of the JSON array must be {"uprn":452079422,"type":"HH","estabType":"RD","category":null,"locality":"DOTHILL","organisationName":null,"line1":null,"line2":"22 THE SAVANNAHS","townName":"TELFORD","postcode":"TF1 3JD","outputArea":"E00071355","lsoaArea":"E01014130","msoaArea":"E02002933","ladCode":"E06000020","regionCode":"E12000005","htc":null,"latitude":52.7133224863256,"longitude":-2.52027253756631}
		And one element of the JSON array must be {"uprn":452079423,"type":"HH","estabType":"RD","category":null,"locality":"DOTHILL","organisationName":null,"line1":null,"line2":"23 THE SAVANNAHS","townName":"TELFORD","postcode":"TF1 3JD","outputArea":"E00071355","lsoaArea":"E01014130","msoaArea":"E02002933","ladCode":"E06000020","regionCode":"E12000005","htc":null,"latitude":52.7133583174276,"longitude":-2.52030257296034}
		And one element of the JSON array must be {"uprn":452079424,"type":"HH","estabType":"RD","category":null,"locality":"DOTHILL","organisationName":null,"line1":null,"line2":"24 THE SAVANNAHS","townName":"TELFORD","postcode":"TF1 3JD","outputArea":"E00071355","lsoaArea":"E01014130","msoaArea":"E02002933","ladCode":"E06000020","regionCode":"E12000005","htc":null,"latitude":52.7134481549962,"longitude":-2.52031844637953}
		And one element of the JSON array must be {"uprn":452079425,"type":"HH","estabType":"RD","category":null,"locality":"DOTHILL","organisationName":null,"line1":null,"line2":"25 THE SAVANNAHS","townName":"TELFORD","postcode":"TF1 3JD","outputArea":"E00071355","lsoaArea":"E01014130","msoaArea":"E02002933","ladCode":"E06000020","regionCode":"E12000005","htc":null,"latitude":52.7134841809637,"longitude":-2.52030407039994}
		And one element of the JSON array must be {"uprn":452079419,"type":"HH","estabType":"RD","category":null,"locality":"DOTHILL","organisationName":null,"line1":null,"line2":"2 THE SAVANNAHS","townName":"TELFORD","postcode":"TF1 3JD","outputArea":"E00071355","lsoaArea":"E01014130","msoaArea":"E02002933","ladCode":"E06000020","regionCode":"E12000005","htc":null,"latitude":52.7133889876974,"longitude":-2.51945907718477}

	# 404    
  @addresses
  Scenario: Get request to the addresses endpoint for a non existing postcode
    When I make the GET call to the frameservice addresses endpoint for postcode "AA231AA"
    Then the response status should be 404
    And the response should contain the field "error.code" with value "RESOURCE_NOT_FOUND"
    And the response should contain the field "error.message" with value "No addresses found for postcode AA231AA"
    And the response should contain the field "error.timestamp"

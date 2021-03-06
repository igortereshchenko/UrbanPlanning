%Calculate distance in meters between two points on google map
function [ distance ] = GoogleMapsDistance(origins_coordinates,  destinations_coordinates,API_KEY)

% Manual: https://developers.google.com/maps/documentation/distance-matrix/intro?hl=en

% Input : origins_coordinates - [latitude longitude]
%         destinations_coordinates - [latitude longitude]
%         API_KEY - your google API KEY
% Return: distance - double value



% Check to see if address is a valid string
if isempty(origins_coordinates) || isempty(destinations_coordinates)
    error('Invalid coordinates provided');
end


%convert  coordinates to query parameter
%[latitude longitude] => 'latitude,longitude'

origins=strcat(num2str(origins_coordinates(1)),',',num2str(origins_coordinates(2)));
destinations=strcat(num2str(destinations_coordinates(1)),',',num2str(destinations_coordinates(2)));

queryUrl = sprintf('https://maps.googleapis.com/maps/api/distancematrix/json?origins=%s&destinations=%s&mode=walking&key=%s', origins,destinations,API_KEY);

try
    json_data=urlread(queryUrl);
catch 
    error('Error, could not reach server, is it a valid URL %s?', queryUrl);
end
   
distance = ParseGoogleMapsJSONDistance(json_data);

end

% Function to parse the XML response from Google Maps
function [distance] = ParseGoogleMapsJSONDistance(json_data)
    map_data=JSON.parse(json_data);
    distance=map_data.rows{1,1}.elements{1,1}.distance.value;
end

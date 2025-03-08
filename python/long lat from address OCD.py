import requests
import urllib.parse
import os
from dotenv import load_dotenv

# Load environment variables from .env file
load_dotenv()

# Get API key from environment variables
api_key = os.getenv('OPENCAGE_API_KEY')
if not api_key:
    raise ValueError("OPENCAGE_API_KEY not found in environment variables")

# Address to geocode
address = "19632 Lanview Ln, Santa Clarita, CA 91350, USA"
encoded_address = urllib.parse.quote(address)

# Create the URL with encoded address
url = f"https://api.opencagedata.com/geocode/v1/json?q={encoded_address}&key={api_key}&limit=1"

# Print the URL (excluding API key for security)
print(f"Requesting: https://api.opencagedata.com/geocode/v1/json?q={encoded_address}&key=****&limit=1")

# Make the request
response = requests.get(url)

# Check if the request was successful
print(f"Status code: {response.status_code}")

# Process the response
if response.status_code == 200:
    data = response.json()
    if data['results'] and len(data['results']) > 0:
        location = data['results'][0]
        lat = location['geometry']['lat']
        lng = location['geometry']['lng']
        print(f"Latitude: {lat}, Longitude: {lng}")
        
        # Print additional information if available
        if 'formatted' in location:
            print(f"Formatted address: {location['formatted']}")
        if 'confidence' in location:
            print(f"Confidence: {location['confidence']}/10")
    else:
        print("No results found for the address")
else:
    print(f"Error: {response.status_code}")
    print(response.text)
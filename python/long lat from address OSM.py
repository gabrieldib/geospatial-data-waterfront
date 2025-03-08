import requests
import urllib.parse

# Properly encode the address for URL
address = "19632 Lanview Ln, Santa Clarita, CA 91350, USA"
encoded_address = urllib.parse.quote(address)

# Create the URL with encoded address
url = f"https://nominatim.openstreetmap.org/search?q={encoded_address}&format=json&addressdetails=1&limit=1"

# Add headers with a User-Agent as required by Nominatim's usage policy
headers = {
    "User-Agent": "GeocodingScript/1.0 (gabriel@gabrieldib.com)"  # Replace with your actual email
}

# Print the URL to verify it's properly formatted
print(f"Requesting: {url}")

# Make the request with headers
response = requests.get(url, headers=headers)

# Check if the request was successful
print(f"Status code: {response.status_code}")

# Process the response
if response.status_code == 200:
    data = response.json()
    if data:
        location = data[0]
        print(f"Latitude: {location['lat']}, Longitude: {location['lon']}")
    else:
        print("No results found for the address")
else:
    print(f"Error: {response.status_code}")
    print(response.text)
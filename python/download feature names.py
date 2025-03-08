import os
import requests
from bs4 import BeautifulSoup

def download_zip_files(url, download_dir="Feature_Names"):
    # Create download directory if it doesn't exist
    os.makedirs(download_dir, exist_ok=True)
    
    # Get the HTML content of the page
    response = requests.get(url)
    response.raise_for_status()  # ensure we notice bad responses

    # Parse the HTML using BeautifulSoup
    soup = BeautifulSoup(response.text, "html.parser")
    
    # Find all <a> tags with href ending with '.zip'
    zip_links = [a["href"] for a in soup.find_all("a", href=True) if a["href"].endswith(".zip")]
    
    print(f"Found {len(zip_links)} zip files.")
    
    for link in zip_links:
        # Build the full URL (the links are relative)
        file_url = url + link
        local_path = os.path.join(download_dir, link)
        print(f"Downloading {file_url} ...")
        
        # Stream the download and write to file in chunks
        with requests.get(file_url, stream=True) as r:
            r.raise_for_status()
            with open(local_path, "wb") as f:
                for chunk in r.iter_content(chunk_size=8192):
                    if chunk:  # filter out keep-alive chunks
                        f.write(chunk)
        print(f"Saved to {local_path}")

if __name__ == "__main__":
    base_url = "https://www2.census.gov/geo/tiger/TIGER2024/FEATNAMES/"
    download_zip_files(base_url)

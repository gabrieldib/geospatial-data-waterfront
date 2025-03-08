import os
import hashlib
import requests
from bs4 import BeautifulSoup
from concurrent.futures import ProcessPoolExecutor, as_completed

def compute_local_md5(file_path, chunk_size=8192):
    """Compute MD5 checksum of a local file."""
    md5 = hashlib.md5()
    with open(file_path, "rb") as f:
        for chunk in iter(lambda: f.read(chunk_size), b""):
            md5.update(chunk)
    return md5.hexdigest()

def compute_remote_md5(url, chunk_size=8192):
    """Compute MD5 checksum of a remote file by streaming its content."""
    md5 = hashlib.md5()
    with requests.get(url, stream=True) as r:
        r.raise_for_status()
        for chunk in r.iter_content(chunk_size=chunk_size):
            if chunk:
                md5.update(chunk)
    return md5.hexdigest()

def process_zip_file(file_url, download_dir):
    """Worker function: checks local vs. remote checksums, downloads if needed."""
    # Extract the filename from the URL
    filename = file_url.split('/')[-1]
    local_path = os.path.join(download_dir, filename)

    # If the file already exists, compare checksums
    if os.path.exists(local_path):
        print(f"[PID {os.getpid()}] Checking local file: {local_path}")
        local_checksum = compute_local_md5(local_path)
        print(f"[PID {os.getpid()}] Local checksum:  {local_checksum}")
        
        print(f"[PID {os.getpid()}] Computing remote checksum for: {filename}")
        remote_checksum = compute_remote_md5(file_url)
        print(f"[PID {os.getpid()}] Remote checksum: {remote_checksum}")
        
        if local_checksum == remote_checksum:
            print(f"[PID {os.getpid()}] Skipping {filename} (checksums match).")
            return f"Skipped: {filename}"
        else:
            print(f"[PID {os.getpid()}] Checksum mismatch for {filename}. Re-downloading.")

    # Otherwise (or checksums mismatch), download
    print(f"[PID {os.getpid()}] Downloading {filename} ...")
    with requests.get(file_url, stream=True) as r:
        r.raise_for_status()
        with open(local_path, "wb") as f:
            for chunk in r.iter_content(chunk_size=8192):
                if chunk:
                    f.write(chunk)
    print(f"[PID {os.getpid()}] Saved to {local_path}")
    return f"Downloaded: {filename}"

def download_zip_files(base_url, download_dir="all_lines", max_workers=None):
    os.makedirs(download_dir, exist_ok=True)

    # Fetch the list of zip files from the remote page
    response = requests.get(base_url)
    response.raise_for_status()
    soup = BeautifulSoup(response.text, "html.parser")

    # Build the list of zip URLs
    zip_links = [
        base_url + a["href"] for a in soup.find_all("a", href=True) 
        if a["href"].endswith(".zip")
    ]
    print(f"Found {len(zip_links)} zip files.")

    # Default to using all logical CPU cores
    if max_workers is None:
        max_workers = os.cpu_count() or 4

    print(f"Using up to {max_workers} processes.")
    
    # Use a ProcessPoolExecutor for true parallelism (CPU-bound tasks)
    results = []
    with ProcessPoolExecutor(max_workers=max_workers) as executor:
        # Submit one task per file
        future_to_url = {
            executor.submit(process_zip_file, url, download_dir): url
            for url in zip_links
        }

        # Collect results as they complete
        for future in as_completed(future_to_url):
            url = future_to_url[future]
            try:
                result = future.result()
                results.append(result)
            except Exception as exc:
                print(f"Error processing {url}: {exc}")
    
    print("All tasks completed.")
    print("Summary:")
    for r in results:
        print(" -", r)

if __name__ == "__main__":
    base_url = "https://www2.census.gov/geo/tiger/TIGER2024/EDGES/"
    download_zip_files(base_url)

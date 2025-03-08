import os
import hashlib
import requests

def compute_local_md5(file_path, chunk_size=8192):
    """Compute MD5 checksum of a local file."""
    md5 = hashlib.md5()
    with open(file_path, "rb") as f:
        while chunk := f.read(chunk_size):
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

if __name__ == "__main__":
    # Replace these with the file you want to test.
    remote_url = "https://www2.census.gov/geo/tiger/TIGER2024/EDGES/tl_2024_01019_edges.zip"
    local_file = "all_lines/tl_2024_01019_edges.zip"
    
    if not os.path.exists(local_file):
        print(f"Local file {local_file} does not exist. Please download it first.")
    else:
        print("Computing local checksum...")
        local_checksum = compute_local_md5(local_file)
        print("Local checksum:", local_checksum)
        
        print("Computing remote checksum...")
        remote_checksum = compute_remote_md5(remote_url)
        print("Remote checksum:", remote_checksum)
        
        if local_checksum == remote_checksum:
            print("Checksums match! You can use the checksum approach.")
        else:
            print("Checksums do NOT match. Something may be off.")

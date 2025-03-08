import os
import zipfile

def unzip_to_named_folder(directory="E:/dev/geospatial-data/data/all_lines"):
    # Iterate over all files in the directory
    for filename in os.listdir(directory):
        if filename.lower().endswith(".zip"):
            zip_path = os.path.join(directory, filename)
            # Create a folder with the same name as the ZIP file (without the .zip extension)
            folder_name = filename[:-4]  # remove the '.zip'
            extract_path = os.path.join(directory, folder_name)
            os.makedirs(extract_path, exist_ok=True)
            print(f"Extracting {zip_path} into {extract_path}...")
            with zipfile.ZipFile(zip_path, "r") as zip_ref:
                zip_ref.extractall(extract_path)
            print(f"Finished extracting {filename}.")

if __name__ == "__main__":
    unzip_to_named_folder()

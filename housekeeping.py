# MIT License
# (c) 2021-2023 sshannigrahi <sshannigrahi@tntech.edu>

import argparse
import os
import re
import shutil

class FileOrganizer:
    def __init__(self, dir_path):
        self.dir_path = dir_path

    def organize_files(self):
        for file_name in os.listdir(self.dir_path):
            # check if the file has the expected format
            if not re.match(r'output-.+-\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z\.pcapng\.zst', file_name):
                continue

            # extract the date from the filename using regular expressions
            date = re.findall(r'\d{4}-\d{2}-\d{2}', file_name)[0]

            # extract the subdirectory name
            subdir_name = re.findall(r'output-(.*)-'+date, file_name)[0]

            # create the main directory with the extracted date
            main_dir_path = os.path.join(self.dir_path, date)
            os.makedirs(main_dir_path, exist_ok=True)

            # create the subdirectory with the extracted name
            # sub_dir_path = os.path.join(main_dir_path, subdir_name)
            # os.makedirs(sub_dir_path, exist_ok=True)

            # move the file to the subdirectory
            old_file_path = os.path.join(self.dir_path, file_name)
            new_file_path = os.path.join(main_dir_path, file_name)
            shutil.move(old_file_path, new_file_path)

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Organize files based on filename.')
    parser.add_argument('-d', '--dir', type=str, required=True, help='Directory path')
    args = parser.parse_args()

    organizer = FileOrganizer(args.dir)
    organizer.organize_files()

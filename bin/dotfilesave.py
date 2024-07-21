#!/usr/bin/python3

import os
import shutil
import argparse
import logging
from os.path import exists, join


logging.basicConfig(
    format='%(asctime)s %(message)s',
    level=logging.INFO,
    datefmt='%Y-%m-%d %H:%M:%S'
)
logger = logging.getLogger(__name__)
logger.setLevel(logging.DEBUG)


DOTFILES_LOCATION = os.getenv("DOTFILES_SAVE_LOCATION", None)


def main():

    if DOTFILES_LOCATION is None:
        logger.critical("No dotfile save location")
        return

    parser = argparse.ArgumentParser(
        description='Saves a file or a directory as a dotfile'
    )

    parser.add_argument(
        "file",
        help="The file/directory that you want to save a dotfile"
    )

    args = vars(parser.parse_args())

    file = args["file"]

    # if supplied file in the parameter does not exists, exit the program
    if not exists(file):
        logger.critical("%s does not exist", file)
        return

    working_dir = os.getcwd()
    working_location = join(working_dir, file)
    logger.debug(f"Current working directory - {working_location}")

    filename = os.path.basename(file)
    target_location = join(DOTFILES_LOCATION, filename)
    logger.debug(f"Target File location - {target_location}")

    return


    # check if the user only wants to track progress
    if args["track_progress"]:
        True

if __name__ == "__main__":
    main()

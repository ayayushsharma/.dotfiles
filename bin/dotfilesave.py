#!/usr/bin/python3

import os
import shutil
import errno
import argparse
import logging
import pathlib
from os.path import exists, join, isfile, islink, isdir

logging.basicConfig(
    format='%(asctime)s %(message)s',
    level=logging.INFO,
    datefmt='%Y-%m-%d %H:%M:%S'
)
logger = logging.getLogger(__name__)
logger.setLevel(logging.INFO)


DOTFILES_LOCATION = os.getenv("DOTFILES_SAVE_LOCATION", None)

parser = argparse.ArgumentParser(
    description='Saves a file or a directory as a dotfile'
)

parser.add_argument(
    "file",
    help="The file/directory that you want to save in dotfiles configs",
)

parser.add_argument(
    "save_as",
    help="Rename the file/dir as",
    nargs='?',
    default=".",
)

parser.add_argument(
    '-v',
    "--verbose",
    action='store_true',
    help="To add more verbosity to code"
)

args = vars(parser.parse_args())

if args["verbose"]:
    logger.setLevel(logging.DEBUG)


def copy_file_tree(source, target):
    try:
        shutil.copytree(source, target)
    except OSError as e:
        if e.errno in (errno.ENOTDIR, errno.EINVAL):
            shutil.copy(source, target)
        else:
            raise Exception("Copy Failed")


def remove(path):
    if isfile(path) or islink(path):
        os.remove(path)
    elif isdir(path):
        shutil.rmtree(path)
    else:
        Exception(f"{path} - Is neither file, link, or dir")


def main():

    if DOTFILES_LOCATION is None:
        logger.critical("No dotfile save location")
        return

    arg_file = args["file"]
    save_as = args["save_as"]

    logger.debug(f"Source File - {arg_file}")
    logger.debug(f"Save as - {save_as}")

    # if supplied file in the parameter does not exists, exit the program
    if not exists(arg_file):
        logger.critical("%s does not exist", arg_file)
        return

    filename = os.path.basename(arg_file)
    working_dir = os.getcwd()

    working_location = join(working_dir, arg_file)
    logger.debug(f"Current working directory - {working_location}")

    if save_as == '.':
        target_location = join(DOTFILES_LOCATION, filename)
    else:
        target_location = join(DOTFILES_LOCATION, save_as)
    logger.debug(f"Target File location - {target_location}")

    # if file already exists in dotfiles dir, exit the program
    if exists(target_location):
        logger.critical(f"{filename} already exists in dotfiles")
        return

    # Copy the file to dotfiles save location
    try:
        logger.debug(f"Copying from {working_location} to {target_location} - start")
        copy_file_tree(working_location, target_location)
        logger.debug(f"Copying from {working_location} to {target_location} - end")
    except Exception as e:
        logger.critical("Error occured. Halting execution")
        logger.exception(e)
        return

    # remove the working directory file
    try:
        logger.debug(f"Removing {working_location} - start")
        remove(working_location)
        logger.debug(f"Removing {working_location} - end")
    except Exception as e:
        logger.critical("Error occured. Halting execution")
        logger.exception(e)
        return

    # create symlink from target file to symlink file
    try:
        logger.debug(f"Symlinking {working_location} to {target_location}- start")
        os.symlink(target_location, working_location)
        logger.debug(f"Symlinking {working_location} to {target_location}- end")
    except Exception as e:
        logger.critical("Failed to create symlink")
        logger.exception(e)
        return

    logger.debug("Saving files to dotfiles - complete")
    return


if __name__ == "__main__":
    main()

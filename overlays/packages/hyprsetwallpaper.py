#!/usr/bin/env python3

# TODO: Make this more swww agnostic
# swww supports querying the monitor configuration
import argparse
from pathlib import Path
from shutil import copyfile
import uuid
import os
from subprocess import check_output, run, STDOUT
from PIL import Image

WAL_CACHE_DIR = Path.home() / ".cache" / "wallpaper"
WAL_SAVE_DIR = Path.home() / "media" / "picture"
WALLRND_CONFIG = Path.home() / ".config" / "wallrnd" / "wallrnd.toml"


def setwallpaper(config):
    for monitor_id, wallpaper_path in config.items():
        default_file = f"wal{monitor_id}.png"
        copyfile(wallpaper_path, WAL_SAVE_DIR / default_file)
        cmd = f"swww img -o {monitor_id} {WAL_SAVE_DIR / default_file}"
        print(cmd)
        print(check_output(cmd, shell=True))


def crop_png(image_path, monitors_info):
    conf = {}
    if not image_path.exists():
        raise FileNotFoundError(image_path)

    image = Image.open(image_path)
    # The name of the wallpaper need to be different each time,
    # so it gets reloaded.
    prefix = str(uuid.uuid4())[:8]
    for monitor_id, monitor_conf in monitors_info.items():
        print(list(monitor_conf))
        path = f"{WAL_CACHE_DIR}/wal{prefix}-{monitor_id}.png"
        image.crop(monitor_conf).save(path, "PNG")
        conf[monitor_id] = path

    return conf


def parse_monitor_info(monitors):
    """
    Sample input:

    Monitor DP-1 (ID 0):
        1920x1080@144 at 1920x597
        active workspace: 1 (1)
        reserved: 0 0 0 0

    Monitor HDMI-A-1 (ID 1):
        1920x1080@60 at 0x1024
        active workspace: 2 ()
        reserved: 0 0 0 0
    """
    monitor_info = {}
    for monitor in monitors:
        monitor_id = monitor.split(" ")[1]
        monitor_state = monitor.split("\n\t")[1].split()
        if len(monitor_state) != 3:
            raise ValueError("Error: Unexpected output from hyprctl")

        monitor_res = monitor_state[0].split("@")[0]
        size = [int(xy) for xy in monitor_res.split("x")]
        offsets = [int(dxdy) for dxdy in monitor_state[-1].split("x")]

        if len(size) != 2 or len(offsets) != 2:
            raise ValueError("Error: Unexpected output from hyprctl")

        coordinates = offsets + [size[0] + offsets[0], size[1] + offsets[1]]
        monitor_info[monitor_id] = coordinates

    return monitor_info


def run_wallrnd(monitor_info):
    wallrnd_svg = WAL_CACHE_DIR / "wallrnd.svg"
    wallrnd_png = WAL_SAVE_DIR / "wallrnd.png"

    max_width = max(dims[0] + dims[2] for dims in monitor_info.values())
    max_heigth = max(dims[1] + dims[3] for dims in monitor_info.values())
    print(max_width, max_heigth)

    run(
        [
            "wallrnd",
            "--verbose",
            "WIP",
            "--config",
            str(WALLRND_CONFIG),
            "--image",
            str(wallrnd_svg),
            "--width",
            str(max_width),
            "--height",
            str(max_heigth),
            "--nice",
        ],
        stderr=STDOUT,
    )

    # Convert to png, inkscape is faster than wallrnd
    run(
        [
            "inkscape",
            "-w",
            str(max_width),
            "-h",
            str(max_heigth),
            wallrnd_svg,
            "-o",
            wallrnd_png,
        ]
    )

    return wallrnd_png


def get_monitors():
    output = run(["hyprctl", "monitors"], capture_output=True).stdout
    return output.decode().strip("\n\n\n").split("\n\n")


def set_hyprland_instance_signature():
    KEY = "HYPRLAND_INSTANCE_SIGNATURE"
    if os.getenv(KEY):
        return

    subdirs = [d for d in Path("/tmp/hypr").iterdir() if d.is_dir()]
    latest = max(subdirs, key=os.path.getmtime)

    instance_signature = latest.name
    print(f"Setting instance signature to {instance_signature}")

    os.putenv(KEY, instance_signature)


def main():
    parser = argparse.ArgumentParser(description="Set wallpaper with hyprland")
    parser.add_argument("-f", "--file", help="Wallpaper file name")
    parser.add_argument(
        "-g",
        "--generate",
        action="store_true",
        help="Generate a wallpaper via wallrnd (needs to be installed)",
    )
    parser.add_argument(
        "-c",
        "--crop",
        action="store_true",
        help=("Cut the wallpaper into pices, " "that fit your monitor configuration"),
    )
    args = parser.parse_args()
    if not args.generate and not args.file:
        parser.print_help()
        return -1

    if not WAL_CACHE_DIR.exists():
        WAL_CACHE_DIR.mkdir()

    set_hyprland_instance_signature()

    monitors = get_monitors()
    monitor_info = parse_monitor_info(monitors)
    file = args.file
    if args.generate:
        file = run_wallrnd(monitor_info)

    config = {monitor_name: file for monitor_name in monitor_info.keys()}
    if args.crop:
        config = crop_png(file, monitor_info)

    setwallpaper(config)


if __name__ == "__main__":
    main()

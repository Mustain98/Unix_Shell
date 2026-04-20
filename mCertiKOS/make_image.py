#!/usr/bin/env python3

"""
Following instructions will create a disk image with following disk geometry parameters:
* size in megabytes = 64
* amount of cylinders = 130
* amount of headers = 16
* amount of sectors per track = 63
"""

import os
import re
import shlex
import subprocess
import sys


class color:
    HEADER = "\033[95m"
    OKBLUE = "\033[94m"
    OKGREEN = "\033[92m"
    WARNING = "\033[93m"
    FAIL = "\033[91m"
    ENDC = "\033[0m"
    BOLD = "\033[1m"
    UNDERLINE = "\033[4m"


def info(c, s):
    print(c + s + color.ENDC)


def panic(s):
    print(color.BOLD + color.FAIL + s + color.ENDC)
    sys.exit(1)


def run(cmd):
    if os.system(cmd) != 0:
        panic("%s executed with error. exit." % cmd)


def exe(cmd):
    proc = subprocess.Popen(shlex.split(cmd), stdout=subprocess.PIPE)
    (out, err) = proc.communicate()
    return out.decode("utf-8") if isinstance(out, bytes) else out


def grep(s, pattern):
    return "\n".join(re.findall(r"^.*%s.*?$" % pattern, s, flags=re.M))


info(color.HEADER, "Building Certikos Image...")

info(color.HEADER, "\ncreating disk...")
run(("dd if=/dev/zero of=certikos.img bs=512 count=%d" % (130 * 16 * 63)))

# Manually write the MBR partition table instead of using `parted`
# Partition 1: Active(0x80), Type(0x83), Start LBA(2048 = 0x800), Size(128992 = 0x1F7E0)
import struct
with open("certikos.img", "r+b") as f:
    f.seek(446)
    # Status(1), CHSStart(3), Type(1), CHSEnd(3), LBAStart(4), LBALen(4)
    # 0x80, \x00\x00\x00, 0x83, \x00\x00\x00, 2048, 128992
    f.write(struct.pack("<B 3B B 3B I I", 0x80, 0, 0, 0, 0x83, 0, 0, 0, 2048, 128992))
    f.seek(510)
    f.write(b'\x55\xAA')

info(color.OKGREEN, "done.")

info(color.HEADER, "\nwriting mbr...")
run("dd if=obj/boot/boot0 of=certikos.img bs=446 count=1 conv=notrunc")
run("dd if=obj/boot/boot1 of=certikos.img bs=512 count=62 seek=1 conv=notrunc")
info(color.OKGREEN, "done.")

info(color.HEADER, "\ncopying kernel files...")
loc = 2048

info(color.OKBLUE, "kernel starts at sector %d" % loc)
run("dd if=obj/kern/kernel of=certikos.img bs=512 seek=%d conv=notrunc" % loc)

info(color.OKGREEN + color.BOLD, "\nAll done.")
sys.exit(0)


# Package

version       = "0.1.0"
author        = "neroist"
description   = "morse code to binary"
license       = "MIT"
srcDir        = "src"
bin           = @["morse2bin"]


# Dependencies

requires "nim >= 1.6.10"
requires "cligen"
requires "zippy"
requires "fab"

import std/strutils

import cligen
import zippy
import fab

proc parseMorseCode*(sep=' ', code: string): seq[byte] = 
  var words = code.split(sep)
  var bin: string

  words.add "...-.-" # eot

  for i in words:
    for j in i.strip().replace(" ", ""):
      if j == '-':
        bin.add '1'
      else:
        bin.add '0'

  if not (bin.len mod 8 == 0):
    for i in 0 .. (bin.len mod 8):
      bin.add '0'

  for i in countup(0, bin.len() - 8, 8):
    result.add parseBinInt(bin[i..<i+8]).byte

proc main(morse: string, file = true, compress = false, sep = ' ', `out` = "out.morse", level = DefaultCompression, fmt = "gzip") = 
  ## Compress morse code and output it

  let dataFormat = case fmt
    of "detect", "d":
      dfDetect
    of "zlib", "z":
      dfZlib
    of "deflate", "f":
      dfDeflate
    of "gzip", "g":
      dfGzip
    else:
      yellow "[!] Invalid data format, defaulting to GZIP"

      dfGzip

  let compressionLevel = if level in [0, 1, 9, -1, 2]:
      level
    else:
      yellow "[!] Invalid compression level, defaulting to DefaultCompression (-1)"
      
      DefaultCompression

  let code = parseMorseCode(sep): 
    if file: 
      readFile(morse)
    else: 
      morse
  
  if compress:
    let compressed = compress(cstring cast[string](code), code.len, compressionLevel, dataFormat)

    `out`.writeFile(compressed)
  else:
    `out`.writeFile(code)

dispatch main, cmdName = "morse2bin"

global.chai = require 'chai'
global.expect = chai.expect
global.assert = chai.assert

# mocha --reporter html-cov > coverage.html && open coverage.html
require("coffee-coverage").register
  path: "relative" # sets the amouth of patgsh you see in output none = user.coffee, abbr = s/c/m/user.coffe, full = src/client/model/user.coffee
  basePath: __dirname + "/../src" #go up to webclient root directory
  # initAll: true #uncomment if you want to see all files no just files required() in tests


fs = require 'fs'

global.rmDir = (dirPath) ->
  try
    files = fs.readdirSync(dirPath)
  catch e
    throw e
    return
  if files.length > 0
    i = 0

    while i < files.length
      filePath = dirPath + "/" + files[i]
      if fs.statSync(filePath).isFile()
        fs.unlinkSync filePath
      else
        rmDir filePath
      i++
  fs.rmdirSync dirPath

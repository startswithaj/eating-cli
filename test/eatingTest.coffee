# These tests are terrible.
sh = require 'execSync'
fs = require 'fs'

describe 'Eating', ->
  after -> 
    result = sh.exec('coffee src/main.coffee --reset')
    rmDir __dirname + '/eatingData'

  it 'set local db path', ->
    result = sh.exec('coffee src/main.coffee --path ' + __dirname + '/eatingData')
    expect(result.stdout).to.have.string "Configuration saved successfully."

  it 'no params', ->
    result = sh.exec('coffee src/main.coffee')
    expect(result.stdout).to.have.string "No meals yet today"

  it 'add a meal', ->
    result = sh.exec('coffee src/main.coffee 7 ham and pineapple pizzas 2 hours ago 7000!')
    expect(result.stdout).to.have.string "7 Ham & Pineapple Pizzas"

  it 'list today', ->
    result = sh.exec('coffee src/main.coffee list today')
    expect(result.stdout).to.have.string "7 Ham & Pineapple Pizzas"

  it 'list today', ->
    result = sh.exec('coffee src/main.coffee list today')
    expect(result.stdout).to.have.string "7 Ham & Pineapple Pizzas"

  it 'export list today', ->
    result = sh.exec('coffee src/main.coffee list today --txt ' + __dirname + '/foods.txt')
    expect(result.stdout).to.have.string "Finished writing"
    text = fs.readFileSync(__dirname + '/foods.txt').toString()
    expect(text).to.have.string "7 Ham & Pineapple Pizzas"
    fs.unlinkSync(__dirname + '/foods.txt')

  it 'remove meal', ->
    result = sh.exec('coffee src/main.coffee remove last')
    expect(result.stdout).to.have.string "Meal Deleted."
    result = sh.exec('coffee src/main.coffee remove last')
    expect(result.stdout).not.to.have.string "7 Ham & Pineapple Pizzas"


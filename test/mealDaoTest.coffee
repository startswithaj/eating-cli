# mealDaoTest
MealDao = require '../src/mealDao'
sugar   = require 'sugar'

testdataDir = __dirname + '/eatingDataMealDao'
mealDao = new MealDao(testdataDir)


describe "MealDao", ->

  after -> 
    rmDir testdataDir

  describe 'Create', ->
    it 'Meal', (done) ->
      meal = 
        "date":new Date()
        "foods":"Green Salad"
        "calories":150
        "important":true
      mealDao.createMeal meal, ->
        done()
    it 'Meal 2', (done) ->
      meal = 
        "date":new Date()
        "foods":"Green Salad"
        "calories":7000
        "important":false
      mealDao.createMeal meal, ->
        done()
    it "meals between dates", (done) ->
      start = Date.create().beginningOfDay()
      end = Date.create().endOfDay()
      mealDao.findBetweenDates start, end, (err, meals) ->
        chai.assert.equal meals.length, 2
        done()

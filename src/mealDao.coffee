#db
tungus = require 'tungus'
mongoose = require 'mongoose'
Meal = require './models/meal'

# console.log "Running mongoose version %s", mongoose.version

module.exports = class MealDao
  constructor: (configDBPath) ->
    # Schema
    @Meal = Meal
    @configDBPath = configDBPath
    @connect()

  connect: (cb) ->
    connectionStr = "tingodb://" + @configDBPath
    # console.log "tingodb://" + @consfigDBPath
    mongoose.connect connectionStr, (err) ->
      # console.log mongoose.models.Meal.db
      if err
        console.log "Could not connect to local database"
        throw err

  disconnect: ->
    mongoose.disconnect();

  createMeal: (meal, cb) ->
    @Meal.create
      date: meal.date
      foods: meal.foods
      calories: meal.calories
      important: meal.important
    , (err, meal) =>
      if err
        console.error "Could not write meal to database"
        throw err
      else
        cb(null, meal)

  updateMeal: (id, meal, cb) ->
    Meal.findByIdAndUpdate id, $set:
      date: meal.date
      foods: meal.foods
      calories: meal.calories
      important: meal.important
    , cb

  deleteMeal: (id, cb) ->
    Meal.findById id, (err, meal) ->
      if err or not meal
        cb "Could not find Meal to delete"
      else
        meal.remove cb

  findBetweenDates: (startDate, endDate, cb) ->
    Meal.find(date:
      $gte: startDate
      $lt: endDate
    ).sort({'date': 1}).exec cb

  findAll: (cb) ->
    Meal.find().sort({'date': 1}).exec cb

  getLastMeal: (cb) ->
    Meal.findOne {}, {}, { sort: { '_id' : -1 } }, cb

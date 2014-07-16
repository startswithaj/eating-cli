sugar       = require 'sugar'
colors      = require 'colors'
_           = require 'underscore'
nconf       = require 'nconf'

EatingUtils = require 'eating-utils'
MealDao     = require './mealDao'
fs          = require 'fs'

meals2Text = new EatingUtils.Meals2Text()

module.exports = class eating 

  constructor: (mealDao) ->
    @homeDir = process.env.HOME or process.env.HOMEPATH or process.env.USERPROFILE
    nconf.use "file",
      file: @homeDir + "/.eating"
    nconf.load()
    nconf.defaults
      'dbPath': @homeDir + '/.eatingdata'
      # 'confirmParse': true
    # confirmParse = nconf.get('confirmParse')

    locale = nconf.get('locale')
    if locale
      Date.setLocale(locale)

    dbPath = nconf.get('dbPath')

    @mealDao = mealDao or new MealDao(dbPath)

  showToday: =>
    startDate = Date.create().beginningOfDay()
    endDate = Date.create().endOfDay()
    @mealDao.findBetweenDates startDate, endDate, (err, meals) ->
      if err
        console.log "Could not find meals.", err
      else if meals.length is 0
        console.log "No meals yet today."
      else
        meals2Text.toConsole meals

  outputMeals: (startDate, endDate, options) =>
    cb = (err, meals) ->
      if err
        console.log "Could not find meals", err
      else if meals.length is 0
        console.log "No Meals for those date/s"
        console.log 'Start Date:', startDate
        console.log 'End Date:', endDate
      else
        if options?.txt
          fs.writeFile options.txt, meals2Text.toTxt(meals, "Eating Food Diary"), (err) ->
            if (err) 
              return console.log(err)
            console.log('Finished writing', options.txt)
        else if options?.json
          fs.writeFile options.txt, meals2Text.toJSON(meals), (err) ->
            if (err) 
              return console.log(err)
            console.log('Finished writing', options.txt)
        else
          meals2Text.toConsole meals

    if startDate is 'all'
      return @mealDao.findAll cb      
    else if startDate is 'today'
      startDate = Date.create().beginningOfDay()
      endDate = Date.create().endOfDay()
    else if startDate is 'yesterday'
      startDate = Date.create('yesterday').beginningOfDay()
      endDate = Date.create('yesterday').endOfDay()
    else if startDate is 'week'
      startDate = Date.create('a week ago').beginningOfDay()
      endDate = Date.create().endOfDay()
    else
      startDate = Date.create(startDate).beginningOfDay()
      if endDate
        endDate = Date.create(endDate).endOfDay()
      else
        endDate = Date.create(startDate).endOfDay()
      
    @mealDao.findBetweenDates startDate, endDate, cb

  removeMeal: (id) =>
    cb = (err, meal) ->
      if err
        console.log err
      else
        meals2Text.meal2Text meal, true
        console.log "Meal Deleted.".green
    if id is 'last'
      @mealDao.getLastMeal (err, meal) =>
        if err or not meal
          console.error "Could not find last meal"
        else
          @mealDao.deleteMeal meal._id, cb
    else
      @mealDao.deleteMeal id, cb

  processArgString: (args) =>
    text = args.join(' ')
    parser = new EatingUtils.MealParser()
    meal = parser.parseMeal text
    # implement confirmation
    @mealDao.createMeal meal, (err, meal) ->
      if err
        console.log 'Could not save meal.'.red, err
      else
        console.log meal.date.format('{Weekday} {Month} {dd}, {yyyy}')
        console.log meals2Text.meal2Text meal, true
        console.log "Saved.".green

  updateOptions: (program) =>
    # Configuration Args
    if path = program.path
      path = path.replace(/^~\//, @homeDir + '/');
      nconf.set('dbPath', path)

    if confirm = program.confirm
      nconf.set('confirmParse', program.confirm)

    if locale = program.locale
      nconf.set('locale', program.locale)

    if config = program.config
      console.log "Database Path:", nconf.get('dbPath')
      console.log "Date Locale:", nconf.get('locale') or 'default'
      console.log()
      return true
    
    if reset = program.reset
      nconf.reset()

    if path or confirm or locale or reset
      nconf.save (err) ->
        if err
          console.error 'Error writing configuration', err.message
          return
        console.log "Configuration saved successfully."
      console.log "Database Path:", nconf.get('dbPath')
      console.log "Date Locale:", nconf.get('locale') or 'default'
      console.log()
      # we're modifying config so exit
      return true

    return false



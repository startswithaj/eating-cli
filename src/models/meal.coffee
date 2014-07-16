mongoose = require("mongoose")
Schema = mongoose.Schema

mealSchema = Schema(
  date: Date
  foods: String
  calories: Number
  important: Boolean
)

module.exports = mongoose.model("Meal", mealSchema)

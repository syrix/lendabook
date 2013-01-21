# The Book model
 
mongoose = require('mongoose')
Schema = mongoose.Schema
 
bookSchema = mongoose.Schema
  title: String
  author: String
  isbn: String
  location: String
  lender: String
  image: String
  description: String

module.exports = mongoose.model 'Books', bookSchema  
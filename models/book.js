// Generated by CoffeeScript 1.3.3
(function() {
  var Schema, bookSchema, mongoose;

  mongoose = require('mongoose');

  Schema = mongoose.Schema;

  bookSchema = mongoose.Schema({
    title: String,
    authors: [String],
    isbn: String,
    location: String,
    lender: {
      email: String,
      id: String
    },
    image: String,
    description: String
  });

  module.exports = mongoose.model('Books', bookSchema);

}).call(this);

// Generated by CoffeeScript 1.4.0
(function() {
  var mongoose;

  mongoose = require('mongoose');

  exports.index = function(req, res) {
    return res.render('index', {
      title: 'Lend a book'
    });
  };

  exports.books = function(Book) {
    return function(req, res) {
      return Book.find(function(err, books) {
        if (err) {
          return res.json({
            error: 'Could not get books'
          });
        } else {
          return res.json(books);
        }
      });
    };
  };

  /*
  exports.book = (req, res) ->
    res.render 'index', { title: 'Lend a book' }
  */


}).call(this);

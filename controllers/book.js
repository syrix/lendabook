// Generated by CoffeeScript 1.3.3
(function() {
  var Book;

  Book = require('../models/book.js');

  exports.list = function(req, res) {
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

  exports.create = function(req, res) {
    var book, id;
    book = new Book(req.body.book);
    id = book._id;
    book.save();
    return res.json({
      ETag: {
        id: "" + id,
        uri: "http://" + (req.header('host')) + req.url,
        type: "book"
      }
    });
  };

  exports["delete"] = function(req, res) {
    console.log("PAram: " + req.params.book);
    return Book.findById(req.params.book, function(err, book) {
      console.log("Err: " + err);
      console.log("Book: " + book);
      if (err) {
        return res.json(404, {
          error: "Book not found"
        });
      } else if (book != null) {
        book.remove();
        return res.json({
          success: true
        });
      } else {
        return res.json(404, {
          error: "Book not found"
        });
      }
    });
  };

}).call(this);

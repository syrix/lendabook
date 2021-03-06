unless Array::filter
  Array::filter = (callback) ->
    element for element in this when callback(element)

# needed to work with minification
window.bookapp = angular.module 'bookapp', []
window.bookapp.controller 'BookCtrl', [ '$scope', '$http', 'Facebook', 'BooksServer', 'BookPartial', 'Analytics', ($scope, $http, Facebook, BooksServer, BookPartial, Analytics) ->

  updateAllBookPartials = ->
    BookPartial.updateAllBookPartials (bookIdToRemoveFromList)->
      books.listjs.remove "bookId", bookIdToRemoveFromList

  Facebook.setAuthSuccessCallback ->
    updateAllBookPartials()

  books = 
    listjs:(() -> 
      options = 
        item: 'book-item'
        page: 6
      res = new List 'book-list', options
      res.on 'updated', updateAllBookPartials
      res
    )()

    add: (book, callback) ->
      BooksServer.add book,
        success: (data) ->
          $scope.newBook._id = data.ETag.id
          Facebook.offer $scope.newBook._id, (err)->
            #TODO Replace following block by the following commented block
            books.listjs.add prettifyBooks [$scope.newBook]
            updateAllBookPartials()
            alert "Buch erfolgreich eingetragen."
            callback()
            #booksServer.remove data.ETag.id
            #alert "Eintragen des Buches fehlgeschlagen. Ist das Coverbild korrekt gesetzt?"
          , () -> #Success
            books.listjs.add prettifyBooks [$scope.newBook]
            #updateAllBookPartials()
            alert "Buch erfolgreich eingetragen."
            callback()

  prettifyBooks= (inputBooks) ->
    inputBooks.map (v) ->
      v.imageTag = "<img src='#{v.image}', style='overflow: hidden; width: 100px', width='100'>"
      v.bookId = v._id
      v

  $scope.showMoreBooks = () ->
    Analytics.trackShowMoreBooks()
    books.listjs.show(0,200)
    $('#moreBooks').hide()
    #updateAllBookPartials()

  # TODO SB descriptions should not be to long or shortened client-side

  checkImage = (src,callbacks) ->
    tester = new Image()
    tester.onload = callbacks.success
    tester.onerror = callbacks.failure
    tester.src = src

  $scope.search = ->
    Analytics.trackSearching()

  $scope.addBookModal = () ->
    Analytics.trackShowAddBookDialog()
    Facebook.ensureLoggedIn ->
      $('#addBook').modal 'show'

  $scope.newBookIsValid = () ->
    $scope? && $scope.newBook? && $scope.newBook.title? && $scope.newBook.title!="" && $scope.newBook.image? && $scope.newBook.image!="" && $scope.newBook.isbn? && $scope.newBook.isbn!="" && $scope.newBook.author? && $scope.newBook.author!="" && $scope.newBook.description && $scope.newBook.description!=""

  $scope.addBook = () ->
    if !$scope.newBookIsValid()
      alert "Bitte fülle alle Felder aus"
    else
      checkImage $('#newBookImage').attr('src'),
        success: ->
          Analytics.trackOffer $scope.newBook.isbn
          Facebook.getCurrentUser (user) ->
            $scope.newBook.lender = user.id
            $scope.newBook.lenderName = user.first_name
            books.add $scope.newBook, ->
              $scope.newBook = {}
          $('#addBook').modal 'hide'
        failure: ->
          alert("Bitte wähle ein gültiges Coverbild aus.")

  BooksServer.getAllBooks
    success: (data) ->
      books.listjs.add prettifyBooks data
      #updateAllBookPartials()

  # $scope.OnTitleChange = () ->
  # Load book data from google books
  # window.test = (data) ->
    # alert JSON.stringify(data)

  # url = 'https://books.google.com/books?bibkeys=ISBN:0451526538&jscmd=viewapi&callback=window.test'
  # $http.jsonp(url)

  Facebook.onLoginStatusChange (status) ->
    Facebook.getCurrentUser (user) ->
      $scope.user = user
      $scope.$apply()

]
  

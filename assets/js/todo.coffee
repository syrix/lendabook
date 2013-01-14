unless Array::filter
  Array::filter = (callback) ->
    element for element in this when callback(element)

# needed to work with minification
window.todoapp = angular.module 'todoapp', []
window.todoapp.controller 'TodoCtrl', [ '$scope', '$http', ($scope, $http) ->
  options =
    item: 'book-item'
  $scope.booksList = new List 'book-list', options

  # TODO SB descriptions should not be to long or shortened client-side
  $scope.staticBooks = [
    {
      title: 'Harry Potter und der Stein der Weisen'
      authors: ['Joanne K. Rowling']
      isbn: '3-551-55167-7'
      location: 'Karlsruhe'
      lender:
        email: 'messmer@sunsteps.org'
      image: 'http://lakritzplanet.files.wordpress.com/2010/01/lit_hp_stein.jpg'
      description: 'Harry Potter erkennt, dass er kein normaler Junge ist, sondern Zauberkräfte hat und kommt auf die Zauberschule.'
    },
    {
      title: 'Eragon'
      authors: ['Christopher Paolini']
      isbn: '3-570-12803-2'
      location: 'Karlsruhe'
      lender:
        email: 'cominch@gmx.de'
      image: 'http://1.bp.blogspot.com/-GhSiZp0aZ4Y/Tx72SUaMR0I/AAAAAAAAAMc/6QXkRY5R7M0/s1600/eragon1.jpg'
      description: 'Irgendwas mit einem Drachen, ziemlich viel Fantasy.'
    },
    {
      title: 'The New Business Road Test'
      authors: ['John W. Mullins']
      isbn: '0-273-70805-8'
      location: 'Karlsruhe'
      lender:
        email: 'cie@kit.edu'
      image: 'http://imgv2-4.scribdassets.com/img/word_document/80290047/255x300/814797a85c/1341953356'
      description: 'Give your business the chance to be one of those that make it.'
    }
  ]

  $scope.books = (searchkey, location) ->
    $scope.staticBooks

  $scope.authorsToString = (array) ->
    array.reduce (x,y) -> x+", "+y

  $scope.addBook = () ->
    $scope.newBook.authors = [$scope.newBook.authors]
    $scope.staticBooks.push $scope.newBook

  $scope.OnTitleChange = () ->
  ###  alert("bla")
    url = "https://www.googleapis.com/books/v1/volumes?q="+$scope.newBook.title
    alert(url)
    alert("inter")
    $http.get
      url: url
      success: (data,status) -> alert("received")
      error: (data,status) -> alert("received")
    alert("sent")###

  prettifiedBooks = () ->
    result = $scope.staticBooks.map (v) ->
      v.authorsAsString = $scope.authorsToString(v.authors)
      v.imageTag = "<img src='#{v.image}', style='overflow: hidden; width: 100px', width='100'>"
      v.lend = "<a class='btn btn-success pull-right', href='mailto:#{v.lender.email}'> Lend now </a>"
      v
    result

  # Add books to list-js
  $scope.booksList.add prettifiedBooks()

]
  

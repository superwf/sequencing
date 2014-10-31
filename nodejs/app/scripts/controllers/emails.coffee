'use strict'

angular.module('sequencingApp').controller 'EmailsCtrl', ['$scope', 'Sequencing', 'Email', 'Order', ($scope, Sequencing, Email, Order) ->
  $scope.$emit 'event:title', 'email'
  $scope.clients = {}
  Email.query (data)->
    $scope.emails = data.records
    #angular.forEach data.records, (v, i)->
    $scope.totalItems = data.totalItems
    $scope.perPage = data.perPage
    null

  $scope.delete = (id, index)->
    Email.delete {id: id}, ->
      $scope.emails.splice index, 1

  $scope.resend = (email)->
    email.sent = false
    Email.update {id: email.id}, email
]

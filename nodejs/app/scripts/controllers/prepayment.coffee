'use strict'
angular.module('sequencingApp').controller 'PrepaymentCtrl', ['$scope', 'Prepayment', 'Sequencing', 'Modal', 'Company', '$modal', ($scope, Prepayment, Sequencing, Modal, Company, $modal) ->
  $scope.record = Modal.record
  $scope.save = ->
    record = Sequencing.copyWithDate($scope.record, 'create_date')
    record.money = record.money * 1
    if $scope.record.id
      Prepayment.update record
    else
      Prepayment.create record, (data)->
        data.company = record.company
        $scope.$close data

  $scope.selectCompany = ->
    Modal.resource = Company
    modal = $modal.open {
      templateUrl: '/views/companiesTable.html'
      controller: 'ModalTableCtrl'
      resolve:
        searcher: ->
          {}
    }
    modal.result.then (data)->
      $scope.record.company = data
      $scope.record.company_id = data.id
      null

  null
]

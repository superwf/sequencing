'use strict'
angular.module('sequencingApp').directive 'notifyFlash', ['$rootScope', ($rootScope)->
  template: '<div class="alert alert-{{level}}" ng-show="msg">{{msg}}<i class="glyphicon glyphicon-remove close" ng-click="close()"></i></div>',
  replace: true
  scope: true
  restrict: 'A'
  link: (scope) ->
    $rootScope.$on 'event:error', (e, msg)->
      scope.level = 'danger'
      scope.msg = msg
      null
    $rootScope.$on 'event:loading', ()->
      scope.level = 'info'
      scope.msg = 'Loading'
      null
    $rootScope.$on 'event:loaded', ->
      scope.msg = null
      null
    scope.close = ->
      scope.msg = null
      null
    null
]

'use strict'
angular.module('sequencingApp').directive 'notifyFlash', ['$rootScope', '$translate', ($rootScope, $translate)->
  template: '<div class="text-center alert alert-{{level}}" ng-show="msg">{{msg}}<i class="glyphicon glyphicon-remove close" ng-click="close()"></i></div>',
  replace: true
  scope: true
  restrict: 'A'
  link: (scope) ->
    $rootScope.$on 'event:error', (e, msg)->
      scope.level = 'danger'
      scope.msg = msg
      null
    $rootScope.$on 'event:notacceptable', (e, msg)->
      scope.level = 'danger'
      scope.msg = ''
      $translate(msg.field).then (l)->
        scope.msg += l
      $translate(msg.error).then (l)->
        scope.msg += l
      $translate('error').then (l)->
        scope.msg += l
      null
    $rootScope.$on 'event:loading', ()->
      scope.level = 'info'
      #scope.msg = 'loading'
      $translate('loading').then (l)->
        scope.msg = l
      null
    $rootScope.$on 'event:loaded', ->
      scope.msg = null
      null
    $rootScope.$on 'event:ok', (e, msg)->
      scope.level = 'success'
      scope.msg = msg
      $translate(msg).then (l)->
        scope.msg = l
      null
    scope.close = ->
      scope.msg = null
      null
    null
]

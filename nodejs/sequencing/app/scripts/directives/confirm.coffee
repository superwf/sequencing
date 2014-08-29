'use strict'
angular.module('sequencingApp').directive 'ngConfirmClick', ['$rootScope', '$window', ($rootScope, $window)->
  priority: -1
  restrict: 'A'
  link: (scope, element, attr) ->
    element.bind 'click', (e)->
      if $window.confirm(attr.message)
        scope.$apply(attr.ngConfirmClick)
]

'use strict'

angular.module('sequencingApp').directive 'datetimepicker', [->
  restrict: 'A'
  link: (scope, element, attrs) ->
    angular.element(element).datetimepicker()
]

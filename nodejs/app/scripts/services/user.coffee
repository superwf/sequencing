'use strict'

angular.module('sequencingApp').factory 'User', ['$resource', 'Sequencing', ($resource, Sequencing)->
  $resource Sequencing.api + '/users/:id', id: '@id', {
    query: {isArray: false, method: 'GET'}
  }
]

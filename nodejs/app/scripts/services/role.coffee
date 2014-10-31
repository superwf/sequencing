'use strict'

angular.module('sequencingApp').factory 'Role', ['Sequencing', '$resource', (Sequencing, $resource)->
  $resource Sequencing.api + '/roles/:id', id: '@id', {
    update: {method: 'PUT', url: Sequencing.api + '/roles/:id'}
    query: {isArray: false, method: 'GET'}
  }
]

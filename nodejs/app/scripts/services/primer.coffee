'use strict'

angular.module('sequencingApp').factory 'Primer', ['Sequencing', '$resource', (Sequencing, $resource)->
  $resource Sequencing.api + '/primers/:id', id: '@id', {
    update: {method: 'PUT', url: Sequencing.api + '/primers/:id'}
    'delete': {method: 'DELETE', url: Sequencing.api + '/primers/:id'}
    create: {method: 'POST'}
    query: {isArray: false, method: 'GET'}
  }
]

'use strict'
angular.module('sequencingApp').factory 'Client', ['Sequencing', '$resource', (Sequencing, $resource)->
  $resource Sequencing.api + '/clients/:id', id: '@id', {
    update: {method: 'PUT', url: Sequencing.api + '/clients/:id'}
    'delete': {method: 'DELETE', url: Sequencing.api + '/clients/:id'}
    create: {method: 'POST'}
    query: {isArray: false, method: 'GET'}
  }
]

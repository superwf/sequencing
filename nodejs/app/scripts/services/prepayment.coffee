'use strict'
angular.module('sequencingApp').factory 'Prepayment', ['Sequencing', '$resource', (Sequencing, $resource)->
  $resource Sequencing.api + '/prepayments/:id', id: '@id', {
    update: {method: 'PUT', url: Sequencing.api + '/prepayments/:id'}
    'delete': {method: 'DELETE', url: Sequencing.api + '/prepayments/:id'}
    create: {method: 'POST'}
    query: {isArray: false, method: 'GET'}
  }
]

'use strict'
angular.module('sequencingApp').factory 'PrepaymentRecord', ['Sequencing', '$resource', (Sequencing, $resource)->
  $resource Sequencing.api + '/prepaymentRecords/:id', id: '@id', {
    update: {method: 'PUT', url: Sequencing.api + '/prepaymentRecords/:id'}
    'delete': {method: 'DELETE', url: Sequencing.api + '/prepaymentRecords/:id'}
    create: {method: 'POST'}
    query: {isArray: true, method: 'GET'}
  }
]

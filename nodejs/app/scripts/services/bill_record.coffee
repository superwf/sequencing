'use strict'
angular.module('sequencingApp').factory 'BillRecord', ['Sequencing', '$resource', (Sequencing, $resource)->
  $resource Sequencing.api + '/billRecords/:id', id: '@id', {
    update: {method: 'PUT', url: Sequencing.api + '/billRecords/:id'}
    'delete': {method: 'DELETE', url: Sequencing.api + '/billRecords/:id'}
    create: {method: 'POST'}
    query: {isArray: false, method: 'GET'}
  }
]

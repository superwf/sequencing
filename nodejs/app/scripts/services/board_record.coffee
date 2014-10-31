'use strict'
angular.module('sequencingApp').factory 'BoardRecord', ['Sequencing', '$resource', (Sequencing, $resource)->
  $resource Sequencing.api + '/boardRecords/:id', id: '@id', {
    update: {method: 'PUT', url: Sequencing.api + '/boardRecords/:id'}
    'delete': {method: 'DELETE', url: Sequencing.api + '/boardRecords/:id'}
    create: {method: 'POST'}
    query: {isArray: false, method: 'GET'}
  }
]

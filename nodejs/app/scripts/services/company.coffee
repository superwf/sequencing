'use strict'
angular.module('sequencingApp').factory 'Company', ['Sequencing', '$resource', (Sequencing, $resource)->
  $resource Sequencing.api + '/companies/:id', id: '@id', {
    update: {method: 'PUT', url: Sequencing.api + '/companies/:id'}
    'delete': {method: 'DELETE', url: Sequencing.api + '/companies/:id'}
    create: {method: 'POST'}
    query: {isArray: false, method: 'GET'}
  }
]

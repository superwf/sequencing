'use strict'

angular.module('sequencingApp').factory 'Email', ['Sequencing', '$resource', (Sequencing, $resource)->
  $resource Sequencing.api + '/emails/:id', id: '@id', {
    update: {method: 'PUT', url: Sequencing.api + '/emails/:id'}
    'delete': {method: 'DELETE', url: Sequencing.api + '/emails/:id'}
    create: {method: 'POST'}
    query: {isArray: false, method: 'GET'}
  }
]

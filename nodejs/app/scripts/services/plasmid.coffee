'use strict'
angular.module('sequencingApp').factory 'Plasmid', ['Sequencing', '$resource', (Sequencing, $resource)->
  $resource Sequencing.api + '/plasmids/:id', id: '@id', {
    update: {method: 'PUT', url: Sequencing.api + '/plasmids/:id'}
    'delete': {method: 'DELETE', url: Sequencing.api + '/plasmids/:id'}
    create: {method: 'POST'}
    query: {isArray: false, method: 'GET'}
    all: {isArray: true, method: 'GET'}
  }
]

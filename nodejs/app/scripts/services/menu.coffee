'use strict'
angular.module('sequencingApp').factory 'Menu', ['Sequencing', '$resource', (Sequencing, $resource)->
  $resource Sequencing.api + '/menus/:id', id: '@id', {
    query: {isArray: true, method: 'GET'}
  }
]

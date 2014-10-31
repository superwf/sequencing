'use strict'

angular.module('sequencingApp').factory 'ClientReaction', ['Sequencing', '$resource', (Sequencing, $resource)->
  $resource Sequencing.api + '/clientReactions/:id', id: '@id', {
    update: {method: 'PUT', url: Sequencing.api + '/clientReactions/:id'}
    'delete': {method: 'DELETE', url: Sequencing.api + '/clientReactions/:id'}
    'deleteAll': {method: 'DELETE'}
    query: {isArray: false, method: 'GET'}
  }
]

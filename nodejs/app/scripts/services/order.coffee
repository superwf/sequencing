'use strict'

angular.module('sequencingApp').factory 'Order', ['Sequencing', '$resource', (Sequencing, $resource)->
  $resource Sequencing.api + '/orders/:id', id: '@id', {
    update: {method: 'PUT', url: Sequencing.api + '/orders/:id'}
    'delete': {method: 'DELETE', url: Sequencing.api + '/orders/:id'}
    create: {method: 'POST'}
    query: {isArray: false, method: 'GET'}
    interpretedReactionFiles: {isArray: true, url: Sequencing.api + '/interpretedReactionFiles/:id'}
    reinterprete: {method: 'PUT', url: Sequencing.api + '/reinterprete'}
    submitInterpretedReactionFiles: {method: 'PUT', url: Sequencing.api + '/submitInterpretedReactionFiles'}
    sending: {isArray: true, url: Sequencing.api + '/sendingOrderEmails'}
    reactions: {method: 'GET', isArray: true, url: Sequencing.api + '/orderReactions/:id'}
    receive: {method: 'POST', url: Sequencing.api + '/receiveOrder'}
    generateRedo: {method: 'POST', url: Sequencing.api + '/generateRedoOrder/:board_head_id'}
  }
]

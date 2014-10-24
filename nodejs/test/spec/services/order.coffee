'use strict'

describe 'Service: order', ->

  # load the service's module
  beforeEach module 'sequencingApp'

  # instantiate service
  order = {}
  beforeEach inject (_order_) ->
    order = _order_

  it 'should do something', ->
    expect(!!order).toBe true

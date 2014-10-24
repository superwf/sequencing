angular.module('sequencingApp').factory 'Timeconvert', ->
  {
    gmt2utc: (t)->
      localTime = t.getTime()
      #console.log new Date(localTime)
      localOffset = 24 * 60 * 60000
      utc = localTime + localOffset
      new Date(utc)
  }

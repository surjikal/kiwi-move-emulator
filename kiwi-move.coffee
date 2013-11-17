assert   = require 'assert'
{Buffer} = require 'buffer'


class KiwiMove

    HOST: '166.78.186.200'
    PORT: '4000'

    constructor: ({@deviceId, @socket} = {}) ->
        assert (@deviceId isnt undefined), '`deviceId` property is required.'
        assert (@socket   isnt undefined), '`socket` property is required.'
        @deviceId = @deviceId.toString()

    accelerometer: ({x, y, z} = {}) ->
        @_send 0, x, y, z, [-16, 16]

    gyroscope: ({x, y, z} = {}) ->
        @_send 1, x, y, z, [-250, 250]

    _send: do ->

        decimalToHex = (decimal, bytes = 4) ->
            (decimal + Math.pow(16, bytes)).toString(16).slice(-bytes)

        percentageToHex = (percentage, bytes = 4) ->
            half = Math.pow(16, bytes) / 2
            [min, max] = [-half, half-1]
            value = ((max - min) * percentage) + min
            return decimalToHex(Math.round(value), bytes)

        rangePercentage = (min, value, max) ->
            return (value - min) / (max - min)

        clamp = (min, value, max) ->
            return Math.min (Math.max value, min), max

        normalizeValue = (range) -> (value) ->
            return '0000' if value is undefined
            [min, max] = range
            value = clamp(min, value, max)
            percentage = rangePercentage(min, value, max)
            return percentageToHex(percentage, 4)

        return (messageIndex, x, y, z, range, done) ->
            messageIndex = messageIndex.toString()
            [x, y, z] = [x, y, z].map normalizeValue(range)
            done ?= ->
            message = [@deviceId, '0', messageIndex, x, y, z].join('')
            data = new Buffer message, 'hex'
            @socket.send data, 0, data.length, @PORT, @HOST, done


module.exports = {KiwiMove}

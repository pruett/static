UUID_REGEXP = /^[0-9a-f]{8}(?:-[0-9a-f]{4}){3}-[0-9a-f]{13}$/

module.exports =
  test: (str) ->
    UUID_REGEXP.test(str)

  generate: ->
    # Generate UUIDs based on the algorithm described in RFC 4122
    # (http:www.ietf.org/rfc/rfc4122.txt). Specifically, see section 4.4:
    # Algorithms for Creating a UUID from Truly Random or Pseudo-Random Numbers.

    s = new Array(36)

    # Fill array with random hexadecimal digits.
    for i in [0..s.length] by 1
      s[i] = Math.floor(Math.random() * 0x10)

    # Conform to RFC-4122, section 4.4.
    s[14] = 4
    s[19] = (s[19] & 0x3) | 0x8

    # Format the UUID.
    itoh = '0123456789abcdef'
    for i in [0..s.length] by 1
      s[i] = itoh[s[i]]

    s[8] = s[13] = s[18] = s[23] = '-'
    s.join('')

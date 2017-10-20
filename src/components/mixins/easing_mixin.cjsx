module.exports =
  # Taken from https://gist.github.com/gre/1650294.
  easingFunction:
    linear:     (t) -> t
    inQuad:     (t) -> t * t
    outQuad:    (t) -> t * (2 - t)
    inOutQuad:  (t) -> if t < .5 then 2 * t * t else -1 + (4 - 2 * t) * t

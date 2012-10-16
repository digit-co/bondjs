createSpy = (value) ->
  spy = (args...) ->
    spy.calledArgs[spy.called] = args
    spy.called++
    value

  spy.called = 0
  spy.calledArgs = []
  spy.calledWith = (args...) ->
    return false if !spy.called
    lastArgs = spy.calledArgs[spy.called-1]
    arrayEqual(args, lastArgs)
  spy

createThroughSpy = (context, method) ->
  spy = (args...) ->
    spy.calledArgs[spy.called] = args
    spy.called++
    method.apply(context, args)

  spy.called = 0
  spy.calledArgs = []
  spy.calledWith = (args...) ->
    return false if !spy.called
    lastArgs = spy.calledArgs[spy.called-1]
    arrayEqual(args, lastArgs)
  spy

arrayEqual = (A, B) ->
  for a, i in A
    b = B[i]
    return false if a != b

  true

bond = (obj, property) ->
  previous = obj[property]

  to = (newValue) ->
    afterEach -> obj[property] = previous
    obj[property] = newValue
    obj[property]

  returnMethod = (returnValue) ->
    afterEach -> obj[property] = previous
    obj[property] = createSpy(returnValue)
    obj[property]

  through = ->
    afterEach -> obj[property] = previous
    obj[property] = createThroughSpy(obj, previous)
    obj[property]

  {
    to: to
    return: returnMethod
    through: through
  }

window?.bond = bond
module?.exports = bond
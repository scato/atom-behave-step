module.exports =
  class StepJumper

    constructor: (@line) ->
      matchData = @line.match(/^\s*(\w+)\s+(.*)/)
      if matchData
        @firstWord = matchData[1]
        @restOfLine = matchData[2]

    stepTypeRegex: ->
      new RegExp "@(Given|When|Then|And)\(.*\)"

    checkMatch: ({filePath, matches}) ->
      console.log("Searching in #{filePath} for '#{@restOfLine}'")
      for match in matches
        step_descriptor = match.matchText.match(/\(\'([^\']*)/)
        try
          regex = new RegExp(step_descriptor[1].replace(/\{[^\}]+\}/g, ".+"))
        catch e
          console.log(step_descriptor[1] + " cannot be turned into a RegExp")
          console.log(e)
          continue
        if @restOfLine.match(regex)
          return [filePath, match.range[0][0]]

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
      for match in matches
        console.log("Searching in #{filePath} for '#{@restOfLine}'")
        regex = match.matchText.match(/\(\'([^\']*)/)
        try
          regex = new RegExp(regex[1].replace(/\{[^\}]+\}/, ".+"))
        catch e
          console.log(e)
          continue
        if @restOfLine.match(regex)
          return [filePath, match.range[0][0]]

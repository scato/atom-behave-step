StepJumper = require "../lib/step-jumper"

describe "jumping", ->
  beforeEach ->
    @stepJumper = new StepJumper("  Given I have a cheese")

  describe "finding lines with step prefixes", ->
    it "should match right step types", ->
      expect("@Given('I have a cheese')".match(@stepJumper.stepTypeRegex())).toBeTruthy()
      expect("@When('I have a cheese')".match(@stepJumper.stepTypeRegex())).toBeTruthy()
      expect("@Then('I have a cheese')".match(@stepJumper.stepTypeRegex())).toBeTruthy()
    it "should not match wrong step types", ->
      expect("@With('I have a cheese')".match(@stepJumper.stepTypeRegex())).toBeFalsy()

  describe "checkMatch", ->
    beforeEach ->
      @match1 =
        matchText: "@Given('some other random crap')"
        range: [[10, 0], [15, 0]]
      @match2 =
        matchText: "@Given('I have a {thing}')"
        range: [[20, 0], [25, 0]]
      @scanMatch =
        filePath: "path/to/file"
        matches: [@match1, @match2]
    it "should return file and line", ->
      expect(@stepJumper.checkMatch(@scanMatch)).toEqual(["path/to/file", 20])

  describe "matching to step description", ->
    it "should match with patterns", ->
      match =
        matchText: "@Given('I have a {thing}')"
        range: [[20, 0]]
      scanMatch =
        filePath: "path/to/file"
        matches: [match]
      expect(@stepJumper.checkMatch(scanMatch)).toEqual(["path/to/file", 20])
    it "should match with multiple patterns", ->
      match =
        matchText: "@Given('I {verb} a {thing}')"
        range: [[20, 0]]
      scanMatch =
        filePath: "path/to/file"
        matches: [match]
      expect(@stepJumper.checkMatch(scanMatch)).toEqual(["path/to/file", 20])
    it "should not match poor patterns", ->
      match =
        matchText: "@Given('I have {thing} with {thing}')"
        range: [[20, 0]]
      scanMatch =
        filePath: "path/to/file"
        matches: [match]
      expect(@stepJumper.checkMatch(scanMatch)).toEqual(undefined)

  describe "checkMatch no match", ->
    beforeEach ->
      @match =
        matchText: "@Given('I do not have a cheese')"
        range: [[20, 0], [25, 0]]
      @scanMatch =
        filePath: "path/to/file"
        matches: [@match]
    it "should return undefined", ->
      expect(@stepJumper.checkMatch(@scanMatch)).toEqual(undefined)

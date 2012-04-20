Processtools = {}
Processtools.crashWithOutput = (output) ->
  console.error output
  process.exit 1
Processtools.finishWithOutput = (output) ->
  console.log output
  process.exit 0

module.exports = Processtools
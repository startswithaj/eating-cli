#!/usr/bin/env coffee
##!/usr/bin/env node < needs to be copied to compiled js in /libs
program     = require 'commander'
Eating = require('./eating')

eating = 

# ## Bug in commander.js tries to exec arguments that match properties of Array as subcommands
# ## https://github.com/visionmedia/commander.js/issues/206
# ## Sugar adds .last and we use it as an arg
delete Array.prototype.last
delete Array.prototype.all

program
  .version(require('../package.json').version)
  .option('-p, --path <path>', 'set data path. defaults to ~/.eatingdata')
  # .option('-c, --confirm <boolean>', 'confirms meal parse result before saving. defaults to true')
  .option('-l, --locale <string>', 'Date Locale for parsing date formats accepts en-US (default), en-UK, en-AU')
  .option('-c, --config', 'Outputs current config')
  .option('-r, --reset', 'Will restore default config')

program
  .command 'help'
  .action program.help

program
  .command 'remove <id>'
  .alias 'rm'
  .description 'finds and removes the mealId provided also accepts \'last\''
  .action new Eating().removeMeal
  .on '--help', ->
    console.log('  Examples:')
    console.log()
    console.log('    $ eating remove last')
    console.log('    $ eating remove 12')
    console.log()

program
  .command 'list <startDate> [endDate]'
  .alias 'show'
  .option "-t, --txt <filePath>", "Export to txt file"
  .option "-j, --json <filePath>", "Export to .json file"
  .description 'see eating list --help for full usage'
  .action new Eating().outputMeals
  .on '--help', ->
    console.log('  Examples:')
    console.log()
    console.log('    $ eating list today')
    console.log('    $ eating list yesterday')
    console.log('    $ eating list week --txt ~/weekOfMeals.txt')
    console.log('    $ eating list 07/22')
    console.log('    $ eating list 07/22 07/28')
    console.log('    $ eating list 07/22 07/28 --json ~/weekOfMeals.json')
    console.log()

program
  .command '*'
  .description 'process arguments as a meal string'
  .action ->
    args = this.rawArgs
    # firt 2 is > node eating
    args = args.slice(2, args.length)
    new Eating().processArgString(args)

# new line
console.log()
program.parse process.argv

updateHappened = new Eating().updateOptions(program)

if not updateHappened and program.args.length is 0
 new Eating().showToday()


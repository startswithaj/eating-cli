# eating-cli

[![Build Status]](https://travis-ci.org/startswithaj/eating-cli)


[![Analytics](https://ga-beacon.appspot.com/UA-51856256-3/startswithaj/eating-cli?pixel)](https://github.com/startswithaj/eating-cli)

**eating** is a very simple node.js command line application for recording what you eat (a meal diary/journal). Inspired by [doing](http://brettterpstra.com/projects/doing/) it takes near to natural language input and turns that into structured meals. There's also a web version at [eatkeep.io](https://www.eatkeep.io)



```
eating 7 ham and pineapple pizzas 2 hours ago 7000!
```

would yield

- Date: (UTC the date/time 2 hours ago)
- Foods: 7 Ham & Pineapple Pizzas
- Calories: 7000
- Important: true (exclamation mark)

n.b. ***I do not encourage you to eat 7 pizzas***

```
eating yesterday 3.30pm 1/2 chocolate bar 200cals
```

would yeild

- Date: (UTC date/time of yesterday 3.30pm)
- Foods: 1/2 Chocolate Bar
- Calories: 200
- Important: false


##How to install
```
npm install -g eating
```
to update
```
npm update -g eating
```
####configuration
eating has 2 configurable options 
- path
-- folder where it will save your data
 - defaults to ~/.eatingdata/
 - I recommend setting to to somewhere in your dropbox or gdrive
```
eating --path '~/Google Drive/eating'
```
- locale
 - date locale defaults to nodes default usually en-US (mm/dd/yyyy)
 - if set to 'en-AU' it will then parse dates as dd/mm/yyyy
```
eating --locale 'en-AU'
```


##How to use

running the command outputs what you've recorded that day and total calories
```
eating
```
to show help
```
eating --help
```
```
eating <command> --help
```
show meals for all/today/yesterdays/week/<date> [enddate] 
```
eating list yesterday
```
```
eating list 22/07
```
```
eating list 22/07 28/07
```
export to a formatted .txt file
```
eating list 22/07 28/07 --txt ~/dairy.txt
```
export to json
```
eating list 22/07 28/07 --json ~/dairy.json
```
to remove a meal, find the meals id (the number next to meal)
```
eating remove id
```
or remove the last added meal
```
eating remove last
```
if none of the commands above it will try and pass all args as a meal
```
eating chicken caesar salad 20 minutes ago 600cals!
```
by putting a '!' (exclamation mark) somewhere in the text will flag the meal as important useful for marking cheat meals, high glucose meals(for diabetics) and other things.

### Problems

If you find a bug or have any problems create an github issue or email me at my github email. I will fix them.

n.b. I have only tested this on OS X

<!-- references -->
[Build Status]: http://img.shields.io/travis/startswithaj/eating-cli/master.svg

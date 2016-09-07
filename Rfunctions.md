# Functions, if-else statements and loops in R [INCOMPLETE]

## Functions

Functions in R are stored in the same way as other objects are, with the `<-` assignment, with a structure like so:

`FUNCTIONNAME <- function(ARGUMENTS) { ACTIONS }`

If you've created functions in JavaScript you'll notice that it's a very similar structure. Here's a working example:

`add2numbers <- function(num1, num2) {`

`total <- num1 + num2 `

`return (total)`

`} `

## If-else statements

If-else statements in R can test something about your data and initiate different actions depending on whether the test is met or not.

The structure of an if-else statement is as follows:

if (CONDITION TO TEST) { DO THIS IF RESULT IS TRUE } 

else { DO THIS IF RESULT IS FALSE}

Here's an example that works:

`if (mynumber > 50) { print("good") } else { print("not so good")}`

If the expression is all on one line you can also omit the curly brackets and write it more simply like so:

`if (mynumber > 50) print("good") else print("not so good")`

If you don't want to squeeze it onto one line, it can be easier to read if you split it across multiple lines like so:

`if (mynumber > 50) { `

  `print("good") `

`}` 

`else { `

`print("not so good")`

`}`

### If-else-if statements

You don't have to use just one 'if' in an if-else statement: you can have multiple tests using `else if` like so:

`if (mynumber > 50) { print("good") } else if (mynumber < 25)  { print("poor")} else {print ("average")}`


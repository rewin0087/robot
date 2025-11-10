# Robot Simulator

## Description

The application is a simulation of a robot moving on a 6x6 square grid.
- There are no obstructions on the grid.
- The robot needs to be prevented from exceeding the limits of the grid, but is allowed to move freely on the grid otherwise.

Create a command-line application that reads in the following commands:

    PLACE X,Y,F
    MOVE
    LEFT
    RIGHT
    REPORT

The PLACE X, Y, O will place the robot at position X, Y on the grid, with orientation O. Orientations are N, E, S, W (for North, East, South and West). Position (0,0) on the grid is the south west corner. First coordinate is along the East/West axis, the second coordinate is along the North/South axis.

MOVE will move the robot one step forward, in whichever direction it is currently facing
LEFT and RIGHT respectfully turn the robot 90° angle to the left or to the right.
REPORT announces the position and orientation of the robot (X, Y, O) in any format (such as standard out)

## Constraints

- Commands are to be ignored until a valid PLACE command is issued
- Any commands that would put the robot out of the defined grid is to be ignored, all other commands (including another PLACE) are to be obeyed

## Example Input and Output

a)

    PLACE 0,0,E
    MOVE
    REPORT
    Output: 1,0,E

b)

    PLACE 0,0,N
    MOVE
    MOVE
    RIGHT
    MOVE
    REPORT
    Output: 1,2,E

c)

    PLACE 0,0,N
    MOVE
    REPORT
    Output: 0,1,N

d)

    PLACE 0,0,N
    LEFT
    REPORT
    Output: 0,0,W

e)

    PLACE 1,2,E
    MOVE
    MOVE
    LEFT
    MOVE
    REPORT
    Output: 3,3,N

## Setup
1. Clone repository
```
git clone git@github.com:rewin0087/robot.git
```

2. Install ruby 3.4.4 first using rbenv or any preferred ruby version manager. Install ruby gems depedencies

run:
```
bundle install
```

## How to run

Navigate to root directory and run `bin/console` and this will run a console application which will ask for input

Example:
```
➜  robot git:(main) ✗ bin/console
Please enter your command:
PLACE 0,0,E
MOVE
REPORT
OUTPUT: 1,0,E
```

## How to run specs

To run the rspec tests, run rspec in the root of the directory in the terminal.

```
bundle exec rspec spec
```

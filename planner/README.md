## Instructions on running the planner

lpg-td-1.0 is the planner that we will be using.  For planning, you need a domain file and a corresponding problem file. 

`lpg-td-1.0 -o [domainFILE] -f [problemFILE] -quality` <br />

This will output the solution onto the screen. For example, you can do

`lpg-td-1.0 -o domain.pddl -f pfile -quality -out mysol` <br />

which prints out the plan to the file 'mysol'. 


#### Note that sometimes, you may have to execute the planner multiple times for it to properly display the plan on the terminal.  
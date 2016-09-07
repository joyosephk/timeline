import sys
import os
import re
class Planner:
    def __init__(self):
        args = sys.argv
        #:w
        #self.run()
        file = open("mysol.SOL",'r')

    def run(self):
        os.system("./lpg-td-1.0 -o domain.pddl -f pfile -quality -out mysol")
        if not self.detect():
            self.run()
        self.parse(open("mysol.SOL"))

    def detect(self):
        handle = open("mysol.SOL","r")
        for line in handle:
            reg = re.search("^\d",line)
            if not (reg is None):
                return True
        return False


    def parse(self, file):
            #takes a file handle, parses the file
            arr = []
            #first, filter out all the non-plan related lines
            for line in file:
                    reg = re.search("^\d",line)
                    if not (reg is None):
                            arr.append(line)
            timed_arr_robot = []
            timed_arr_human = []
            #now parse the results into dictionary objects
            for el in arr:
                    num = re.search("(\d{1,8}\.\d{1,8}){1,3}",el)
                    start = num.group(0)
                    end_num = re.search("(\[)(\d{1,8}\.\d{1,8})(\])",el)
                    end = end_num.group(2)
                    words = re.search("([A-Z _]{1,20}\ )([A-Z _ ]{1,20}\ )([A-Z _ ]{1,20})",el)
                    action = words.group(1)
                    agent  =  words.group(2)
                    print agent
                    obj = words.group(3)
		    if(agent == "ROBOT "):
                            agent = "ROBOT"
			    timed_arr_robot.append( {"start": start, "duration": end, "action": action, "agent":agent, "object":obj})
		    else: 
			    timed_arr_human.append( {"start": start, "duration": end, "action": action, "agent":agent, "object":obj})
            self.timed_arr_robot = timed_arr_robot
            self.timed_arr_human = timed_arr_human
            print timed_arr_robot
            print timed_arr_human
            return (timed_arr_robot, timed_arr_human)
    def get_plans(self):
        return (self.timed_arr_robot, self.timed_arr_human)
    def current_tasks(self, time_elapsed):
        return (get_current_task("HUMAN", time_elapsed), get_current_task("ROBOT", time_elapsed))
	
    def get_current_task(self, agent, time_elapsed):
                    data = []
                    if(agent == "ROBOT"):
                                    data = self.timed_arr_robot
                    else: 
                                    data = self.timed_arr_human
                    curr_index = 0
                    curr = data[curr_index]
                    while time_elapsed > 0:
                            time_elapsed = time_elapsed - curr[curr_index]["duration"]
                            curr_index+=1
                            curr = data[curr_index]
                    return curr

#TEST SCRIPTS HERE
if __name__ == '__main__':
        planner = Planner()


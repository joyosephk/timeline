import sys
import os
import re
class Planner:
    def __init__(self):
        args = sys.argv
        self.run()
        file = open("mysol.SOL",'r')
        parse(file)

    def run(self):
        os.system("./lpg-td-1.0 -o domain.pddl -f pfile -quality -out mysol")

    def parse(self, file):
            #takes a file handle, parses the file
            arr = []
            #first, filter out all the non-plan related lines
            for line in file:
                    reg = re.search("^\d",line)
                    if not (reg is None):
                            arr.append(line)
            timed_arr = []
            #now parse the results into dictionary objects
            for el in arr:
                    num = re.search("(\d{1,8}\.\d{1,8}){1,3}",el)
                    start = num.group(0)
                    end_num = re.search("(\[)(\d{1,8}\.\d{1,8})(\])",el)
                    end = end_num.group(2)
                    words = re.search("([A-Z]{1,20}\ )([A-Z]{1,20}\ )([A-Z]{1,20})",el)
                    action = words.group(1)
                    agent  =  words.group(2)
                    obj = words.group(3)
                    timed_arr.append( {"start": start, "duration": end, "action": action, "agent":agent, "object":obj})
            self.timed_arr = timed_arr
            return timed_arr
    def current_tasks(self, time_elapsed):
        pass
if __name__ == '__main__':
        main()


import os

for f in range(1,16):
	for r in range(1, 26):
		command = "head -n 60000 tracef%02d_%02d.txt > ./truncated/tracef%02d_%02d.txt" %(f, r, f, r)
		os.system(command)

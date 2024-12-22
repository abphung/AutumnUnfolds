import subprocess
from datetime import datetime
from pathlib import Path


current_timestamp = datetime.now().timestamp()
Path(str(current_timestamp)).mkdir(parents=True, exist_ok=True)
placement = [
"00AB0C0DDD00",
"0AABBCC0EDDD",
"AABB0FCCEGGG",
"AHBFFFCEEEG0",
"HHHHIFFJJEG0",
"0HKKIIJJLLG0",
"KKKIIJJM0LLL",
"KNNOIMMMMPPL",
"0NQORRMS0TP0",
"0NQOOR0SSTP0",
"NNQQORRSTTPP",
"0QQ0ORSS0TT0",
]

start_time = datetime.now()
for i in range(20):
	letter = chr(ord('A') + i)
	print(str(letter))
	rows = set()
	cols = set()
	for j, row in enumerate(placement):
		if letter in row:
			rows.add(j)
			cols.add(row.index(letter))
			cols.add(11 - row[::-1].index(letter))
	start_x = min(cols)
	start_y = min(rows)
	width = max(cols) - start_x + 1
	height = max(rows) - start_y + 1
	encoding = ""
	for y in range(height):
		for x in range(width):	
			encoding += "1" if placement[start_y + y][start_x + x] == letter else "0"

	subprocess.run(["/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD", "-o", str(current_timestamp) + "/" + str(letter) + ".stl", "-D", 'param1="' + encoding + '"', "-D", "param2=" + str(width), "-D", "param3=" + str(height), "-D", "param4=" + str(start_x), "-D", "param5=" + str(11 - max(rows)), "Dice Encoding.scad"]) 

print(current_timestamp)
print(datetime.now() - start_time)
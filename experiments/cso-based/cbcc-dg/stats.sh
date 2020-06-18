tail -n 1 tracef01_* | grep -P "^[0-9].*" > bestsf01.txt
tail -n 1 tracef02_* | grep -P "^[0-9].*" > bestsf02.txt
tail -n 1 tracef03_* | grep -P "^[0-9].*" > bestsf03.txt
tail -n 1 tracef04_* | grep -P "^[0-9].*" > bestsf04.txt
tail -n 1 tracef05_* | grep -P "^[0-9].*" > bestsf05.txt
tail -n 1 tracef06_* | grep -P "^[0-9].*" > bestsf06.txt
tail -n 1 tracef07_* | grep -P "^[0-9].*" > bestsf07.txt
tail -n 1 tracef08_* | grep -P "^[0-9].*" > bestsf08.txt
tail -n 1 tracef09_* | grep -P "^[0-9].*" > bestsf09.txt
tail -n 1 tracef10_* | grep -P "^[0-9].*" > bestsf10.txt
tail -n 1 tracef11_* | grep -P "^[0-9].*" > bestsf11.txt
tail -n 1 tracef12_* | grep -P "^[0-9].*" > bestsf12.txt
tail -n 1 tracef13_* | grep -P "^[0-9].*" > bestsf13.txt
tail -n 1 tracef14_* | grep -P "^[0-9].*" > bestsf14.txt
tail -n 1 tracef15_* | grep -P "^[0-9].*" > bestsf15.txt

octave stats.m
mv meanf*   ../result/
mv stdf*    ../result/
mv medianf* ../result/
mv bestsf*  ../result/

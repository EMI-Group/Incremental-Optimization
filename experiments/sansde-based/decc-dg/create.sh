sed -e  "s;%FUN%;01;g" run.template.m > run01.m
sed -e  "s;%FUN%;02;g" run.template.m > run02.m
sed -e  "s;%FUN%;03;g" run.template.m > run03.m
sed -e  "s;%FUN%;04;g" run.template.m > run04.m
sed -e  "s;%FUN%;05;g" run.template.m > run05.m
sed -e  "s;%FUN%;06;g" run.template.m > run06.m
sed -e  "s;%FUN%;07;g" run.template.m > run07.m

sed -e  "s;%NAME%;CCDG-F01;g"  -e "s;%SCRIPT%;run01.m;g" pbs-script.template > pbs-script01
sed -e  "s;%NAME%;CCDG-F02;g"  -e "s;%SCRIPT%;run02.m;g" pbs-script.template > pbs-script02
sed -e  "s;%NAME%;CCDG-F03;g"  -e "s;%SCRIPT%;run03.m;g" pbs-script.template > pbs-script03
sed -e  "s;%NAME%;CCDG-F04;g"  -e "s;%SCRIPT%;run04.m;g" pbs-script.template > pbs-script04
sed -e  "s;%NAME%;CCDG-F05;g"  -e "s;%SCRIPT%;run05.m;g" pbs-script.template > pbs-script05
sed -e  "s;%NAME%;CCDG-F06;g"  -e "s;%SCRIPT%;run06.m;g" pbs-script.template > pbs-script06
sed -e  "s;%NAME%;CCDG-F07;g"  -e "s;%SCRIPT%;run07.m;g" pbs-script.template > pbs-script07

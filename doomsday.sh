#!/bin/bash

####DOOMSDAY ALGORITHM####
####WRITTEN BY PETER HARRIS####

TOTAL=10
START_YEAR=1600
END_YEAR=3000

correct=0
incorrect=0
time=0

for (( i=0 ; i<TOTAL ; i++ )) ; do

####CREATE DATE####
year=$((START_YEAR + RANDOM % ($END_YEAR - $START_YEAR + 1) ))
if (( $year % 4 == 0 )) ; then
	if (( $year % 100 == 0 )) ; then
		if (( $year % 400 == 0 )) ; then
			leapyear=true
		else
			leapyear=false
		fi
	else
		leapyear=true
	fi
else
	leapyear=false
fi
month=$((1 + RANDOM % 12))
if (( $month == 1 || $month == 3 || $month == 5 || $month == 7 || $month == 8 || $month == 10 || $month == 12 )) ; then
	day=$((1 + RANDOM % 31))
fi
if (( $month == 4 || $month == 6 || $month == 9 || $month == 11 )) ; then
	day=$((1 + RANDOM % 30))
fi
if (( $month == 2 )) ; then
	if $leapyear ; then
		day=$((1 + RANDOM % 29))
	else
		day=$((1 + RANDOM % 28))
	fi
fi

echo $month"/"$day"/"$year
#echo "$day"/$month"/"$year

####GET DOOMSDAY####
p1=$(($year % 100 / 12))
p2=$(($year % 100 % 12))
p3=$(($p2 / 4))
if (( $year / 100 % 4 == 0 )) ; then
	p4=2
elif (( $year / 100 % 4 == 1 )) ; then
	p4=0
elif (( $year / 100 % 4 == 2 )) ; then
	p4=5
elif (( $year / 100 % 4 == 3 )) ; then
	p4=3
fi
total=$(( $p1+$p2+$p3+$p4 ))
dday=$(( $total % 7 ))
#DISPLAY DOOMSDAY
#if (( $dday == 0 )) ; then 
#	echo "   SUNDAY"
#elif (( $dday == 1 )) ; then
#	echo "   MONDAY"
#elif (( $dday == 2 )) ; then
#	echo "   TUESDAY"
#elif (( $dday == 3 )) ; then
#	echo "   WEDNESDAY"
#elif (( $dday == 4 )) ; then
#	echo "   THURSDAY"
#elif (( $dday == 5 )) ; then
#	echo "   FRIDAY"
#elif (( $dday == 6 )) ; then
#	echo "   SATURDAY"
#fi

####CALCULATE DAY OF WEEK####
days_in_month=(31 28 31 30 31 30 31 31 30 31 30) 
days_in_month_ly=("${days_in_month[@]}")
days_in_month_ly[1]=29
day_number=0
if $leapyear ; then
	for (( x=0 ; x<$month-1 ; x++ )) ; do
		(( day_number+=days_in_month_ly[x] ))
	done
else
	for (( x=0 ; x<$month-1 ; x++ )) ; do
		(( day_number+=days_in_month[x] ))
	done
fi
(( day_number+=$day ))
if $leapyear ; then
	days_diff=$(( $day_number-4 ))
else
	days_diff=$(( $day_number-3 ))
fi
dow=$(( $days_diff + $dday ))
while (( $dow < 0 )) ; do
	(( dow+=7 )) 
done
(( dow%=7 )) 
starttime=`date +%s`
read response
endtime=`date +%s`
if [[ $response == su ]] ; then
	ans="0"
elif [[ $response == mo ]] ; then
	ans="1"
elif [[ $response == tu ]] ; then
	ans="2"
elif [[ $response == we ]] ; then
	ans="3"
elif [[ $response == th ]] ; then
	ans="4"
elif [[ $response == fr ]] ; then
	ans="5"
elif [[ $response == sa ]] ; then
	ans="6"
fi
if [[ $ans == $dow ]] ; then
	((correct++))
	echo -n "Correct!"
else
	((incorrect++))
	echo -n "Not correct!"
fi
runtime=$(($endtime - $starttime))
echo " $runtime seconds"
((time+=$runtime))
if (( $dow == 0 )) ; then 
	echo "   SUNDAY"
elif (( $dow == 1 )) ; then
	echo "   MONDAY"
elif (( $dow == 2 )) ; then
	echo "   TUESDAY"
elif (( $dow == 3 )) ; then
	echo "   WEDNESDAY"
elif (( $dow == 4 )) ; then
	echo "   THURSDAY"
elif (( $dow == 5 )) ; then
	echo "   FRIDAY"
elif (( $dow == 6 )) ; then
	echo "   SATURDAY"
fi

done

echo "......."
echo "Correct: "$correct
echo "Incorrect: "$incorrect
echo -n "Average: "
echo -n $((100*time/TOTAL)) | sed 's/..$/.&/' 
echo " seconds"


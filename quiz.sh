#!/bin/bash
if [ $# -eq 1 ]; then
    if [[ "$1" == "highscores" ]]; then
        echo "------------Top 5 High Scores------------"
        sort -t '|' -k2 -nr highscores.txt | head -5
        exit 0
    elif [[ "$1" == "practice" ]]; then
        echo "Entering practice mode..."
        sleep 1; clear
        shuffled_numbers=($(seq 1 20 | shuf))
        for ((i=0; i<20; i++)) do
        rn=${shuffled_numbers[i]}
         echo " Question $((i+1)) of 20"
        awk -F '|' -v line="$rn" 'NR==line {print $1, $2, $3, $4, $5}' questions.txt
        read -p "Enter the correct answer (A/B/C/D): " answer
        answer="${answer^^}"
            while true; do
            if [[ "$answer" != "A" && "$answer" != "a" && "$answer" != "B" && "$answer" != "b" && "$answer" != "C" && "$answer" != "c" && "$answer" != "D" && "$answer" != "d" ]]; then
                echo "Invalid input. Please enter A, B, C, or D."
                echo ""
                echo " Question $((i+1)) of 20"
                awk -F '|' -v line="$rn" 'NR==line {print $1, $2, $3, $4, $5}' questions.txt
                read -p "Enter the correct answer (A/B/C/D): " answer
                answer="${answer^^}"
            else
                break
                fi
            done
            if [[ "$answer" == $(awk -F '|' -v line="$rn" 'NR==line {print $6}' questions.txt) ]]; then
             awk -F '|' -v line="$rn" 'NR==line {print "\033[32m Correct! (" $6 ")\033[0m"}' questions.txt
             else
                awk -F '|' -v line="$rn" 'NR==line {print "\033[31m Incorrect! The correct answer was: " $6 "\033[0m"}' questions.txt
             fi
        sleep 1; clear
        done
        echo "Practice session over. Returning to main menu..."
        exit 0
    fi   
else
echo "----------Welcome to the Quiz Game!----------"
read -p "Enter your name: " name
echo "Hello, $name! Let's start the game."
echo ""
shuffled_numbers=($(seq 1 20 | shuf))
x=0
long_streak=0
correct_answers=0
for ((i=0; i<20; i++)) do
rn=${shuffled_numbers[i]}
 echo " Question $((i+1)) of 20"
awk -F '|' -v line="$rn" 'NR==line {print $1, $2, $3, $4, $5}' questions.txt
    read -p "Enter your answer (A/B/C/D): " answer
    answer="${answer^^}"
 while true; do
 if [[ "$answer" != "A"  && "$answer" != "B"  && "$answer" != "C" && "$answer" != "D" ]]; then
    y=$x
    x=0
    echo "Invalid input. Please enter A, B, C, or D."
    echo " Question $((i+1)) of 20"
    awk -F '|' -v line="$rn" 'NR==line {print $1, $2, $3, $4, $5}' questions.txt
    read -p "Enter your answer (A/B/C/D): " answer
    answer="${answer^^}"
 else
    break
    fi
done
    if [[ "$answer" == $(awk -F '|' -v line="$rn" 'NR==line {print $6}' questions.txt) ]]; then
        awk -F '|' -v line="$rn" 'NR==line {print "\033[32m Correct! (" $6 ")\033[0m"}' questions.txt
        sleep 2; clear
     x=$((x + 1))
     else
       awk -F '|' -v line="$rn" 'NR==line {print "\033[31m Incorrect! The correct answer was: " $6 "\033[0m"}' questions.txt
         sleep 2; clear
        x=0
     fi
    if [[ $x -ne 0 ]]; then
    correct_answers=$((correct_answers + 1))
    fi
    if [[ $x -gt $long_streak ]]; then
  long_streak=$x
    fi
done
echo "----------Game Statistics----------"
echo "Correct: $correct_answers, Incorect: $((20 - correct_answers)) ,Longeset streak: $long_streak, Final score: $((correct_answers * 100 / 20))%"
score=$((correct_answers * 100 / 20))
echo " $name | $score | $correct_answers/20 | $(date +"%Y-%m-%d")" >> highscores.txt
echo "------------Quiz Over!------------"
read -p "Press Enter to view the high scores..."
echo "------------Highest Scores------------"
sort -t '|' -k2 -nr highscores.txt | head -1
fi
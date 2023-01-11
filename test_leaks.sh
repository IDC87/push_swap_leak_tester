#!/bin/bash

YELLOW='\033[1;33m'
RED='\033[0;31m'
GREY='\033[90m'
BOLD='\033[1m'
NC='\033[0m'
GREEN='\033[0;32m'
UNDERLINED='\033[4m'

BOLDGREEN="\e[1;${GREEN}m"
ITALICRED="\e[3;${GREY}"
ENDCOLOR="\e[0m"

file_name="push_swap"
checker_name="checker"

if [ ! -f "$file_name" ]; then
  echo -e "\n${RED}Error: \nyou must have the $file_name file created for this to work\n"
  exit 1
else
  echo -e "\n${GREEN}File $file_name found\n"
  echo -e "${GREEN}STARTING\n"
fi

declare -a hundred_numbers
for i in {1..100}; do
  new_number=$((RANDOM % 201 - 100))
  if [[ " ${hundred_numbers[@]} " =~ " ${new_number} " ]]; then
    continue
  else
    hundred_numbers+=($new_number)
  fi
done

declare -a five_hundred_numbers
for i in {1..500}; do
  new_number=$((RANDOM % 501 - 250))
  if [[ " ${five_hundred_numbers[@]} " =~ " ${new_number} " ]]; then
    continue
  else
    five_hundred_numbers+=($new_number)
  fi
done

declare -a five_numbers
for i in {1..5}; do
  new_number=$((RANDOM % 25 - 12))
  if [[ " ${five_numbers[@]} " =~ " ${new_number} " ]]; then
    continue
  else
    five_numbers+=($new_number)
  fi
done


function center_text {
  local text="$1"
  local width="$2"
  local spaces=$(( ($width - ${#text}) / 16 ))
	printf "\n\n"
  for ((i = 0; i < $spaces; i++)); do
    printf " "
  done
  printf "${YELLOW}${BOLD}${UNDERLINED}%s${NC}\n\n" "$text"
}


function leak_indicator {
	if [ "$?" -ne "0" ]; then
  echo -e "${RED}${BOLD}Memory leaks detected!${NC}\n"
else
  echo -e "${GREEN}${BOLD}No Memory leaks detected!${NC}\n"
fi
}


center_text "NO ARGUMENTS" $(tput cols)
valgrind --leak-check=yes ./push_swap > /dev/null 2>&1
leak_indicator
echo -e "${GREY}./push_swap${NC}\n"

center_text "1 ARGUMENT ONLY" $(tput cols)
valgrind --leak-check=yes ./push_swap 1 > /dev/null 2>&1
leak_indicator
echo -e "${GREY}./push_swap 1${NC}\n"

center_text "2 ARGUMENTS SORTED" $(tput cols)
valgrind --leak-check=yes ./push_swap 1 2 > /dev/null 2>&1
leak_indicator
echo -e "${GREY}./push_swap 1 2${NC}\n"

center_text "5 ARGUMENTS SORTED" $(tput cols)
valgrind --leak-check=yes ./push_swap -3 -1 30 50 100 > /dev/null 2>&1
leak_indicator
echo -e "${GREY}./push_swap -3 -1 30 50 100${NC}\n"

center_text "INT_MIN CHECK" $(tput cols)
valgrind --leak-check=yes ./push_swap 3 2 5 -2147483649 3 > /dev/null 2>&1
leak_indicator
echo -e "${GREY}./push_swap 3 2 5 -2147483649 3${NC}\n"

center_text "INT_MAX CHECK" $(tput cols)
valgrind --leak-check=yes ./push_swap 3 5 2147483648 3 > /dev/null 2>&1
leak_indicator
echo -e "${GREY}./push_swap 3 5 2147483648 3${NC}\n"

center_text "HAS INVALID CHARS" $(tput cols)
valgrind --leak-check=yes ./push_swap 3 1 -2 c 8 > /dev/null 2>&1
leak_indicator
echo -e "${GREY}./push_swap 3 1 -2 c 8${NC}\n"

center_text "HAS DUPLICATES" $(tput cols)
valgrind --leak-check=yes ./push_swap 5 1 4 2 1 > /dev/null 2>&1
leak_indicator
echo -e "${GREY}./push_swap 5 1 4 2 1${NC}\n"

center_text "5 ARGUMENTS SORTED" $(tput cols)
valgrind --leak-check=yes ./push_swap -3 -1 30 50 100 > /dev/null 2>&1
leak_indicator
echo -e "${GREY}./push_swap -3 -1 30 50 100${NC}\n"

center_text "2 VALUE STACK" $(tput cols)
valgrind --leak-check=yes ./push_swap -3 -20 > /dev/null 2>&1
leak_indicator
echo -e "${GREY}./push_swap -3 -20${NC}\n"

center_text "3 VALUE STACK" $(tput cols)
valgrind --leak-check=yes ./push_swap 200 -1 5 > /dev/null 2>&1
leak_indicator
echo -e "${GREY}./push_swap 200 -1 5${NC}\n"

center_text "5 VALUE STACK" $(tput cols)
valgrind --leak-check=yes ./push_swap 30 -4 72 8 -1 > /dev/null 2>&1
leak_indicator
echo -e "${GREY}./push_swap 30 -4 72 8 -1${NC}\n"

center_text "100 VALUE STACK" $(tput cols)
valgrind --leak-check=yes ./push_swap ${hundred_numbers[@]} > /dev/null 2>&1
leak_indicator
echo -e "${GREY}./push_swap (random 100 numbers)${NC}\n"

center_text "500 VALUE STACK" $(tput cols)
valgrind --leak-check=yes ./push_swap ${five_hundred_numbers[@]} > /dev/null 2>&1
leak_indicator
echo -e "${GREY}./push_swap (random 500 numbers)${NC}\n"

center_text "" $(tput cols)
center_text "INTS AS SINGLE STRING ARGUMENT" $(tput cols)
center_text "" $(tput cols)


center_text "1 ARGUMENT ONLY" $(tput cols)
valgrind --leak-check=yes ./push_swap "1" > /dev/null 2>&1
leak_indicator
printf "${GREY}./push_swap "'"1"'"${NC}\n"

center_text "2 ARGUMENTS SORTED" $(tput cols)
valgrind --leak-check=yes ./push_swap "1 2" > /dev/null 2>&1
leak_indicator
echo -e "${GREY}./push_swap "'"1 2"'"${NC}\n"

center_text "5 ARGUMENTS SORTED" $(tput cols)
valgrind --leak-check=yes ./push_swap "-3 -1 30 50 100" > /dev/null 2>&1
leak_indicator
echo -e "${GREY}./push_swap "'"-3 -1 30 50 100"'"${NC}\n"

center_text "INT_MIN CHECK" $(tput cols)
valgrind --leak-check=yes ./push_swap "3 2 5 -2147483649 3" > /dev/null 2>&1
leak_indicator
echo -e "${GREY}./push_swap "'"3 2 5 -2147483649 3"'"${NC}\n"

center_text "INT_MAX CHECK" $(tput cols)
valgrind --leak-check=yes ./push_swap "3 5 2147483648 3" > /dev/null 2>&1
leak_indicator
echo -e "${GREY}./push_swap "'"3 5 2147483648 3"'"${NC}\n"

center_text "HAS INVALID CHARS" $(tput cols)
valgrind --leak-check=yes ./push_swap "3 1 -2 c 8" > /dev/null 2>&1
leak_indicator
echo -e "${GREY}./push_swap "'"3 1 -2 c 8"'"${NC}\n"

center_text "HAS DUPLICATES" $(tput cols)
valgrind --leak-check=yes ./push_swap "5 1 4 2 1" > /dev/null 2>&1
leak_indicator
echo -e "${GREY}./push_swap "'"5 1 4 2 1"'"${NC}\n"

center_text "5 ARGUMENTS SORTED" $(tput cols)
valgrind --leak-check=yes ./push_swap "-3 -1 30 50 100" > /dev/null 2>&1
leak_indicator
echo -e "${GREY}./push_swap "'"-3 -1 30 50 100"'"${NC}\n"

center_text "2 VALUE STACK" $(tput cols)
valgrind --leak-check=yes ./push_swap "-3 -20" > /dev/null 2>&1
leak_indicator
echo -e "${GREY}./push_swap "'"-3 -20"'"${NC}\n"

center_text "3 VALUE STACK" $(tput cols)
valgrind --leak-check=yes ./push_swap "200 -1 5" > /dev/null 2>&1
leak_indicator
echo -e "${GREY}./push_swap "'"200 -1 5"'"${NC}\n"

center_text "5 VALUE STACK" $(tput cols)
valgrind --leak-check=yes ./push_swap "30 -4 72 8 -1" > /dev/null 2>&1
leak_indicator
echo -e "${GREY}./push_swap "'"30 -4 72 8"'" -1${NC}\n"



echo -e "\e[1;30;4;42mERROR MANAGEMENT\e[0m"

echo -e "\n${ITALICRED}Run with non numeric parameters${NC}"
./push_swap r @ z

echo -e "\n${ITALICRED}run with duplicates${NC}"

./push_swap 3 4 1 5 4
echo -e "\n${ITALICRED}run with only numeric one with MAXINT ${NC}"
./push_swap 2147483648

echo -e "\n${ITALICRED}run without parameters ${NC}\n"
./push_swap



echo -e "\n\e[1;30;4;42mPush_swap - identity test\e[0m\n"

echo -e "\n${ITALICRED}./push_swap 42 ${NC}"
./push_swap 42

echo -e "\n${ITALICRED}./push_swap 0 1 2 3 ${NC}"
./push_swap 0 1 2 3

echo -e "\n${ITALICRED}./push_swap 0 1 2 3 4 5 6 7 8 9${NC}"
./push_swap 0 1 2 3 4 5 6 7 8 9

if [ ! -f "$checker_name" ]; then
  echo -e "\n${RED}${BOLD}Error:\n"
  echo -e "${RED}${BOLD}For this part to work:\n"
  echo -e "${RED}${BOLD}Download the checker first and/or change its name to just "'"checker"'"\n${NC}"
  exit 1
fi

echo -e "\n\e[1;30;4;42mPush_swap - simple version\e[0m\n"

echo -e "\n${ITALICRED}ARG="2 1 0"; ./push_swap $ARG | ./checker $ARG${NC}"
ARG="2 1 0"; ./push_swap $ARG | ./checker $ARG



echo -e "\n\e[1;30;4;42mAnother simple version\e[0m\n"

echo -e "\n${ITALICRED}ARG="1 5 2 4 3"; ./push_swap $ARG | ./checker $ARG${NC}"
echo -e "\n"
ARG="1 5 2 4 3"; ./push_swap $ARG | ./checker $ARG
echo -e "\n"
./push_swap $ARG

echo -e "\n\n\n${ITALICRED}ARG="${five_numbers[@]}"; ./push_swap ${five_numbers[@]} | ./checker ${five_numbers[@]}${NC}"
echo -e "\n"
ARG="${five_numbers[@]}"; ./push_swap ${five_numbers[@]} | ./checker ${five_numbers[@]}
echo -e "\n"
./push_swap ${five_numbers[@]}



echo -e "\n\n\e[1;30;4;42mPush_swap - Middle version\e[0m\n"

echo -e "\n${ITALICRED}ARG="${hundred_numbers[@]}"; ./push_swap 100 numbers | ./checker 100 numbers${NC}"
echo -e "\n"
ARG="${hundred_numbers[@]}"; ./push_swap $ARG | ./checker $ARG
echo -e "\n"



echo -e "\n\n\e[1;30;4;42mPush_swap - Advanced version\e[0m\n"

echo -e "\n${ITALICRED}ARG="${five_hundred_numbers[@]}"; ./push_swap 500 numbers | ./checker 500 numbers${NC}"
echo -e "\n"
ARG="${five_hundred_numbers[@]}"; ./push_swap $ARG | ./checker $ARG
echo -e "\n"
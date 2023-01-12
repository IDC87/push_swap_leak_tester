#!/bin/bash

YELLOW='\033[1;33m'
RED='\033[0;31m'
GREY='\033[90m'
BOLD='\033[1m'
NC='\033[0m'
GREEN='\033[0;32m'
UNDERLINED='\033[4m'

BOLDGREEN="\e[1;${GREEN}"
ITALICRED="\e[3;${GREY}"
ENDCOLOR="\e[0m"

file_name="push_swap"
checker_name="checker"

check_os_and_execute() {
    if [ -f /etc/os-release ]; then
        echo -e "\n\e[1;30;4;42mDetected Linux\e[0m"
    elif [ "$(uname)" == "Darwin" ]; then
        echo "Detected MacOS"        
    else
        echo "Unknown Operating System"
    fi
}
check_os_and_execute


if [ ! -f "$file_name" ]; then
  echo -e "\n${RED}Error: \nyou must have the $file_name file created for this to work\n"
  exit 1
else
  echo -e "\n${GREEN}File $file_name found\n"
  echo -e "${GREEN}${BOLD}STARTING${NC}\n"
fi
sleep 1

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

declare -a hundred_numbers
for i in {1..100}; do
  new_number=$((RANDOM % 201 - 100))
  if [[ " ${hundred_numbers[@]} " =~ " ${new_number} " ]]; then
    continue
  else
    hundred_numbers+=($new_number)
  fi
done
IFS=' '
hundred_numbers_string="\"${hundred_numbers[*]}\""

declare -a five_hundred_numbers
for i in {1..500}; do
  new_number=$((RANDOM % 501 - 250))
  if [[ " ${five_hundred_numbers[@]} " =~ " ${new_number} " ]]; then
    continue
  else
    five_hundred_numbers+=($new_number)
  fi
done
IFS=' '
five_hundred_numbers_string="\"${hundred_numbers[*]}\""

declare -a five_numbers
count=0
while [ $count -lt 5 ]
do
  new_number=$((RANDOM % 25 - 12))
  if [[ " ${five_numbers[@]} " =~ " ${new_number} " ]]; then
    continue
  else
    five_numbers+=($new_number)
    count=$((count+1))
  fi
done

#--------------------------------------------------------------------------------------------------------------------------------
description=("NO ARGUMENTS" "1 ARGUMENT ONLY" "2 ARGUMENTS SORTED" "3 ARGUMENTS SORTED" "5 ARGUMENTS SORTED" \
"INT_MIN CHECK" "INT_MAX CHECK" "HAS INVALID CHARS" "HAS DUPLICATES" "2 VALUE STACK" "3 VALUE STACK" "5 VALUE STACK")

args=("" "1" "1 2" "20 21 100" "-3 -1 30 31 100" "3 2 5 -2147483649 3" "3 2 5 2147483648 3" "3 1 -2 c 8" \
"5 1 4 2 1" "-3 -20" "200 -1 5" "30 -4 72 8 -1")

center_text "NORMAL INPUTS" $(tput cols)

for index in "${!args[@]}"
do
    output=$(valgrind --tool=memcheck --leak-check=full ./push_swap ${args[index]} 2>&1)
    err_output=$(./push_swap ${args[index]} 2>&1 >/dev/null)
    if echo "$output" | grep -q "Process terminating with default action of signal 11 (SIGSEGV)" && [ -z "$err_output" ]; then
	 	echo -e "${RED}${BOLD}MEHHH... SEGFAULT!${NC}\n"	
	elif echo "$output" | grep -q "LEAK SUMMARY:" && [ -z "$err_output" ]; then
    	echo -e "${RED}${BOLD}Memory leaks detected! with arguments: ${GREY}${args[index]}  (${description[index]}) ${NC}\n"	 
    elif echo "$output" | grep -q "All heap blocks were freed -- no leaks are possible"; then
      echo -e "${GREEN}${BOLD}No Memory leaks detected! with arguments: ${GREY}${args[index]} (${description[index]}) ${NC}\n"
    else
      echo -e "Unexpected output, check the output manually with arguments: ${GREY}${args[index]}\n"
    fi
done

output=$(valgrind --tool=memcheck --leak-check=full ./push_swap ${hundred_numbers_string[@]} 2>&1)
err_output=$(./push_swap ${hundred_numbers_string[@]} 2>&1 >/dev/null)
	if echo "$output" | grep -q "Process terminating with default action of signal 11 (SIGSEGV)" && [ -z "$err_output" ]; then
	 	echo -e "${RED}${BOLD}MEHHH... SEGFAULT!${NC}\n"
    elif echo "$output" | grep -q "LEAK SUMMARY:" && [ -z "$err_output" ]; then
      echo -e "${RED}${BOLD}Memory leaks detected! with arguments: ${GREY}100 random numbers   ${NC}\n"
    elif echo "$output" | grep -q "All heap blocks were freed -- no leaks are possible"; then
      echo -e "${GREEN}${BOLD}No Memory leaks detected! with arguments: ${GREY}100 random numbers  ${NC}\n"
    else
      echo -e "Unexpected output, check the output manually with arguments: ${GREY}${hundred_numbers_string[@]}\n"
    fi

output=$(valgrind --tool=memcheck --leak-check=full ./push_swap ${five_hundred_numbers_string[@]} 2>&1)
err_output=$(./push_swap ${five_hundred_numbers_string[@]} 2>&1 >/dev/null)
	if echo "$output" | grep -q "Process terminating with default action of signal 11 (SIGSEGV)" && [ -z "$err_output" ]; then
	 	echo -e "${RED}${BOLD}MEHHH... SEGFAULT!${NC}\n"
    elif echo "$output" | grep -q "LEAK SUMMARY:" && [ -z "$err_output" ]; then
      echo -e "${RED}${BOLD}Memory leaks detected! with arguments: ${GREY}500 random numbers   ${NC}\n"
    elif echo "$output" | grep -q "All heap blocks were freed -- no leaks are possible"; then
      echo -e "${GREEN}${BOLD}No Memory leaks detected! with arguments: ${GREY}500 random numbers  ${NC}\n"
    else
      echo -e "Unexpected output, check the output manually with arguments: ${GREY}${five_hundred_numbers_string[@]}\n"
    fi

#------------------------------------------------------------------------------------------------------------------

center_text "INTS AS SINGLE STRING ARGUMENT" $(tput cols)

description=("1 ARGUMENT ONLY" "2 ARGUMENTS SORTED" "3 ARGUMENTS SORTED" "5 ARGUMENTS SORTED" \
"INT_MIN CHECK" "INT_MAX CHECK" "HAS INVALID CHARS" "HAS DUPLICATES" "2 VALUE STACK" "3 VALUE STACK" "5 VALUE STACK")

args=('"1"' '"1 2"' '"20 21 100"' '"-3 -1 30 31 100"' '"3 2 5 -2147483649 3"' '"3 2 5 2147483648 3"' '"3 1 -2 c 8"' \
'"5 1 4 2 1"' '"-3 -20"' '"200 -1 5"' '"30 -4 72 8 -1"')

for index in "${!args[@]}"
do
    output=$(valgrind --tool=memcheck --leak-check=full ./push_swap ${args[index]} 2>&1)
    err_output=$(./push_swap ${args[index]} 2>&1 >/dev/null)
    if echo "$output" | grep -q "Process terminating with default action of signal 11 (SIGSEGV)" && [ -z "$err_output" ]; then
	 	echo -e "${RED}${BOLD}MEHHH... SEGFAULT!${NC}\n"	
	elif echo "$output" | grep -q "LEAK SUMMARY:" && [ -z "$err_output" ]; then
    	echo -e "${RED}${BOLD}Memory leaks detected! with arguments: ${GREY}${args[index]}  (${description[index]}) ${NC}\n"	 
    elif echo "$output" | grep -q "All heap blocks were freed -- no leaks are possible"; then
      echo -e "${GREEN}${BOLD}No Memory leaks detected! with arguments: ${GREY}${args[index]} (${description[index]}) ${NC}\n"
    else
      echo -e "Unexpected output, check the output manually with arguments: ${GREY}${args[index]}\n"
    fi
done

output=$(valgrind --tool=memcheck --leak-check=full ./push_swap ${hundred_numbers_string[@]} 2>&1)
err_output=$(./push_swap ${hundred_numbers_string[@]} 2>&1 >/dev/null)
	if echo "$output" | grep -q "Process terminating with default action of signal 11 (SIGSEGV)" && [ -z "$err_output" ]; then
	 	echo -e "${RED}${BOLD}MEHHH... SEGFAULT!${NC}\n"
    elif echo "$output" | grep -q "LEAK SUMMARY:" && [ -z "$err_output" ]; then
      echo -e "${RED}${BOLD}Memory leaks detected! with arguments: ${GREY}${hundred_numbers_string[@]}${NC}\n"
    elif echo "$output" | grep -q "All heap blocks were freed -- no leaks are possible"; then
      echo -e "${GREEN}${BOLD}No Memory leaks detected! with arguments: ${GREY}100 random numbers${NC}\n"
    else
      echo -e "Unexpected output, check the output manually with arguments: ${GREY}${hundred_numbers_string[@]}\n"
    fi

output=$(valgrind --tool=memcheck --leak-check=full ./push_swap ${five_hundred_numbers[@]} 2>&1)
err_output=$(./push_swap ${five_hundred_numbers[@]} 2>&1 >/dev/null)
	if echo "$output" | grep -q "Process terminating with default action of signal 11 (SIGSEGV)" && [ -z "$err_output" ]; then
	 	echo -e "${RED}${BOLD}MEHHH... SEGFAULT!${NC}\n"
    elif echo "$output" | grep -q "LEAK SUMMARY:" && [ -z "$err_output" ]; then
      echo -e "${RED}${BOLD}Memory leaks detected! with arguments: ${GREY}500 random numbers   ${NC}\n"
    elif echo "$output" | grep -q "All heap blocks were freed -- no leaks are possible"; then
      echo -e "${GREEN}${BOLD}No Memory leaks detected! with arguments: ${GREY}500 random numbers  ${NC}\n"
    else
      echo -e "Unexpected output, check the output manually with arguments: ${GREY}${five_hundred_numbers[@]}\n"
    fi


sleep 1
echo -e "\n\n\e[1;30;4;42mERROR MANAGEMENT\e[0m"
sleep 1

echo -e "\n${ITALICRED}Run with non numeric parameters${NC}"
./push_swap r @ z

echo -e "\n${ITALICRED}run with duplicates${NC}"

./push_swap 3 4 1 5 4
echo -e "\n${ITALICRED}run with only numeric one with MAXINT ${NC}"
./push_swap 2147483648

echo -e "\n${ITALICRED}run without parameters ${NC}\n"
./push_swap


sleep 1
echo -e "\n\e[1;30;4;42mPush_swap - identity test\e[0m\n"
sleep 1
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

sleep 1
echo -e "\n\n\e[1;30;4;42mPush_swap - simple version\e[0m\n"
sleep 1
echo -e "\n${ITALICRED}ARG="2 1 0"; ./push_swap $ARG | ./checker $ARG${NC}"
ARG="2 1 0"; ./push_swap $ARG | ./checker $ARG


sleep 1
echo -e "\n\n\e[1;30;4;42mAnother simple version\e[0m\n"
sleep 1
echo -e "\n${ITALICRED}ARG="1 5 2 4 3"; ./push_swap $ARG | ./checker $ARG${NC}"
echo -e "\n"
ARG="1 5 2 4 3"; ./push_swap $ARG | ./checker $ARG
echo -e "\n"
./push_swap $ARG

sleep 1
echo -e "\n\n\n${ITALICRED}ARG="${five_numbers[@]}"; ./push_swap ${five_numbers[@]} | ./checker ${five_numbers[@]}${NC}"
echo -e "\n"
ARG="${five_numbers[@]}"; ./push_swap ${five_numbers[@]} | ./checker ${five_numbers[@]}
echo -e "\n"
./push_swap ${five_numbers[@]}


sleep 1
echo -e "\n\n\e[1;30;4;42mPush_swap - Middle version\e[0m\n"
sleep 1
echo -e "\n${ITALICRED}ARG="${hundred_numbers[@]}"; ./push_swap 100 numbers | ./checker 100 numbers${NC}"
echo -e "\n"
ARG="${hundred_numbers[@]}"; ./push_swap $ARG | ./checker $ARG
echo -e "\n"


sleep 1
echo -e "\n\n\e[1;30;4;42mPush_swap - Advanced version\e[0m\n"
sleep 1
echo -e "\n${ITALICRED}ARG="${five_hundred_numbers[@]}"; ./push_swap 500 numbers | ./checker 500 numbers${NC}"
echo -e "\n"
ARG="${five_hundred_numbers[@]}"; ./push_swap $ARG | ./checker $ARG
echo -e "\n"
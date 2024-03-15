#! /bin/bash

### Global scoreboard
player1_Score=0
player2_Score=0

### Checking if they want to continue multiplayer or quit the game
pvpagain() {
    echo "Will this legendary dual between 2 titans continue? [y/n]:"
    read -re playeranswer
    if [[ "${playeranswer,,}" == 'y' || ${playeranswer,,} == 'yes' ]]; then 
        echo "BATTLE OF THE GIANTS AGAIN!!"
    elif [[ ${playeranswer,,} == 'n' || ${playeranswer,,} == 'no' ]]; then
        echo "Thanks for playing!!!!"
        exit 0
    else 
        echo " "
        echo "Please Try Again...."
        echo "Enter in either ${bold}[y/yes/n/no]${normal}"
        pvpagain
    fi
}

### Checking if the player wants to continue playing single player or quit the game.
### This function is very similar to pvpagain or anytime I'm asking the players if they want to play again really.
### Thinking about a way to abstract this into a function of this own, and pass in the messages I want to be echo still.
### That way it cleans up a lot more code & maintains the fun of different messages for different points of playing the game.
playagain() {
    echo "Would you like to try your luck against the CPU again? [y/n]:"
    read -re playeranswer
    if [[ "${playeranswer,,}" == 'y' || ${playeranswer,,} == 'yes' ]]; then 
        echo "BATTLE OF THE GIANTS AGAIN!!"
    elif [[ ${playeranswer,,} == 'n' || ${playeranswer,,} == 'no' ]]; then
        echo "Thanks for playing!!!!"
        exit 0
    else 
        echo " "
        echo "Please Try Again...."
        echo "Enter in either ${bold}[y/yes/n/no]${normal}"
        playagain
    fi
}

### CPU randomly picking rock, paper or scissors
cpuchoice() {
    echo "CPU deciding how to kick your ass this time"
    sleep 2
    case "$(($RANDOM%3))" in
        "0") # Rock
            return 0
            ;;
        "1") # Paper
            return 1
            ;;
        "2") # Scissors
            return 2
            ;;
    esac
    return 0
}

### Returning player's choice of rock, paper or scissors
playerchoice() {
    echo " "
    echo "Please choose rock, paper or scissors: [rock/paper/scissors]"
    read -res rpschoice
    echo "######################################################"
    #echo "${rpschoice,,}" # Keeping for debug if I want
    if [[ ${rpschoice,,} ==  "rock" || ${rpschoice,,} ==  "paper" || ${rpschoice,,} ==  "scissors" ]]; then
        case "${rpschoice,,}" in
            "rock")
                return 0
                ;;
            "paper")
                return 1
                ;;
            "scissors")
                return 2
                ;;
        esac
    else
        echo " "
        echo "Please Try Again...."
        echo "Only choose from either rock, paper or scissors: [rock/paper/scissors]"
        playerchoice
    fi
}

### Run the 2-player logic
2player() {
    echo "Player 1 up 1st"
    echo "Player 2, no PEEKING!!!"
    echo "######################################################"
    playerchoice
    player1=$?
    echo " "
    echo "Player 2 up next"
    echo "Player 1, no PEEKING!!!"
    echo "######################################################"
    playerchoice
    player2=$?
    result=$(($player1 - $player2))
    case "$result" in
        -2)
            echo " "
            echo "Player 1 swept the rug right from under ya!!!"
            ((player1_Score+=1))
            ;;
        -1)
            echo " "
            echo "Player 2 laughs at your puny choice!"
            ((player2_Score+=1))
            ;;
        0)
            echo " "
            echo "This game was a tie!! You must be sharing the same brain right now :D"
            ;;
        1)
            echo " "
            echo "Player 1 must be reading your mind. THEY DID IT AGAIN!"
            ((player1_Score+=1))
            ;;
        2)
            echo " "
            echo "Player 2 mocks your futile attempts. Bring your best against them!"
            ((player2_Score+=1))
            ;;
    esac
}

### Run the singleplayer logic
singleplayer() {
    echo "Player 1 up 1st"
    playerchoice
    player1=$?
    echo "CPU up next"
    echo "######################################################"
    cpuchoice
    player2=$?
    result=$(($player1 - $player2))
    case "$result" in
        -2)
            echo "Against all odds... YOU HAVE WON!!! YOU GENIUS!!!"
            ((player1_Score+=1))
            ;;
        -1)
            echo "THE CPU HAS CRUSHED YOU ONCE AGAIN! They take pity on your intellectual choices"
            ((player2_Score+=1))
            ;;
        0)
            echo "This game was a tie!! You must be using chatgpt to compete!"
            ;;
        1)
            echo "Against all odds... YOU HAVE WON!!! YOU GENIUS!!!"
            ((player1_Score+=1))
            ;;
        2)
            echo "THE CPU HAS CRUSHED YOU ONCE AGAIN! They take pity on your intellectual choices"
            ((player2_Score+=1))
            ;;
    esac
}   


### Argument passed to this function should be either 0 or 3. 0 for single player. 3 for 2-player pvp.
gameboard() {
    player1_Score=0
    player2_Score=0
    echo "Gametime!!!"
    echo "######################################################"
    echo ""
    #echo "$1"
    case "$1" in
        "0") # Single player game mode
            while true; do
                singleplayer
                echo " "
                echo "Current Scores:"
                echo "Player 1: $player1_Score"
                echo "Player 2: $player2_Score"
                playagain
            done
            ;;
        "3") # Multiplayer player game mode
            while true; do
                2player
                echo " "
                echo "Current Scores:"
                echo "Player 1: $player1_Score"
                echo "Player 2: $player2_Score"
                pvpagain
            done
            ;;
    esac
}

### Deciding if the user wants to play against the CPU or against a friend
multiplayer() {
    echo "Single or 2-player PVP? [1/2]"
    read -res playeranswer
    #echo "$playeranswer"

    if [[ "$playeranswer" == '1' ]]; then 
        echo "Can you defeat the ${bold}ALL MIGHTY CPU?!?!!${normal}"
        return 0
    elif [[ "$playeranswer" == '2' ]]; then
        echo "2-Player MORTAL COMBAT BEGINS!!"
        return 3
    else
        echo " "
        echo "Please Try Again...."
        echo "Enter in either 1 for single player or 2 for local-pvp ${bold}[1/2]${normal}"
        multiplayer
    fi
}

### Initial checking if the user wants to play
gamestart() {
    echo "Would you like to play? [y/n]: "
    read -res playeranswer

    if [[ "${playeranswer,,}" == 'y' || ${playeranswer,,} == 'yes' ]]; then 
        echo "LETSSS ROCK!"
        return 0
    elif [[ ${playeranswer,,} == 'n' || ${playeranswer,,} == 'no' ]]; then
        echo "Thanks for playing!!!!"
        exit 0
    else
        echo " "
        echo "Please Try Again...."
        echo "Enter in either ${bold}[y/yes/n/no]${normal}"
        gamestart
    fi
}

main() {
    ### Giving formatting options
    bold=$(tput bold)
    normal=$(tput sgr0)

    ### Intro into this awesome game!
    echo "${bold}ARE YOU READY TO RUMBLE!!?!?!?!?!"
    echo "${normal}IN THE STRONGEST ${bold}ROCK PAPER SCISSORS${normal} BATTLE YOU HAVE EVER PARTICIPATED IN??!?!?!?!"

    ### Ask the players if they want to play?
    gamestart
    ### See if they want single player mode or multiplayer mode
    multiplayer
    
    ### Proceed to play the game
    gameboard $?
}

# Executing the Main function
main
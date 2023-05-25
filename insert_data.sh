#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
cat games.csv | while IFS="," read year round winner opponent winner_goals opponent_goals
do
if [[ $winner != winner && $opponent != opponent && $year != year && $round != round && $winner_goals != winner_goals && $opponent_goals != opponent_goals ]]
then
  WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$winner'")
  if [[ -z $WINNER_ID ]]
    then
   INSERT_TEAM=$($PSQL "INSERT INTO teams(name) VALUES ('$winner')")
   if [[ $INSERT_TEAM == 'INSERT 0 1' ]]
   then
   echo inserted $winner;
   WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$winner'")
    fi
  fi

  OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$opponent'")
  if [[ -z $OPPONENT_ID ]]
    then
   INSERT_TEAM=$($PSQL "INSERT INTO teams(name) VALUES ('$opponent')")
   if [[ $INSERT_TEAM == 'INSERT 0 1' ]]
   then
   echo inserted $opponent;
   OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$opponent'")
    fi
  fi 

  INSERT_GAMES=$($PSQL "INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES($year,'$round',$WINNER_ID,$OPPONENT_ID,$winner_goals,$opponent_goals)")
  if [[ $INSERT_GAMES == 'INSERT 0 1' ]]
    then
    echo inserted game
  fi
fi
done
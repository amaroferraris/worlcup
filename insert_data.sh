#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE teams, games")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  #  Adding every team by querying winner and opponent
  if [[ $OPPONENT != "opponent" ]]
  then
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    if [[ -z $OPPONENT_ID ]]
    then
      INSERT_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      # echo TEAMS - Inserted: $OPPONENT
    fi
  fi
  if [[ $WINNER != "winner" ]]
  then
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    if [[ -z $WINNER_ID ]]
    then
      INSERT_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      # echo TEAMS - Inserted: $WINNER

    fi
  fi

  OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
  WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")

  if [[ $YEAR != "year" ]]
  then
    INSERT_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
    echo Inserted on games... Year: $YEAR, Round: $ROUND, Winner: $WINNER_ID, Opponent: $OPPONENT_ID, Goals: $WINNER_GOALS, $OPPONENT_GOALS
  fi

done

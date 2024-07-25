#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.


echo $($PSQL "TRUNCATE TABLE games, teams")


cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  # the winner variable will never be equal to "winner" so we might as well use it for our loop
  if [[ $WINNER != "winner" ]]
    then
      WINNER_QUERY=$($PSQL "SELECT name FROM teams WHERE name='$WINNER'")

      #if we don't find anything..
      if [[ -z $WINNER_QUERY ]]
        then
        INSERT_WINNER_QUERY=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")

          #if our winner was successfuly inserted in the DB...
          if [[ $INSERT_WINNER_QUERY == "INSERT 0 1" ]]
            then
              echo "$WINNER was added in the DB"
          fi
      fi
  fi

  #now for the opponent team
  if [[ $OPPONENT != "opponent" ]]
    then
      OPPONENT_QUERY=$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT'")

      if [[ -z $OPPONENT_QUERY ]]
        then
          INSERT_OPPONENT_QUERY=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
          if [[ $INSERT_TEAM2_NAME == "INSERT 0 1" ]]
            then
              echo "$OPPONENT was added in the DB"
          fi
      fi
  fi

  #now we insert the games
  if [[ YEAR != "year" ]]
    then
      WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
      OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

      INSERT_GAME=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
      if [[ $INSERT_GAME == "INSERT 0 1" ]]
        then
          echo "Added in the DB: $YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS and $OPPONENT_GOALS"
      fi
  fi
    
done
class PoolsController < ApplicationController
  # GET /pools
  def index
    numPools = params['numPools'].to_i
    numTeams = params['numTeams'].to_i
    numRounds = params['numRounds'].to_i
    snake = params['snake'] == 'true'

    #define pools
    pools = []
    for i in 0..numPools-1
      pools.push({ :id => i+1, :name => "Pool"+(i+1).to_s26, :teams => []})
    end

    #assign teams to pools
    for i in 0..numTeams.to_i-1
      team = { :id => i+1, :name => "Team"+(i+1).to_s }

      poolID = i % numPools;
      #handle snake ordering
      if(snake && (((i / numPools).floor) % 2) == 1)
        poolID = (poolID - (numPools - 1)).abs
      end
      
      pools[poolID][:teams].push(team)
    end

    #create the games
    gameID = 1 #handle game id. all id generating would go away if using ActiveRecord
    pools.each_with_index { |pool, a|
      pool[:rounds] = []
      for b in 0..numRounds-1
        
        #could move game calculation out and just loop once if using ActiveRecord (or didn't care about sequential ids)
        games = []
        for i in 0..pool[:teams].size-1 #loop through teams in pool
          for j in i+1..pool[:teams].size-1 #loop through temas of higher index
            games.push({ :id => gameID, :team1 => pool[:teams][i], :team2 => pool[:teams][j] })
            gameID += 1
          end
        end
        #end of section that could be moved out a loop

        pool[:rounds].push({ :id => (a*numRounds)+b+1, :games => games})
      end
    }

    json_response(pools)
  end
end

require "json"
class Players
    attr_accessor :name, :position, :bank, :property
    def initialize (name, position, bank, property)
        @name = name
        @position = position
        @bank = bank
        @property = property
    end

end

class Map
    attr_accessor :name, :price, :color, :type, :owner, :loc
    def initialize (name, price, color, type, owner, loc)
        @name = name
        @price = price
        @color = color
        @type = type
        @owner = owner
        @loc =loc
    end

end

def load_map()
    file = File.read "board.json"
    data = JSON.parse(file)
    return data
end

def read_map(data,i)
    map_name = data[i]["name"]
    map_price = data[i]["price"]
    map_color = data[i]["colour"]
    map_type = data[i]["type"]
    map_owner =nil
    map_loc = i
    map = Map.new(map_name,map_price,map_color,map_type,map_owner,map_loc)

    return map
end

def map(data)
    map = Array.new()
    for i in 0...data.length
         map << read_map(data,i)
    end
    return map

end

def load_players()
    starting_position = 0
    starting_bank = 16
    starting_property = 0
    players = Array.new()
    player1 = Players.new("Peter",starting_position,starting_bank,starting_property)
    player2 = Players.new("Billy",starting_position,starting_bank,starting_property)
    player3 = Players.new("Charlotte", starting_position,starting_bank,starting_property)
    player4 = Players.new("Sweedal", starting_position,starting_bank,starting_property)
    players << player1
    players << player2
    players << player3
    players << player4
    return players
    

end

def load_dice
    file = File.read "rolls_1.json"
    data = JSON.parse(file)
    return data

end

def dice_queue(dice)
    queue = Queue.new
    for i in 0...dice.length
        queue << dice[i]
    end
    return queue

end

def check_property(players,map)
    position = players.position
    if map[position].owner == nil
        players.bank -= map[position].price
        map[position].owner = players.name
    end
    puts "map name : " + map[position].name.to_s + " Map owner : " +  map[position].owner.to_s
end


def moving(players,queue,map)
    while queue.length != 0
        
        for i in 0...players.length
            if queue.length != 0
                
                players[i].position += queue.pop
                if players[i].position > 8
                    players[i].position -= 8
                    players[i].bank += 1
                end
                check_property(players[i],map)
                puts "Name : " + players[i].name.to_s + "Position : " + players[i].position.to_s + " Bank : " + players[i].bank.to_s
            end
        end
    end

end

def start()
    data = load_map()
    map = map(data)
    players = load_players()
    puts map[1].owner
    puts players[0].position
    dice = load_dice()
    queue = dice_queue(dice)
    moving(players,queue,map)
    puts map[5].loc
end

start()
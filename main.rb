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
    attr_accessor :name, :price, :color, :type, :owner
    def initialize (name, price, color, type, owner)
        @name = name
        @price = price
        @color = color
        @type = type
        @owner = owner
    end

end

def load_map()
    file = File.read "board.json"
    data = JSON.parse(file)
    # map = Map.new()
    # for i in 0...data.length
       
    #     puts data[i]["name"]

    # end
    return data
end

def read_map(data,i)
    map_name = data[i]["name"]
    map_price = data[i]["price"]
    map_color = data[i]["colour"]
    map_type = data[i]["type"]
    map_owner =nil
    map = Map.new(map_name,map_price,map_color,map_type,map_owner)

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

def start()
    data = load_map()
    map = map(data)
    players = load_players()
    puts map[1].owner
    puts players[0].position
end

start()
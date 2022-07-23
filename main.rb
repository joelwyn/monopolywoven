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

def check_property_color(players,map,j,m_position)
    same_color_owner = false
    for i in 0...map.length
        if map[i].color == map[m_position].color && map[i].loc != map[m_position].loc && map[i].owner !=nil 
            if map[i].owner ==players[j].name 
                same_color_owner = true
           # puts "xxxx : " + i.to_s + map[i].owner.to_s
            end
        end
    end
    return same_color_owner

end

def check_property(players,map,i)
    position = players[i].position
    if map[position].owner == nil
        players[i].bank -= map[position].price
        map[position].owner = players[i].name
    else
        for j in 0...players.length
            if map[position].owner == players[j].name
                #map_color = map[position].color
                same_color_owner = check_property_color(players,map,j,position)
                if same_color_owner == true
                    players[i].bank = players[i].bank - map[position].price * 2
                    players[j].bank = players[j].bank + map[position].price * 2
                else
                    players[i].bank -= map[position].price
                    players[j].bank += map[position].price
                end
            end
        end

    end
    #puts "map name : " + map[position].name.to_s + " Map owner : " +  map[position].owner.to_s + " map color : " + map[position].color.to_s
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
                check_property(players,map,i)
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
    puts map[0].owner
end

start()
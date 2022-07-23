require "json"

# player class that holding different attributes
class Players
    attr_accessor :name, :position, :bank, :property
    def initialize (name, position, bank, property)
        @name = name
        @position = position
        @bank = bank
        @property = property
    end

end

# map class that holding different property info
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

# loading board from json file
def load_map()
    file = File.read "board.json"
    data = JSON.parse(file)
    return data
end

# storing each attributes into a map object
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

# storing each position in the map into an array
def map(data)
    map = Array.new()
    for i in 0...data.length
         map << read_map(data,i)
    end
    return map

end

# adding new players as an object with players class with default settings then store the players into an array
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

# checking integer with min and max value for selection of the dice set
def read_integer_in_range()
    value = gets.chomp
    i_value = value.to_i
    while(i_value < 1 or i_value >2)
        puts " Please select option 1 for dice set 1 and select option 2 for dice set 2 "
        value = gets.chomp
        i_value = value.to_i
    end
    return i_value

end

# selectionn to use which dice set
def load_dice
    puts("Please select option 1 for dice set 1 and select option 2 for dice set 2")
    selection = read_integer_in_range()
    case selection 
        when 1
            file = File.read "rolls_1.json"
            data = JSON.parse(file)
        when 2
            file = File.read "rolls_2.json"
            data = JSON.parse(file)
        end
    return data

end

# using queue to input all the integer of move from dice json file
def dice_queue(dice)
    queue = Queue.new
    for i in 0...dice.length
        queue << dice[i]
    end
    return queue

end

# checking property color to determine whether if the same color belongs to the same owner
def check_property_color(players,map,j,m_position)
    same_color_owner = false
    for i in 0...map.length
        if map[i].color == map[m_position].color && map[i].loc != map[m_position].loc && map[i].owner !=nil 
            if map[i].owner ==players[j].name 
                same_color_owner = true
            end
        end
    end
    return same_color_owner

end

# checking if property is owned or vacant, if vacant player will purchase it, and if it is owned, player will pay rent
def check_property(players,map,i)
    position = players[i].position
    if map[position].owner == nil
        players[i].bank -= map[position].price
        map[position].owner = players[i].name
    else
        for j in 0...players.length
            if map[position].owner == players[j].name
                same_color_owner = check_property_color(players,map,j,position)
                if same_color_owner == true
                    players[i].bank = players[i].bank - map[position].price * 2
                    if players[i].bank >= 0
                        players[j].bank = players[j].bank + map[position].price * 2
                    else
                        players[j].bank = players[j].bank + map[position].price * 2 + players[i].bank
                    end
                else
                    players[i].bank -= map[position].price
                    if players[i].bank >= 0
                        players[j].bank += map[position].price
                    else
                        players[j].bank = players[j].bank + map[position].price + players[i].bank
                    end
                end
            end
        end
    end
end

# check bank status of each player to make sure everyone is not below 0
def check_bank_status(players,i)
    insolvent = false
    if players[i].bank < 0
            puts players[i].bank
            insolvent = true
    end
    return insolvent
end

# popping the queue to start moving each players
def moving(players,queue,map)
    bank_status = false
    while queue.length != 0 && bank_status == false       
        for i in 0...players.length  
            if queue.length != 0 && bank_status == false
                players[i].position += queue.pop
                if players[i].position > 8
                    players[i].position -= 8
                    players[i].bank += 1
                end
                check_property(players,map,i)
                bank_status = check_bank_status(players,i)
            end
        end
    end

end

def start()
    data = load_map()
    map = map(data)
    players = load_players()
    dice = load_dice()
    queue = dice_queue(dice)
    moving(players,queue,map)
    puts"--------------------------------------------------"
    puts "* Who would win each game?"
    winner = players.max_by {|name,bank| bank}
    puts winner.name.to_s 
    puts"--------------------------------------------------"
    puts "* How much money does everybody end up with?"
    for i in 0...players.length
       puts "Players name: " + players[i].name.to_s + ", accounts $ : " + players[i].bank.to_s
    end
    puts"--------------------------------------------------"
    puts "* What spaces does everybody finish on?"
    for i in 0...players.length
        puts "Players name: " + players[i].name.to_s + ", position : " + players[i].position.to_s
     end
     puts"--------------------------------------------------"
end

start()
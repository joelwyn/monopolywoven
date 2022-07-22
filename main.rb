require "json"
class Players
    attr_accessor :position, :bank, :property
    def initialize (position, bank, property)
        @position = position
        @bank = bank
        @property = property
    end

end
class Map
    attr_accessor :name, :price, :color, :type
    def initialize (name, price, color, type)
        @name = name
        @price = price
        @color = color
        @type = type
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
    puts ("map name: " + map_name.to_s + "map price: "  + map_price.to_s)
end
def map(data)
    map = Array.new()
    for i in 0...data.length
         map << read_map(data,i)
    end
    puts data.length

end


def start()
    data = load_map()
    map(data)
    peter = Players.new(0,16,0)
    puts peter.bank
end

start()
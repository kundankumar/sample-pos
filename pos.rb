#  assuming Barcode Scanner reads barcode and decrypt to provide "barcode" as string input to the system
#  on pressing exit button it sends exitcode as boolean input
#  "display_message" and "print_message" are string outputs for corresponding devices

DATABASE = []
Record = Struct.new(:barcode, :id, :name, :price)
DATABASE.push(Record.new("1234567890", 1, 'Item 1', 10.0))
DATABASE.push(Record.new("2345678901", 2, 'Item 2', 20.0))
DATABASE.push(Record.new("3456789012", 3, 'Item 3', 30.0))


class Scanner
    def read_barcode(barcode, exitcode)
        handle = nil
        handle = barcode unless exitcode
    end
end

class LCD
    def display_message(msg)
        puts "* LCD * #{msg}"
    end
end

class Printer
    def print_message(msg)
        puts "* Printer * \n#{msg}"
    end
end

class Item  
    attr_reader :id, :name, :price, :barcode
    def initialize(barcode, id, name, price)
        @id = id
        @name =  name
        @price = price
        @barcode = barcode
    end
end

class List
    def initialize
        @scanned_items =[]
    end

    def add_item(item)
        @scanned_items.push(item)
    end

    def total
        price = 0.0
        @scanned_items.each { |item| price += item.price }
        price
    end

    def receipt
        all_items = []
        @scanned_items.each do |item|
            all_items << "#{item.name} : #{item.price}"
        end

        all_items <<  "-----------------\nTotal : #{total}"
        "#{all_items.join("\n")}"
    end

end

class POS
    def scan(barcode, is_exit)
        set_up_devices
        if @scanner.read_barcode(barcode, is_exit)
            search_item(barcode)
        else
            sumup_items
        end        
    end

    private

    def search_item(barcode)
        record = DATABASE.select {|x| x.barcode.eql?(barcode)}.first
        return @display.display_message("Product not found") unless record
        item = Item.new(record.barcode, record.id, record.name, record.price)
        process_item(item)
    end

    def sumup_items
        @display.display_message(@list.total)
        @printer.print_message(@list.receipt)
    end

    def process_item(item)
        @display.display_message("#{item.name} : #{item.price}")
        @list.add_item(item)
    end

    def set_up_devices
        @scanner ||= Scanner.new
        @display ||= LCD.new
        @printer ||= Printer.new
        @list    ||= List.new
    end

end


def client_code(pos, barcode, is_exit)
    pos.scan(barcode, is_exit)
end

# INSTRUCTION:
# 1. Add Record in DATABASE line#5
# 2. Call client code with barcode(string) and exitstatus(bool) 
# 3. Run this file as 'ruby ./pos.rb'

pos = POS.new
puts 'Client interacts with POS instance'
client_code(pos, '1234567890', false)
client_code(pos, '2345678901', false)
client_code(pos, '3456789012', false)
client_code(pos, '4567890123', false)
client_code(pos, nil, true)

require 'brainy'
require 'csv'
training_data = CSV.read('data/testdata.csv').map { |row| row.map(&:to_f) }
net = Brainy::Network.new(5, 7, 8, 0.25)
training_data.each { |datum| net.train!(datum.first(5), datum.last(8)) }
puts net.to_yaml

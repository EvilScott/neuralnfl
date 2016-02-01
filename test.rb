require_relative 'lib/neuralnfl'
net = NeuralNFL.create(1, 1)
100.times do
  i = Random.new.rand(0..Math::PI)
  o = Math.sin(i)
  net.train!([i], [o])
end

puts net.eval([0])
puts net.eval([Math::PI / 2])

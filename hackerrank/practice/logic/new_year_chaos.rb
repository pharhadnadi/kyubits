#!/bin/ruby

require 'json'
require 'stringio'

# Complete the minimumBribes function below.
def minimumBribes(q)
  bribe_count = 0
  # q.each_with_index do |person,i|
  i = q.size-1
  while i >= 0 do
    person = q[i]
    position = i+1
    offset = person - position

    if offset > 2
      puts "Too chaotic"
      return
    else
      j=i
      while j-1 >= 0 or j+1 > person do
        j-=1
        if q[j] > person
          bribe_count += 1
        else
          # break if j+1 == person
        end
      end
    end
    i-=1
  end
  puts bribe_count
end

t = gets.to_i

t.times do |t_itr|
  n = gets.to_i

  q = gets.rstrip.split(' ').map(&:to_i)

  minimumBribes q
end

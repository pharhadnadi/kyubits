#!/bin/ruby

n,m,q = gets.strip.split(' ')
n = n.to_i
m = m.to_i
q = q.to_i
a = gets.strip
a = a.split(' ').map(&:to_i)
b = gets.strip
b = b.split(' ').map(&:to_i)
hsh = {}
res = {}
require 'set'
for a0 in (0..q-1)
  r1,c1,r2,c2 = gets.strip.split(' ')
  r1 = r1.to_i
  c1 = c1.to_i
  r2 = r2.to_i
  c2 = c2.to_i
  ans = []
  ans = Set.new
  (r1..r2).each do |r|
    (c1..c2).each do |c|
      x,y = [a[r],b[c]].sort
      hsh["#{x},#{y}"] ||= (x).gcd(y)
      res["#{r},#{c}"] ||=  hsh["#{x},#{y}"]
      ans << res["#{r},#{c}"]
    end
  end
  puts ans.length
end
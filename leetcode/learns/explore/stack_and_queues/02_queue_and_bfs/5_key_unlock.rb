# Open the Lock
# Go to Discuss
# You have a lock in front of you with 4 circular wheels. Each wheel has 10 slots: '0', '1', '2', '3', '4', '5', '6', '7', '8', '9'. The wheels can rotate freely and wrap around: for example we can turn '9' to be '0', or '0' to be '9'. Each move consists of turning one wheel one slot.
#
#     The lock initially starts at '0000', a string representing the state of the 4 wheels.
#
#     You are given a list of deadends dead ends, meaning if the lock displays any of these codes, the wheels of the lock will stop turning and you will be unable to open it.
#
#     Given a target representing the value of the wheels that will unlock the lock, return the minimum total number of turns required to open the lock, or -1 if it is impossible.
#
#     Example 1:
#     Input: deadends = ["0201","0101","0102","1212","2002"], target = "0202"
# Output: 6
# Explanation:
#     A sequence of valid moves would be "0000" -> "1000" -> "1100" -> "1200" -> "1201" -> "1202" -> "0202".
#         Note that a sequence like "0000" -> "0001" -> "0002" -> "0102" -> "0202" would be invalid,
#                                                                                           because the wheels of the lock become stuck after the display becomes the dead end "0102".
#     Example 2:
#     Input: deadends = ["8888"], target = "0009"
# Output: 1
# Explanation:
#     We can turn the last wheel in reverse to move from "0000" -> "0009".
#     Example 3:
#     Input: deadends = ["8887","8889","8878","8898","8788","8988","7888","9888"], target = "8888"
# Output: -1
# Explanation:
#     We can't reach the target without getting stuck.
# Example 4:
# Input: deadends = ["0000"], target = "8888"
# Output: -1
# Note:
# The length of deadends will be in the range [1, 500].
# target will not be in the list deadends.
# Every string in deadends and the string target will be a string of 4 digits from the 10,000 possibilities '0000' to '9999'.

# @param {String[]} deadends
# @param {String} target
# @return {Integer}
def open_lock(deadends, target)
  stop = {}
  deadends.each {|x| stop[x] = true}
  start = "0000"
  step = attempt(start, target, stop, 0, {})
  step || -1
end

def attempt try, target, stop, step, mem
  queue = [[try, step]]
  while !queue.empty? do
    try, step = queue.shift
    mem[try] = true
    next if stop[try]
    # p try
    return step if target == try
    8.times do |n|
      new = move(try, n)
      # p new
      unless mem[new]
        if queue.empty?
          queue << [new, step+1]
        else
          head_score = score(queue.first.first, target)
          tail_score = score(queue.last.first, target)
          new_score = score(new, target)
          if (head_score-new_score).abs < (tail_score-new_score).abs
            queue.unshift [new, step+1]
          else
            queue << [new, step+1]
          end
        end
      end
      mem[new] = true
    end
  end
  nil
end

def score try, target
  try_ary = try.chars.map(&:to_i)
  targ_ary = target.chars.map(&:to_i)
  score = 0
  try_ary.each_with_index {|n, i|
    m = targ_ary[i]
    del = [(n-m).abs, (n-m+10).abs, (n-m-10).abs].min
    score+=del
  }
  score
end

def move str, config
  ary = str.chars.map(&:to_i)
  x = 4
  idx = config % x
  ary[idx] += (config >= x ? -1 : 1)
  ary[idx] = 9 if ary[idx] == -1
  ary[idx] = 0 if ary[idx] == 10
  ary.join
end

# good
# deadends = ["0201", "0101", "0102", "1212", "2002"]
# target = "0202"

# good after memoization
# deadends = ["8887","8889","8878","8898","8788","8988","7888","9888"]
# target = "8888"

deadends =
    ["6678", "8666", "7877", "8677", "6777", "6777", "6767", "7877", "8687", "8788", "6667", "6768", "7667", "7786", "7667", "6878", "7668", "7778", "6776", "6787", "6766", "8877", "7688", "7876", "8777", "8677", "7866", "8688", "7686", "8877", "7866", "7777", "7787", "7676", "8688", "7866", "8787", "7876", "6887", "8677", "8778", "7886", "8788", "6686", "7788", "7787", "8687", "8777", "7888", "7767", "8678", "8877", "7866", "8776", "8687", "8878", "8776", "7877", "7788", "8687", "8776", "6866", "7776", "8877", "6886", "6778", "7788", "8666", "6668", "7768", "8886", "8888", "8666", "8768", "8878", "7666", "8766", "7678", "8688", "6866", "7887", "7887", "8867", "8668", "7777", "6687", "8886", "8768", "8687", "8678", "8876", "8776", "8777", "6776", "6876", "8878", "8877", "7876", "6867", "8886", "6687", "8886", "6777", "7678", "8777", "8768", "8868", "8777", "7877", "6676", "6876", "7778", "7668", "6687", "6666", "8786", "6876", "7868", "8676", "7888", "8886", "8666", "6876", "7788", "8867", "6766", "8877", "6668", "8887", "7866", "8776", "6687", "7787", "7688", "8767", "6667", "8876", "8678", "6686", "7668", "6687", "8878", "7886", "7788", "6788", "7868", "7887", "8766", "7668", "8866", "7877", "7876", "6878", "6868", "8688", "6866", "6886", "8888", "6766", "6877", "8678", "7778", "8666", "8777", "6787", "8788", "6886", "6887", "7886", "6668", "7868", "6868", "6877", "6766", "8778", "7687", "7686", "7667", "7676", "7778", "6778", "6677", "8687", "7867", "7786", "6866", "6767", "6688", "7778", "6778", "6766", "7877", "6766", "8678", "7786", "8886", "7666", "8666", "7676", "8888", "7666", "7787", "8768", "7767", "7886", "7688", "6776", "7876", "7686", "7677", "7867", "6667", "7877", "7766", "7777", "8877", "7778", "7777", "7868", "6686", "6676", "7676", "7887", "8778", "8888", "7687", "6686", "8876", "7767", "7888", "8666", "7768", "6686", "7768", "7678", "8867", "7767", "6866", "8876", "7688", "8766", "7777", "7687", "8686", "8687", "6868", "7887", "8786", "6688", "6777", "6666", "8688", "6877", "7687", "7767", "7668", "8668", "6777", "8786", "8876", "6688", "8878", "6887", "8886", "7788", "8678", "7788", "6677", "6667", "6867", "6886", "7687", "7778", "7776", "7678", "6768", "7668", "6678", "6887", "6888", "8687", "8787", "8866", "7677", "8667", "6876", "8787", "6786", "6688", "7786", "6777", "8777", "6778", "6787", "7886", "8878", "8677", "6677", "7766", "7876", "8667", "7668", "7867", "6888", "7687", "8666", "6868", "6767", "7768", "8876", "8867", "6866", "6687", "8878", "6866", "8888", "7788", "6687", "6878", "8676", "8686", "7768", "6686", "6787", "8687", "7888", "6867", "7886", "8777", "6676", "7678", "6868", "8766", "7787", "8688", "7868", "6876", "8677", "6878", "6888", "6788", "6686", "7887", "6678", "6786", "7668", "7867", "8686", "7686", "8886", "6688", "7877", "7866", "8887", "7666", "8688", "8868", "7787", "6867", "8666", "7766", "6787", "6668", "8866", "8786", "7876", "6788", "7686", "6667", "8878", "7868", "6886", "6887", "6768", "7777", "6877", "8766", "6876", "8687", "8777", "7687", "8878", "7778", "7868", "6868", "8887", "8686", "7677", "7788", "7766", "6777", "7686", "7766", "8677", "6767", "8777", "8776", "6686", "6678", "6668", "8687", "8878", "6776", "7687", "7868", "8876", "6676", "8878", "7868", "6788", "7677", "6776", "7768", "6677", "6788", "6677", "6767", "6678", "7766", "6688", "7788", "6778", "8678", "7777", "7676", "6688", "6767", "7777", "8686", "8766", "8668", "6766", "7666", "8687", "8786", "6777", "6686", "7667", "8776", "7777", "7887", "6878", "8876", "7668", "6866", "6766", "6778", "8866", "7768", "6877", "8788", "8776", "7877", "8776", "6767", "8776", "8868", "6678", "6666", "7668", "8777", "6877", "6677", "8888", "6767", "6787", "7777", "8868", "6777", "7688", "6668", "6876", "6678", "8766", "8676", "6786", "8676", "6788", "6878", "8878", "7666", "8766", "8868", "6767", "8876", "8678", "6688", "7766", "7877", "6777", "7888", "6676", "7867", "8676", "7688", "8888", "6777", "8687", "6667", "6667"]
target = "7878"

p open_lock(deadends, target)

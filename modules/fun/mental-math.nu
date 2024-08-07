# A simple math game. Type "exit" to stop playing and get your score :)
def main [
  range_x: range = 1..100           # Range to use for first operand
  range_y: range = 1..100           # Range to use for second operand
  --operators (-o): string = '+-*/' # List of operators to use, among the following: +, -, * and /
] {
  let invalid_operators = $operators | str replace --all -r '[+\-*/]' ''
  if ($invalid_operators | str length) > 0 {
    error make {
      msg: "Please use supported operators: +, -, * and /"
      label: {
        text: $"Consider removing the following operator\(s\): '($invalid_operators)'"
        span: (metadata $operators).span
      }
    }
  }

  mut n = 0
  mut score = 0

  loop {
    let x = random int $range_x
    let y = random int $range_y
    let operator = choose-operator $operators
    let solution = match $operator {
      + => ($x + $y),
      - => ($x - $y),
      * => ($x * $y),
      / => ($x / $y)
    }

    let answer = input $"($x) ($operator) ($y) = "
    if $answer == "exit" { break }
    $n += 1

    try {
      let answer = $answer | into float
      if $answer == $solution {
        print "Well done :)"
        $score += 1
      } else {
        print $"Wrong. The solution is ($solution)."
      }
    } catch {
      print "Please type a valid number."
    }
    print "\n"
  }

  echo $"Thanks for playing! You scored ($score)/($n)"
}

def choose-operator [operators] {
  let operators = $operators | split chars
  let length = $operators | length
  $operators | get (random int ..($length - 1))
}

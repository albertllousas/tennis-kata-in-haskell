# tennis-kata-using-state-monad

Cool [Tennis kata](https://codingdojo.org/kata/Tennis/) to practice TDD.

## Description
This Kata is about implementing a simple tennis game. The scoring system is rather simple:

1. Each player can have either of these points in one game “love” “15” “30” “40”
2. If you have 40 and you win the point you win the game, however there are special rules.
3. If both have 40 the players are “deuce”.
4. If the game is in deuce, the winner of a point will have advantage
5. If the player with advantage wins the ball he wins the game
6. If the player without advantage wins they are back at deuce.

## Tests

```shell
> stack test

Tennis
  acceptance
    Play a full game
  game rules
    If a player wins a point, it's current score is increased
    if a player have 40 and they win the point, then they win the game
    If both have 40 the players are “deuce”
    If the game is in deuce, the winner of a point will have advantage
    If the player with advantage wins the ball they win the game
    If the player without advantage wins they are back at deuce.

Finished in 0.0017 seconds
```

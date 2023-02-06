{-# OPTIONS_GHC -Werror=incomplete-patterns #-}
module Tennis where
import Control.Monad.State

data Player = PlayerOne | PlayerTwo deriving (Eq, Show)

data Score = Love | FifthTeen | Thirty | Forty | Deuce | Advantage deriving (Eq, Show)

data GameStatus = WonBy Player | Ongoing deriving (Eq, Show)

data Game =  Game { scores:: (Score, Score), status:: GameStatus } deriving (Eq, Show)

score :: Player -> State Game Score
score PlayerOne = state $ \g -> case (winPoint PlayerOne g) of game@Game { scores = (s1, _) } -> (s1, game)
score PlayerTwo = state $ \g -> case (winPoint PlayerTwo g) of game@Game { scores = (_, s2) } ->  (s2, game)

startGame =  Game { scores = (Love, Love), status = Ongoing }

winPoint :: Player -> Game -> Game
winPoint PlayerOne Game{ scores = (s1, s2) } = buildGame (pointFor PlayerOne s1 s2)
winPoint PlayerTwo Game{ scores = (s1, s2) } = buildGame (swapScores (pointFor PlayerTwo s2 s1))

pointFor :: Player -> Score -> Score -> (Score, Score, GameStatus)
pointFor p Love s  =  (FifthTeen, s, Ongoing)
pointFor p FifthTeen s  =  (Thirty, s, Ongoing)
pointFor p Thirty Forty  =  (Deuce, Deuce, Ongoing)
pointFor p Thirty s  =  (Forty, s, Ongoing)
pointFor p Forty s  =  (Forty, s, (WonBy p))
pointFor p Deuce Advantage  =  (Deuce, Deuce, Ongoing)
pointFor p Deuce s  =  (Advantage, s, Ongoing)
pointFor p Advantage s  = (Advantage, s, (WonBy p))

buildGame (s1, s2, status) = Game { scores = (s1, s2), status = status }

swapScores :: (Score, Score, a) -> (Score, Score, a)
swapScores (a,b,c) = (b,a,c)

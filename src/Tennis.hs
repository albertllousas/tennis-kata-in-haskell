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
winPoint PlayerOne Game{ scores = (s1, s2) } = buildGame (nextStatusFor PlayerOne s1 s2)
winPoint PlayerTwo Game{ scores = (s1, s2) } = buildGame (swapScores (nextStatusFor PlayerTwo s2 s1))

nextStatusFor :: Player -> Score -> Score -> (Score, Score, GameStatus)
nextStatusFor p Love s  =  (FifthTeen, s, Ongoing)
nextStatusFor p FifthTeen s  =  (Thirty, s, Ongoing)
nextStatusFor p Thirty Forty  =  (Deuce, Deuce, Ongoing)
nextStatusFor p Thirty s  =  (Forty, s, Ongoing)
nextStatusFor p Forty s  =  (Forty, s, (WonBy p))
nextStatusFor p Deuce Advantage  =  (Deuce, Deuce, Ongoing)
nextStatusFor p Deuce s  =  (Advantage, s, Ongoing)
nextStatusFor p Advantage s  = (Advantage, s, (WonBy p))

buildGame (s1, s2, status) = Game { scores = (s1, s2), status = status }

swapScores :: (Score, Score, a) -> (Score, Score, a)
swapScores (a,b,c) = (b,a,c)

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
winPoint PlayerOne Game{ scores = (scorePlayer1, scorePlayer2) } = buildGame (nextStateGivenAPointFor PlayerOne scorePlayer1 scorePlayer2)
winPoint PlayerTwo Game{ scores = (scorePlayer1, scorePlayer2) } = buildGame (swapScores (nextStateGivenAPointFor PlayerTwo scorePlayer2 scorePlayer1))

nextStateGivenAPointFor :: Player -> Score -> Score -> (Score, Score, GameStatus)
nextStateGivenAPointFor _      Love        otherPlayerScore = (FifthTeen, otherPlayerScore, Ongoing)
nextStateGivenAPointFor _      FifthTeen   otherPlayerScore = (Thirty, otherPlayerScore, Ongoing)
nextStateGivenAPointFor _      Thirty      Forty            = (Deuce, Deuce, Ongoing)
nextStateGivenAPointFor _      Thirty      otherPlayerScore = (Forty, otherPlayerScore, Ongoing)
nextStateGivenAPointFor player Forty       otherPlayerScore = (Forty, otherPlayerScore, (WonBy player))
nextStateGivenAPointFor _      Deuce       Advantage        = (Deuce, Deuce, Ongoing)
nextStateGivenAPointFor _      Deuce       otherPlayerScore = (Advantage, otherPlayerScore, Ongoing)
nextStateGivenAPointFor player Advantage   otherPlayerScore = (Advantage, otherPlayerScore, (WonBy player))

buildGame (scorePlayer1, scorePlayer2, status) = Game { scores = (scorePlayer1, scorePlayer2), status = status }

swapScores :: (Score, Score, a) -> (Score, Score, a)
swapScores (score1, score2, c) = (score2, score1, c)

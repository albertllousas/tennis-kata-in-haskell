{-# OPTIONS_GHC -Werror=incomplete-patterns #-}
module Tennis where

data Player = PlayerOne | PlayerTwo deriving (Eq, Show)

data Score = Love | FifthTeen | Thirty | Forty | Deuce | Advantage deriving (Eq, Show)

data GameStatus = WonBy Player | Ongoing deriving (Eq, Show)

data Game =  Game { scores:: (Score, Score), status:: GameStatus } deriving (Eq, Show)

--add state -> next gamestatus


startGame =  Game { scores = (Love, Love), status = Ongoing }

winPoint :: Player -> Game -> Game
winPoint PlayerOne Game{ scores = (s1, s2) } = buildGame (next PlayerOne s1 s2)
winPoint PlayerTwo Game{ scores = (s1, s2) } = buildGame (swap (next PlayerTwo s2 s1))

swap (a,b,c) = (b,a,c)

next :: Player -> Score -> Score -> (Score, Score, GameStatus)
next p Love s  =  (FifthTeen, s, Ongoing)
next p FifthTeen s  =  (Thirty, s, Ongoing)
next p Thirty Forty  =  (Deuce, Deuce, Ongoing)
next p Thirty s  =  (Forty, s, Ongoing)
next p Forty s  =  (Forty, s, (WonBy p))
next p Deuce Advantage  =  (Deuce, Deuce, Ongoing)
next p Deuce s  =  (Advantage, s, Ongoing)
next p Advantage s  = (Advantage, s, (WonBy p))

buildGame (s1, s2, status) = Game { scores = (s1, s2), status = status }

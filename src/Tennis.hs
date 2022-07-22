{-# OPTIONS_GHC -Werror=incomplete-patterns #-}
module Tennis where

data Player = PlayerOne | PlayerTwo deriving (Eq, Show)

data Score = Love | FifthTeen | Thirty | Forty | Deuce | Advantage deriving (Eq, Show)

data GameStatus = WonBy Player | Ongoing deriving (Eq, Show)

data Game =  Game { scores:: (Score, Score), status:: GameStatus } deriving (Eq, Show)

startGame =  Game { scores = (Love, Love), status = Ongoing }

cambiar esto uun poco swap?

winPoint :: Player -> Game -> Game
winPoint PlayerOne Game{ scores = (Love, s) } = build (FifthTeen, s) Ongoing
winPoint PlayerOne Game{ scores = (FifthTeen, s) } = build(Thirty, s) Ongoing
winPoint PlayerOne Game{ scores = (Thirty, Forty) } = build (Deuce, Deuce) Ongoing
winPoint PlayerOne Game{ scores = (Thirty, s) } = build (Forty, s) Ongoing
winPoint PlayerOne Game{ scores = (Forty, s) } = build (Forty, s) (WonBy PlayerOne)
winPoint PlayerOne Game{ scores = (Deuce, Advantage) } = build (Deuce, Deuce) Ongoing
winPoint PlayerOne Game{ scores = (Deuce, s) } = build (Advantage, Deuce) Ongoing
winPoint PlayerOne Game{ scores = (Advantage, s) } = build (Advantage, Deuce) (WonBy PlayerOne)
winPoint PlayerTwo Game{ scores = (s, Love) } = build (s, FifthTeen) Ongoing
winPoint PlayerTwo Game{ scores = (s, FifthTeen) } = build (s, Thirty) Ongoing
winPoint PlayerTwo Game{ scores = (Forty, Thirty) } = build (Deuce, Deuce) Ongoing
winPoint PlayerTwo Game{ scores = (s, Thirty) } = build (s, Forty) Ongoing
winPoint PlayerTwo Game{ scores = (s, Forty) } = build (s, Forty) (WonBy PlayerTwo)
winPoint PlayerTwo Game{ scores = (Advantage, Deuce) } = build (Deuce, Deuce) Ongoing
winPoint PlayerTwo Game{ scores = (s, Deuce) } = build (Deuce, Advantage) Ongoing
winPoint PlayerTwo Game{ scores = (s, Advantage) } = build (Deuce, Advantage) (WonBy PlayerTwo)

build scores status = Game { scores = scores, status = status }




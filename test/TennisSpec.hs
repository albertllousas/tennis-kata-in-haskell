module TennisSpec where

import Tennis
import Test.Hspec


spec :: Spec
spec = do

--  describe "acceptance" $ do
--
--    it "Play a full game" $ do
--      let initialGame = startGame
--      let result = do
--                g <- winPoint PlayerOne initialGame
--                g' <- winPoint PlayerTwo g
--                g'' <- (play X (1,0) g')
--                g''' <- (play O (1,2) g'')
--                g'''' <- (play X (0,0) g''')
--                g''''' <- (play O (2,0) g'''')
--                (play X (2,2) g''''')
--      let expectedGrid = [[TakenBy X, TakenBy O, Empty],
--                        [TakenBy X, TakenBy X, TakenBy O],
--                        [TakenBy O, Empty, TakenBy X]]
--      result `shouldBe` (Right $ Game { grid = expectedGrid, status= Winner X })

  describe "game rules" $ do

    it "If a player wins a point, it's current score is increased" $ do
      let game  = startGame
      winPoint PlayerOne game `shouldBe` Game { scores = (FifthTeen, Love), status = Ongoing }

    it "if a player have 40 and they win the point, then they win the game" $ do
      let game  = Game { scores = (FifthTeen, Forty) , status = Ongoing }
      winPoint PlayerTwo game `shouldBe` Game { scores = (FifthTeen, Forty), status = WonBy PlayerTwo }

    it "If both have 40 the players are “deuce”" $ do
      let game  = Game { scores = (Thirty, Forty) , status = Ongoing }
      winPoint PlayerOne game `shouldBe` Game { scores = (Deuce, Deuce), status = Ongoing }

    it "If the game is in deuce, the winner of a point will have advantage" $ do
      let game  = Game { scores = (Deuce, Deuce) , status = Ongoing }
      winPoint PlayerOne game `shouldBe` Game { scores = (Advantage, Deuce), status = Ongoing }

    it "If the player with advantage wins the ball they win the game" $ do
       let game  = Game { scores = (Deuce, Advantage) , status = Ongoing }
       winPoint PlayerTwo game `shouldBe` Game { scores = (Deuce, Advantage), status = WonBy PlayerTwo }

    it "If the player without advantage wins they are back at deuce." $ do
       let game  = Game { scores = (Deuce, Advantage) , status = Ongoing }
       winPoint PlayerOne game `shouldBe` Game { scores = (Deuce, Deuce), status = Ongoing }
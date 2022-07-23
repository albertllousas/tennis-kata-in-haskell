module TennisSpec where

import Tennis
import Test.Hspec
import Control.Monad.State

spec :: Spec
spec = do

  describe "acceptance" $ do

    it "Play a full game" $ do
      let result = do
                score PlayerOne
                score PlayerOne
                score PlayerTwo
                score PlayerOne
                score PlayerTwo
                score PlayerOne
      runState (result) startGame `shouldBe` (Forty, Game { scores = (Forty, Thirty), status = WonBy PlayerOne })

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
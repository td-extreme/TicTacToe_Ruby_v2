require 'ai_minimax'
require 'game_board'
require 'game_state'
require 'game_rules'

describe AiMinimax do
  let (:board) { GameBoard.new }
  let (:rules) { GameRules.new }
  let (:test_ai) { AiMinimax.new(rules) }
  let (:test_ai2) { AiMinimax.new(rules) }
  let (:test_state) { GameState.new(board , :X, :O) }
  let(:spaces) { test_state.game_board.spaces }
  let(:corners) { [0, 2, 6, 8] }
  let(:sides) { [1, 3, 5, 7] }

  describe "Playing the last move " do
    it "plays 0 when that is the only space open " do
      set_spaces(:O, [1,3,4,8])
      set_spaces(:X, [2,5,6,7])
      expect(test_ai.get_move(test_state)).to eq(0)
    end

    it "plays 1 when that is the only space open " do
      set_spaces(:O, [0,3,4,8])
      set_spaces(:X, [2,5,6,7])
      expect(test_ai.get_move(test_state)).to eq(1)
    end

    it "plays 8 when that is the only space open " do
      set_spaces(:O, [0,4,5,7])
      set_spaces(:X, [1,2,3,6])
      expect(test_ai.get_move(test_state)).to eq(8)
    end
  end

  describe "Playing second to last move " do
    it "it will play to block if the other move doesn't block or win." do
      set_spaces(:X, [1,2,3,4])
      set_spaces(:O, [0,5,6])
      expect(test_ai.get_move(test_state)).to eq(7)
    end

    it "it plays to win if one of the moves wins and the other blocks" do
      set_spaces(:X, [2,5,7])
      set_spaces(:O, [1,3,4,6])
      expect(test_ai.get_move(test_state)).to eq(8)
    end

    it "it plays to win if the other move doesn't win or block " do
      set_spaces(:X, [4,6,8])
      set_spaces(:O, [0,3,5,7])
      expect(test_ai.get_move(test_state)).to eq(2)
    end
  end

  describe "When it goes first " do
    it "plays a corner on empty board " do
      move = test_ai.get_move(test_state)
      expect(corners.include?(move)).to eq(true)
    end
  end

  describe "When it goes second " do
    describe "Player 1 played a corner " do
      it "plays center square if other player played a corner 0" do
        spaces[0] = :O
        expect(test_ai.get_move(test_state)).to eq(4)
      end

      it "plays center square if other player played a corner 2" do
        spaces[2] = :O
        expect(test_ai.get_move(test_state)).to eq(4)
      end

      it "plays center square if other player played a corner 6" do
        spaces[6] = :O
        expect(test_ai.get_move(test_state)).to eq(4)
      end

      it "plays center square if other player played a corner 8" do
        spaces[8] = :O
        expect(test_ai.get_move(test_state)).to eq(4)
      end
    end

    describe "Player 1 played center " do
      it "returns a corner move " do
        set_spaces(:O, [4])
        move = test_ai.get_move(test_state)
        expect(corners.include?(move)).to eq(true)
      end
    end 

    describe "Player 1 played a side " do
      it "returns a cornver move if player1 played 1 " do
        set_spaces(:O, [1])
        move = test_ai.get_move(test_state)
        expect(corners.include?(move)).to eq(true)
      end

      it "returns a cornver move if player1 played 3 " do
        set_spaces(:O, [3])
        move = test_ai.get_move(test_state)
        expect(corners.include?(move)).to eq(true)
      end

      it "returns a cornver move if player1 played 5 " do
        set_spaces(:O, [5])
        move = test_ai.get_move(test_state)
        expect(corners.include?(move)).to eq(true)
      end

      it "returns a cornver move if player1 played 7 " do
        set_spaces(:O, [7])
        move = test_ai.get_move(test_state)
        expect(corners.include?(move)).to eq(true)
      end
    end
  end

  describe "Turn 3 " do
   describe "opposite corner is unavailable or won't lead to a fork " do
      it "returns adjacent corner when player 2 plays opposite corner " do
        set_spaces(:X, [0])
        set_spaces(:O, [8])
        move = test_ai.get_move(test_state)
        expect([2,6].include?(move)).to eq(true)
      end

      it "returns adjacent corner when player 2 plays opposite side " do
        set_spaces(:X, [6])
        set_spaces(:O, [1])
        expect(test_ai.get_move(test_state)).to eq(8)
      end

      it "returns adjacent corner when player 2 plays opposite side " do
        set_spaces(:X, [6])
        set_spaces(:O, [5])
        expect(test_ai.get_move(test_state)).to eq(8)
      end


      it "returns adjacent corner when player 2 plays opposite side " do
        set_spaces(:X, [8])
        set_spaces(:O, [1])
        expect(test_ai.get_move(test_state)).to eq(6)
      end

      it "returns adjacent corner when player 2 plays opposite side " do
        set_spaces(:X, [8])
        set_spaces(:O, [3])
        expect(test_ai.get_move(test_state)).to eq(6)
      end
    end
  end

  describe "Turn 4 " do
    describe "prevent opponent from creating a fork " do
      it "returns side to force opponent to block on next turn " do
        set_spaces(:O, [0,8])
        set_spaces(:X, [4])
        move = test_ai.get_move(test_state)
        expect(sides.include?(move)).to eq(true)
      end

      it "returns a side to force opponent to block on next turn 2 " do
        set_spaces(:O, [6,2])
        set_spaces(:X, [4])
        move = test_ai.get_move(test_state)
        expect(sides.include?(move)).to eq(true)
      end
    end
  end

  describe "Turn 5 " do
    describe "creating forkss " do
      it "plays 0 to create a fork " do
        set_spaces(:X, [2,8])
        set_spaces(:O, [5,6])
        expect(test_ai.get_move(test_state)).to eq(0)
      end

      it "plays 2 to create a fork " do
        set_spaces(:X, [0, 6])
        set_spaces(:O, [3, 8])
        expect(test_ai.get_move(test_state)).to eq(2)
      end

      it "plays 6 to create a fork " do
        set_spaces(:X, [0,8])
        set_spaces(:O, [2,4])
        expect(test_ai.get_move(test_state)).to eq(6)
      end

      it "plays 8 to create a fork " do
        set_spaces(:X, [0, 6])
        set_spaces(:O, [2, 3])
        expect(test_ai.get_move(test_state)).to eq(8)
      end
    end
  end

  describe "Turn 6 " do
    describe "creating forks " do
      it "plays 8 to create a fork " do
        set_spaces(:X, [0,6])
        set_spaces(:O, [1,2,3])
        expect(test_ai.get_move(test_state)).to eq(8)
      end

      it "plays 0 to create a fork " do
        set_spaces(:X, [6,8])
        set_spaces(:O, [2,5,7])
        expect(test_ai.get_move(test_state)).to eq(0)
      end
    end
  end

  def set_spaces(mark, spaces_to_set)
    spaces_to_set.each { |i| spaces[i] = mark }
  end  
end

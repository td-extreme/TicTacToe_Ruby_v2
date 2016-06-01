class GameRules

  def tied?(board)
    board.full? && !winner(board)
  end

  def game_over?(board)
    tied?(board) || !!(winner(board))
  end
  
  def winner(board)
    check_win_col(board.spaces) || check_win_row(board.spaces) || check_win_diagonal(board.spaces)
  end

private

  def check_win_col(spaces)
    return spaces[0] if [spaces[0], spaces[3], spaces[6]].uniq.length == 1 && \
      spaces[0] != ' '
    return spaces[1] if [spaces[1], spaces[4], spaces[7]].uniq.length == 1 && \
      spaces[1] != ' '
    return spaces[2] if [spaces[2], spaces[5], spaces[8]].uniq.length == 1 && \
      spaces[2] != ' '
  end

  def check_win_row(spaces)
    return spaces[0] if [spaces[0], spaces[1], spaces[2]].uniq.length == 1 && \
      spaces[0] != ' '
    return spaces[3] if [spaces[3], spaces[4], spaces[5]].uniq.length == 1 && \
      spaces[3] != ' '
    return spaces[6] if [spaces[6], spaces[7], spaces[8]].uniq.length == 1 && \
      spaces[6] != ' '
  end

  def check_win_diagonal(spaces)
    return spaces[4] if [spaces[0], spaces[4], spaces[8]].uniq.length == 1 && \
      spaces[4] != ' '
    return spaces[4] if [spaces[6], spaces[4], spaces[2]].uniq.length == 1 && \
      spaces[4] != ' '
  end
end

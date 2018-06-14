class Player
  def play_turn(warrior)
    if warrior_can_rest?(warrior)
      warrior.rest!
    else
      proceed(warrior)
    end
  end

  def warrior_can_rest?(warrior)
    warrior.health < 20 && warrior.feel.empty?
  end

  def proceed(warrior)
    warrior.feel.empty? ? warrior.walk! : warrior.attack!
  end
end

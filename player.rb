class Player
  attr_reader :warrior
  attr_accessor :health
  def play_turn(received_warrior)
    set_warrior(received_warrior)
    play_action
    update_health
  end

  def play_action
    warrior_can_rest? ? warrior.rest! : proceed
  end

  def warrior_can_rest?
    not_losing_health? && warrior.health < 20 && warrior.feel.empty?
  end

  def not_losing_health?
    !(health && warrior.health < health)
  end

  def proceed
    warrior.feel.empty? ? warrior.walk! : handle_encounter
  end

  def handle_encounter
    warrior.feel.captive? ? warrior.rescue! : warrior.attack!
  end

  def update_health
    self.health = warrior.health
  end

  def set_warrior(received_warrior)
    @warrior = received_warrior
  end
end

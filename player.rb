class Player
  attr_reader :warrior
  attr_accessor :health, :captive_rescued
  def play_turn(received_warrior)
    set_warrior(received_warrior)
    set_captive_rescued
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
    !losing_health?
  end

  def losing_health?
    health && warrior.health < health
  end

  def proceed
    warrior.feel.empty? ? choose_direction : handle_encounter
  end

  def choose_direction
    captive_rescued ? cautious_walk : find_captive
  end

  def cautious_walk
    should_back_away? ? warrior.walk!(:backward) : warrior.walk!
  end

  def find_captive
    warrior.feel(:backward).empty? ? warrior.walk!(:backward) : rescue_captive
  end

  def rescue_captive
    warrior.rescue!(:backward)
    self.captive_rescued = true
  end

  def handle_encounter
    warrior.feel.captive? ? warrior.rescue! : warrior.attack!
  end

  def should_back_away?
    warrior.health < 10 && losing_health?
  end

  def update_health
    self.health = warrior.health
  end

  def set_warrior(received_warrior)
    @warrior = received_warrior
  end

  def set_captive_rescued
    @captive_rescued ||= false
  end
end

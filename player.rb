class Player
  attr_accessor :warrior, :health, :first_captive_rescued
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
    first_captive_rescued ? proceed_forward : proceed_backward
  end

  def proceed_backward
    archer_behind? ? warrior.shoot!(:backward) : find_captive
  end

  def archer_behind?
    look_results = warrior.look(:backward)
    look_results.any?{ |result| result.to_s == 'Archer' }
  end

  def proceed_forward
    safe_to_walk? ? choose_direction : handle_encounter
  end

  def safe_to_walk?
    warrior.feel.empty? && no_wizard_ahead?
  end

  def no_wizard_ahead?
    !wizard_ahead?
  end

  def wizard_ahead?
    safe_encounters = ['nothing', 'Captive', 'wall']
    look_results = warrior.look.reject{ |result| safe_encounters.include?(result.to_s) }
    look_results.any?
  end

  def choose_direction
    first_captive_rescued ? cautious_walk : find_captive
  end

  def cautious_walk
    should_back_away? ? warrior.walk!(:backward) : warrior.walk!
  end

  def find_captive
    warrior.feel(:backward).empty? ? warrior.walk!(:backward) : rescue_captive
  end

  def rescue_captive
    warrior.rescue!(:backward)
    self.first_captive_rescued = true
  end

  def handle_encounter
    safe_encounter? ? handle_safe_encounter : handle_enemy_encounter
  end

  def handle_safe_encounter
    warrior.feel.captive? ? warrior.rescue! : warrior.pivot!(:backward)
  end

  def handle_enemy_encounter
    warrior.feel.empty? ? warrior.shoot! : warrior.attack!
  end

  def safe_encounter?
    warrior.feel.captive? || warrior.feel.wall?
  end

  def should_back_away?
    warrior.health < 10 && losing_health?
  end

  def update_health
    self.health = warrior.health
  end

  def set_warrior(received_warrior)
    self.warrior = received_warrior
  end

  def set_captive_rescued
    self.first_captive_rescued ||= false
  end
end

class Player
  attr_accessor :warrior, :health
  def play_turn(received_warrior)
    set_warrior(received_warrior)
    play_action
    update_health
  end

  def play_action
    warrior_needs_rest? ? warrior.rest! : proceed
  end

  def warrior_needs_rest?
    not_losing_health? && warrior.health < 20 && warrior.feel.empty?
  end

  def not_losing_health?
    !losing_health?
  end

  def losing_health?
    health && warrior.health < health
  end

  def captive_behind?
    look_results = warrior.look(:backward).map{ |result| result.to_s }
    look_results == ['nothing', 'nothing', 'Archer']
  end

  def proceed
    captive_behind? ? proceed_backward : proceed_forward
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
    cautious_walk
  end

  def cautious_walk
    should_back_away? ? warrior.walk!(:backward) : warrior.walk!
  end

  def find_captive
    warrior.feel(:backward).empty? ? warrior.walk!(:backward) : warrior.rescue!(:backward)
  end

  def handle_encounter
    safe_encounter? ? handle_safe_encounter : warrior.shoot!
  end

  def handle_safe_encounter
    warrior.feel.captive? ? warrior.rescue! : warrior.pivot!(:backward)
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
end
